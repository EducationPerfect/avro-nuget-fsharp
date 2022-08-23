# Avro NuGet GitHub Actions
This repository houses GitHub actions to Nuget Packages out of Avro schema files and publish them.


## How to use:
Please have a look at [avro-nuget-sandbox repository](https://github.com/EducationPerfect/avro-nuget-sandbox) as an example.


## Contributing:
- After change the code in any action, you can use `make pack-build` to build the container on your local dev environment.
- Running `make pack-run` will generate the code and pack it as a NuGet package and store it in the `artifacts` folder.
- There are some other targets in the [Makefile](./Makefile) which could help you for debugging. Please remember the Makefile requires `avro-nuget-sandbox` as a sibling repository on your local env.
- When you are happy with your changes commit the code and push to github. 
- Finally create a new release by choosing a proper tag.
- You can test the actions on GitHub workflow from [avro-nuget-sandbox]. Please remember to update the actions versions [here](https://github.com/EducationPerfect/avro-nuget-sandbox/blob/main/.github/workflows/ci.yaml#L44) and [here](https://github.com/EducationPerfect/avro-nuget-sandbox/blob/main/.github/workflows/ci.yaml#L55) to the latest release version.


## Actions
---
## Pack
The `pack` action generate a Nuget package out of the given Avro schema files and has the following inputs:

#### Inputs

#### `package-name`

**Required** The name of the NuGet package.

#### `package-version`

**Required** The version of the NuGet package.

#### `avro-folder`

**Required** The path to the folder containing Avro schema files.

#### `output-path`

**Required** The path to the put generated package at.

#### `company-name`

The name of the company publishing the package. The default value is `Education Perfect`.

#### `authors`

The authors of the package. The default value is `Team VOID`.

### Example usage

```yaml
uses: EducationPerfect/avro-nuget/pack@v0.2.1
with:
  package-name: 'AwesomePackage'
  package-version: 1.0.0
  avro-dir-path: ./avro
  output-path: ./packages
  authors: 'Team Void'
```

---
## Publish
The `public` action publish the given Nuget packages to s given source and has the following inputs:

### Inputs

#### `packages`

**Required** The path of the NuGet package. (e.g. ./packages/*.nupkg)

#### `source`

**Required** The source for hosting NuGet packages.

#### `api-key`

**Required** The API Key of the source.

### Example usage

```yaml
uses: EducationPerfect/avro-nuget/publish@v0.2.1
with:
  packages: ./packages/*.nupkg
  source: https://nuget.pkg.github.com/${{ github.repository_owner }}/index.json
  api-key: ${{ github.token }}
```

