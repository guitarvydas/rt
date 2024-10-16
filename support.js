function encodews (s) { return encodequotes (encodeURIComponent (s)); }

function encodequotes (s) { 
    let rs = s.replace (/"/g, '%22').replace (/'/g, '%27');
    return rs;
}

function semanticError (message, expr) {
    throw Error ('*** Semantic Error ***', message, error);
}
