#!/bin/sh -l

set -e

SRC=./src

for i in "$@"; do
  case $i in
    -n=*|--package-name=*)
      PACKAGE_NAME="${i#*=}"
      shift
      ;;
    -v=*|--package-version=*)
      PACKAGE_VERSION="${i#*=}"
      shift
      ;;
    -p=*|--avro-dir-path=*)
      AVRO_FOLDER="${i#*=}"
      shift
      ;;
    -o=*|--output-path=*)
      OUTPUT_PATH="${i#*=}"
      shift
      ;;
    -c=*|--company=*)
      COMPANY="${i#*=}"
      shift
      ;;
    -a=*|--authors=*)
      AUTHORS="${i#*=}"
      shift
      ;;
    *)
      ;;
  esac
done

echo "[Inputs]:"
echo "  - Package name    = $PACKAGE_NAME"
echo "  - Package version = $PACKAGE_VERSION"
echo "  - Avro folder     = $AVRO_FOLDER"
echo "  - Output path     = $OUTPUT_PATH"
echo "  - Company         = $COMPANY"
echo "  - Authors         = $AUTHORS"

export PATH="$PATH:/root/.dotnet/tools"
PACKAGE_SRC_FOLDER=$SRC/$PACKAGE_NAME
PROJ=$PACKAGE_SRC_FOLDER/$PACKAGE_NAME.fsproj

echo "Clean up..."
rm -rf ./src

echo "Creating file 'Directory.Build.props'..."
cp /opt/build-tools/Directory.Build.props.template ./Directory.Build.props
sed -i -e "s/{{ Company }}/$COMPANY/g" -e "s/{{ Authors }}/$AUTHORS/g"  Directory.Build.props

echo "Creating $PACKAGE_NAME project..."
dotnet new classlib --name $PACKAGE_NAME --output $PACKAGE_SRC_FOLDER --framework netstandard2.0 --language F#
dotnet add $PROJ package Apache.Avro --version 1.11.1
sed -i -e "s|Library\.fs|**/*.fs|g" $PROJ
rm -f ./$SRC/$PACKAGE_NAME/Library.fs

cat $PROJ

echo "Adding Avro files..."

count=$(find $AVRO_FOLDER -name "*.avsc" | wc -l)
if [ "$count" -eq "0" ]; then
  echo "Error: No Avro schema file found at '$AVRO_FOLDER'"
  exit -1
fi

for file in $(find $AVRO_FOLDER -name "*.avsc" -exec readlink -f {} \;)
do
  echo "Avro schema file found at '$file'. Generating '$PACKAGE_SRC_FOLDER/$file.fs' ..."
  fs-avrogen-apache --schema-file $file --output $PACKAGE_SRC_FOLDER/$file.fs
done

echo "Restoring packages..."
dotnet restore $PROJ

echo "Building the project..."
dotnet build -c Release --no-restore $PROJ

echo "Packing $PACKAGE_NAME version $PACKAGE_VERSION at $OUTPUT_PATH..."
dotnet pack $PROJ -c Release --no-build --no-restore  -p:PackageVersion=$PACKAGE_VERSION -o $OUTPUT_PATH
