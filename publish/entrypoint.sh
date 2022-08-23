#!/bin/sh -l
set -e 

SRC=./src

for i in "$@"; do
  case $i in
    -p=*|--packages=*)
      PACKAGES="${i#*=}"
      shift
      ;;
    -s=*|--source=*)
      SOURCE="${i#*=}"
      shift
      ;;
    -k=*|--api-key=*)
      API_KEY="${i#*=}"
      shift
      ;;
    *)
      ;;
  esac
done

echo "[Inputs]:"
echo "Packages = $PACKAGES"
echo "Source   = $SOURCE"
echo "API KEY  = ****"

echo "Publishing packages..."
dotnet nuget push $PACKAGES \
          --source $SOURCE \
          --api-key $API_KEY \
          --skip-duplicate
