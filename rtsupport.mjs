let _ = {
    fname_stack : [],
    continuation_stack : [],

    top : function (stack) { let v = stack.pop (); stack.push (v); return v; },
    set_top : function (stack, v) { stack.pop (); stack.push (v); return v; },

    fname : function () { return _.fname_stack [_.fname_stack.length - 1]; },
    push_fname : function (s) { _.fname_stack.push (s); },
    pop_fname : function () { _.fname_stack.pop (); return ""; },
    push_continuation : function (s) { _.continuation_stack.push (s); },
    pop_continuation : function () { _.continuation_stack.pop (); return ""; },
    continuation : function () { return _.continuation_stack[_.continuation_stack.length -1]; }    
};

export {_};
