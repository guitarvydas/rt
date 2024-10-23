
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
    (let ((fname (cdr (assoc '(cdr (assoc '(basename     container_xml                                                  #|line 21|#)  path))  os))))
        (let ((routings (read_and_convert_json_file     fname                                                           #|line 22|#)))
            (return-from json2internal  routings)                                                                       #|line 23|#))#|line 24|#
)
(defun delete_decls (&optional  d)                                                                                      #|line 26|#
    #| pass |#                                                                                                          #|line 27|##|line 28|#
)
(defun make_component_registry (&optional )                                                                             #|line 30|#
    (return-from make_component_registry (Component_Registry  ))                                                        #|line 31|##|line 32|#
)
(defun register_component (&optional  reg  template  (ok_to_overwrite  nil))                                            #|line 34|#
    (let ((name (mangle_name    (cdr (assoc ' name  template))                                                          #|line 35|#)))
        (cond
          (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                   #|line 36|#
                (load_error     (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 37|#
            ))
          (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                   #|line 38|#
            (return-from register_component  reg)                                                                       #|line 39|#)#|line 40|#
)
(defun register_multiple_components (&optional  reg  templates)                                                         #|line 42|#
    (loop for template in  templates
      do                                                                                                                #|line 43|#
          (register_component     reg   template )                                                                      #|line 44|#
      )                                                                                                                 #|line 45|#
)
(defun get_component_instance (&optional  reg  full_name  owner)                                                        #|line 47|#
    (let ((template_name (mangle_name     full_name                                                                     #|line 48|#)))
        (cond
          (( in   template_name (cdr (assoc ' templates  reg)))                                                         #|line 49|#
                (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))                                   #|line 50|#
                    (cond
                      (( equal    template  nil)                                                                        #|line 51|#
                            (load_error     (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 52|#)
                              (return-from get_component_instance  nil)                                                 #|line 53|#
                        )
                      (t                                                                                                #|line 54|#
                            (let ((owner_name  ""))                                                                     #|line 55|#
                                (let ((instance_name  template_name))                                                   #|line 56|#
                                    (cond
                                      ((not (equal   nil  owner))                                                       #|line 57|#
                                            (let ((owner_name (cdr (assoc ' name  owner))))                             #|line 58|#
                                                (let ((instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))))))#|line 59|#
                                        )
                                      (t                                                                                #|line 60|#
                                            (let ((instance_name  template_name)))                                      #|line 61|#
                                        ))
                                      (let ((instance (cdr (assoc '(instantiator     reg   owner   instance_name  (cdr (assoc ' template_data  template)) #|line 62|#)  template))))
                                          (setf (cdr (assoc ' depth  instance)) (calculate_depth     instance           #|line 63|#))
                                            (return-from get_component_instance  instance))))
                        )))                                                                                             #|line 64|#
            )
          (t                                                                                                            #|line 65|#
                (load_error     (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 66|#)
                  (return-from get_component_instance  nil)                                                             #|line 67|#
            )))                                                                                                         #|line 68|#
)
(defun calculate_depth (&optional  eh)                                                                                  #|line 69|#
    (cond
      (( equal   (cdr (assoc ' owner  eh))  nil)                                                                        #|line 70|#
            (return-from calculate_depth  0)                                                                            #|line 71|#
        )
      (t                                                                                                                #|line 72|#
            (return-from calculate_depth (+  1 (calculate_depth    (cdr (assoc ' owner  eh)) )))                        #|line 73|#
        ))                                                                                                              #|line 74|#
)
(defun dump_registry (&optional  reg)                                                                                   #|line 76|#
    (print  )                                                                                                           #|line 77|#
      (print     "*** PALETTE ***"                                                                                      #|line 78|#)
        (loop for c in (cdr (assoc ' templates  reg))
          do                                                                                                            #|line 79|#
              (print    (cdr (assoc ' name  c)) )                                                                       #|line 80|#
          )
          (print     "***************"                                                                                  #|line 81|#)
            (print  )                                                                                                   #|line 82|##|line 83|#
)
(defun print_stats (&optional  reg)                                                                                     #|line 85|#
    (print     (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg)))                                #|line 86|#)#|line 87|#
)
(defun mangle_name (&optional  s)                                                                                       #|line 89|#
    #|  trim name to remove code from Container component names _ deferred until later (or never) |#                    #|line 90|#
      (return-from mangle_name  s)                                                                                      #|line 91|##|line 92|#
)
(defun generate_shell_components (&optional  reg  container_list)                                                       #|line 95|#
    #|  [ |#                                                                                                            #|line 96|#
      #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 97|#
        #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                        #|line 98|#
          #|  ] |#                                                                                                      #|line 99|#
            (cond
              ((not (equal   nil  container_list))                                                                      #|line 100|#
                    (loop for diagram in  container_list
                      do                                                                                                #|line 101|#
                          #|  loop through every component in the diagram and look for names that start with “$“ |#     #|line 102|#
                            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 103|#
                              (loop for child_descriptor in (cdr (assoc 'children  diagram))
                                do                                                                                      #|line 104|#
                                    (cond
                                      ((first_char_is    (cdr (assoc 'name  child_descriptor))   "$" )                  #|line 105|#
                                            (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 106|#
                                                (let ((cmd (cdr (assoc '(strip  )  (subseq  name 1)))))                 #|line 107|#
                                                    (let ((generated_leaf (Template   :name  name :instantiator  shell_out_instantiate :template_data  cmd #|line 108|#)))
                                                        (register_component     reg   generated_leaf ))))               #|line 109|#
                                        )
                                      ((first_char_is    (cdr (assoc 'name  child_descriptor))   "'" )                  #|line 110|#
                                            (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 111|#
                                                (let ((s  (subseq  name 1)))                                            #|line 112|#
                                                    (let ((generated_leaf (Template   :name  name :instantiator  string_constant_instantiate :template_data  s #|line 113|#)))
                                                        (register_component     reg   generated_leaf :ok_to_overwrite  t ))))
                                        ))
                                )
                      )                                                                                                 #|line 114|#
                ))                                                                                                      #|line 115|#
)
(defun first_char (&optional  s)                                                                                        #|line 117|#
    (return-from first_char  (car  s))                                                                                  #|line 118|##|line 119|#
)
(defun first_char_is (&optional  s  c)                                                                                  #|line 121|#
    (return-from first_char_is ( equal    c (first_char     s                                                           #|line 122|#)))#|line 123|#
)#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 125|##|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 126|#
(defun run_command (&optional  eh  cmd  s)                                                                              #|line 127|#
    (let ((ret (cdr (assoc '(run     cmd :capture_output  t :input  s :encoding  "UTF_8"                                #|line 128|#)  subprocess))))
        (cond
          ((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                          #|line 129|#
                (cond
                  ((not (equal  (cdr (assoc ' stderr  ret))  nil))                                                      #|line 130|#
                        (return-from run_command (values  "" (cdr (assoc ' stderr  ret))))                              #|line 131|#
                    )
                  (t                                                                                                    #|line 132|#
                        (return-from run_command (values  ""  (concatenate 'string  "error in shell_out " (cdr (assoc ' returncode  ret)))))
                    ))                                                                                                  #|line 133|#
            )
          (t                                                                                                            #|line 134|#
                (return-from run_command (values (cdr (assoc ' stdout  ret))  nil))                                     #|line 135|#
            )))                                                                                                         #|line 136|#
)#|  Data for an asyncronous component _ effectively, a function with input |#                                          #|line 138|##|  and output queues of messages. |##|line 139|##|  |##|line 140|##|  Components can either be a user_supplied function (“lea“), or a “container“ |##|line 141|##|  that routes messages to child components according to a list of connections |##|line 142|##|  that serve as a message routing table. |##|line 143|##|  |##|line 144|##|  Child components themselves can be leaves or other containers. |##|line 145|##|  |##|line 146|##|  `handler` invokes the code that is attached to this component. |##|line 147|##|  |##|line 148|##|  `instance_data` is a pointer to instance data that the `leaf_handler` |##|line 149|##|  function may want whenever it is invoked again. |##|line 150|##|  |##|line 151|##|line 152|##|line 155|##|line 156|##|  Eh_States :: enum { idle, active } |##|line 157|#
(defun Eh (&optional )                                                                                                  #|line 158|#
  (list
    (cons 'name  "")                                                                                                    #|line 159|#
    (cons 'inq (cdr (assoc '(Queue  )  queue)))                                                                         #|line 160|#
    (cons 'outq (cdr (assoc '(Queue  )  queue)))                                                                        #|line 161|#
    (cons 'owner  nil)                                                                                                  #|line 162|#
    (cons 'saved_messages (cdr (assoc '(LifoQueue  )  queue))) #|  stack of saved message(s) |#                         #|line 163|#
    (cons 'inject  injector_NIY)                                                                                        #|line 164|#
    (cons 'children  nil)                                                                                               #|line 165|#
    (cons 'visit_ordering (cdr (assoc '(Queue  )  queue)))                                                              #|line 166|#
    (cons 'connections  nil)                                                                                            #|line 167|#
    (cons 'routings (cdr (assoc '(Queue  )  queue)))                                                                    #|line 168|#
    (cons 'handler  nil)                                                                                                #|line 169|#
    (cons 'instance_data  nil)                                                                                          #|line 170|#
    (cons 'state  "idle")                                                                                               #|line 171|##|  bootstrap debugging |##|line 172|#
    (cons 'kind  nil) #|  enum { container, leaf, } |#                                                                  #|line 173|#
    (cons 'trace  nil) #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |##|line 174|#
    (cons 'depth  0) #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |##|line 175|#)#|line 176|#)
                                                                                                                        #|line 177|##|  Creates a component that acts as a container. It is the same as a `Eh` instance |##|line 178|##|  whose handler function is `container_handler`. |##|line 179|#
(defun make_container (&optional  name  owner)                                                                          #|line 180|#
    (let ((eh (Eh  )))                                                                                                  #|line 181|#
        (setf (cdr (assoc ' name  eh))  name)                                                                           #|line 182|#
          (setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 183|#
            (setf (cdr (assoc ' handler  eh))  container_handler)                                                       #|line 184|#
              (setf (cdr (assoc ' inject  eh))  container_injector)                                                     #|line 185|#
                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 186|#
                  (setf (cdr (assoc ' kind  eh))  "container")                                                          #|line 187|#
                    (return-from make_container  eh)                                                                    #|line 188|#)#|line 189|#
)#|  Creates a new leaf component out of a handler function, and a data parameter |#                                    #|line 191|##|  that will be passed back to your handler when called. |##|line 192|##|line 193|#
(defun make_leaf (&optional  name  owner  instance_data  handler)                                                       #|line 194|#
    (let ((eh (Eh  )))                                                                                                  #|line 195|#
        (setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)))#|line 196|#
          (setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 197|#
            (setf (cdr (assoc ' handler  eh))  handler)                                                                 #|line 198|#
              (setf (cdr (assoc ' instance_data  eh))  instance_data)                                                   #|line 199|#
                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 200|#
                  (setf (cdr (assoc ' kind  eh))  "leaf")                                                               #|line 201|#
                    (return-from make_leaf  eh)                                                                         #|line 202|#)#|line 203|#
)#|  Sends a message on the given `port` with `data`, placing it on the output |#                                       #|line 205|##|  of the given component. |##|line 206|##|line 207|#
(defun send (&optional  eh  port  datum  causingMessage)                                                                #|line 208|#
    (let ((msg (make_message     port   datum                                                                           #|line 209|#)))
        (log_send   :sender  eh :sender_port  port :msg  msg :cause_msg  causingMessage                                 #|line 210|#)
          (put_output     eh   msg                                                                                      #|line 211|#))#|line 212|#
)
(defun send_string (&optional  eh  port  s  causingMessage)                                                             #|line 214|#
    (let ((datum (new_datum_string     s                                                                                #|line 215|#)))
        (let ((msg (make_message   :port  port :datum  datum                                                            #|line 216|#)))
            (log_send_string   :sender  eh :sender_port  port :msg  msg :cause_msg  causingMessage                      #|line 217|#)
              (put_output     eh   msg                                                                                  #|line 218|#)))#|line 219|#
)
(defun forward (&optional  eh  port  msg)                                                                               #|line 221|#
    (let ((fwdmsg (make_message     port  (cdr (assoc ' datum  msg))                                                    #|line 222|#)))
        (log_forward   :sender  eh :sender_port  port :msg  msg :cause_msg  msg                                         #|line 223|#)
          (put_output     eh   msg                                                                                      #|line 224|#))#|line 225|#
)
(defun inject (&optional  eh  msg)                                                                                      #|line 227|#
    (cdr (assoc '(inject     eh   msg                                                                                   #|line 228|#)  eh))#|line 229|#
)#|  Returns a list of all output messages on a container. |#                                                           #|line 231|##|  For testing / debugging purposes. |##|line 232|##|line 233|#
(defun output_list (&optional  eh)                                                                                      #|line 234|#
    (return-from output_list (cdr (assoc ' outq  eh)))                                                                  #|line 235|##|line 236|#
)#|  Utility for printing an array of messages. |#                                                                      #|line 238|#
(defun print_output_list (&optional  eh)                                                                                #|line 239|#
    (loop for m in (list    (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
      do                                                                                                                #|line 240|#
          (print    (format_message     m ) )                                                                           #|line 241|#
      )                                                                                                                 #|line 242|#
)
(defun spaces (&optional  n)                                                                                            #|line 244|#
    (let (( s  ""))                                                                                                     #|line 245|#
        (loop for i in (loop for n from 0 below  n by 1 collect n)
          do                                                                                                            #|line 246|#
              (setf  s (+  s  " "))                                                                                     #|line 247|#
          )
          (return-from spaces  s)                                                                                       #|line 248|#)#|line 249|#
)
(defun set_active (&optional  eh)                                                                                       #|line 251|#
    (setf (cdr (assoc ' state  eh))  "active")                                                                          #|line 252|##|line 253|#
)
(defun set_idle (&optional  eh)                                                                                         #|line 255|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 256|##|line 257|#
)#|  Utility for printing a specific output message. |#                                                                 #|line 259|##|line 260|#
(defun fetch_first_output (&optional  eh  port)                                                                         #|line 261|#
    (loop for msg in (list    (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
      do                                                                                                                #|line 262|#
          (cond
            (( equal   (cdr (assoc ' port  msg))  port)                                                                 #|line 263|#
                  (return-from fetch_first_output (cdr (assoc ' datum  msg)))
              ))                                                                                                        #|line 264|#
      )
      (return-from fetch_first_output  nil)                                                                             #|line 265|##|line 266|#
)
(defun print_specific_output (&optional  eh  (port  "")  (stderr  nil))                                                 #|line 268|#
    (let (( datum (fetch_first_output     eh   port                                                                     #|line 269|#)))
        (let (( outf  nil))                                                                                             #|line 270|#
            (cond
              ((not (equal   datum  nil))                                                                               #|line 271|#
                    (cond
                      ( stderr
                            #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |##|line 272|#
                              (setf  outf (cdr (assoc ' stderr  sys)))                                                  #|line 273|#
                        )
                      (t                                                                                                #|line 274|#
                            (setf  outf (cdr (assoc ' stdout  sys)))                                                    #|line 275|#
                        ))
                      (print    (cdr (assoc '(srepr  )  datum)) :file  outf )                                           #|line 276|#
                ))))                                                                                                    #|line 277|#
)
(defun put_output (&optional  eh  msg)                                                                                  #|line 279|#
    (cdr (assoc '(cdr (assoc '(put     msg                                                                              #|line 280|#)  outq))  eh))#|line 281|#
)
(defun injector_NIY (&optional  eh  msg)                                                                                #|line 283|#
    #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#      #|line 284|#
      (print     (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))) #|line 289|#)
        (exit  )                                                                                                        #|line 290|##|line 291|#
)                                                                                                                       #|line 297|#
(defparameter  root_project  "")                                                                                        #|line 298|#
(defparameter  root_0D  "")                                                                                             #|line 299|##|line 300|#
(defun set_environment (&optional  rproject  r0D)                                                                       #|line 301|##|line 302|##|line 303|#
        (setf  root_project  rproject)                                                                                  #|line 304|#
          (setf  root_0D  r0D)                                                                                          #|line 305|##|line 306|#
)
(defun probe_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 308|#
    (let ((name_with_id (gensymbol     "?"                                                                              #|line 309|#)))
        (return-from probe_instantiate (make_leaf   :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 310|#)))#|line 311|#
)
(defun probeA_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 312|#
    (let ((name_with_id (gensymbol     "?A"                                                                             #|line 313|#)))
        (return-from probeA_instantiate (make_leaf   :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 314|#)))#|line 315|#
)
(defun probeB_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 317|#
    (let ((name_with_id (gensymbol     "?B"                                                                             #|line 318|#)))
        (return-from probeB_instantiate (make_leaf   :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 319|#)))#|line 320|#
)
(defun probeC_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 322|#
    (let ((name_with_id (gensymbol     "?C"                                                                             #|line 323|#)))
        (return-from probeC_instantiate (make_leaf   :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 324|#)))#|line 325|#
)
(defun probe_handler (&optional  eh  msg)                                                                               #|line 327|#
    (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                      #|line 328|#
        (print     (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))) :file (cdr (assoc ' stderr  sys)) #|line 329|#))#|line 330|#
)
(defun trash_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 332|#
    (let ((name_with_id (gensymbol     "trash"                                                                          #|line 333|#)))
        (return-from trash_instantiate (make_leaf   :name  name_with_id :owner  owner :instance_data  nil :handler  trash_handler #|line 334|#)))#|line 335|#
)
(defun trash_handler (&optional  eh  msg)                                                                               #|line 337|#
    #|  to appease dumped_on_floor checker |#                                                                           #|line 338|#
      #| pass |#                                                                                                        #|line 339|##|line 340|#
)
(defun TwoMessages (&optional  first  second)                                                                           #|line 341|#
  (list
    (cons 'first  first)                                                                                                #|line 342|#
    (cons 'second  second)                                                                                              #|line 343|#)#|line 344|#)
                                                                                                                        #|line 345|##|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |##|line 346|#
(defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 347|#
  (list
    (cons 'state  state)                                                                                                #|line 348|#
    (cons 'buffer  buffer)                                                                                              #|line 349|#)#|line 350|#)
                                                                                                                        #|line 351|#
(defun reclaim_Buffers_from_heap (&optional  inst)                                                                      #|line 352|#
    #| pass |#                                                                                                          #|line 353|##|line 354|#
)
(defun deracer_instantiate (&optional  reg  owner  name  template_data)                                                 #|line 356|#
    (let ((name_with_id (gensymbol     "deracer"                                                                        #|line 357|#)))
        (let ((inst (Deracer_Instance_Data     "idle"  (TwoMessages     nil   nil )                                     #|line 358|#)))
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 359|#
              (let ((eh (make_leaf   :name  name_with_id :owner  owner :instance_data  inst :handler  deracer_handler   #|line 360|#)))
                  (return-from deracer_instantiate  eh)                                                                 #|line 361|#)))#|line 362|#
)
(defun send_first_then_second (&optional  eh  inst)                                                                     #|line 364|#
    (forward     eh   "1"  (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                           #|line 365|#)
      (forward     eh   "2"  (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                        #|line 366|#)
        (reclaim_Buffers_from_heap     inst                                                                             #|line 367|#)#|line 368|#
)
(defun deracer_handler (&optional  eh  msg)                                                                             #|line 370|#
    (setf  inst (cdr (assoc ' instance_data  eh)))                                                                      #|line 371|#
      (cond
        (( equal   (cdr (assoc ' state  inst))  "idle")                                                                 #|line 372|#
              (cond
                (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 373|#
                      (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 374|#
                        (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                          #|line 375|#
                  )
                (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 376|#
                      (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 377|#
                        (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                           #|line 378|#
                  )
                (t                                                                                                      #|line 379|#
                      (runtime_error     (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 380|#
          )
        (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                      #|line 381|#
              (cond
                (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 382|#
                      (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 383|#
                        (send_first_then_second     eh   inst                                                           #|line 384|#)
                          (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 385|#
                  )
                (t                                                                                                      #|line 386|#
                      (runtime_error     (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 387|#
          )
        (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                     #|line 388|#
              (cond
                (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 389|#
                      (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 390|#
                        (send_first_then_second     eh   inst                                                           #|line 391|#)
                          (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 392|#
                  )
                (t                                                                                                      #|line 393|#
                      (runtime_error     (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 394|#
          )
        (t                                                                                                              #|line 395|#
              (runtime_error     "bad state for deracer {eh.state}" )                                                   #|line 396|#
          ))                                                                                                            #|line 397|#
)
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)                                #|line 399|#
    (let ((name_with_id (gensymbol     "Low Level Read Text File"                                                       #|line 400|#)))
        (return-from low_level_read_text_file_instantiate (make_leaf     name_with_id   owner   nil   low_level_read_text_file_handler #|line 401|#)))#|line 402|#
)
(defun low_level_read_text_file_handler (&optional  eh  msg)                                                            #|line 404|#
    (let ((fname (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                  #|line 405|#
        ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
        ;; given eh and msg if needed
        (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
          (with-open-file (stream fname)
            (let ((contents (make-string (file-length stream))))
              (read-sequence contents stream)
              (send_string eh "" contents))))
                                                                                                                        #|line 406|#)#|line 407|#
)
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)                                     #|line 409|#
    (let ((name_with_id (gensymbol     "Ensure String Datum"                                                            #|line 410|#)))
        (return-from ensure_string_datum_instantiate (make_leaf     name_with_id   owner   nil   ensure_string_datum_handler #|line 411|#)))#|line 412|#
)
(defun ensure_string_datum_handler (&optional  eh  msg)                                                                 #|line 414|#
    (cond
      (( equal    "string" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg)))                                          #|line 415|#
            (forward     eh   ""   msg )                                                                                #|line 416|#
        )
      (t                                                                                                                #|line 417|#
            (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))))#|line 418|#
                (send_string     eh   "✗"   emsg   msg ))                                                               #|line 419|#
        ))                                                                                                              #|line 420|#
)
(defun Syncfilewrite_Data (&optional )                                                                                  #|line 422|#
  (list
    (cons 'filename  "")                                                                                                #|line 423|#)#|line 424|#)
                                                                                                                        #|line 425|##|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |##|line 426|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)                                           #|line 427|#
    (let ((name_with_id (gensymbol     "syncfilewrite"                                                                  #|line 428|#)))
        (let ((inst (Syncfilewrite_Data  )))                                                                            #|line 429|#
            (return-from syncfilewrite_instantiate (make_leaf     name_with_id   owner   inst   syncfilewrite_handler   #|line 430|#))))#|line 431|#
)
(defun syncfilewrite_handler (&optional  eh  msg)                                                                       #|line 433|#
    (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 434|#
        (cond
          (( equal    "filename" (cdr (assoc ' port  msg)))                                                             #|line 435|#
                (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)))               #|line 436|#
            )
          (( equal    "input" (cdr (assoc ' port  msg)))                                                                #|line 437|#
                (let ((contents (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                   #|line 438|#
                    (let (( f (open    (cdr (assoc ' filename  inst))   "w"                                             #|line 439|#)))
                        (cond
                          ((not (equal   f  nil))                                                                       #|line 440|#
                                (cdr (assoc '(write    (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))              #|line 441|#)  f))
                                  (cdr (assoc '(close  )  f))                                                           #|line 442|#
                                    (send     eh   "done"  (new_datum_bang  )   msg )                                   #|line 443|#
                            )
                          (t                                                                                            #|line 444|#
                                (send_string     eh   "✗"   (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))   msg )
                            ))))                                                                                        #|line 445|#
            )))                                                                                                         #|line 446|#
)
(defun StringConcat_Instance_Data (&optional )                                                                          #|line 448|#
  (list
    (cons 'buffer1  nil)                                                                                                #|line 449|#
    (cons 'buffer2  nil)                                                                                                #|line 450|#
    (cons 'count  0)                                                                                                    #|line 451|#)#|line 452|#)
                                                                                                                        #|line 453|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)                                            #|line 454|#
    (let ((name_with_id (gensymbol     "stringconcat"                                                                   #|line 455|#)))
        (let ((instp (StringConcat_Instance_Data  )))                                                                   #|line 456|#
            (return-from stringconcat_instantiate (make_leaf     name_with_id   owner   instp   stringconcat_handler    #|line 457|#))))#|line 458|#
)
(defun stringconcat_handler (&optional  eh  msg)                                                                        #|line 460|#
    (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 461|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 462|#
                (setf (cdr (assoc ' buffer1  inst)) (clone_string    (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 463|#))
                  (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 464|#
                    (maybe_stringconcat     eh   inst   msg )                                                           #|line 465|#
            )
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 466|#
                (setf (cdr (assoc ' buffer2  inst)) (clone_string    (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 467|#))
                  (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 468|#
                    (maybe_stringconcat     eh   inst   msg )                                                           #|line 469|#
            )
          (t                                                                                                            #|line 470|#
                (runtime_error     (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))   #|line 471|#)#|line 472|#
            )))                                                                                                         #|line 473|#
)
(defun maybe_stringconcat (&optional  eh  inst  msg)                                                                    #|line 475|#
    (cond
      (( and  ( equal    0 (len    (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len    (cdr (assoc ' buffer2  inst)) )))#|line 476|#
            (runtime_error     "something is wrong in stringconcat, both strings are 0 length" )                        #|line 477|#
        ))
      (cond
        (( >=  (cdr (assoc ' count  inst))  2)                                                                          #|line 478|#
              (let (( concatenated_string  ""))                                                                         #|line 479|#
                  (cond
                    (( equal    0 (len    (cdr (assoc ' buffer1  inst)) ))                                              #|line 480|#
                          (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                     #|line 481|#
                      )
                    (( equal    0 (len    (cdr (assoc ' buffer2  inst)) ))                                              #|line 482|#
                          (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                     #|line 483|#
                      )
                    (t                                                                                                  #|line 484|#
                          (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst))))   #|line 485|#
                      ))
                    (send_string     eh   ""   concatenated_string   msg                                                #|line 486|#)
                      (setf (cdr (assoc ' buffer1  inst))  nil)                                                         #|line 487|#
                        (setf (cdr (assoc ' buffer2  inst))  nil)                                                       #|line 488|#
                          (setf (cdr (assoc ' count  inst))  0))                                                        #|line 489|#
          ))                                                                                                            #|line 490|#
)#|  |#                                                                                                                 #|line 492|##|line 493|##|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 494|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)                                               #|line 495|#
    (let ((name_with_id (gensymbol     "shell_out"                                                                      #|line 496|#)))
        (let ((cmd (cdr (assoc '(split     template_data                                                                #|line 497|#)  shlex))))
            (return-from shell_out_instantiate (make_leaf     name_with_id   owner   cmd   shell_out_handler            #|line 498|#))))#|line 499|#
)
(defun shell_out_handler (&optional  eh  msg)                                                                           #|line 501|#
    (let ((cmd (cdr (assoc ' instance_data  eh))))                                                                      #|line 502|#
        (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                  #|line 503|#
            (multiple-value-setq ( stdout  stderr) (run_command     eh   cmd   s                                        #|line 504|#))
              (cond
                ((not (equal   stderr  nil))                                                                            #|line 505|#
                      (send_string     eh   "✗"   stderr   msg )                                                        #|line 506|#
                  )
                (t                                                                                                      #|line 507|#
                      (send_string     eh   ""   stdout   msg )                                                         #|line 508|#
                  ))))                                                                                                  #|line 509|#
)
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)                                         #|line 511|##|line 512|##|line 513|#
        (let ((name_with_id (gensymbol     "strconst"                                                                   #|line 514|#)))
            (let (( s  template_data))                                                                                  #|line 515|#
                (cond
                  ((not (equal   root_project  ""))                                                                     #|line 516|#
                        (setf  s (cdr (assoc '(sub     "_00_"   root_project   s )  re)))                               #|line 517|#
                    ))
                  (cond
                    ((not (equal   root_0D  ""))                                                                        #|line 518|#
                          (setf  s (cdr (assoc '(sub     "_0D_"   root_0D   s )  re)))                                  #|line 519|#
                      ))
                    (return-from string_constant_instantiate (make_leaf     name_with_id   owner   s   string_constant_handler #|line 520|#))))#|line 521|#
)
(defun string_constant_handler (&optional  eh  msg)                                                                     #|line 523|#
    (let ((s (cdr (assoc ' instance_data  eh))))                                                                        #|line 524|#
        (send_string     eh   ""   s   msg                                                                              #|line 525|#))#|line 526|#
)
(defun string_make_persistent (&optional  s)                                                                            #|line 528|#
    #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                      #|line 529|#
      (return-from string_make_persistent  s)                                                                           #|line 530|##|line 531|#
)
(defun string_clone (&optional  s)                                                                                      #|line 533|#
    (return-from string_clone  s)                                                                                       #|line 534|##|line 535|#
)                                                                                                                       #|line 538|##|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |##|line 539|##|  where ${_00_} is the root directory for the project |##|line 540|##|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |##|line 541|##|line 542|##|line 543|##|line 544|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)                            #|line 545|#
    (let ((reg (make_component_registry  )))                                                                            #|line 546|#
        (loop for diagram_source in  diagram_source_files
          do                                                                                                            #|line 547|#
              (let ((all_containers_within_single_file (json2internal     diagram_source                                #|line 548|#)))
                  (generate_shell_components     reg   all_containers_within_single_file                                #|line 549|#)
                    (loop for container in  all_containers_within_single_file
                      do                                                                                                #|line 550|#
                          (register_component     reg  (Template   :name (cdr (assoc 'name  container)) :template_data  container :instantiator  container_instantiator ) )
                      ))                                                                                                #|line 551|#
          )
          (initialize_stock_components     reg                                                                          #|line 552|#)
            (return-from initialize_component_palette  reg)                                                             #|line 553|#)#|line 554|#
)
(defun print_error_maybe (&optional  main_container)                                                                    #|line 556|#
    (let ((error_port  "✗"))                                                                                            #|line 557|#
        (let ((err (fetch_first_output     main_container   error_port                                                  #|line 558|#)))
            (cond
              (( and  (not (equal   err  nil)) ( <   0 (len    (trimws    (cdr (assoc '(srepr  )  err)) ) )))           #|line 559|#
                    (print     "___ !!! ERRORS !!! ___"                                                                 #|line 560|#)
                      (print_specific_output     main_container   error_port   nil )                                    #|line 561|#
                ))))                                                                                                    #|line 562|#
)#|  debugging helpers |#                                                                                               #|line 564|##|line 565|#
(defun dump_outputs (&optional  main_container)                                                                         #|line 566|#
    (print  )                                                                                                           #|line 567|#
      (print     "___ Outputs ___"                                                                                      #|line 568|#)
        (print_output_list     main_container                                                                           #|line 569|#)#|line 570|#
)
(defun trace_outputs (&optional  main_container)                                                                        #|line 572|#
    (print  )                                                                                                           #|line 573|#
      (print     "___ Message Traces ___"                                                                               #|line 574|#)
        (print_routing_trace     main_container                                                                         #|line 575|#)#|line 576|#
)
(defun dump_hierarchy (&optional  main_container)                                                                       #|line 578|#
    (print  )                                                                                                           #|line 579|#
      (print     (concatenate 'string  "___ Hierarchy ___" (build_hierarchy     main_container ))                       #|line 580|#)#|line 581|#
)
(defun build_hierarchy (&optional  c)                                                                                   #|line 583|#
    (let (( s  ""))                                                                                                     #|line 584|#
        (loop for child in (cdr (assoc ' children  c))
          do                                                                                                            #|line 585|#
              (setf  s  (concatenate 'string  s (build_hierarchy     child )))                                          #|line 586|#
          )
          (let (( indent  ""))                                                                                          #|line 587|#
              (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
                do                                                                                                      #|line 588|#
                    (setf  indent (+  indent  "  "))                                                                    #|line 589|#
                )
                (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")"))))))#|line 590|#))#|line 591|#
)
(defun dump_connections (&optional  c)                                                                                  #|line 593|#
    (print  )                                                                                                           #|line 594|#
      (print     "___ connections ___"                                                                                  #|line 595|#)
        (dump_possible_connections     c                                                                                #|line 596|#)
          (loop for child in (cdr (assoc ' children  c))
            do                                                                                                          #|line 597|#
                (print  )                                                                                               #|line 598|#
                  (dump_possible_connections     child )                                                                #|line 599|#
            )                                                                                                           #|line 600|#
)
(defun trimws (&optional  s)                                                                                            #|line 602|#
    #|  remove whitespace from front and back of string |#                                                              #|line 603|#
      (return-from trimws (cdr (assoc '(strip  )  s)))                                                                  #|line 604|##|line 605|#
)
(defun clone_string (&optional  s)                                                                                      #|line 607|#
    (return-from clone_string  s                                                                                        #|line 608|##|line 609|#)#|line 610|#
)
(defparameter  load_errors  nil)                                                                                        #|line 611|#
(defparameter  runtime_errors  nil)                                                                                     #|line 612|##|line 613|#
(defun load_error (&optional  s)                                                                                        #|line 614|##|line 615|#
      (print     s                                                                                                      #|line 616|#)
        (quit  )                                                                                                        #|line 617|#
          (setf  load_errors  t)                                                                                        #|line 618|##|line 619|#
)
(defun runtime_error (&optional  s)                                                                                     #|line 621|##|line 622|#
      (print     s                                                                                                      #|line 623|#)
        (quit  )                                                                                                        #|line 624|#
          (setf  runtime_errors  t)                                                                                     #|line 625|##|line 626|#
)
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)                                            #|line 628|#
    (let ((instance_name (gensymbol     "fakepipe"                                                                      #|line 629|#)))
        (return-from fakepipename_instantiate (make_leaf     instance_name   owner   nil   fakepipename_handler         #|line 630|#)))#|line 631|#
)
(defparameter  rand  0)                                                                                                 #|line 633|##|line 634|#
(defun fakepipename_handler (&optional  eh  msg)                                                                        #|line 635|##|line 636|#
      (setf  rand (+  rand  1))
        #|  not very random, but good enough _ 'rand' must be unique within a single run |#                             #|line 637|#
          (send_string     eh   ""   (concatenate 'string  "/tmp/fakepipe"  rand)   msg                                 #|line 638|#)#|line 639|#
)                                                                                                                       #|line 641|##|  all of the the built_in leaves are listed here |##|line 642|##|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 643|##|line 644|##|line 645|#
(defun initialize_stock_components (&optional  reg)                                                                     #|line 646|#
    (register_component     reg  (Template     "1then2"   nil   deracer_instantiate )                                   #|line 647|#)
      (register_component     reg  (Template     "?"   nil   probe_instantiate )                                        #|line 648|#)
        (register_component     reg  (Template     "?A"   nil   probeA_instantiate )                                    #|line 649|#)
          (register_component     reg  (Template     "?B"   nil   probeB_instantiate )                                  #|line 650|#)
            (register_component     reg  (Template     "?C"   nil   probeC_instantiate )                                #|line 651|#)
              (register_component     reg  (Template     "trash"   nil   trash_instantiate )                            #|line 652|#)#|line 653|#
                (register_component     reg  (Template     "Low Level Read Text File"   nil   low_level_read_text_file_instantiate ) #|line 654|#)
                  (register_component     reg  (Template     "Ensure String Datum"   nil   ensure_string_datum_instantiate ) #|line 655|#)#|line 656|#
                    (register_component     reg  (Template     "syncfilewrite"   nil   syncfilewrite_instantiate )      #|line 657|#)
                      (register_component     reg  (Template     "stringconcat"   nil   stringconcat_instantiate )      #|line 658|#)
                        #|  for fakepipe |#                                                                             #|line 659|#
                          (register_component     reg  (Template     "fakepipename"   nil   fakepipename_instantiate )  #|line 660|#)#|line 661|#
)                                                                                                                       #|line 663|#
(defun initialize (&optional )                                                                                          #|line 664|#
    (let ((root_of_project  (nth  1 argv)))                                                                             #|line 665|#
        (let ((root_of_0D  (nth  2 argv)))                                                                              #|line 666|#
            (let ((arg  (nth  3 argv)))                                                                                 #|line 667|#
                (let ((main_container_name  (nth  4 argv)))                                                             #|line 668|#
                    (let ((diagram_names  (nthcdr  5 (argv))))                                                          #|line 669|#
                        (let ((palette (initialize_component_palette     root_project   root_0D   diagram_names         #|line 670|#)))
                            (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg )))#|line 671|#))))))#|line 672|#
)
(defun start (&optional  palette  env  (show_hierarchy  nil)  (show_connections  nil)  (show_traces  nil)  (show_all_outputs  nil))#|line 674|#
    (let ((root_of_project (nth  0  env)))                                                                              #|line 675|#
        (let ((root_of_0D (nth  1  env)))                                                                               #|line 676|#
            (let ((main_container_name (nth  2  env)))                                                                  #|line 677|#
                (let ((diagram_names (nth  3  env)))                                                                    #|line 678|#
                    (let ((arg (nth  4  env)))                                                                          #|line 679|#
                        (set_environment     root_of_project   root_of_0D                                               #|line 680|#)
                          #|  get entrypoint container |#                                                               #|line 681|#
                            (let (( main_container (get_component_instance     palette   main_container_name :owner  nil #|line 682|#)))
                                (cond
                                  (( equal    nil  main_container)                                                      #|line 683|#
                                        (load_error     (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)")))) #|line 687|#)#|line 688|#
                                    ))
                                  (cond
                                    ( show_hierarchy                                                                    #|line 689|#
                                          (dump_hierarchy     main_container                                            #|line 690|#)#|line 691|#
                                      ))
                                    (cond
                                      ( show_connections                                                                #|line 692|#
                                            (dump_connections     main_container                                        #|line 693|#)#|line 694|#
                                        ))
                                      (cond
                                        ((not  load_errors)                                                             #|line 695|#
                                              (let (( arg (new_datum_string     arg                                     #|line 696|#)))
                                                  (let (( msg (make_message     ""   arg                                #|line 697|#)))
                                                      (inject     main_container   msg                                  #|line 698|#)
                                                        (cond
                                                          ( show_all_outputs                                            #|line 699|#
                                                                (dump_outputs     main_container                        #|line 700|#)
                                                            )
                                                          (t                                                            #|line 701|#
                                                                (print_error_maybe     main_container                   #|line 702|#)
                                                                  (print_specific_output     main_container :port  "" :stderr  nil #|line 703|#)
                                                                    (cond
                                                                      ( show_traces                                     #|line 704|#
                                                                            (print     "--- routing traces ---"         #|line 705|#)
                                                                              (print    (routing_trace_all     main_container ) #|line 706|#)#|line 707|#
                                                                        ))                                              #|line 708|#
                                                            ))
                                                          (cond
                                                            ( show_all_outputs                                          #|line 709|#
                                                                  (print     "--- done ---"                             #|line 710|#)#|line 711|#
                                                              ))))                                                      #|line 712|#
                                          ))))))))                                                                      #|line 713|#
)                                                                                                                       #|line 715|##|line 716|##|  utility functions  |##|line 717|#
(defun send_int (&optional  eh  port  i  causing_message)                                                               #|line 718|#
    (let ((datum (new_datum_int     i                                                                                   #|line 719|#)))
        (send     eh   port   datum   causing_message                                                                   #|line 720|#))#|line 721|#
)
(defun send_bang (&optional  eh  port  causing_message)                                                                 #|line 723|#
    (let ((datum (new_datum_bang  )))                                                                                   #|line 724|#
        (send     eh   port   datum   causing_message                                                                   #|line 725|#))#|line 726|#
)





