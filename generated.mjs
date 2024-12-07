

function low_level_read_text_file_handler (eh,msg) {/* line 1 */
    let fname =  msg.datum.srepr ();/* line 2 */

    data = fs.readFileSync (fname);
    if (data) {
      send_string (eh, "", data, msg);
    } else {
      send_string (eh, "✗", `read error on file '${fname}'`, msg);
    }
    }
                              /* line 3 *//* line 4 */
}





