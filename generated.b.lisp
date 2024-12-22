
                                                            #|line 1|# #|line 2|# #|line 3|#
(defclass Component_Registry ()                             #|line 4|#
  (
    (templates :accessor templates :initarg :templates :initform  (dict-fresh))  #|line 5|#)) #|line 6|#

                                                            #|line 7|#
(defclass Template ()                                       #|line 8|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 9|#
    (template_data :accessor template_data :initarg :template_data :initform  nil)  #|line 10|#
    (instantiator :accessor instantiator :initarg :instantiator :initform  nil)  #|line 11|#)) #|line 12|#

                                                            #|line 13|#
(defun mkTemplate (&optional  name  template_data  instantiator)
  (declare (ignorable  name  template_data  instantiator))  #|line 14|#
  (let (( templ  (make-instance 'Template)                  #|line 15|#))
    (declare (ignorable  templ))
    (setf (slot-value  templ 'name)  name)                  #|line 16|#
    (setf (slot-value  templ 'template_data)  template_data) #|line 17|#
    (setf (slot-value  templ 'instantiator)  instantiator)  #|line 18|#
    (return-from mkTemplate  templ)                         #|line 19|#) #|line 20|#
  )
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 22|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (deep-expand (read f)))
                                                            #|line 23|# #|line 24|#
  )
(defun json2internal (&optional  pathname  container_xml)
  (declare (ignorable  pathname  container_xml))            #|line 26|#
  (let ((fname  container_xml                               #|line 27|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   pathname  fname  #|line 28|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                 #|line 29|#)) #|line 30|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                  #|line 32|#
  #| pass |#                                                #|line 33|# #|line 34|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 36|#
  (return-from make_component_registry  (make-instance 'Component_Registry) #|line 37|#) #|line 38|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template  nil )) #|line 40|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (funcall (quote abstracted_register_component)   reg  template  t )) #|line 41|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))     #|line 43|#
  (let ((name (funcall (quote mangle_name)  (slot-value  template 'name)  #|line 44|#)))
    (declare (ignorable name))
    (cond
      (( and  ( dict-in?  ( and  (not (equal   reg  nil))  name) (slot-value  reg 'templates)) (not  ok_to_overwrite)) #|line 45|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (slot-value  template 'name)  "/ already declared"))  #|line 46|#)
        (return-from abstracted_register_component  reg)    #|line 47|#
        )
      (t                                                    #|line 48|#
        (setf (gethash name (slot-value  reg 'templates))  template) #|line 49|#
        (return-from abstracted_register_component  reg)    #|line 50|# #|line 51|#
        )))                                                 #|line 52|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 54|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 55|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (slot-value  reg 'templates)) #|line 56|#
        (let ((template (gethash template_name (slot-value  reg 'templates))))
          (declare (ignorable template))                    #|line 57|#
          (cond
            (( equal    template  nil)                      #|line 58|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can;t find component /"  (concatenate 'string  template_name  "/"))  #|line 59|#)
              (return-from get_component_instance  nil)     #|line 60|#
              )
            (t                                              #|line 61|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 62|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 63|#
                  (cond
                    ((not (equal   nil  owner))             #|line 64|#
                      (setf  owner_name (slot-value  owner 'name)) #|line 65|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name)) #|line 66|#)
                      )
                    (t                                      #|line 67|#
                      (setf  instance_name  template_name)  #|line 68|# #|line 69|#
                      ))
                  (let ((instance (funcall (slot-value  template 'instantiator)   reg  owner  instance_name (slot-value  template 'template_data)  #|line 70|#)))
                    (declare (ignorable instance))
                    (return-from get_component_instance  instance) #|line 71|#))) #|line 72|#
              )))
        )
      (t                                                    #|line 73|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 74|#)
        (return-from get_component_instance  nil)           #|line 75|# #|line 76|#
        )))                                                 #|line 77|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 79|#
  (funcall (quote nl) )                                     #|line 80|#
  (format *standard-output* "~a~%"  "*** PALETTE ***")      #|line 81|#
  (loop for c in (slot-value  reg 'templates)
    do
      (progn
        c                                                   #|line 82|#
        (funcall (quote print)  (slot-value  c 'name) )     #|line 83|#
        ))
  (format *standard-output* "~a~%"  "***************")      #|line 84|#
  (funcall (quote nl) )                                     #|line 85|# #|line 86|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 88|#
  (format *standard-output* "~a~%"  (concatenate 'string  "registry statistics: " (slot-value  reg 'stats))) #|line 89|# #|line 90|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 92|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 93|#
  (return-from mangle_name  s)                              #|line 94|# #|line 95|#
  )                                                         #|line 97|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 98|# #|  and output queues of messages. |# #|line 99|# #|  |# #|line 100|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 101|# #|  that routes messages to child components according to a list of connections |# #|line 102|# #|  that serve as a message routing table. |# #|line 103|# #|  |# #|line 104|# #|  Child components themselves can be leaves or other containers. |# #|line 105|# #|  |# #|line 106|# #|  `handler` invokes the code that is attached to this component. |# #|line 107|# #|  |# #|line 108|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 109|# #|  function may want whenever it is invoked again. |# #|line 110|# #|  |# #|line 111|# #|line 112|# #|  Eh_States :: enum { idle, active } |# #|line 113|#
(defclass Eh ()                                             #|line 114|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 115|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 116|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 117|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 118|#
    (children :accessor children :initarg :children :initform  nil)  #|line 119|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 120|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 121|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 122|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 123|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 124|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 125|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 126|# #|  bootstrap debugging |# #|line 127|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 128|#)) #|line 129|#

                                                            #|line 130|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 131|# #|  whose handler function is `container_handler`. |# #|line 132|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 133|#
  (let (( eh  (make-instance 'Eh)                           #|line 134|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 135|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 136|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 137|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 138|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 139|#
    (setf (slot-value  eh 'kind)  "container")              #|line 140|#
    (return-from make_container  eh)                        #|line 141|#) #|line 142|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 144|# #|  that will be passed back to your handler when called. |# #|line 145|# #|line 146|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 147|#
  (let (( eh  (make-instance 'Eh)                           #|line 148|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "."  name)) #|line 149|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 150|#
    (setf (slot-value  eh 'handler)  handler)               #|line 151|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 152|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 153|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 154|#
    (return-from make_leaf  eh)                             #|line 155|#) #|line 156|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 158|# #|  of the given component. |# #|line 159|# #|line 160|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 161|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 162|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 163|#)) #|line 164|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 166|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 167|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 168|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 169|#))) #|line 170|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 172|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value  msg 'datum)  #|line 173|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  fwdmsg                #|line 174|#)) #|line 175|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 177|#
  (funcall (slot-value  eh 'finject)   eh  msg              #|line 178|#) #|line 179|#
  ) #|  Returns a list of all output messages on a container. |# #|line 181|# #|  For testing / debugging purposes. |# #|line 182|# #|line 183|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 184|#
  (return-from output_list (slot-value  eh 'outq))          #|line 185|# #|line 186|#
  ) #|  Utility for printing an array of messages. |#       #|line 188|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 189|#
  (format *standard-output* "~a~%"  "{")                    #|line 190|#
  (loop for m in (queue2list (slot-value  eh 'outq))
    do
      (progn
        m                                                   #|line 191|#
        (format *standard-output* "~a~%" (funcall (quote format_message)   m )) #|line 192|# #|line 193|#
        ))
  (format *standard-output* "~a~%"  "}")                    #|line 194|# #|line 195|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 197|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 198|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 199|#
          (setf  s (+  s  " "))                             #|line 200|#
          ))
    (return-from spaces  s)                                 #|line 201|#) #|line 202|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 204|#
  (setf (slot-value  eh 'state)  "active")                  #|line 205|# #|line 206|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 208|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 209|# #|line 210|#
  ) #|  Utility for printing a specific output message. |#  #|line 212|# #|line 213|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 214|#
  (loop for msg in (queue2list (slot-value  eh 'outq))
    do
      (progn
        msg                                                 #|line 215|#
        (cond
          (( equal   (slot-value  msg 'port)  port)         #|line 216|#
            (return-from fetch_first_output (slot-value  msg 'datum))
            ))                                              #|line 217|#
        ))
  (return-from fetch_first_output  nil)                     #|line 218|# #|line 219|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 221|#
  #|  port ∷ “” |#                                          #|line 222|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 223|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a~%" (slot-value  datum 'v)) #|line 224|#) #|line 225|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 226|#
  #|  port ∷ “” |#                                          #|line 227|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 228|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 229|#
    (format *error-output* "~a~%" (slot-value  datum 'v))   #|line 230|#) #|line 231|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 233|#
  (enqueue (slot-value  eh 'outq)  msg)                     #|line 234|# #|line 235|#
  )
(defparameter  root_project  "")                            #|line 237|#
(defparameter  root_0D  "")                                 #|line 238|# #|line 239|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 240|# #|line 241|# #|line 242|#
  (setf  root_project  rproject)                            #|line 243|#
  (setf  root_0D  r0D)                                      #|line 244|# #|line 245|#
  )                                                         #|line 247|#
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 248|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 249|#
  (return-from string_make_persistent  s)                   #|line 250|# #|line 251|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 253|#
  (return-from string_clone  s)                             #|line 254|# #|line 255|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 257|# #|  where ${_00_} is the root directory for the project |# #|line 258|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 259|# #|line 260|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 261|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 262|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 263|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 264|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 265|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 266|#
                  (funcall (quote register_component)   reg (funcall (quote mkTemplate)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 267|#) #|line 268|#
                  )))                                       #|line 269|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 270|#)
    (return-from initialize_component_palette  reg)         #|line 271|#) #|line 272|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 274|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 275|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 276|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (slot-value  err 'v) )))) #|line 277|#
          (format *standard-output* "~a~%"  "___ !!! ERRORS !!! ___") #|line 278|#
          (funcall (quote print_specific_output)   main_container  error_port  #|line 279|#) #|line 280|#
          ))))                                              #|line 281|#
  ) #|  debugging helpers |#                                #|line 283|# #|line 284|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 285|#
  (format *standard-output* "~a~%"  "")                     #|line 286|# #|line 287|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 289|#
  (funcall (quote nl) )                                     #|line 290|#
  (format *standard-output* "~a~%"  "___ Outputs ___")      #|line 291|#
  (funcall (quote print_output_list)   main_container       #|line 292|#) #|line 293|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 295|#
  #|  remove whitespace from front and back of string |#    #|line 296|#
  (return-from trimws (funcall (slot-value  s 'strip) ))    #|line 297|# #|line 298|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 300|#
  (return-from clone_string  s                              #|line 301|# #|line 302|#) #|line 303|#
  )
(defparameter  load_errors  nil)                            #|line 304|#
(defparameter  runtime_errors  nil)                         #|line 305|# #|line 306|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 307|# #|line 308|#
  (format *standard-output* "~a~%"  s)                      #|line 309|#
  (format *standard-output* "
  ")                                                        #|line 310|#
  (setf  load_errors  t)                                    #|line 311|# #|line 312|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 314|# #|line 315|#
  (format *standard-output* "~a~%"  s)                      #|line 316|#
  (setf  runtime_errors  t)                                 #|line 317|# #|line 318|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 320|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 321|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 322|#))) #|line 323|#
  )
(defparameter  rand  0)                                     #|line 325|# #|line 326|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 327|# #|line 328|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 329|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 330|#) #|line 331|#
  )                                                         #|line 333|#
(defclass Switch1star_Instance_Data ()                      #|line 334|#
  (
    (state :accessor state :initarg :state :initform  "1")  #|line 335|#)) #|line 336|#

                                                            #|line 337|#
(defun switch1star_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 338|#
  (let ((name_with_id (funcall (quote gensymbol)   "switch1*"  #|line 339|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Switch1star_Instance_Data) #|line 340|#))
      (declare (ignorable instp))
      (return-from switch1star_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'switch1star_handler  #|line 341|#)))) #|line 342|#
  )
(defun switch1star_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 344|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 345|#
    (let ((whichOutput (slot-value  inst 'state)))
      (declare (ignorable whichOutput))                     #|line 346|#
      (cond
        (( equal    "" (slot-value  msg 'port))             #|line 347|#
          (cond
            (( equal    "1"  whichOutput)                   #|line 348|#
              (funcall (quote forward)   eh  "1"  msg       #|line 349|#)
              (setf (slot-value  inst 'state)  "*")         #|line 350|#
              )
            (( equal    "*"  whichOutput)                   #|line 351|#
              (funcall (quote forward)   eh  "*"  msg       #|line 352|#)
              )
            (t                                              #|line 353|#
              (funcall (quote send)   eh  "✗"  "internal error bad state in switch1*"  msg  #|line 354|#) #|line 355|#
              ))
          )
        (( equal    "reset" (slot-value  msg 'port))        #|line 356|#
          (setf (slot-value  inst 'state)  "1")             #|line 357|#
          )
        (t                                                  #|line 358|#
          (funcall (quote send)   eh  "✗"  "internal error bad message for switch1*"  msg  #|line 359|#) #|line 360|#
          ))))                                              #|line 361|#
  )
(defclass Latch_Instance_Data ()                            #|line 363|#
  (
    (datum :accessor datum :initarg :datum :initform  nil)  #|line 364|#)) #|line 365|#

                                                            #|line 366|#
(defun latch_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 367|#
  (let ((name_with_id (funcall (quote gensymbol)   "latch"  #|line 368|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Latch_Instance_Data)      #|line 369|#))
      (declare (ignorable instp))
      (return-from latch_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'latch_handler  #|line 370|#)))) #|line 371|#
  )
(defun latch_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 373|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 374|#
    (cond
      (( equal    "" (slot-value  msg 'port))               #|line 375|#
        (setf (slot-value  inst 'datum) (slot-value  msg 'datum)) #|line 376|#
        )
      (( equal    "release" (slot-value  msg 'port))        #|line 377|#
        (let (( d (slot-value  inst 'datum)))
          (declare (ignorable  d))                          #|line 378|#
          (funcall (quote send)   eh  ""  d  msg            #|line 379|#)
          (setf (slot-value  inst 'datum)  nil)             #|line 380|#)
        )
      (t                                                    #|line 381|#
        (funcall (quote send)   eh  "✗"  "internal error bad message for latch"  msg  #|line 382|#) #|line 383|#
        )))                                                 #|line 384|#
  ) #|  all of the the built_in leaves are listed here |#   #|line 386|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 387|# #|line 388|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 389|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 390|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 391|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 392|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 393|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 394|#) #|line 395|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 396|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 397|#) #|line 398|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 399|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 400|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "switch1*"  nil  #'switch1star_instantiate )  #|line 401|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "latch"  nil  #'latch_instantiate )  #|line 402|#)
  #|  for fakepipe |#                                       #|line 403|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 404|#) #|line 405|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 407|#
  (return-from argv
    (get-main-args)
                                                            #|line 408|#) #|line 409|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 411|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 412|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 413|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 414|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 415|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 416|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 417|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 418|#)))))) #|line 419|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 421|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 422|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 423|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 424|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 425|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 426|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 427|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 428|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 429|#)
            #|  get entrypoint container |#                 #|line 430|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 431|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 432|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 436|#) #|line 437|#
                  ))
              (cond
                ((not  load_errors)                         #|line 438|#
                  (let (( marg (funcall (quote new_datum_string)   arg  #|line 439|#)))
                    (declare (ignorable  marg))
                    (let (( msg (funcall (quote make_message)   ""  marg  #|line 440|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 441|#)
                      (cond
                        ( show_all_outputs                  #|line 442|#
                          (funcall (quote dump_outputs)   main_container  #|line 443|#)
                          )
                        (t                                  #|line 444|#
                          (funcall (quote print_error_maybe)   main_container  #|line 445|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 446|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 447|#
                                (format *standard-output* "~a~%"  "«««no outputs»»»)") #|line 448|#
                                )
                              (t                            #|line 449|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 450|#) #|line 451|#
                                )))                         #|line 452|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 453|#
                          (format *standard-output* "~a~%"  "--- done ---") #|line 454|# #|line 455|#
                          ))))                              #|line 456|#
                  ))))))))                                  #|line 457|#
  )                                                         #|line 459|# #|  utility functions  |# #|line 460|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 461|#
  (let ((datum (funcall (quote new_datum_string)  (format nil "~a"  i)  #|line 462|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 463|#)) #|line 464|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 466|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 467|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 468|#)) #|line 469|#
  )





