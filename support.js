_ = {
    fname_stack : [],
    fname : function () { return _.fname_stack [0]; },
    push_fname : function (s) { _.fname_stack.push (s); },
    pop_fname : function () { _.fname_stack.pop (); return ""; }
}
,
