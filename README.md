# node-cdx-bom

This project provides a CLI tool (via NPM and Docker) that may be used to generate a
[CycloneDX](https://cyclonedx.org) Software Bill-of-Materials (BOM) for a
NodeJS project/repo.

## Installing from NPM

```
npm install -g @jupiterone/node-cdx-bom
```

NOTE: this tool relies on [cyclonedx-cli](https://github.com/CycloneDX/cyclonedx-cli/releases). The binary should be installed as `cyclonedx` somewhere in your PATH prior to running the `node-cdx-bom` command.

## Running node-cdx-bom

Try:

```
cd my-project-repo
node-cdx-bom
 - or -
docker run -v $PWD:/src jupiterone/node-cdx-bom /src/bom.json
```

This will generate a `bom.json` file in your project root.

NOTE: you must specify `/src` as your Docker volume mount target (`-v $PWD:/src`)!

## Assumptions

* You're only interested in generating a BOM for packages you actually use in
  production and `devDependencies` aren't of interest/in-scope.  These are ignored.
* node_modules are present (You've run `npm install` or `yarn install` first.)
* node_modules of all sub-packages of interest are present (if monorepo)
* deploy/ packages (if any) are out-of-scope, and should be ignored.

The discovered packages that remain are, therefore, required.  These are
marked as such by setting the property `scope: 'required'` for each of the
BOM `components[]`.

## Environment Variables

To override the location of the ignored deploy dir, set the IGNORE_DIR variable.
