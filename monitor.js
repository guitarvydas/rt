

function monitor_install (reg) {/* line 1 */
    register_component ( reg,mkTemplate ( "@", null, monitor_instantiator))/* line 2 *//* line 3 *//* line 4 */
}

function monitor_instantiator (reg,owner,name,template_data) {/* line 5 */
    name_with_id = gensymbol ( "@")/* line 6 */
    return make_leaf ( name_with_id, owner, null, monitor_handler)/* line 7 */;/* line 8 *//* line 9 */
}

function monitor_handler (eh,msg) {/* line 10 */
    s =  msg.datum.srepr ()   /* line 11 */
    i = Number ( s)           /* line 12 */
    while ( i >  0) {         /* line 13 */
      let  s =  `${ " "}${ s}` /* line 14 */;
      let  i =  i- 1;         /* line 15 *//* line 16 */}
    print ( s)                /* line 17 *//* line 18 */
}





