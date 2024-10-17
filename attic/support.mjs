function encodews (s) { return _.encodequotes (encodeURIComponent (s)); }

function encodequotes (s) { 
    let rs = s.replace (/"/g, '%22').replace (/'/g, '%27');
    return rs;
}

let linenumber = 1;
function getlineinc () {
    let n = linenumber;
    linenumer += 1;
    return `${n}`;
}


