import * as fs from 'fs';
let src = fs.readFileSync(0, 'utf-8')
    .replace (/¶/g, '\n')
;
fs.writeFileSync("/tmp/src", src);
console.log (src);
