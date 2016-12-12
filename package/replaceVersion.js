var Fs = require("fs");
var packageFile = Fs.readFileSync(process.argv[2]);
var pack = JSON.parse(packageFile);
pack.version = process.argv[3];
packageFile = JSON.stringify(pack, null, 4);
Fs.writeFileSync(process.argv[2], packageFile)