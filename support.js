function encodews (s) { return encodequotes (encodeURIComponent (s)); }

function encodequotes (s) { 
    let rs = s.replace (/"/g, '%22').replace (/'/g, '%27');
    return rs;
}

let linenumber = 0;
function getlineinc () {
    linenumber += 1;
    return `${linenumber}`;
}

function part (s, i) {
    let lis = s.split (",");
    //return lis [i+0];
    //return `[[/${i}/ ... /${lis.length}/ ... /${lis[1]}/]]`
    return `${lis [i]}`
}


