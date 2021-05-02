const fs = require('fs');

function uniqueComponents(components) {
  const uniques = [];
  seen = {};
  for (const component of components) {
    component.scope = "required";
    seen[component.purl] = component;
  }
  for (const purl in seen) {
    uniques.push(seen[purl]);
  }

  return uniques;
}

async function run() {
  const infile = process.argv[2];
  if (!infile) {
    console.error("Missing input file argument!");
    process.exit(2);
  }
  const outfile = process.argv[3] || infile;

  const data = require(infile);
  data.components = uniqueComponents(data.components);
  fs.writeFileSync(outfile, JSON.stringify(data, null, 2));
}

run().catch(console.error);
