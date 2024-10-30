
(ql:quickload :cl-json)
                                                                                                                        #|line 1|##|line 2|##|line 3|#
(defun Component_Registry (&optional )                                                                                  #|line 4|#
  (list
    (cons 'templates  nil)                                                                                              #|line 5|#)#|line 6|#)
                                                                                                                        #|line 7|#
(defun Template (&optional  name  template_data  instantiator)                                                          #|line 8|#
  (list
    (cons 'name  name)                                                                                                  #|line 9|#
    (cons 'template_data  template_data)                                                                                #|line 10|#
    (cons 'instantiator  instantiator)                                                                                  #|line 11|#)#|line 12|#)
                                                                                                                        #|line 13|#
(defun read_and_convert_json_file (&optional  filename)
  (declare (ignorable  filename))                                                                                       #|line 14|#

  ;; read json from a named file and convert it into internal form (a tree of routings)
  ;; return the routings from the function or raise an error
  (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
    (json:decode-json json-stream))
                                                                                                                        #|line 15|##|line 16|#
  )
(defun json2internal (&optional  container_xml)
  (declare (ignorable  container_xml))                                                                                  #|line 18|#
  (let ((fname (let ((p (parse-namestring  container_xml)))(format nil "~a.~a" (pathname-name p) (pathname-type p)))    #|line 19|#))
    (declare (ignorable fname))
    (let ((routings (read_and_convert_json_file    fname                                                                #|line 20|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                                                                             #|line 21|#))#|line 22|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 24|#
  #| pass |#                                                                                                            #|line 25|##|line 26|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                                                                                #|line 28|#
  (return-from make_component_registry (Component_Registry  ))                                                          #|line 29|##|line 30|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (abstracted_register_component    reg  template  nil ))                               #|line 32|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (abstracted_register_component    reg  template  t ))               #|line 33|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))                                                                 #|line 35|#
  (let ((name (mangle_name   (cdr (assoc ' name  template))                                                             #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                       #|line 37|#
        (load_error    (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 38|#
        ))
    (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                         #|line 39|#
    (return-from abstracted_register_component  reg)                                                                    #|line 40|#)#|line 41|#
  )
(defun register_multiple_components (&optional  reg  templates)
  (declare (ignorable  reg  templates))                                                                                 #|line 43|#
  (loop for template in  templates
    do                                                                                                                  #|line 44|#
    (register_component    reg  template )                                                                              #|line 45|#
    )                                                                                                                   #|line 46|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))                                                                          #|line 48|#
  (let ((template_name (mangle_name    full_name                                                                        #|line 49|#)))
    (declare (ignorable template_name))
    (cond
      (( in   template_name (cdr (assoc ' templates  reg)))                                                             #|line 50|#
        (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))
          (declare (ignorable template))                                                                                #|line 51|#
          (cond
            (( equal    template  nil)                                                                                  #|line 52|#
              (load_error    (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 53|#)
              (return-from get_component_instance  nil)                                                                 #|line 54|#
              )
            (t                                                                                                          #|line 55|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))                                                                        #|line 56|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))                                                                   #|line 57|#
                  (cond
                    ((not (equal   nil  owner))                                                                         #|line 58|#
                      (setf  owner_name (cdr (assoc ' name  owner)))                                                    #|line 59|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name)))#|line 60|#
                      )
                    (t                                                                                                  #|line 61|#
                      (setf  instance_name  template_name)                                                              #|line 62|#
                      ))
                  (let ((instance (cdr (assoc '(instantiator    reg  owner  instance_name (cdr (assoc ' template_data  template)) #|line 63|#)  template))))
                    (declare (ignorable instance))
                    (setf (cdr (assoc ' depth  instance)) (calculate_depth    instance                                  #|line 64|#))
                    (return-from get_component_instance  instance))))
              )))                                                                                                       #|line 65|#
        )
      (t                                                                                                                #|line 66|#
        (load_error    (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 67|#)
        (return-from get_component_instance  nil)                                                                       #|line 68|#
        )))                                                                                                             #|line 69|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 70|#
  (cond
    (( equal   (cdr (assoc ' owner  eh))  nil)                                                                          #|line 71|#
      (return-from calculate_depth  0)                                                                                  #|line 72|#
      )
    (t                                                                                                                  #|line 73|#
      (return-from calculate_depth (+  1 (calculate_depth   (cdr (assoc ' owner  eh)) )))                               #|line 74|#
      ))                                                                                                                #|line 75|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 77|#
  (nl  )                                                                                                                #|line 78|#
  (format *standard-output* "~a"  "*** PALETTE ***")                                                                    #|line 79|#
  (loop for c in (cdr (assoc ' templates  reg))
    do                                                                                                                  #|line 80|#
    (print   (cdr (assoc ' name  c)) )                                                                                  #|line 81|#
    )
  (format *standard-output* "~a"  "***************")                                                                    #|line 82|#
  (nl  )                                                                                                                #|line 83|##|line 84|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 86|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg))))            #|line 87|##|line 88|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 90|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |#                      #|line 91|#
  (return-from mangle_name  s)                                                                                          #|line 92|##|line 93|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                                                                            #|line 95|#
  #|  [ |#                                                                                                              #|line 96|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 97|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                              #|line 98|#
  #|  ] |#                                                                                                              #|line 99|#
  (cond
    ((not (equal   nil  container_list))                                                                                #|line 100|#
      (loop for diagram in  container_list
        do                                                                                                              #|line 101|#
        #|  loop through every component in the diagram and look for names that start with “$“ |#                       #|line 102|#
        #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 103|#
        (loop for child_descriptor in (cdr (assoc 'children  diagram))
          do                                                                                                            #|line 104|#
          (cond
            ((first_char_is   (cdr (assoc 'name  child_descriptor))  "$" )                                              #|line 105|#
              (let ((name (cdr (assoc 'name  child_descriptor))))
                (declare (ignorable name))                                                                              #|line 106|#
                (let ((cmd (cdr (assoc '(strip  )  (subseq  name 1)))))
                  (declare (ignorable cmd))                                                                             #|line 107|#
                  (let ((generated_leaf (Template    name  #'shell_out_instantiate  cmd                                 #|line 108|#)))
                    (declare (ignorable generated_leaf))
                    (register_component    reg  generated_leaf                                                          #|line 109|#))))
              )
            ((first_char_is   (cdr (assoc 'name  child_descriptor))  "'" )                                              #|line 110|#
              (let ((name (cdr (assoc 'name  child_descriptor))))
                (declare (ignorable name))                                                                              #|line 111|#
                (let ((s  (subseq  name 1)                                                                              #|line 112|#))
                  (declare (ignorable s))
                  (let ((generated_leaf (Template    name  #'string_constant_instantiate  s                             #|line 113|#)))
                    (declare (ignorable generated_leaf))
                    (register_component_allow_overwriting    reg  generated_leaf                                        #|line 114|#))))#|line 115|#
              ))                                                                                                        #|line 116|#
          )                                                                                                             #|line 117|#
        )                                                                                                               #|line 118|#
      ))                                                                                                                #|line 119|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 121|#
  (return-from first_char  (car  s)                                                                                     #|line 122|#)#|line 123|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                                                                                           #|line 125|#
  (return-from first_char_is ( equal    c (first_char    s                                                              #|line 126|#)))#|line 127|#
  )#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 129|##|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 130|#
(defun run_command (&optional  eh  cmd  s)
  (declare (ignorable  eh  cmd  s))                                                                                     #|line 131|#
  #|  capture_output ∷ ⊤ |#                                                                                             #|line 132|#
  (let ((ret (cdr (assoc '(run    cmd  s  "UTF_8"                                                                       #|line 133|#)  subprocess))))
    (declare (ignorable ret))
    (cond
      ((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                              #|line 134|#
        (cond
          ((not (equal  (cdr (assoc ' stderr  ret))  nil))                                                              #|line 135|#
            (return-from run_command (values  "" (cdr (assoc ' stderr  ret))))                                          #|line 136|#
            )
          (t                                                                                                            #|line 137|#
            (return-from run_command (values  ""  (concatenate 'string  "error in shell_out " (cdr (assoc ' returncode  ret)))))
            ))                                                                                                          #|line 138|#
        )
      (t                                                                                                                #|line 139|#
        (return-from run_command (values (cdr (assoc ' stdout  ret))  nil))                                             #|line 140|#
        )))                                                                                                             #|line 141|#
  )#|  Data for an asyncronous component _ effectively, a function with input |#                                        #|line 143|##|  and output queues of messages. |##|line 144|##|  |##|line 145|##|  Components can either be a user_supplied function (“lea“), or a “container“ |##|line 146|##|  that routes messages to child components according to a list of connections |##|line 147|##|  that serve as a message routing table. |##|line 148|##|  |##|line 149|##|  Child components themselves can be leaves or other containers. |##|line 150|##|  |##|line 151|##|  `handler` invokes the code that is attached to this component. |##|line 152|##|  |##|line 153|##|  `instance_data` is a pointer to instance data that the `leaf_handler` |##|line 154|##|  function may want whenever it is invoked again. |##|line 155|##|  |##|line 156|##|line 157|##|  Eh_States :: enum { idle, active } |##|line 158|#
(defun Eh (&optional )                                                                                                  #|line 159|#
  (list
    (cons 'name  "")                                                                                                    #|line 160|#
    (cons 'inq  (make-instance 'Queue)                                                                                  #|line 161|#)
    (cons 'outq  (make-instance 'Queue)                                                                                 #|line 162|#)
    (cons 'owner  nil)                                                                                                  #|line 163|#
    (cons 'saved_messages  nil) #|  stack of saved message(s) |#                                                        #|line 164|#
    (cons 'children  nil)                                                                                               #|line 165|#
    (cons 'visit_ordering  (make-instance 'Queue)                                                                       #|line 166|#)
    (cons 'connections  nil)                                                                                            #|line 167|#
    (cons 'routings  (make-instance 'Queue)                                                                             #|line 168|#)
    (cons 'handler  nil)                                                                                                #|line 169|#
    (cons 'instance_data  nil)                                                                                          #|line 170|#
    (cons 'state  "idle")                                                                                               #|line 171|##|  bootstrap debugging |##|line 172|#
    (cons 'kind  nil) #|  enum { container, leaf, } |#                                                                  #|line 173|#
    (cons 'trace  nil) #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |##|line 174|#
    (cons 'depth  0) #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |##|line 175|#)#|line 176|#)
                                                                                                                        #|line 177|##|  Creates a component that acts as a container. It is the same as a `Eh` instance |##|line 178|##|  whose handler function is `container_handler`. |##|line 179|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                                                                                    #|line 180|#
  (let ((eh (Eh  )))
    (declare (ignorable eh))                                                                                            #|line 181|#
    (setf (cdr (assoc ' name  eh))  name)                                                                               #|line 182|#
    (setf (cdr (assoc ' owner  eh))  owner)                                                                             #|line 183|#
    (setf (cdr (assoc ' handler  eh))  #'container_handler)                                                             #|line 184|#
    (setf (cdr (assoc ' inject  eh))  #'container_injector)                                                             #|line 185|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 186|#
    (setf (cdr (assoc ' kind  eh))  "container")                                                                        #|line 187|#
    (return-from make_container  eh)                                                                                    #|line 188|#)#|line 189|#
  )#|  Creates a new leaf component out of a handler function, and a data parameter |#                                  #|line 191|##|  that will be passed back to your handler when called. |##|line 192|##|line 193|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler))                                                            #|line 194|#
  (let ((eh (Eh  )))
    (declare (ignorable eh))                                                                                            #|line 195|#
    (setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)) #|line 196|#)
    (setf (cdr (assoc ' owner  eh))  owner)                                                                             #|line 197|#
    (setf (cdr (assoc ' handler  eh))  handler)                                                                         #|line 198|#
    (setf (cdr (assoc ' instance_data  eh))  instance_data)                                                             #|line 199|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 200|#
    (setf (cdr (assoc ' kind  eh))  "leaf")                                                                             #|line 201|#
    (return-from make_leaf  eh)                                                                                         #|line 202|#)#|line 203|#
  )#|  Sends a message on the given `port` with `data`, placing it on the output |#                                     #|line 205|##|  of the given component. |##|line 206|##|line 207|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))                                                                #|line 208|#
  (let ((msg (make_message    port  datum                                                                               #|line 209|#)))
    (declare (ignorable msg))
    (put_output    eh  msg                                                                                              #|line 210|#))#|line 211|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))                                                                    #|line 213|#
  (let ((datum (new_datum_string    s                                                                                   #|line 214|#)))
    (declare (ignorable datum))
    (let ((msg (make_message    port  datum                                                                             #|line 215|#)))
      (declare (ignorable msg))
      (put_output    eh  msg                                                                                            #|line 216|#)))#|line 217|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                                                                                  #|line 219|#
  (let ((fwdmsg (make_message    port (cdr (assoc ' datum  msg))                                                        #|line 220|#)))
    (declare (ignorable fwdmsg))
    (put_output    eh  msg                                                                                              #|line 221|#))#|line 222|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 224|#
  (cdr (assoc '(inject    eh  msg                                                                                       #|line 225|#)  eh))#|line 226|#
  )#|  Returns a list of all output messages on a container. |#                                                         #|line 228|##|  For testing / debugging purposes. |##|line 229|##|line 230|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 231|#
  (return-from output_list (cdr (assoc ' outq  eh)))                                                                    #|line 232|##|line 233|#
  )#|  Utility for printing an array of messages. |#                                                                    #|line 235|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 236|#
  (loop for m in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
    do                                                                                                                  #|line 237|#
    (format *standard-output* "~a" (format_message    m ))                                                              #|line 238|#
    )                                                                                                                   #|line 239|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                                                                              #|line 241|#
  (let (( s  ""))
    (declare (ignorable  s))                                                                                            #|line 242|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do                                                                                                                #|line 243|#
      (setf  s (+  s  " "))                                                                                             #|line 244|#
      )
    (return-from spaces  s)                                                                                             #|line 245|#)#|line 246|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 248|#
  (setf (cdr (assoc ' state  eh))  "active")                                                                            #|line 249|##|line 250|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 252|#
  (setf (cdr (assoc ' state  eh))  "idle")                                                                              #|line 253|##|line 254|#
  )#|  Utility for printing a specific output message. |#                                                               #|line 256|##|line 257|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 258|#
  (loop for msg in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
    do                                                                                                                  #|line 259|#
    (cond
      (( equal   (cdr (assoc ' port  msg))  port)                                                                       #|line 260|#
        (return-from fetch_first_output (cdr (assoc ' datum  msg)))
        ))                                                                                                              #|line 261|#
    )
  (return-from fetch_first_output  nil)                                                                                 #|line 262|##|line 263|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 265|#
  #|  port ∷ “” |#                                                                                                      #|line 266|#
  (let (( datum (fetch_first_output    eh  port                                                                         #|line 267|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (cdr (assoc '(srepr  )  datum)))                                                     #|line 268|#)#|line 269|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 270|#
  #|  port ∷ “” |#                                                                                                      #|line 271|#
  (let (( datum (fetch_first_output    eh  port                                                                         #|line 272|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |#        #|line 273|#
    (format *error-output* "~a" (cdr (assoc '(srepr  )  datum)))                                                        #|line 274|#)#|line 275|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 277|#
  (cdr (assoc '(cdr (assoc '(put    msg                                                                                 #|line 278|#)  outq))  eh))#|line 279|#
  )
(defun injector_NIY (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 281|#
  #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#        #|line 282|#
  (format *standard-output* "~a"  (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))))#|line 287|#
  (exit  )                                                                                                              #|line 288|##|line 289|#
  )
(defparameter  root_project  "")                                                                                        #|line 291|#
(defparameter  root_0D  "")                                                                                             #|line 292|##|line 293|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                                                                                  #|line 294|##|line 295|##|line 296|#
  (setf  root_project  rproject)                                                                                        #|line 297|#
  (setf  root_0D  r0D)                                                                                                  #|line 298|##|line 299|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 301|#
  (let ((name_with_id (gensymbol    "?"                                                                                 #|line 302|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                              #|line 303|#)))#|line 304|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 305|#
  (let ((name_with_id (gensymbol    "?A"                                                                                #|line 306|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                             #|line 307|#)))#|line 308|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 310|#
  (let ((name_with_id (gensymbol    "?B"                                                                                #|line 311|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                             #|line 312|#)))#|line 313|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 315|#
  (let ((name_with_id (gensymbol    "?C"                                                                                #|line 316|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                             #|line 317|#)))#|line 318|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 320|#
  (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
    (declare (ignorable s))                                                                                             #|line 321|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))))#|line 322|#)#|line 323|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 325|#
  (let ((name_with_id (gensymbol    "trash"                                                                             #|line 326|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (make_leaf    name_with_id  owner  nil  #'trash_handler                              #|line 327|#)))#|line 328|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 330|#
  #|  to appease dumped_on_floor checker |#                                                                             #|line 331|#
  #| pass |#                                                                                                            #|line 332|##|line 333|#
  )
(defun TwoMessages (&optional  first  second)                                                                           #|line 334|#
  (list
    (cons 'first  first)                                                                                                #|line 335|#
    (cons 'second  second)                                                                                              #|line 336|#)#|line 337|#)
                                                                                                                        #|line 338|##|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |##|line 339|#
(defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 340|#
  (list
    (cons 'state  state)                                                                                                #|line 341|#
    (cons 'buffer  buffer)                                                                                              #|line 342|#)#|line 343|#)
                                                                                                                        #|line 344|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                                                                                           #|line 345|#
  #| pass |#                                                                                                            #|line 346|##|line 347|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 349|#
  (let ((name_with_id (gensymbol    "deracer"                                                                           #|line 350|#)))
    (declare (ignorable name_with_id))
    (let ((inst (Deracer_Instance_Data    "idle" (TwoMessages    nil  nil )                                             #|line 351|#)))
      (declare (ignorable inst))
      (setf (cdr (assoc ' state  inst))  "idle")                                                                        #|line 352|#
      (let ((eh (make_leaf    name_with_id  owner  inst  #'deracer_handler                                              #|line 353|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)                                                                           #|line 354|#)))#|line 355|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                                                                                       #|line 357|#
  (forward    eh  "1" (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                                #|line 358|#)
  (forward    eh  "2" (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                               #|line 359|#)
  (reclaim_Buffers_from_heap    inst                                                                                    #|line 360|#)#|line 361|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 363|#
  (let (( inst (cdr (assoc ' instance_data  eh))))
    (declare (ignorable  inst))                                                                                         #|line 364|#
    (cond
      (( equal   (cdr (assoc ' state  inst))  "idle")                                                                   #|line 365|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 366|#
            (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                              #|line 367|#
            (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                                      #|line 368|#
            )
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 369|#
            (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                             #|line 370|#
            (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                                       #|line 371|#
            )
          (t                                                                                                            #|line 372|#
            (runtime_error    (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
            ))                                                                                                          #|line 373|#
        )
      (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                        #|line 374|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 375|#
            (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                              #|line 376|#
            (send_first_then_second    eh  inst                                                                         #|line 377|#)
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 378|#
            )
          (t                                                                                                            #|line 379|#
            (runtime_error    (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
            ))                                                                                                          #|line 380|#
        )
      (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                       #|line 381|#
        (cond
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 382|#
            (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                             #|line 383|#
            (send_first_then_second    eh  inst                                                                         #|line 384|#)
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 385|#
            )
          (t                                                                                                            #|line 386|#
            (runtime_error    (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
            ))                                                                                                          #|line 387|#
        )
      (t                                                                                                                #|line 388|#
        (runtime_error    "bad state for deracer {eh.state}" )                                                          #|line 389|#
        )))                                                                                                             #|line 390|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 392|#
  (let ((name_with_id (gensymbol    "Low Level Read Text File"                                                          #|line 393|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (make_leaf    name_with_id  owner  nil  #'low_level_read_text_file_handler #|line 394|#)))#|line 395|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 397|#
  (let ((fname (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
    (declare (ignorable fname))                                                                                         #|line 398|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                                                                                        #|line 399|#)#|line 400|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 402|#
  (let ((name_with_id (gensymbol    "Ensure String Datum"                                                               #|line 403|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (make_leaf    name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 404|#)))#|line 405|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 407|#
  (cond
    (( equal    "string" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg)))                                            #|line 408|#
      (forward    eh  ""  msg )                                                                                         #|line 409|#
      )
    (t                                                                                                                  #|line 410|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))#|line 411|#))
        (declare (ignorable emsg))
        (send_string    eh  "✗"  emsg  msg ))                                                                           #|line 412|#
      ))                                                                                                                #|line 413|#
  )
(defun Syncfilewrite_Data (&optional )                                                                                  #|line 415|#
  (list
    (cons 'filename  "")                                                                                                #|line 416|#)#|line 417|#)
                                                                                                                        #|line 418|##|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |##|line 419|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 420|#
  (let ((name_with_id (gensymbol    "syncfilewrite"                                                                     #|line 421|#)))
    (declare (ignorable name_with_id))
    (let ((inst (Syncfilewrite_Data  )))
      (declare (ignorable inst))                                                                                        #|line 422|#
      (return-from syncfilewrite_instantiate (make_leaf    name_with_id  owner  inst  #'syncfilewrite_handler           #|line 423|#))))#|line 424|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 426|#
  (let (( inst (cdr (assoc ' instance_data  eh))))
    (declare (ignorable  inst))                                                                                         #|line 427|#
    (cond
      (( equal    "filename" (cdr (assoc ' port  msg)))                                                                 #|line 428|#
        (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)))                       #|line 429|#
        )
      (( equal    "input" (cdr (assoc ' port  msg)))                                                                    #|line 430|#
        (let ((contents (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
          (declare (ignorable contents))                                                                                #|line 431|#
          (let (( f (open   (cdr (assoc ' filename  inst))  "w"                                                         #|line 432|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                                                                                   #|line 433|#
                (cdr (assoc '(write   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))                               #|line 434|#)  f))
                (cdr (assoc '(close  )  f))                                                                             #|line 435|#
                (send    eh  "done" (new_datum_bang  )  msg )                                                           #|line 436|#
                )
              (t                                                                                                        #|line 437|#
                (send_string    eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))  msg )
                ))))                                                                                                    #|line 438|#
        )))                                                                                                             #|line 439|#
  )
(defun StringConcat_Instance_Data (&optional )                                                                          #|line 441|#
  (list
    (cons 'buffer1  nil)                                                                                                #|line 442|#
    (cons 'buffer2  nil)                                                                                                #|line 443|#
    (cons 'count  0)                                                                                                    #|line 444|#)#|line 445|#)
                                                                                                                        #|line 446|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 447|#
  (let ((name_with_id (gensymbol    "stringconcat"                                                                      #|line 448|#)))
    (declare (ignorable name_with_id))
    (let ((instp (StringConcat_Instance_Data  )))
      (declare (ignorable instp))                                                                                       #|line 449|#
      (return-from stringconcat_instantiate (make_leaf    name_with_id  owner  instp  #'stringconcat_handler            #|line 450|#))))#|line 451|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 453|#
  (let (( inst (cdr (assoc ' instance_data  eh))))
    (declare (ignorable  inst))                                                                                         #|line 454|#
    (cond
      (( equal    "1" (cdr (assoc ' port  msg)))                                                                        #|line 455|#
        (setf (cdr (assoc ' buffer1  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))         #|line 456|#))
        (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                           #|line 457|#
        (maybe_stringconcat    eh  inst  msg )                                                                          #|line 458|#
        )
      (( equal    "2" (cdr (assoc ' port  msg)))                                                                        #|line 459|#
        (setf (cdr (assoc ' buffer2  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))         #|line 460|#))
        (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                           #|line 461|#
        (maybe_stringconcat    eh  inst  msg )                                                                          #|line 462|#
        )
      (t                                                                                                                #|line 463|#
        (runtime_error    (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))            #|line 464|#)#|line 465|#
        )))                                                                                                             #|line 466|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                                                                                  #|line 468|#
  (cond
    (( and  ( equal    0 (len   (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len   (cdr (assoc ' buffer2  inst)) )))  #|line 469|#
      (runtime_error    "something is wrong in stringconcat, both strings are 0 length" )                               #|line 470|#
      ))
  (cond
    (( >=  (cdr (assoc ' count  inst))  2)                                                                              #|line 471|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))                                                                      #|line 472|#
        (cond
          (( equal    0 (len   (cdr (assoc ' buffer1  inst)) ))                                                         #|line 473|#
            (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                                   #|line 474|#
            )
          (( equal    0 (len   (cdr (assoc ' buffer2  inst)) ))                                                         #|line 475|#
            (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                                   #|line 476|#
            )
          (t                                                                                                            #|line 477|#
            (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst))))                 #|line 478|#
            ))
        (send_string    eh  ""  concatenated_string  msg                                                                #|line 479|#)
        (setf (cdr (assoc ' buffer1  inst))  nil)                                                                       #|line 480|#
        (setf (cdr (assoc ' buffer2  inst))  nil)                                                                       #|line 481|#
        (setf (cdr (assoc ' count  inst))  0))                                                                          #|line 482|#
      ))                                                                                                                #|line 483|#
  )#|  |#                                                                                                               #|line 485|##|line 486|##|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 487|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 488|#
  (let ((name_with_id (gensymbol    "shell_out"                                                                         #|line 489|#)))
    (declare (ignorable name_with_id))
    ( equal    cmd (split-sequence '(#\space)  template_data)                                                           #|line 490|#)
    (return-from shell_out_instantiate (make_leaf    name_with_id  owner  cmd  #'shell_out_handler                      #|line 491|#)))#|line 492|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 494|#
  (let ((cmd (cdr (assoc ' instance_data  eh))))
    (declare (ignorable cmd))                                                                                           #|line 495|#
    (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
      (declare (ignorable s))                                                                                           #|line 496|#
      (let (( stdout  nil))
        (declare (ignorable  stdout))                                                                                   #|line 497|#
        (let (( stderr  nil))
          (declare (ignorable  stderr))                                                                                 #|line 498|#
          (multiple-value-setq ( stdout  stderr) (run_command    eh  cmd  s                                             #|line 499|#))
          (cond
            ((not (equal   stderr  nil))                                                                                #|line 500|#
              (send_string    eh  "✗"  stderr  msg )                                                                    #|line 501|#
              )
            (t                                                                                                          #|line 502|#
              (send_string    eh  ""  stdout  msg )                                                                     #|line 503|#
              ))))))                                                                                                    #|line 504|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 506|##|line 507|##|line 508|#
  (let ((name_with_id (gensymbol    "strconst"                                                                          #|line 509|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                                                                                          #|line 510|#
      (cond
        ((not (equal   root_project  ""))                                                                               #|line 511|#
          (setf  s (cdr (assoc '(sub    "_00_"  root_project  s )  re)))                                                #|line 512|#
          ))
      (cond
        ((not (equal   root_0D  ""))                                                                                    #|line 513|#
          (setf  s (cdr (assoc '(sub    "_0D_"  root_0D  s )  re)))                                                     #|line 514|#
          ))
      (return-from string_constant_instantiate (make_leaf    name_with_id  owner  s  #'string_constant_handler          #|line 515|#))))#|line 516|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 518|#
  (let ((s (cdr (assoc ' instance_data  eh))))
    (declare (ignorable s))                                                                                             #|line 519|#
    (send_string    eh  ""  s  msg                                                                                      #|line 520|#))#|line 521|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 523|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                        #|line 524|#
  (return-from string_make_persistent  s)                                                                               #|line 525|##|line 526|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 528|#
  (return-from string_clone  s)                                                                                         #|line 529|##|line 530|#
  )#|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |#                                   #|line 532|##|  where ${_00_} is the root directory for the project |##|line 533|##|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |##|line 534|##|line 535|##|line 536|##|line 537|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files))                                                    #|line 538|#
  (let ((reg (make_component_registry  )))
    (declare (ignorable reg))                                                                                           #|line 539|#
    (loop for diagram_source in  diagram_source_files
      do                                                                                                                #|line 540|#
      (let ((all_containers_within_single_file (json2internal    diagram_source                                         #|line 541|#)))
        (declare (ignorable all_containers_within_single_file))
        (generate_shell_components    reg  all_containers_within_single_file                                            #|line 542|#)
        (loop for container in  all_containers_within_single_file
          do                                                                                                            #|line 543|#
          (register_component    reg (Template   (cdr (assoc 'name  container)) #|  template_data =  |# container #|  instantiator =  |# #'container_instantiator ) )
          ))                                                                                                            #|line 544|#
      )
    (initialize_stock_components    reg                                                                                 #|line 545|#)
    (return-from initialize_component_palette  reg)                                                                     #|line 546|#)#|line 547|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 549|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                                                                                    #|line 550|#
    (let ((err (fetch_first_output    main_container  error_port                                                        #|line 551|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (len   (trimws   (cdr (assoc '(srepr  )  err)) ) )))                   #|line 552|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___")                                                     #|line 553|#
          (print_specific_output    main_container  error_port  nil )                                                   #|line 554|#
          ))))                                                                                                          #|line 555|#
  )#|  debugging helpers |#                                                                                             #|line 557|##|line 558|#
(defun nl (&optional )
  (declare (ignorable ))                                                                                                #|line 559|#
  (format *standard-output* "~a"  "")                                                                                   #|line 560|##|line 561|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 563|#
  (nl  )                                                                                                                #|line 564|#
  (format *standard-output* "~a"  "___ Outputs ___")                                                                    #|line 565|#
  (print_output_list    main_container                                                                                  #|line 566|#)#|line 567|#
  )
(defun trace_outputs (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 569|#
  (nl  )                                                                                                                #|line 570|#
  (format *standard-output* "~a"  "___ Message Traces ___")                                                             #|line 571|#
  (print_routing_trace    main_container                                                                                #|line 572|#)#|line 573|#
  )
(defun dump_hierarchy (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 575|#
  (nl  )                                                                                                                #|line 576|#
  (format *standard-output* "~a"  (concatenate 'string  "___ Hierarchy ___" (build_hierarchy    main_container )))      #|line 577|##|line 578|#
  )
(defun build_hierarchy (&optional  c)
  (declare (ignorable  c))                                                                                              #|line 580|#
  (let (( s  ""))
    (declare (ignorable  s))                                                                                            #|line 581|#
    (loop for child in (cdr (assoc ' children  c))
      do                                                                                                                #|line 582|#
      (setf  s  (concatenate 'string  s (build_hierarchy    child )))                                                   #|line 583|#
      )
    (let (( indent  ""))
      (declare (ignorable  indent))                                                                                     #|line 584|#
      (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
        do                                                                                                              #|line 585|#
        (setf  indent (+  indent  "  "))                                                                                #|line 586|#
        )
      (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")")))))#|line 587|#)))#|line 588|#
  )
(defun dump_connections (&optional  c)
  (declare (ignorable  c))                                                                                              #|line 590|#
  (nl  )                                                                                                                #|line 591|#
  (format *standard-output* "~a"  "___ connections ___")                                                                #|line 592|#
  (dump_possible_connections    c                                                                                       #|line 593|#)
  (loop for child in (cdr (assoc ' children  c))
    do                                                                                                                  #|line 594|#
    (nl  )                                                                                                              #|line 595|#
    (dump_possible_connections    child )                                                                               #|line 596|#
    )                                                                                                                   #|line 597|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 599|#
  #|  remove whitespace from front and back of string |#                                                                #|line 600|#
  (return-from trimws (cdr (assoc '(strip  )  s)))                                                                      #|line 601|##|line 602|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 604|#
  (return-from clone_string  s                                                                                          #|line 605|##|line 606|#)#|line 607|#
  )
(defparameter  load_errors  nil)                                                                                        #|line 608|#
(defparameter  runtime_errors  nil)                                                                                     #|line 609|##|line 610|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 611|##|line 612|#
  (format *standard-output* "~a"  s)                                                                                    #|line 613|#
  (quit  )                                                                                                              #|line 614|#
  (setf  load_errors  t)                                                                                                #|line 615|##|line 616|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 618|##|line 619|#
  (format *standard-output* "~a"  s)                                                                                    #|line 620|#
  (quit  )                                                                                                              #|line 621|#
  (setf  runtime_errors  t)                                                                                             #|line 622|##|line 623|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 625|#
  (let ((instance_name (gensymbol    "fakepipe"                                                                         #|line 626|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (make_leaf    instance_name  owner  nil  #'fakepipename_handler               #|line 627|#)))#|line 628|#
  )
(defparameter  rand  0)                                                                                                 #|line 630|##|line 631|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 632|##|line 633|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |#                                   #|line 634|#
  (send_string    eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg                                             #|line 635|#)#|line 636|#
  )                                                                                                                     #|line 638|##|  all of the the built_in leaves are listed here |##|line 639|##|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 640|##|line 641|##|line 642|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 643|#
  (register_component    reg (Template    "1then2"  nil  #'deracer_instantiate )                                        #|line 644|#)
  (register_component    reg (Template    "?"  nil  #'probe_instantiate )                                               #|line 645|#)
  (register_component    reg (Template    "?A"  nil  #'probeA_instantiate )                                             #|line 646|#)
  (register_component    reg (Template    "?B"  nil  #'probeB_instantiate )                                             #|line 647|#)
  (register_component    reg (Template    "?C"  nil  #'probeC_instantiate )                                             #|line 648|#)
  (register_component    reg (Template    "trash"  nil  #'trash_instantiate )                                           #|line 649|#)#|line 650|#
  (register_component    reg (Template    "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )     #|line 651|#)
  (register_component    reg (Template    "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )               #|line 652|#)#|line 653|#
  (register_component    reg (Template    "syncfilewrite"  nil  #'syncfilewrite_instantiate )                           #|line 654|#)
  (register_component    reg (Template    "stringconcat"  nil  #'stringconcat_instantiate )                             #|line 655|#)
  #|  for fakepipe |#                                                                                                   #|line 656|#
  (register_component    reg (Template    "fakepipename"  nil  #'fakepipename_instantiate )                             #|line 657|#)#|line 658|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                                                                                #|line 660|#

  (error 'NIY)
                                                                                                                        #|line 661|##|line 662|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                                                                                #|line 664|#
  (let ((root_of_project  (nth  1 (argv))                                                                               #|line 665|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                                                                                  #|line 666|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                                                                                       #|line 667|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))                                                                     #|line 668|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))                                                                      #|line 669|#))
            (declare (ignorable diagram_names))
            (let ((palette (initialize_component_palette    root_project  root_0D  diagram_names                        #|line 670|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg )))#|line 671|#))))))#|line 672|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (start_with_debug    palette  env  nil  nil  nil  nil )                                                               #|line 674|#
  )
(defun start_with_debug (&optional  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs)
  (declare (ignorable  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs))                  #|line 675|#
  #|  show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥ |#                                        #|line 676|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                                                                               #|line 677|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                                                                                  #|line 678|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))                                                                       #|line 679|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))                                                                           #|line 680|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                                                                                   #|line 681|#
            (set_environment    root_of_project  root_of_0D                                                             #|line 682|#)
            #|  get entrypoint container |#                                                                             #|line 683|#
            (let (( main_container (get_component_instance    palette  main_container_name  nil                         #|line 684|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)                                                                        #|line 685|#
                  (load_error    (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)")))) #|line 689|#)#|line 690|#
                  ))
              (cond
                ( show_hierarchy                                                                                        #|line 691|#
                  (dump_hierarchy    main_container                                                                     #|line 692|#)#|line 693|#
                  ))
              (cond
                ( show_connections                                                                                      #|line 694|#
                  (dump_connections    main_container                                                                   #|line 695|#)#|line 696|#
                  ))
              (cond
                ((not  load_errors)                                                                                     #|line 697|#
                  (let (( arg (new_datum_string    arg                                                                  #|line 698|#)))
                    (declare (ignorable  arg))
                    (let (( msg (make_message    ""  arg                                                                #|line 699|#)))
                      (declare (ignorable  msg))
                      (inject    main_container  msg                                                                    #|line 700|#)
                      (cond
                        ( show_all_outputs                                                                              #|line 701|#
                          (dump_outputs    main_container                                                               #|line 702|#)
                          )
                        (t                                                                                              #|line 703|#
                          (print_error_maybe    main_container                                                          #|line 704|#)
                          (print_specific_output    main_container  ""                                                  #|line 705|#)
                          (cond
                            ( show_traces                                                                               #|line 706|#
                              (format *standard-output* "~a"  "--- routing traces ---")                                 #|line 707|#
                              (format *standard-output* "~a" (routing_trace_all    main_container ))                    #|line 708|##|line 709|#
                              ))                                                                                        #|line 710|#
                          ))
                      (cond
                        ( show_all_outputs                                                                              #|line 711|#
                          (format *standard-output* "~a"  "--- done ---")                                               #|line 712|##|line 713|#
                          ))))                                                                                          #|line 714|#
                  ))))))))                                                                                              #|line 715|#
  )                                                                                                                     #|line 717|##|line 718|##|  utility functions  |##|line 719|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))                                                                   #|line 720|#
  (let ((datum (new_datum_int    i                                                                                      #|line 721|#)))
    (declare (ignorable datum))
    (send    eh  port  datum  causing_message                                                                           #|line 722|#))#|line 723|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))                                                                      #|line 725|#
  (let ((datum (new_datum_bang  )))
    (declare (ignorable datum))                                                                                         #|line 726|#
    (send    eh  port  datum  causing_message                                                                           #|line 727|#))#|line 728|#
  )





