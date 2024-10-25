
(ql:quickload :cl-json)
                                                                                                                        #|line 4|##|line 5|#
(defun Component_Registry (&optional )                                                                                  #|line 6|#
  (list
    (cons 'templates  nil)                                                                                              #|line 7|#)#|line 8|#)
                                                                                                                        #|line 9|#
(defun Template (&optional  name  template_data  instantiator)                                                          #|line 10|#
  (list
    (cons 'name  name)                                                                                                  #|line 11|#
    (cons 'template_data  template_data)                                                                                #|line 12|#
    (cons 'instantiator  instantiator)                                                                                  #|line 13|#)#|line 14|#)
                                                                                                                        #|line 15|#
(defun read_and_convert_json_file (&optional  filename)                                                                 #|line 16|#
    ;; read json from a named file and convert it into internal form (a tree of routings)
    ;; return the routings from the function or print an error message and return nil
    (handler-bind ((error #'(lambda (condition) nil)))
      (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
        (json:decode-json json-stream)))
                                                                                                                        #|line 17|##|line 18|#
)
(defun json2internal (&optional  container_xml)                                                                         #|line 20|#
    (let ((fname (cdr (assoc '(cdr (assoc '(basename    container_xml                                                   #|line 21|#)  path))  os))))
        (let ((routings (read_and_convert_json_file    fname                                                            #|line 22|#)))
            (return-from json2internal  routings)                                                                       #|line 23|#))#|line 24|#
)
(defun delete_decls (&optional  d)                                                                                      #|line 26|#
    #| pass |#                                                                                                          #|line 27|##|line 28|#
)
(defun make_component_registry (&optional )                                                                             #|line 30|#
    (return-from make_component_registry (Component_Registry  ))                                                        #|line 31|##|line 32|#
)
(defun register_component (&optional  reg  template)
    (return-from register_component (abstracted_register_component    reg  template  nil ))                             #|line 34|#
)
(defun register_component_allow_overwriting (&optional  reg  template)
    (return-from register_component_allow_overwriting (abstracted_register_component    reg  template  t ))             #|line 35|#
)
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)                                        #|line 37|#
    (let ((name (mangle_name   (cdr (assoc ' name  template))                                                           #|line 38|#)))
        (cond
          (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                   #|line 39|#
                (load_error    (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 40|#
            ))
          (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                   #|line 41|#
            (return-from abstracted_register_component  reg)                                                            #|line 42|#)#|line 43|#
)
(defun register_multiple_components (&optional  reg  templates)                                                         #|line 45|#
    (loop for template in  templates
      do                                                                                                                #|line 46|#
          (register_component    reg  template )                                                                        #|line 47|#
      )                                                                                                                 #|line 48|#
)
(defun get_component_instance (&optional  reg  full_name  owner)                                                        #|line 50|#
    (let ((template_name (mangle_name    full_name                                                                      #|line 51|#)))
        (cond
          (( in   template_name (cdr (assoc ' templates  reg)))                                                         #|line 52|#
                (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))                                   #|line 53|#
                    (cond
                      (( equal    template  nil)                                                                        #|line 54|#
                            (load_error    (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 55|#)
                              (return-from get_component_instance  nil)                                                 #|line 56|#
                        )
                      (t                                                                                                #|line 57|#
                            (let ((owner_name  ""))                                                                     #|line 58|#
                                (let ((instance_name  template_name))                                                   #|line 59|#
                                    (cond
                                      ((not (equal   nil  owner))                                                       #|line 60|#
                                            (let ((owner_name (cdr (assoc ' name  owner))))                             #|line 61|#
                                                (let ((instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))))))#|line 62|#
                                        )
                                      (t                                                                                #|line 63|#
                                            (let ((instance_name  template_name)))                                      #|line 64|#
                                        ))
                                      (let ((instance (cdr (assoc '(instantiator    reg  owner  instance_name (cdr (assoc ' template_data  template)) #|line 65|#)  template))))
                                          (setf (cdr (assoc ' depth  instance)) (calculate_depth    instance            #|line 66|#))
                                            (return-from get_component_instance  instance))))
                        )))                                                                                             #|line 67|#
            )
          (t                                                                                                            #|line 68|#
                (load_error    (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 69|#)
                  (return-from get_component_instance  nil)                                                             #|line 70|#
            )))                                                                                                         #|line 71|#
)
(defun calculate_depth (&optional  eh)                                                                                  #|line 72|#
    (cond
      (( equal   (cdr (assoc ' owner  eh))  nil)                                                                        #|line 73|#
            (return-from calculate_depth  0)                                                                            #|line 74|#
        )
      (t                                                                                                                #|line 75|#
            (return-from calculate_depth (+  1 (calculate_depth   (cdr (assoc ' owner  eh)) )))                         #|line 76|#
        ))                                                                                                              #|line 77|#
)
(defun dump_registry (&optional  reg)                                                                                   #|line 79|#
    (print  )                                                                                                           #|line 80|#
      (print    "*** PALETTE ***"                                                                                       #|line 81|#)
        (loop for c in (cdr (assoc ' templates  reg))
          do                                                                                                            #|line 82|#
              (print   (cdr (assoc ' name  c)) )                                                                        #|line 83|#
          )
          (print    "***************"                                                                                   #|line 84|#)
            (print  )                                                                                                   #|line 85|##|line 86|#
)
(defun print_stats (&optional  reg)                                                                                     #|line 88|#
    (print    (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg)))                                 #|line 89|#)#|line 90|#
)
(defun mangle_name (&optional  s)                                                                                       #|line 92|#
    #|  trim name to remove code from Container component names _ deferred until later (or never) |#                    #|line 93|#
      (return-from mangle_name  s)                                                                                      #|line 94|##|line 95|#
)
(defun generate_shell_components (&optional  reg  container_list)                                                       #|line 98|#
    #|  [ |#                                                                                                            #|line 99|#
      #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 100|#
        #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                        #|line 101|#
          #|  ] |#                                                                                                      #|line 102|#
            (cond
              ((not (equal   nil  container_list))                                                                      #|line 103|#
                    (loop for diagram in  container_list
                      do                                                                                                #|line 104|#
                          #|  loop through every component in the diagram and look for names that start with “$“ |#     #|line 105|#
                            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 106|#
                              (loop for child_descriptor in (cdr (assoc 'children  diagram))
                                do                                                                                      #|line 107|#
                                    (cond
                                      ((first_char_is   (cdr (assoc 'name  child_descriptor))  "$" )                    #|line 108|#
                                            (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 109|#
                                                (let ((cmd (cdr (assoc '(strip  )  (subseq  name 1)))))                 #|line 110|#
                                                    (let ((generated_leaf (Template    name  shell_out_instantiate  cmd #|line 111|#)))
                                                        (register_component    reg  generated_leaf                      #|line 112|#))))
                                        )
                                      ((first_char_is   (cdr (assoc 'name  child_descriptor))  "'" )                    #|line 113|#
                                            (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 114|#
                                                (let ((s  (subseq  name 1)))                                            #|line 115|#
                                                    (let ((generated_leaf (Template    name  string_constant_instantiate  s #|line 116|#)))
                                                        (register_component_allow_overwriting    reg  generated_leaf    #|line 117|#))))#|line 118|#
                                        ))                                                                              #|line 119|#
                                )                                                                                       #|line 120|#
                      )                                                                                                 #|line 121|#
                ))                                                                                                      #|line 122|#
)
(defun first_char (&optional  s)                                                                                        #|line 124|#
    (return-from first_char  (car  s))                                                                                  #|line 125|##|line 126|#
)
(defun first_char_is (&optional  s  c)                                                                                  #|line 128|#
    (return-from first_char_is ( equal    c (first_char    s                                                            #|line 129|#)))#|line 130|#
)#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 132|##|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 133|#
(defun run_command (&optional  eh  cmd  s)                                                                              #|line 134|#
    #|  capture_output ∷ ⊤ |#                                                                                           #|line 135|#
      (let ((ret (cdr (assoc '(run    cmd  s  "UTF_8"                                                                   #|line 136|#)  subprocess))))
          (cond
            ((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                        #|line 137|#
                  (cond
                    ((not (equal  (cdr (assoc ' stderr  ret))  nil))                                                    #|line 138|#
                          (return-from run_command (values  "" (cdr (assoc ' stderr  ret))))                            #|line 139|#
                      )
                    (t                                                                                                  #|line 140|#
                          (return-from run_command (values  ""  (concatenate 'string  "error in shell_out " (cdr (assoc ' returncode  ret)))))
                      ))                                                                                                #|line 141|#
              )
            (t                                                                                                          #|line 142|#
                  (return-from run_command (values (cdr (assoc ' stdout  ret))  nil))                                   #|line 143|#
              )))                                                                                                       #|line 144|#
)#|  Data for an asyncronous component _ effectively, a function with input |#                                          #|line 146|##|  and output queues of messages. |##|line 147|##|  |##|line 148|##|  Components can either be a user_supplied function (“lea“), or a “container“ |##|line 149|##|  that routes messages to child components according to a list of connections |##|line 150|##|  that serve as a message routing table. |##|line 151|##|  |##|line 152|##|  Child components themselves can be leaves or other containers. |##|line 153|##|  |##|line 154|##|  `handler` invokes the code that is attached to this component. |##|line 155|##|  |##|line 156|##|  `instance_data` is a pointer to instance data that the `leaf_handler` |##|line 157|##|  function may want whenever it is invoked again. |##|line 158|##|  |##|line 159|##|line 160|##|line 163|##|line 164|##|  Eh_States :: enum { idle, active } |##|line 165|#
(defun Eh (&optional )                                                                                                  #|line 166|#
  (list
    (cons 'name  "")                                                                                                    #|line 167|#
    (cons 'inq (cdr (assoc '(Queue  )  queue)))                                                                         #|line 168|#
    (cons 'outq (cdr (assoc '(Queue  )  queue)))                                                                        #|line 169|#
    (cons 'owner  nil)                                                                                                  #|line 170|#
    (cons 'saved_messages (cdr (assoc '(LifoQueue  )  queue))) #|  stack of saved message(s) |#                         #|line 171|#
    (cons 'inject  injector_NIY)                                                                                        #|line 172|#
    (cons 'children  nil)                                                                                               #|line 173|#
    (cons 'visit_ordering (cdr (assoc '(Queue  )  queue)))                                                              #|line 174|#
    (cons 'connections  nil)                                                                                            #|line 175|#
    (cons 'routings (cdr (assoc '(Queue  )  queue)))                                                                    #|line 176|#
    (cons 'handler  nil)                                                                                                #|line 177|#
    (cons 'instance_data  nil)                                                                                          #|line 178|#
    (cons 'state  "idle")                                                                                               #|line 179|##|  bootstrap debugging |##|line 180|#
    (cons 'kind  nil) #|  enum { container, leaf, } |#                                                                  #|line 181|#
    (cons 'trace  nil) #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |##|line 182|#
    (cons 'depth  0) #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |##|line 183|#)#|line 184|#)
                                                                                                                        #|line 185|##|  Creates a component that acts as a container. It is the same as a `Eh` instance |##|line 186|##|  whose handler function is `container_handler`. |##|line 187|#
(defun make_container (&optional  name  owner)                                                                          #|line 188|#
    (let ((eh (Eh  )))                                                                                                  #|line 189|#
        (setf (cdr (assoc ' name  eh))  name)                                                                           #|line 190|#
          (setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 191|#
            (setf (cdr (assoc ' handler  eh))  container_handler)                                                       #|line 192|#
              (setf (cdr (assoc ' inject  eh))  container_injector)                                                     #|line 193|#
                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 194|#
                  (setf (cdr (assoc ' kind  eh))  "container")                                                          #|line 195|#
                    (return-from make_container  eh)                                                                    #|line 196|#)#|line 197|#
)#|  Creates a new leaf component out of a handler function, and a data parameter |#                                    #|line 199|##|  that will be passed back to your handler when called. |##|line 200|##|line 201|#
(defun make_leaf (&optional  name  owner  instance_data  handler)                                                       #|line 202|#
    (let ((eh (Eh  )))                                                                                                  #|line 203|#
        (setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)))#|line 204|#
          (setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 205|#
            (setf (cdr (assoc ' handler  eh))  handler)                                                                 #|line 206|#
              (setf (cdr (assoc ' instance_data  eh))  instance_data)                                                   #|line 207|#
                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 208|#
                  (setf (cdr (assoc ' kind  eh))  "leaf")                                                               #|line 209|#
                    (return-from make_leaf  eh)                                                                         #|line 210|#)#|line 211|#
)#|  Sends a message on the given `port` with `data`, placing it on the output |#                                       #|line 213|##|  of the given component. |##|line 214|##|line 215|#
(defun send (&optional  eh  port  datum  causingMessage)                                                                #|line 216|#
    (let ((msg (make_message    port  datum                                                                             #|line 217|#)))
        (log_send    eh  port  msg  causingMessage                                                                      #|line 218|#)
          (put_output    eh  msg                                                                                        #|line 219|#))#|line 220|#
)
(defun send_string (&optional  eh  port  s  causingMessage)                                                             #|line 222|#
    (let ((datum (new_datum_string    s                                                                                 #|line 223|#)))
        (let ((msg (make_message    port  datum                                                                         #|line 224|#)))
            (log_send_string    eh  port  msg  causingMessage                                                           #|line 225|#)
              (put_output    eh  msg                                                                                    #|line 226|#)))#|line 227|#
)
(defun forward (&optional  eh  port  msg)                                                                               #|line 229|#
    (let ((fwdmsg (make_message    port (cdr (assoc ' datum  msg))                                                      #|line 230|#)))
        (log_forward    eh  port  msg  msg                                                                              #|line 231|#)
          (put_output    eh  msg                                                                                        #|line 232|#))#|line 233|#
)
(defun inject (&optional  eh  msg)                                                                                      #|line 235|#
    (cdr (assoc '(inject    eh  msg                                                                                     #|line 236|#)  eh))#|line 237|#
)#|  Returns a list of all output messages on a container. |#                                                           #|line 239|##|  For testing / debugging purposes. |##|line 240|##|line 241|#
(defun output_list (&optional  eh)                                                                                      #|line 242|#
    (return-from output_list (cdr (assoc ' outq  eh)))                                                                  #|line 243|##|line 244|#
)#|  Utility for printing an array of messages. |#                                                                      #|line 246|#
(defun print_output_list (&optional  eh)                                                                                #|line 247|#
    (loop for m in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
      do                                                                                                                #|line 248|#
          (print   (format_message    m ) )                                                                             #|line 249|#
      )                                                                                                                 #|line 250|#
)
(defun spaces (&optional  n)                                                                                            #|line 252|#
    (let (( s  ""))                                                                                                     #|line 253|#
        (loop for i in (loop for n from 0 below  n by 1 collect n)
          do                                                                                                            #|line 254|#
              (setf  s (+  s  " "))                                                                                     #|line 255|#
          )
          (return-from spaces  s)                                                                                       #|line 256|#)#|line 257|#
)
(defun set_active (&optional  eh)                                                                                       #|line 259|#
    (setf (cdr (assoc ' state  eh))  "active")                                                                          #|line 260|##|line 261|#
)
(defun set_idle (&optional  eh)                                                                                         #|line 263|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 264|##|line 265|#
)#|  Utility for printing a specific output message. |#                                                                 #|line 267|##|line 268|#
(defun fetch_first_output (&optional  eh  port)                                                                         #|line 269|#
    (loop for msg in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
      do                                                                                                                #|line 270|#
          (cond
            (( equal   (cdr (assoc ' port  msg))  port)                                                                 #|line 271|#
                  (return-from fetch_first_output (cdr (assoc ' datum  msg)))
              ))                                                                                                        #|line 272|#
      )
      (return-from fetch_first_output  nil)                                                                             #|line 273|##|line 274|#
)
(defun print_specific_output (&optional  eh  port)                                                                      #|line 276|#
    #|  port ∷ “” |#                                                                                                    #|line 277|#
      (let (( datum (fetch_first_output    eh  port                                                                     #|line 278|#)))
          (let (( outf  nil))                                                                                           #|line 279|#
              (cond
                ((not (equal   datum  nil))                                                                             #|line 280|#
                      (setf  outf (cdr (assoc ' stdout  sys)))                                                          #|line 281|#
                        (print   (cdr (assoc '(srepr  )  datum))  outf )                                                #|line 282|#
                  ))))                                                                                                  #|line 283|#
)
(defun print_specific_output_to_stderr (&optional  eh  port)                                                            #|line 284|#
    #|  port ∷ “” |#                                                                                                    #|line 285|#
      (let (( datum (fetch_first_output    eh  port                                                                     #|line 286|#)))
          (let (( outf  nil))                                                                                           #|line 287|#
              (cond
                ((not (equal   datum  nil))                                                                             #|line 288|#
                      #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |##|line 289|#
                        (setf  outf (cdr (assoc ' stderr  sys)))                                                        #|line 290|#
                          (print   (cdr (assoc '(srepr  )  datum))  outf )                                              #|line 291|#
                  ))))                                                                                                  #|line 292|#
)
(defun put_output (&optional  eh  msg)                                                                                  #|line 294|#
    (cdr (assoc '(cdr (assoc '(put    msg                                                                               #|line 295|#)  outq))  eh))#|line 296|#
)
(defun injector_NIY (&optional  eh  msg)                                                                                #|line 298|#
    #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#      #|line 299|#
      (print    (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))) #|line 304|#)
        (exit  )                                                                                                        #|line 305|##|line 306|#
)                                                                                                                       #|line 312|#
(defparameter  root_project  "")                                                                                        #|line 313|#
(defparameter  root_0D  "")                                                                                             #|line 314|##|line 315|#
(defun set_environment (&optional  rproject  r0D)                                                                       #|line 316|##|line 317|##|line 318|#
        (setf  root_project  rproject)                                                                                  #|line 319|#
          (setf  root_0D  r0D)                                                                                          #|line 320|##|line 321|#
)
(defun probe_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 323|#
    (let ((name_with_id (gensymbol    "?"                                                                               #|line 324|#)))
        (return-from probe_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                            #|line 325|#)))#|line 326|#
)
(defun probeA_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 327|#
    (let ((name_with_id (gensymbol    "?A"                                                                              #|line 328|#)))
        (return-from probeA_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                           #|line 329|#)))#|line 330|#
)
(defun probeB_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 332|#
    (let ((name_with_id (gensymbol    "?B"                                                                              #|line 333|#)))
        (return-from probeB_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                           #|line 334|#)))#|line 335|#
)
(defun probeC_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 337|#
    (let ((name_with_id (gensymbol    "?C"                                                                              #|line 338|#)))
        (return-from probeC_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                           #|line 339|#)))#|line 340|#
)
(defun probe_handler (&optional  eh  msg)                                                                               #|line 342|#
    (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                      #|line 343|#
        (print    (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))) (cdr (assoc ' stderr  sys)) #|line 344|#))#|line 345|#
)
(defun trash_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 347|#
    (let ((name_with_id (gensymbol    "trash"                                                                           #|line 348|#)))
        (return-from trash_instantiate (make_leaf    name_with_id  owner  nil  trash_handler                            #|line 349|#)))#|line 350|#
)
(defun trash_handler (&optional  eh  msg)                                                                               #|line 352|#
    #|  to appease dumped_on_floor checker |#                                                                           #|line 353|#
      #| pass |#                                                                                                        #|line 354|##|line 355|#
)
(defun TwoMessages (&optional  first  second)                                                                           #|line 356|#
  (list
    (cons 'first  first)                                                                                                #|line 357|#
    (cons 'second  second)                                                                                              #|line 358|#)#|line 359|#)
                                                                                                                        #|line 360|##|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |##|line 361|#
(defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 362|#
  (list
    (cons 'state  state)                                                                                                #|line 363|#
    (cons 'buffer  buffer)                                                                                              #|line 364|#)#|line 365|#)
                                                                                                                        #|line 366|#
(defun reclaim_Buffers_from_heap (&optional  inst)                                                                      #|line 367|#
    #| pass |#                                                                                                          #|line 368|##|line 369|#
)
(defun deracer_instantiate (&optional  reg  owner  name  template_data)                                                 #|line 371|#
    (let ((name_with_id (gensymbol    "deracer"                                                                         #|line 372|#)))
        (let ((inst (Deracer_Instance_Data    "idle" (TwoMessages    nil  nil )                                         #|line 373|#)))
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 374|#
              (let ((eh (make_leaf    name_with_id  owner  inst  deracer_handler                                        #|line 375|#)))
                  (return-from deracer_instantiate  eh)                                                                 #|line 376|#)))#|line 377|#
)
(defun send_first_then_second (&optional  eh  inst)                                                                     #|line 379|#
    (forward    eh  "1" (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                              #|line 380|#)
      (forward    eh  "2" (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                           #|line 381|#)
        (reclaim_Buffers_from_heap    inst                                                                              #|line 382|#)#|line 383|#
)
(defun deracer_handler (&optional  eh  msg)                                                                             #|line 385|#
    (setf  inst (cdr (assoc ' instance_data  eh)))                                                                      #|line 386|#
      (cond
        (( equal   (cdr (assoc ' state  inst))  "idle")                                                                 #|line 387|#
              (cond
                (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 388|#
                      (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 389|#
                        (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                          #|line 390|#
                  )
                (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 391|#
                      (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 392|#
                        (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                           #|line 393|#
                  )
                (t                                                                                                      #|line 394|#
                      (runtime_error    (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 395|#
          )
        (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                      #|line 396|#
              (cond
                (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 397|#
                      (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 398|#
                        (send_first_then_second    eh  inst                                                             #|line 399|#)
                          (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 400|#
                  )
                (t                                                                                                      #|line 401|#
                      (runtime_error    (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 402|#
          )
        (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                     #|line 403|#
              (cond
                (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 404|#
                      (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 405|#
                        (send_first_then_second    eh  inst                                                             #|line 406|#)
                          (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 407|#
                  )
                (t                                                                                                      #|line 408|#
                      (runtime_error    (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 409|#
          )
        (t                                                                                                              #|line 410|#
              (runtime_error    "bad state for deracer {eh.state}" )                                                    #|line 411|#
          ))                                                                                                            #|line 412|#
)
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)                                #|line 414|#
    (let ((name_with_id (gensymbol    "Low Level Read Text File"                                                        #|line 415|#)))
        (return-from low_level_read_text_file_instantiate (make_leaf    name_with_id  owner  nil  low_level_read_text_file_handler #|line 416|#)))#|line 417|#
)
(defun low_level_read_text_file_handler (&optional  eh  msg)                                                            #|line 419|#
    (let ((fname (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                  #|line 420|#
        ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
        ;; given eh and msg if needed
        (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
          (with-open-file (stream fname)
            (let ((contents (make-string (file-length stream))))
              (read-sequence contents stream)
              (send_string eh "" contents))))
                                                                                                                        #|line 421|#)#|line 422|#
)
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)                                     #|line 424|#
    (let ((name_with_id (gensymbol    "Ensure String Datum"                                                             #|line 425|#)))
        (return-from ensure_string_datum_instantiate (make_leaf    name_with_id  owner  nil  ensure_string_datum_handler #|line 426|#)))#|line 427|#
)
(defun ensure_string_datum_handler (&optional  eh  msg)                                                                 #|line 429|#
    (cond
      (( equal    "string" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg)))                                          #|line 430|#
            (forward    eh  ""  msg )                                                                                   #|line 431|#
        )
      (t                                                                                                                #|line 432|#
            (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))))#|line 433|#
                (send_string    eh  "✗"  emsg  msg ))                                                                   #|line 434|#
        ))                                                                                                              #|line 435|#
)
(defun Syncfilewrite_Data (&optional )                                                                                  #|line 437|#
  (list
    (cons 'filename  "")                                                                                                #|line 438|#)#|line 439|#)
                                                                                                                        #|line 440|##|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |##|line 441|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)                                           #|line 442|#
    (let ((name_with_id (gensymbol    "syncfilewrite"                                                                   #|line 443|#)))
        (let ((inst (Syncfilewrite_Data  )))                                                                            #|line 444|#
            (return-from syncfilewrite_instantiate (make_leaf    name_with_id  owner  inst  syncfilewrite_handler       #|line 445|#))))#|line 446|#
)
(defun syncfilewrite_handler (&optional  eh  msg)                                                                       #|line 448|#
    (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 449|#
        (cond
          (( equal    "filename" (cdr (assoc ' port  msg)))                                                             #|line 450|#
                (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)))               #|line 451|#
            )
          (( equal    "input" (cdr (assoc ' port  msg)))                                                                #|line 452|#
                (let ((contents (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                   #|line 453|#
                    (let (( f (open   (cdr (assoc ' filename  inst))  "w"                                               #|line 454|#)))
                        (cond
                          ((not (equal   f  nil))                                                                       #|line 455|#
                                (cdr (assoc '(write   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))               #|line 456|#)  f))
                                  (cdr (assoc '(close  )  f))                                                           #|line 457|#
                                    (send    eh  "done" (new_datum_bang  )  msg )                                       #|line 458|#
                            )
                          (t                                                                                            #|line 459|#
                                (send_string    eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))  msg )
                            ))))                                                                                        #|line 460|#
            )))                                                                                                         #|line 461|#
)
(defun StringConcat_Instance_Data (&optional )                                                                          #|line 463|#
  (list
    (cons 'buffer1  nil)                                                                                                #|line 464|#
    (cons 'buffer2  nil)                                                                                                #|line 465|#
    (cons 'count  0)                                                                                                    #|line 466|#)#|line 467|#)
                                                                                                                        #|line 468|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)                                            #|line 469|#
    (let ((name_with_id (gensymbol    "stringconcat"                                                                    #|line 470|#)))
        (let ((instp (StringConcat_Instance_Data  )))                                                                   #|line 471|#
            (return-from stringconcat_instantiate (make_leaf    name_with_id  owner  instp  stringconcat_handler        #|line 472|#))))#|line 473|#
)
(defun stringconcat_handler (&optional  eh  msg)                                                                        #|line 475|#
    (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 476|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 477|#
                (setf (cdr (assoc ' buffer1  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 478|#))
                  (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 479|#
                    (maybe_stringconcat    eh  inst  msg )                                                              #|line 480|#
            )
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 481|#
                (setf (cdr (assoc ' buffer2  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 482|#))
                  (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 483|#
                    (maybe_stringconcat    eh  inst  msg )                                                              #|line 484|#
            )
          (t                                                                                                            #|line 485|#
                (runtime_error    (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))    #|line 486|#)#|line 487|#
            )))                                                                                                         #|line 488|#
)
(defun maybe_stringconcat (&optional  eh  inst  msg)                                                                    #|line 490|#
    (cond
      (( and  ( equal    0 (len   (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len   (cdr (assoc ' buffer2  inst)) )))#|line 491|#
            (runtime_error    "something is wrong in stringconcat, both strings are 0 length" )                         #|line 492|#
        ))
      (cond
        (( >=  (cdr (assoc ' count  inst))  2)                                                                          #|line 493|#
              (let (( concatenated_string  ""))                                                                         #|line 494|#
                  (cond
                    (( equal    0 (len   (cdr (assoc ' buffer1  inst)) ))                                               #|line 495|#
                          (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                     #|line 496|#
                      )
                    (( equal    0 (len   (cdr (assoc ' buffer2  inst)) ))                                               #|line 497|#
                          (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                     #|line 498|#
                      )
                    (t                                                                                                  #|line 499|#
                          (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst))))   #|line 500|#
                      ))
                    (send_string    eh  ""  concatenated_string  msg                                                    #|line 501|#)
                      (setf (cdr (assoc ' buffer1  inst))  nil)                                                         #|line 502|#
                        (setf (cdr (assoc ' buffer2  inst))  nil)                                                       #|line 503|#
                          (setf (cdr (assoc ' count  inst))  0))                                                        #|line 504|#
          ))                                                                                                            #|line 505|#
)#|  |#                                                                                                                 #|line 507|##|line 508|##|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 509|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)                                               #|line 510|#
    (let ((name_with_id (gensymbol    "shell_out"                                                                       #|line 511|#)))
        (let ((cmd (cdr (assoc '(split    template_data                                                                 #|line 512|#)  shlex))))
            (return-from shell_out_instantiate (make_leaf    name_with_id  owner  cmd  shell_out_handler                #|line 513|#))))#|line 514|#
)
(defun shell_out_handler (&optional  eh  msg)                                                                           #|line 516|#
    (let ((cmd (cdr (assoc ' instance_data  eh))))                                                                      #|line 517|#
        (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                  #|line 518|#
            (multiple-value-setq ( stdout  stderr) (run_command    eh  cmd  s                                           #|line 519|#))
              (cond
                ((not (equal   stderr  nil))                                                                            #|line 520|#
                      (send_string    eh  "✗"  stderr  msg )                                                            #|line 521|#
                  )
                (t                                                                                                      #|line 522|#
                      (send_string    eh  ""  stdout  msg )                                                             #|line 523|#
                  ))))                                                                                                  #|line 524|#
)
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)                                         #|line 526|##|line 527|##|line 528|#
        (let ((name_with_id (gensymbol    "strconst"                                                                    #|line 529|#)))
            (let (( s  template_data))                                                                                  #|line 530|#
                (cond
                  ((not (equal   root_project  ""))                                                                     #|line 531|#
                        (setf  s (cdr (assoc '(sub    "_00_"  root_project  s )  re)))                                  #|line 532|#
                    ))
                  (cond
                    ((not (equal   root_0D  ""))                                                                        #|line 533|#
                          (setf  s (cdr (assoc '(sub    "_0D_"  root_0D  s )  re)))                                     #|line 534|#
                      ))
                    (return-from string_constant_instantiate (make_leaf    name_with_id  owner  s  string_constant_handler #|line 535|#))))#|line 536|#
)
(defun string_constant_handler (&optional  eh  msg)                                                                     #|line 538|#
    (let ((s (cdr (assoc ' instance_data  eh))))                                                                        #|line 539|#
        (send_string    eh  ""  s  msg                                                                                  #|line 540|#))#|line 541|#
)
(defun string_make_persistent (&optional  s)                                                                            #|line 543|#
    #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                      #|line 544|#
      (return-from string_make_persistent  s)                                                                           #|line 545|##|line 546|#
)
(defun string_clone (&optional  s)                                                                                      #|line 548|#
    (return-from string_clone  s)                                                                                       #|line 549|##|line 550|#
)                                                                                                                       #|line 553|##|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |##|line 554|##|  where ${_00_} is the root directory for the project |##|line 555|##|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |##|line 556|##|line 557|##|line 558|##|line 559|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)                            #|line 560|#
    (let ((reg (make_component_registry  )))                                                                            #|line 561|#
        (loop for diagram_source in  diagram_source_files
          do                                                                                                            #|line 562|#
              (let ((all_containers_within_single_file (json2internal    diagram_source                                 #|line 563|#)))
                  (generate_shell_components    reg  all_containers_within_single_file                                  #|line 564|#)
                    (loop for container in  all_containers_within_single_file
                      do                                                                                                #|line 565|#
                          (register_component    reg (Template   (cdr (assoc 'name  container)) #|  template_data =  |# container #|  instantiator =  |# container_instantiator ) )
                      ))                                                                                                #|line 566|#
          )
          (initialize_stock_components    reg                                                                           #|line 567|#)
            (return-from initialize_component_palette  reg)                                                             #|line 568|#)#|line 569|#
)
(defun print_error_maybe (&optional  main_container)                                                                    #|line 571|#
    (let ((error_port  "✗"))                                                                                            #|line 572|#
        (let ((err (fetch_first_output    main_container  error_port                                                    #|line 573|#)))
            (cond
              (( and  (not (equal   err  nil)) ( <   0 (len   (trimws   (cdr (assoc '(srepr  )  err)) ) )))             #|line 574|#
                    (print    "___ !!! ERRORS !!! ___"                                                                  #|line 575|#)
                      (print_specific_output    main_container  error_port  nil )                                       #|line 576|#
                ))))                                                                                                    #|line 577|#
)#|  debugging helpers |#                                                                                               #|line 579|##|line 580|#
(defun dump_outputs (&optional  main_container)                                                                         #|line 581|#
    (print  )                                                                                                           #|line 582|#
      (print    "___ Outputs ___"                                                                                       #|line 583|#)
        (print_output_list    main_container                                                                            #|line 584|#)#|line 585|#
)
(defun trace_outputs (&optional  main_container)                                                                        #|line 587|#
    (print  )                                                                                                           #|line 588|#
      (print    "___ Message Traces ___"                                                                                #|line 589|#)
        (print_routing_trace    main_container                                                                          #|line 590|#)#|line 591|#
)
(defun dump_hierarchy (&optional  main_container)                                                                       #|line 593|#
    (print  )                                                                                                           #|line 594|#
      (print    (concatenate 'string  "___ Hierarchy ___" (build_hierarchy    main_container ))                         #|line 595|#)#|line 596|#
)
(defun build_hierarchy (&optional  c)                                                                                   #|line 598|#
    (let (( s  ""))                                                                                                     #|line 599|#
        (loop for child in (cdr (assoc ' children  c))
          do                                                                                                            #|line 600|#
              (setf  s  (concatenate 'string  s (build_hierarchy    child )))                                           #|line 601|#
          )
          (let (( indent  ""))                                                                                          #|line 602|#
              (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
                do                                                                                                      #|line 603|#
                    (setf  indent (+  indent  "  "))                                                                    #|line 604|#
                )
                (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")"))))))#|line 605|#))#|line 606|#
)
(defun dump_connections (&optional  c)                                                                                  #|line 608|#
    (print  )                                                                                                           #|line 609|#
      (print    "___ connections ___"                                                                                   #|line 610|#)
        (dump_possible_connections    c                                                                                 #|line 611|#)
          (loop for child in (cdr (assoc ' children  c))
            do                                                                                                          #|line 612|#
                (print  )                                                                                               #|line 613|#
                  (dump_possible_connections    child )                                                                 #|line 614|#
            )                                                                                                           #|line 615|#
)
(defun trimws (&optional  s)                                                                                            #|line 617|#
    #|  remove whitespace from front and back of string |#                                                              #|line 618|#
      (return-from trimws (cdr (assoc '(strip  )  s)))                                                                  #|line 619|##|line 620|#
)
(defun clone_string (&optional  s)                                                                                      #|line 622|#
    (return-from clone_string  s                                                                                        #|line 623|##|line 624|#)#|line 625|#
)
(defparameter  load_errors  nil)                                                                                        #|line 626|#
(defparameter  runtime_errors  nil)                                                                                     #|line 627|##|line 628|#
(defun load_error (&optional  s)                                                                                        #|line 629|##|line 630|#
      (print    s                                                                                                       #|line 631|#)
        (quit  )                                                                                                        #|line 632|#
          (setf  load_errors  t)                                                                                        #|line 633|##|line 634|#
)
(defun runtime_error (&optional  s)                                                                                     #|line 636|##|line 637|#
      (print    s                                                                                                       #|line 638|#)
        (quit  )                                                                                                        #|line 639|#
          (setf  runtime_errors  t)                                                                                     #|line 640|##|line 641|#
)
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)                                            #|line 643|#
    (let ((instance_name (gensymbol    "fakepipe"                                                                       #|line 644|#)))
        (return-from fakepipename_instantiate (make_leaf    instance_name  owner  nil  fakepipename_handler             #|line 645|#)))#|line 646|#
)
(defparameter  rand  0)                                                                                                 #|line 648|##|line 649|#
(defun fakepipename_handler (&optional  eh  msg)                                                                        #|line 650|##|line 651|#
      (setf  rand (+  rand  1))
        #|  not very random, but good enough _ 'rand' must be unique within a single run |#                             #|line 652|#
          (send_string    eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg                                     #|line 653|#)#|line 654|#
)                                                                                                                       #|line 656|##|  all of the the built_in leaves are listed here |##|line 657|##|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 658|##|line 659|##|line 660|#
(defun initialize_stock_components (&optional  reg)                                                                     #|line 661|#
    (register_component    reg (Template    "1then2"  nil  deracer_instantiate )                                        #|line 662|#)
      (register_component    reg (Template    "?"  nil  probe_instantiate )                                             #|line 663|#)
        (register_component    reg (Template    "?A"  nil  probeA_instantiate )                                         #|line 664|#)
          (register_component    reg (Template    "?B"  nil  probeB_instantiate )                                       #|line 665|#)
            (register_component    reg (Template    "?C"  nil  probeC_instantiate )                                     #|line 666|#)
              (register_component    reg (Template    "trash"  nil  trash_instantiate )                                 #|line 667|#)#|line 668|#
                (register_component    reg (Template    "Low Level Read Text File"  nil  low_level_read_text_file_instantiate ) #|line 669|#)
                  (register_component    reg (Template    "Ensure String Datum"  nil  ensure_string_datum_instantiate ) #|line 670|#)#|line 671|#
                    (register_component    reg (Template    "syncfilewrite"  nil  syncfilewrite_instantiate )           #|line 672|#)
                      (register_component    reg (Template    "stringconcat"  nil  stringconcat_instantiate )           #|line 673|#)
                        #|  for fakepipe |#                                                                             #|line 674|#
                          (register_component    reg (Template    "fakepipename"  nil  fakepipename_instantiate )       #|line 675|#)#|line 676|#
)                                                                                                                       #|line 678|#
(defun initialize (&optional )                                                                                          #|line 679|#
    (let ((root_of_project  (nth  1 argv)))                                                                             #|line 680|#
        (let ((root_of_0D  (nth  2 argv)))                                                                              #|line 681|#
            (let ((arg  (nth  3 argv)))                                                                                 #|line 682|#
                (let ((main_container_name  (nth  4 argv)))                                                             #|line 683|#
                    (let ((diagram_names  (nthcdr  5 (argv))))                                                          #|line 684|#
                        (let ((palette (initialize_component_palette    root_project  root_0D  diagram_names            #|line 685|#)))
                            (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg )))#|line 686|#))))))#|line 687|#
)
(defun start (&optional  palette  env)
    (start_with_debug    palette  env  nil  nil  nil  nil )                                                             #|line 689|#
)
(defun start_with_debug (&optional  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs)      #|line 690|#
    #|  show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥ |#                                      #|line 691|#
      (let ((root_of_project (nth  0  env)))                                                                            #|line 692|#
          (let ((root_of_0D (nth  1  env)))                                                                             #|line 693|#
              (let ((main_container_name (nth  2  env)))                                                                #|line 694|#
                  (let ((diagram_names (nth  3  env)))                                                                  #|line 695|#
                      (let ((arg (nth  4  env)))                                                                        #|line 696|#
                          (set_environment    root_of_project  root_of_0D                                               #|line 697|#)
                            #|  get entrypoint container |#                                                             #|line 698|#
                              (let (( main_container (get_component_instance    palette  main_container_name  nil       #|line 699|#)))
                                  (cond
                                    (( equal    nil  main_container)                                                    #|line 700|#
                                          (load_error    (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)")))) #|line 704|#)#|line 705|#
                                      ))
                                    (cond
                                      ( show_hierarchy                                                                  #|line 706|#
                                            (dump_hierarchy    main_container                                           #|line 707|#)#|line 708|#
                                        ))
                                      (cond
                                        ( show_connections                                                              #|line 709|#
                                              (dump_connections    main_container                                       #|line 710|#)#|line 711|#
                                          ))
                                        (cond
                                          ((not  load_errors)                                                           #|line 712|#
                                                (let (( arg (new_datum_string    arg                                    #|line 713|#)))
                                                    (let (( msg (make_message    ""  arg                                #|line 714|#)))
                                                        (inject    main_container  msg                                  #|line 715|#)
                                                          (cond
                                                            ( show_all_outputs                                          #|line 716|#
                                                                  (dump_outputs    main_container                       #|line 717|#)
                                                              )
                                                            (t                                                          #|line 718|#
                                                                  (print_error_maybe    main_container                  #|line 719|#)
                                                                    (print_specific_output    main_container  ""        #|line 720|#)
                                                                      (cond
                                                                        ( show_traces                                   #|line 721|#
                                                                              (print    "--- routing traces ---"        #|line 722|#)
                                                                                (print   (routing_trace_all    main_container ) #|line 723|#)#|line 724|#
                                                                          ))                                            #|line 725|#
                                                              ))
                                                            (cond
                                                              ( show_all_outputs                                        #|line 726|#
                                                                    (print    "--- done ---"                            #|line 727|#)#|line 728|#
                                                                ))))                                                    #|line 729|#
                                            ))))))))                                                                    #|line 730|#
)                                                                                                                       #|line 732|##|line 733|##|  utility functions  |##|line 734|#
(defun send_int (&optional  eh  port  i  causing_message)                                                               #|line 735|#
    (let ((datum (new_datum_int    i                                                                                    #|line 736|#)))
        (send    eh  port  datum  causing_message                                                                       #|line 737|#))#|line 738|#
)
(defun send_bang (&optional  eh  port  causing_message)                                                                 #|line 740|#
    (let ((datum (new_datum_bang  )))                                                                                   #|line 741|#
        (send    eh  port  datum  causing_message                                                                       #|line 742|#))#|line 743|#
)





