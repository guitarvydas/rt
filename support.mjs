let _ = {
    top : function (stack) { let v = stack.pop (); stack.push (v); return v; },
    
    set_top : function (stack, v) { stack.pop (); stack.push (v); return v; },
	

    // for rewriter
    parameter_names : [],
    argnames : [],
    evaled_args : [],

    reset_stacks : function () { 
	_.argnames = [];
	_.evaled_args = [];
    },

    memo_parameter : function (str) {
	_.parameter_names.push (str); 
	return "";
    },
    foreach_parameter : function (str) {
	let s = [];
	_.parameter_names.forEach (p => s.push (str.replaceAll ("☐", `${p}`) + "\n"));
	return s.join ('');
    },

    foreach_arg : function (str) {
	let s = [`//foreach_arg (${str})\n`];
	_.evaled_args.forEach (p => s.push (str.replaceAll ("☐", `${p}`) + "\n"));
	return s.join ('');
    },

    memo_arg : function (name, s) { _.argnames.push (name); _.evaled_args.push (s.replaceAll ("☐", `${name}`)); return ""; },
    args_as_string : function () { return _.evaled_args.join (''); },


};

export {_};
