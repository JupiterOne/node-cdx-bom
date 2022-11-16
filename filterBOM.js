const fs = require('fs');

function uniqueRequiredComponents(components) {
  seen = {};
  for (const component of components) {
    seen[component.purl] = {
      ...component,
      scope: 'required'
      // 'scope' is useful for downstream consumers of the SBOM.
      // Given the assumptions of this project we have enough knowledge
      // to set this value here.
      // May be one of 'optional', 'required', 'excluded'.
      // See: https://github.com/CycloneDX/specification/blob/master/schema/bom-1.2.xsd#L487-L510
    };
  }
  return Object.values(seen);
}

async function run() {
  const infile = process.argv[2];
  if (!infile) {
    console.error("Missing input file argument!");
    process.exit(2);
  }
  const outfile = process.argv[3] || infile;

  const data = JSON.parse(fs.readFileSync(infile, 'utf8'));

  if (data !== undefined && data.components !== undefined) {
    console.log('Before: ' + data.components.length + ' components.');
    data.components = uniqueRequiredComponents(data.components);
    console.log(' After: ' + data.components.length + ' components.');
  } else {
    console.log('data.components is empty');
  }
  
  fs.writeFileSync(outfile, JSON.stringify(data, null, 2));
}

run().catch(err => {
  console.error(err);
  process.exit(2);
});
