#|  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 1|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 2|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 3|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 4|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 5|#)))) #|line 6|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 8|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 9|#
    (let ((s (slot-value (slot-value  msg 'datum) 'v)))
      (declare (ignorable s))                               #|line 10|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 11|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 12|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 13|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 14|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 15|#
              (cond
                (( equal    rc  0)                          #|line 16|#
                  (funcall (quote send_string)   eh  ""  (concatenate 'string  stdout  stderr)  msg  #|line 17|#)
                  )
                (t                                          #|line 18|#
                  (funcall (quote send_string)   eh  "✗"  (concatenate 'string  stdout  stderr)  msg  #|line 19|#) #|line 20|#
                  ))))))))                                  #|line 21|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 23|#
  #|  [ |#                                                  #|line 24|#
  #|      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 25|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 26|#
  #|  ] |#                                                  #|line 27|#
  (cond
    ((not (equal   nil  container_list))                    #|line 28|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 29|#
            #|  loop through every component in the diagram and look for names that start with “$“ or “'“  |# #|line 30|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 31|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 32|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 33|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 34|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 35|#
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  cmd  #'shell_out_instantiate  #|line 36|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 37|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 38|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 39|#
                        (let ((s  (subseq  name 1)          #|line 40|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  s  #'string_constant_instantiate  #|line 41|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 42|#)))) #|line 43|#
                      ))                                    #|line 44|#
                  ))                                        #|line 45|#
            ))                                              #|line 46|#
      ))
  (return-from generate_shell_components  reg)              #|line 47|# #|line 48|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 50|#
  (return-from first_char  (char  s 0)                      #|line 51|#) #|line 52|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 54|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 55|#))) #|line 56|#
  )                                                         #|line 58|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 59|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 60|# #|line 61|#
 #|   intentionally left empty  |#                         #|line 1|#
(load "~/quicklisp/setup.lisp")
(proclaim '(optimize (debug 3) (safety 3) (speed 0)))

(defun dict (lis)
;; make a dict, given a list of pairs
(let ((ht (make-hash-table :test 'equal)))
(mapc #'(lambda (pair)
(let ((name (car pair))
(v (deep-expand (cdr pair))))
(setf (gethash name ht) v)))
lis)
ht))

(defun jarray (lis)
;; convert a JSON array into a lisp list (straight-forward, almost nothing to do)
(mapcar #'deep-expand lis))


(defun deep-expand (x)
(cond
((null x) nil)
((listp x) (cond
((eq 'dict (car x)) (dict (cdr x)))
((eq 'jarray (car x)) (jarray (cdr x)))
(t (error "unknown list in deep-expand"))))
(t x)))


(defun dict-fresh () (make-hash-table :test 'equal))

(defun dict-in? (name table)
(when (and table name)
(multiple-value-bind (dont-care found)
(gethash name table)
dont-care ;; quell warnings that dont-care is unused
found)))

(defun key-mangle (s) s)


(defun is-pair? (x)
(and
(listp x)
(symbolp (car x))))

(defun is-json-object? (x)
(and
(listp x)
(not (atom (cdr x)))
(= 1 (length x))
(is-pair? x)))

(defun is-json-array? (x)
(and
(listp x)
(listp (car x))))

(defun rewrite-pair (pair)
(let ((k (if (symbolp (car pair))
(symbol-name (car pair))
(car pair))))
(let ((x (cdr pair)))
(let ((v (if (or (is-json-object? x) (is-json-array? x))
(rewrite-json x)
x)))
(cons k v)))))

(defun rewrite-json (x)
(cond
((is-pair? x) (rewrite-pair x))
((is-json-object? x) (mapcar #'rewrite-json x))
((is-json-array? x) (mapcar #'rewrite-json x))))

(defclass Queue ()
((contents :accessor contents :initform nil)))

(defmethod enqueue ((self Queue) v)
(setf (contents self) (append (contents self) (list v))))

(defmethod dequeue ((self Queue))
(pop (contents self)))

(defmethod empty? ((self Queue))
(null (contents self)))

(defmethod queue2list ((self Queue))
(contents self))
                                                            #|line 1|# #|line 2|#
(defparameter  counter  0)                                  #|line 3|#
(defparameter  ticktime  0)                                 #|line 4|# #|line 5|#
(defparameter  digits (list                                 #|line 6|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" )) #|line 12|# #|line 13|# #|line 14|#
(defun gensymbol (&optional  s)
  (declare (ignorable  s))                                  #|line 15|# #|line 16|#
  (let ((name_with_id  (concatenate 'string  s (funcall (quote subscripted_digit)   counter )) #|line 17|#))
    (declare (ignorable name_with_id))
    (setf  counter (+  counter  1))                         #|line 18|#
    (return-from gensymbol  name_with_id)                   #|line 19|#) #|line 20|#
  )
(defun subscripted_digit (&optional  n)
  (declare (ignorable  n))                                  #|line 22|# #|line 23|#
  (cond
    (( and  ( >=   n  0) ( <=   n  29))                     #|line 24|#
      (return-from subscripted_digit (nth  n  digits))      #|line 25|#
      )
    (t                                                      #|line 26|#
      (return-from subscripted_digit  (concatenate 'string  "₊" (format nil "~a"  n)) #|line 27|#) #|line 28|#
      ))                                                    #|line 29|#
  )
(defclass Datum ()                                          #|line 31|#
  (
    (v :accessor v :initarg :v :initform  nil)              #|line 32|#
    (clone :accessor clone :initarg :clone :initform  nil)  #|line 33|#
    (reclaim :accessor reclaim :initarg :reclaim :initform  nil)  #|line 34|#
    (other :accessor other :initarg :other :initform  nil)  #|  reserved for use on per-project basis  |# #|line 35|#)) #|line 36|#

                                                            #|line 37|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                  #|line 38|#
  (let ((d  (make-instance 'Datum)                          #|line 39|#))
    (declare (ignorable d))
    (setf (slot-value  d 'v)  s)                            #|line 40|#
    (setf (slot-value  d 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 41|#)))
    (setf (slot-value  d 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 42|#)))
    (return-from new_datum_string  d)                       #|line 43|#) #|line 44|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 46|#
  (let ((newd (funcall (quote new_datum_string)  (slot-value  d 'v)  #|line 47|#)))
    (declare (ignorable newd))
    (return-from clone_datum_string  newd)                  #|line 48|#) #|line 49|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 51|#
  #| pass |#                                                #|line 52|# #|line 53|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 55|#
  (let ((p  (make-instance 'Datum)                          #|line 56|#))
    (declare (ignorable p))
    (setf (slot-value  p 'v)  "")                           #|line 57|#
    (setf (slot-value  p 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 58|#)))
    (setf (slot-value  p 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 59|#)))
    (return-from new_datum_bang  p)                         #|line 60|#) #|line 61|#
  )
(defun clone_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 63|#
  (return-from clone_datum_bang (funcall (quote new_datum_bang) )) #|line 64|# #|line 65|#
  )
(defun reclaim_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 67|#
  #| pass |#                                                #|line 68|# #|line 69|#
  ) #|  Mevent passed to a leaf component. |#               #|line 71|# #|  |# #|line 72|# #|  `port` refers to the name of the incoming or outgoing port of this component. |# #|line 73|# #|  `payload` is the data attached to this mevent. |# #|line 74|#
(defclass Mevent ()                                         #|line 75|#
  (
    (port :accessor port :initarg :port :initform  nil)     #|line 76|#
    (datum :accessor datum :initarg :datum :initform  nil)  #|line 77|#)) #|line 78|#

                                                            #|line 79|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                  #|line 80|#
  (return-from clone_port (funcall (quote clone_string)   s  #|line 81|#)) #|line 82|#
  ) #|  Utility for making a `Mevent`. Used to safely "seed“ mevents |# #|line 84|# #|  entering the very top of a network. |# #|line 85|#
(defun make_mevent (&optional  port  datum)
  (declare (ignorable  port  datum))                        #|line 86|#
  (let ((p (funcall (quote clone_string)   port             #|line 87|#)))
    (declare (ignorable p))
    (let (( m  (make-instance 'Mevent)                      #|line 88|#))
      (declare (ignorable  m))
      (setf (slot-value  m 'port)  p)                       #|line 89|#
      (setf (slot-value  m 'datum) (funcall (slot-value  datum 'clone) )) #|line 90|#
      (return-from make_mevent  m)                          #|line 91|#)) #|line 92|#
  ) #|  Clones a mevent. Primarily used internally for “fanning out“ a mevent to multiple destinations. |# #|line 94|#
(defun mevent_clone (&optional  mev)
  (declare (ignorable  mev))                                #|line 95|#
  (let (( m  (make-instance 'Mevent)                        #|line 96|#))
    (declare (ignorable  m))
    (setf (slot-value  m 'port) (funcall (quote clone_port)  (slot-value  mev 'port)  #|line 97|#))
    (setf (slot-value  m 'datum) (funcall (slot-value (slot-value  mev 'datum) 'clone) )) #|line 98|#
    (return-from mevent_clone  m)                           #|line 99|#) #|line 100|#
  ) #|  Frees a mevent. |#                                  #|line 102|#
(defun destroy_mevent (&optional  mev)
  (declare (ignorable  mev))                                #|line 103|#
  #|  during debug, dont destroy any mevent, since we want to trace mevents, thus, we need to persist ancestor mevents |# #|line 104|#
  #| pass |#                                                #|line 105|# #|line 106|#
  )
(defun destroy_datum (&optional  mev)
  (declare (ignorable  mev))                                #|line 108|#
  #| pass |#                                                #|line 109|# #|line 110|#
  )
(defun destroy_port (&optional  mev)
  (declare (ignorable  mev))                                #|line 112|#
  #| pass |#                                                #|line 113|# #|line 114|#
  ) #|  |#                                                  #|line 116|#
(defun format_mevent (&optional  m)
  (declare (ignorable  m))                                  #|line 117|#
  (cond
    (( equal    m  nil)                                     #|line 118|#
      (return-from format_mevent  "{}")                     #|line 119|#
      )
    (t                                                      #|line 120|#
      (return-from format_mevent  (concatenate 'string  "{\""  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  "\":\""  (concatenate 'string (slot-value (slot-value  m 'datum) 'v)  "\"}")))) #|line 121|#) #|line 122|#
      ))                                                    #|line 123|#
  )
(defun format_mevent_raw (&optional  m)
  (declare (ignorable  m))                                  #|line 124|#
  (cond
    (( equal    m  nil)                                     #|line 125|#
      (return-from format_mevent_raw  "")                   #|line 126|#
      )
    (t                                                      #|line 127|#
      (return-from format_mevent_raw (slot-value (slot-value  m 'datum) 'v)) #|line 128|# #|line 129|#
      ))                                                    #|line 130|#
  )
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 136|#
(defun create_down_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 137|#
  #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 138|#
  (let (( connector  (make-instance 'Connector)             #|line 139|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "down")       #|line 140|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 141|#))
    (let ((target_proto (gethash  "target"  proto_conn)))
      (declare (ignorable target_proto))                    #|line 142|#
      (let ((id_proto (gethash  "id"  target_proto)))
        (declare (ignorable id_proto))                      #|line 143|#
        (let ((target_component (gethash id_proto  children_by_id)))
          (declare (ignorable target_component))            #|line 144|#
          (cond
            (( equal    target_component  nil)              #|line 145|#
              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (gethash  "name" (gethash  "target"  proto_conn))) ) #|line 146|#
              )
            (t                                              #|line 147|#
              (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 148|#)) #|line 149|#
              ))
          (return-from create_down_connector  connector)    #|line 150|#)))) #|line 151|#
  )
(defun create_across_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 153|#
  (let (( connector  (make-instance 'Connector)             #|line 154|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "across")     #|line 155|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 156|#
      (let ((target_component (gethash (gethash  "id" (gethash  "target"  proto_conn))  children_by_id)))
        (declare (ignorable target_component))              #|line 157|#
        (cond
          (( equal    source_component  nil)                #|line 158|#
            (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (gethash  "name" (gethash  "source"  proto_conn)))  #|line 159|#)
            )
          (t                                                #|line 160|#
            (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 161|#))
            (cond
              (( equal    target_component  nil)            #|line 162|#
                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (gethash  "name" (gethash  "target"  proto_conn)))  #|line 163|#)
                )
              (t                                            #|line 164|#
                (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 165|#)) #|line 166|#
                ))                                          #|line 167|#
            ))
        (return-from create_across_connector  connector)    #|line 168|#))) #|line 169|#
  )
(defun create_up_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 171|#
  (let (( connector  (make-instance 'Connector)             #|line 172|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "up")         #|line 173|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 174|#
      (cond
        (( equal    source_component  nil)                  #|line 175|#
          (funcall (quote load_error)   (concatenate 'string  "internal error: .Up connection source not ok " (gethash  "name" (gethash  "source"  proto_conn))) ) #|line 176|#
          )
        (t                                                  #|line 177|#
          (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 178|#))
          (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 179|#)) #|line 180|#
          ))
      (return-from create_up_connector  connector)          #|line 181|#)) #|line 182|#
  )
(defun create_through_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 184|#
  (let (( connector  (make-instance 'Connector)             #|line 185|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "through")    #|line 186|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 187|#))
    (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 188|#))
    (return-from create_through_connector  connector)       #|line 189|#) #|line 190|#
  )                                                         #|line 192|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 193|# #|line 194|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 195|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 196|#
      (let ((children_by_id  (dict-fresh)))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 197|#
        #|  collect children |#                             #|line 198|#
        (loop for child_desc in (gethash  "children"  desc)
          do
            (progn
              child_desc                                    #|line 199|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (gethash  "name"  child_desc)  container  #|line 200|#)))
                (declare (ignorable child_instance))
                (setf  children (append  children (list  child_instance))) #|line 201|#
                (let ((id (gethash  "id"  child_desc)))
                  (declare (ignorable id))                  #|line 202|#
                  (setf (gethash id  children_by_id)  child_instance) #|line 203|# #|line 204|#)) #|line 205|#
              ))
        (setf (slot-value  container 'children)  children)  #|line 206|# #|line 207|#
        (let ((connectors  nil))
          (declare (ignorable connectors))                  #|line 208|#
          (loop for proto_conn in (gethash  "connections"  desc)
            do
              (progn
                proto_conn                                  #|line 209|#
                (let (( connector  (make-instance 'Connector) #|line 210|#))
                  (declare (ignorable  connector))
                  (cond
                    (( equal   (gethash  "dir"  proto_conn)  enumDown) #|line 211|#
                      (setf  connectors (append  connectors (list (funcall (quote create_down_connector)   container  proto_conn  connectors  children_by_id )))) #|line 212|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumAcross) #|line 213|#
                      (setf  connectors (append  connectors (list (funcall (quote create_across_connector)   container  proto_conn  connectors  children_by_id )))) #|line 214|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumUp) #|line 215|#
                      (setf  connectors (append  connectors (list (funcall (quote create_up_connector)   container  proto_conn  connectors  children_by_id )))) #|line 216|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumThrough) #|line 217|#
                      (setf  connectors (append  connectors (list (funcall (quote create_through_connector)   container  proto_conn  connectors  children_by_id )))) #|line 218|# #|line 219|#
                      )))                                   #|line 220|#
                ))
          (setf (slot-value  container 'connections)  connectors) #|line 221|#
          (return-from container_instantiator  container)   #|line 222|#)))) #|line 223|#
  ) #|  The default handler for container components. |#    #|line 225|#
(defun container_handler (&optional  container  mevent)
  (declare (ignorable  container  mevent))                  #|line 226|#
  (funcall (quote route)   container  #|  from=  |# container  mevent )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 227|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 228|#
        (funcall (quote step_children)   container  mevent ) #|line 229|#
        ))                                                  #|line 230|#
  ) #|  Frees the given container and associated data. |#   #|line 232|#
(defun destroy_container (&optional  eh)
  (declare (ignorable  eh))                                 #|line 233|#
  #| pass |#                                                #|line 234|# #|line 235|#
  ) #|  Routing connection for a container component. The `direction` field has |# #|line 237|# #|  no affect on the default mevent routing system _ it is there for debugging |# #|line 238|# #|  purposes, or for reading by other tools. |# #|line 239|# #|line 240|#
(defclass Connector ()                                      #|line 241|#
  (
    (direction :accessor direction :initarg :direction :initform  nil)  #|  down, across, up, through |# #|line 242|#
    (sender :accessor sender :initarg :sender :initform  nil)  #|line 243|#
    (receiver :accessor receiver :initarg :receiver :initform  nil)  #|line 244|#)) #|line 245|#

                                                            #|line 246|# #|  `Sender` is used to “pattern match“ which `Receiver` a mevent should go to, |# #|line 247|# #|  based on component ID (pointer) and port name. |# #|line 248|# #|line 249|#
(defclass Sender ()                                         #|line 250|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 251|#
    (component :accessor component :initarg :component :initform  nil)  #|line 252|#
    (port :accessor port :initarg :port :initform  nil)     #|line 253|#)) #|line 254|#

                                                            #|line 255|# #|line 256|# #|line 257|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 258|# #|  to incoming mevents to this queue. |# #|line 259|# #|line 260|#
(defclass Receiver ()                                       #|line 261|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 262|#
    (queue :accessor queue :initarg :queue :initform  nil)  #|line 263|#
    (port :accessor port :initarg :port :initform  nil)     #|line 264|#
    (component :accessor component :initarg :component :initform  nil)  #|line 265|#)) #|line 266|#

                                                            #|line 267|#
(defun mkSender (&optional  name  component  port)
  (declare (ignorable  name  component  port))              #|line 268|#
  (let (( s  (make-instance 'Sender)                        #|line 269|#))
    (declare (ignorable  s))
    (setf (slot-value  s 'name)  name)                      #|line 270|#
    (setf (slot-value  s 'component)  component)            #|line 271|#
    (setf (slot-value  s 'port)  port)                      #|line 272|#
    (return-from mkSender  s)                               #|line 273|#) #|line 274|#
  )
(defun mkReceiver (&optional  name  component  port  q)
  (declare (ignorable  name  component  port  q))           #|line 276|#
  (let (( r  (make-instance 'Receiver)                      #|line 277|#))
    (declare (ignorable  r))
    (setf (slot-value  r 'name)  name)                      #|line 278|#
    (setf (slot-value  r 'component)  component)            #|line 279|#
    (setf (slot-value  r 'port)  port)                      #|line 280|#
    #|  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. |# #|line 281|#
    (setf (slot-value  r 'queue)  q)                        #|line 282|#
    (return-from mkReceiver  r)                             #|line 283|#) #|line 284|#
  ) #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 286|#
(defun sender_eq (&optional  s1  s2)
  (declare (ignorable  s1  s2))                             #|line 287|#
  (let ((same_components ( equal   (slot-value  s1 'component) (slot-value  s2 'component))))
    (declare (ignorable same_components))                   #|line 288|#
    (let ((same_ports ( equal   (slot-value  s1 'port) (slot-value  s2 'port))))
      (declare (ignorable same_ports))                      #|line 289|#
      (return-from sender_eq ( and   same_components  same_ports)) #|line 290|#)) #|line 291|#
  ) #|  Delivers the given mevent to the receiver of this connector. |# #|line 293|# #|line 294|#
(defun deposit (&optional  parent  conn  mevent)
  (declare (ignorable  parent  conn  mevent))               #|line 295|#
  (let ((new_mevent (funcall (quote make_mevent)  (slot-value (slot-value  conn 'receiver) 'port) (slot-value  mevent 'datum)  #|line 296|#)))
    (declare (ignorable new_mevent))
    (funcall (quote push_mevent)   parent (slot-value (slot-value  conn 'receiver) 'component) (slot-value (slot-value  conn 'receiver) 'queue)  new_mevent  #|line 297|#)) #|line 298|#
  )
(defun force_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 300|#
  (let ((tick_mev (funcall (quote make_mevent)   "." (funcall (quote new_datum_bang) )  #|line 301|#)))
    (declare (ignorable tick_mev))
    (funcall (quote push_mevent)   parent  eh (slot-value  eh 'inq)  tick_mev  #|line 302|#)
    (return-from force_tick  tick_mev)                      #|line 303|#) #|line 304|#
  )
(defun push_mevent (&optional  parent  receiver  inq  m)
  (declare (ignorable  parent  receiver  inq  m))           #|line 306|#
  (enqueue  inq  m)                                         #|line 307|#
  (enqueue (slot-value  parent 'visit_ordering)  receiver)  #|line 308|# #|line 309|#
  )
(defun is_self (&optional  child  container)
  (declare (ignorable  child  container))                   #|line 311|#
  #|  in an earlier version “self“ was denoted as ϕ |#      #|line 312|#
  (return-from is_self ( equal    child  container))        #|line 313|# #|line 314|#
  )
(defun step_child (&optional  child  mev)
  (declare (ignorable  child  mev))                         #|line 316|#
  (let ((before_state (slot-value  child 'state)))
    (declare (ignorable before_state))                      #|line 317|#
    (funcall (slot-value  child 'handler)   child  mev      #|line 318|#)
    (let ((after_state (slot-value  child 'state)))
      (declare (ignorable after_state))                     #|line 319|#
      (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 320|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 321|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 322|#)) #|line 323|#
  )
(defun step_children (&optional  container  causingMevent)
  (declare (ignorable  container  causingMevent))           #|line 325|#
  (setf (slot-value  container 'state)  "idle")             #|line 326|#
  (loop for child in (queue2list (slot-value  container 'visit_ordering))
    do
      (progn
        child                                               #|line 327|#
        #|  child = container represents self, skip it |#   #|line 328|#
        (cond
          ((not (funcall (quote is_self)   child  container )) #|line 329|#
            (cond
              ((not (empty? (slot-value  child 'inq)))      #|line 330|#
                (let ((mev (dequeue (slot-value  child 'inq)) #|line 331|#))
                  (declare (ignorable mev))
                  (let (( began_long_run  nil))
                    (declare (ignorable  began_long_run))   #|line 332|#
                    (let (( continued_long_run  nil))
                      (declare (ignorable  continued_long_run)) #|line 333|#
                      (let (( ended_long_run  nil))
                        (declare (ignorable  ended_long_run)) #|line 334|#
                        (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  mev  #|line 335|#))
                        (cond
                          ( began_long_run                  #|line 336|#
                            #| pass |#                      #|line 337|#
                            )
                          ( continued_long_run              #|line 338|#
                            #| pass |#                      #|line 339|#
                            )
                          ( ended_long_run                  #|line 340|#
                            #| pass |#                      #|line 341|# #|line 342|#
                            ))
                        (funcall (quote destroy_mevent)   mev  #|line 343|#)))))
                )
              (t                                            #|line 344|#
                (cond
                  ((not (equal  (slot-value  child 'state)  "idle")) #|line 345|#
                    (let ((mev (funcall (quote force_tick)   container  child  #|line 346|#)))
                      (declare (ignorable mev))
                      (funcall (slot-value  child 'handler)   child  mev  #|line 347|#)
                      (funcall (quote destroy_mevent)   mev  #|line 348|#)) #|line 349|#
                    ))                                      #|line 350|#
                ))                                          #|line 351|#
            (cond
              (( equal   (slot-value  child 'state)  "active") #|line 352|#
                #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 353|#
                (setf (slot-value  container 'state)  "active") #|line 354|# #|line 355|#
                ))                                          #|line 356|#
            (loop while (not (empty? (slot-value  child 'outq)))
              do
                (progn                                      #|line 357|#
                  (let ((mev (dequeue (slot-value  child 'outq)) #|line 358|#))
                    (declare (ignorable mev))
                    (funcall (quote route)   container  child  mev  #|line 359|#)
                    (funcall (quote destroy_mevent)   mev   #|line 360|#)) #|line 361|#
                  ))                                        #|line 362|#
            ))                                              #|line 363|#
        ))                                                  #|line 364|#
  )
(defun attempt_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 366|#
  (cond
    ((not (equal  (slot-value  eh 'state)  "idle"))         #|line 367|#
      (funcall (quote force_tick)   parent  eh              #|line 368|#) #|line 369|#
      ))                                                    #|line 370|#
  )
(defun is_tick (&optional  mev)
  (declare (ignorable  mev))                                #|line 372|#
  (return-from is_tick ( equal    "." (slot-value  mev 'port))
    #|  assume that any mevent that is sent to port "." is a tick  |# #|line 373|#) #|line 374|#
  ) #|  Routes a single mevent to all matching destinations, according to |# #|line 376|# #|  the container's connection network. |# #|line 377|# #|line 378|#
(defun route (&optional  container  from_component  mevent)
  (declare (ignorable  container  from_component  mevent))  #|line 379|#
  (let (( was_sent  nil))
    (declare (ignorable  was_sent))
    #|  for checking that output went somewhere (at least during bootstrap) |# #|line 380|#
    (let (( fromname  ""))
      (declare (ignorable  fromname))                       #|line 381|# #|line 382|#
      (setf  ticktime (+  ticktime  1))                     #|line 383|#
      (cond
        ((funcall (quote is_tick)   mevent )                #|line 384|#
          (loop for child in (slot-value  container 'children)
            do
              (progn
                child                                       #|line 385|#
                (funcall (quote attempt_tick)   container  child ) #|line 386|#
                ))
          (setf  was_sent  t)                               #|line 387|#
          )
        (t                                                  #|line 388|#
          (cond
            ((not (funcall (quote is_self)   from_component  container )) #|line 389|#
              (setf  fromname (slot-value  from_component 'name)) #|line 390|# #|line 391|#
              ))
          (let ((from_sender (funcall (quote mkSender)   fromname  from_component (slot-value  mevent 'port)  #|line 392|#)))
            (declare (ignorable from_sender))               #|line 393|#
            (loop for connector in (slot-value  container 'connections)
              do
                (progn
                  connector                                 #|line 394|#
                  (cond
                    ((funcall (quote sender_eq)   from_sender (slot-value  connector 'sender) ) #|line 395|#
                      (funcall (quote deposit)   container  connector  mevent  #|line 396|#)
                      (setf  was_sent  t)                   #|line 397|# #|line 398|#
                      ))                                    #|line 399|#
                  )))                                       #|line 400|#
          ))
      (cond
        ((not  was_sent)                                    #|line 401|#
          (live_update  "Error"  (concatenate 'string (slot-value  container 'name)  (concatenate 'string  ": mevent '"  (concatenate 'string (slot-value  mevent 'port)  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))) #|line 402|# #|line 403|#
          ))))                                              #|line 404|#
  )
(defun any_child_ready (&optional  container)
  (declare (ignorable  container))                          #|line 406|#
  (loop for child in (slot-value  container 'children)
    do
      (progn
        child                                               #|line 407|#
        (cond
          ((funcall (quote child_is_ready)   child )        #|line 408|#
            (return-from any_child_ready  t)                #|line 409|# #|line 410|#
            ))                                              #|line 411|#
        ))
  (return-from any_child_ready  nil)                        #|line 412|# #|line 413|#
  )
(defun child_is_ready (&optional  eh)
  (declare (ignorable  eh))                                 #|line 415|#
  (return-from child_is_ready ( or  ( or  ( or  (not (empty? (slot-value  eh 'outq))) (not (empty? (slot-value  eh 'inq)))) (not (equal  (slot-value  eh 'state)  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 416|# #|line 417|#
  )
(defun append_routing_descriptor (&optional  container  desc)
  (declare (ignorable  container  desc))                    #|line 419|#
  (enqueue (slot-value  container 'routings)  desc)         #|line 420|# #|line 421|#
  )
(defun container_injector (&optional  container  mevent)
  (declare (ignorable  container  mevent))                  #|line 423|#
  (funcall (quote container_handler)   container  mevent    #|line 424|#) #|line 425|#
  )                                                         #|line 427|# #|line 428|# #|line 429|#
(defclass Component_Registry ()                             #|line 430|#
  (
    (templates :accessor templates :initarg :templates :initform  (dict-fresh))  #|line 431|#)) #|line 432|#

                                                            #|line 433|#
(defclass Template ()                                       #|line 434|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 435|#
    (template_data :accessor template_data :initarg :template_data :initform  nil)  #|line 436|#
    (instantiator :accessor instantiator :initarg :instantiator :initform  nil)  #|line 437|#)) #|line 438|#

                                                            #|line 439|#
(defun mkTemplate (&optional  name  template_data  instantiator)
  (declare (ignorable  name  template_data  instantiator))  #|line 440|#
  (let (( templ  (make-instance 'Template)                  #|line 441|#))
    (declare (ignorable  templ))
    (setf (slot-value  templ 'name)  name)                  #|line 442|#
    (setf (slot-value  templ 'template_data)  template_data) #|line 443|#
    (setf (slot-value  templ 'instantiator)  instantiator)  #|line 444|#
    (return-from mkTemplate  templ)                         #|line 445|#) #|line 446|#
  )
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 448|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (deep-expand (read f)))
                                                            #|line 449|# #|line 450|#
  )
(defun json2internal (&optional  pathname  container_xml)
  (declare (ignorable  pathname  container_xml))            #|line 452|#
  (let ((fname  container_xml                               #|line 453|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   pathname  fname  #|line 454|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                 #|line 455|#)) #|line 456|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                  #|line 458|#
  #| pass |#                                                #|line 459|# #|line 460|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 462|#
  (return-from make_component_registry  (make-instance 'Component_Registry) #|line 463|#) #|line 464|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template  nil )) #|line 466|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (funcall (quote abstracted_register_component)   reg  template  t )) #|line 467|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))     #|line 469|#
  (let ((name (funcall (quote mangle_name)  (slot-value  template 'name)  #|line 470|#)))
    (declare (ignorable name))
    (cond
      (( and  ( dict-in?  ( and  (not (equal   reg  nil))  name) (slot-value  reg 'templates)) (not  ok_to_overwrite)) #|line 471|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (slot-value  template 'name)  "/ already declared"))  #|line 472|#)
        (return-from abstracted_register_component  reg)    #|line 473|#
        )
      (t                                                    #|line 474|#
        (setf (gethash name (slot-value  reg 'templates))  template) #|line 475|#
        (return-from abstracted_register_component  reg)    #|line 476|# #|line 477|#
        )))                                                 #|line 478|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 480|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 481|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (slot-value  reg 'templates)) #|line 482|#
        (let ((template (gethash template_name (slot-value  reg 'templates))))
          (declare (ignorable template))                    #|line 483|#
          (cond
            (( equal    template  nil)                      #|line 484|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 485|#)
              (return-from get_component_instance  nil)     #|line 486|#
              )
            (t                                              #|line 487|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 488|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 489|#
                  (cond
                    ((not (equal   nil  owner))             #|line 490|#
                      (setf  owner_name (slot-value  owner 'name)) #|line 491|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "▹"  template_name)) #|line 492|#)
                      )
                    (t                                      #|line 493|#
                      (setf  instance_name  template_name)  #|line 494|# #|line 495|#
                      ))
                  (let ((instance (funcall (slot-value  template 'instantiator)   reg  owner  instance_name (slot-value  template 'template_data)  #|line 496|#)))
                    (declare (ignorable instance))
                    (return-from get_component_instance  instance) #|line 497|#))) #|line 498|#
              )))
        )
      (t                                                    #|line 499|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 500|#)
        (return-from get_component_instance  nil)           #|line 501|# #|line 502|#
        )))                                                 #|line 503|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 505|#
  (funcall (quote nl) )                                     #|line 506|#
  (format *standard-output* "~a~%"  "*** PALETTE ***")      #|line 507|#
  (loop for c in (slot-value  reg 'templates)
    do
      (progn
        c                                                   #|line 508|#
        (funcall (quote print)  (slot-value  c 'name) )     #|line 509|#
        ))
  (format *standard-output* "~a~%"  "***************")      #|line 510|#
  (funcall (quote nl) )                                     #|line 511|# #|line 512|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 514|#
  (format *standard-output* "~a~%"  (concatenate 'string  "registry statistics: " (slot-value  reg 'stats))) #|line 515|# #|line 516|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 518|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 519|#
  (return-from mangle_name  s)                              #|line 520|# #|line 521|#
  )                                                         #|line 523|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 524|# #|  and output queues of mevents. |# #|line 525|# #|  |# #|line 526|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 527|# #|  that routes mevents to child components according to a list of connections |# #|line 528|# #|  that serve as a mevent routing table. |# #|line 529|# #|  |# #|line 530|# #|  Child components themselves can be leaves or other containers. |# #|line 531|# #|  |# #|line 532|# #|  `handler` invokes the code that is attached to this component. |# #|line 533|# #|  |# #|line 534|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 535|# #|  function may want whenever it is invoked again. |# #|line 536|# #|  |# #|line 537|# #|line 538|# #|  Eh_States :: enum { idle, active } |# #|line 539|#
(defclass Eh ()                                             #|line 540|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 541|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 542|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 543|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 544|#
    (children :accessor children :initarg :children :initform  nil)  #|line 545|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 546|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 547|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 548|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 549|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 550|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 551|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 552|# #|  bootstrap debugging |# #|line 553|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 554|#)) #|line 555|#

                                                            #|line 556|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 557|# #|  whose handler function is `container_handler`. |# #|line 558|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 559|#
  (let (( eh  (make-instance 'Eh)                           #|line 560|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 561|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 562|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 563|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 564|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 565|#
    (setf (slot-value  eh 'kind)  "container")              #|line 566|#
    (return-from make_container  eh)                        #|line 567|#) #|line 568|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 570|# #|  that will be passed back to your handler when called. |# #|line 571|# #|line 572|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 573|#
  (let (( eh  (make-instance 'Eh)                           #|line 574|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "▹"  name)) #|line 575|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 576|#
    (setf (slot-value  eh 'handler)  handler)               #|line 577|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 578|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 579|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 580|#
    (return-from make_leaf  eh)                             #|line 581|#) #|line 582|#
  ) #|  Sends a mevent on the given `port` with `data`, placing it on the output |# #|line 584|# #|  of the given component. |# #|line 585|# #|line 586|#
(defun send (&optional  eh  port  datum  causingMevent)
  (declare (ignorable  eh  port  datum  causingMevent))     #|line 587|#
  (let ((mev (funcall (quote make_mevent)   port  datum     #|line 588|#)))
    (declare (ignorable mev))
    (funcall (quote put_output)   eh  mev                   #|line 589|#)) #|line 590|#
  )
(defun send_string (&optional  eh  port  s  causingMevent)
  (declare (ignorable  eh  port  s  causingMevent))         #|line 592|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 593|#)))
    (declare (ignorable datum))
    (let ((mev (funcall (quote make_mevent)   port  datum   #|line 594|#)))
      (declare (ignorable mev))
      (funcall (quote put_output)   eh  mev                 #|line 595|#))) #|line 596|#
  )
(defun forward (&optional  eh  port  mev)
  (declare (ignorable  eh  port  mev))                      #|line 598|#
  (let ((fwdmev (funcall (quote make_mevent)   port (slot-value  mev 'datum)  #|line 599|#)))
    (declare (ignorable fwdmev))
    (funcall (quote put_output)   eh  fwdmev                #|line 600|#)) #|line 601|#
  )
(defun inject (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 603|#
  (funcall (slot-value  eh 'finject)   eh  mev              #|line 604|#) #|line 605|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 607|#
  (setf (slot-value  eh 'state)  "active")                  #|line 608|# #|line 609|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 611|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 612|# #|line 613|#
  )
(defun put_output (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 615|#
  (enqueue (slot-value  eh 'outq)  mev)                     #|line 616|# #|line 617|#
  )
(defparameter  root_project  "")                            #|line 619|#
(defparameter  root_0D  "")                                 #|line 620|# #|line 621|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 622|# #|line 623|# #|line 624|#
  (setf  root_project  rproject)                            #|line 625|#
  (setf  root_0D  r0D)                                      #|line 626|# #|line 627|#
  )                                                         #|line 629|#
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 630|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 631|#
  (return-from string_make_persistent  s)                   #|line 632|# #|line 633|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 635|#
  (return-from string_clone  s)                             #|line 636|# #|line 637|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 639|# #|  where ${_00_} is the root directory for the project |# #|line 640|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 641|# #|line 642|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 643|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 644|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 645|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 646|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 647|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 648|#
                  (funcall (quote register_component)   reg (funcall (quote mkTemplate)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 649|#) #|line 650|#
                  )))                                       #|line 651|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 652|#)
    (return-from initialize_component_palette  reg)         #|line 653|#) #|line 654|#
  )                                                         #|line 656|#
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 657|#
  (return-from clone_string  s                              #|line 658|# #|line 659|#) #|line 660|#
  )
(defparameter  load_errors  nil)                            #|line 661|#
(defparameter  runtime_errors  nil)                         #|line 662|# #|line 663|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 664|# #|line 665|#
  (format *error-output* "~a~%"  s)                         #|line 666|#
  (format *error-output* "
  ")                                                        #|line 667|#
  (setf  load_errors  t)                                    #|line 668|# #|line 669|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 671|# #|line 672|#
  (format *error-output* "~a~%"  s)                         #|line 673|#
  (setf  runtime_errors  t)                                 #|line 674|# #|line 675|#
  )                                                         #|line 677|#
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 678|#
  (return-from argv
    (get-main-args)
                                                            #|line 679|#) #|line 680|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 682|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 683|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 684|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 685|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 686|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 687|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 688|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 689|#)))))) #|line 690|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))                       #|line 692|#
  (live_update  ""  "reset")                                #|line 693|#
  (live_update  "Live"  "begin...")                         #|line 694|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 695|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 696|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 697|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 698|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 699|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 700|#)
            #|  get entrypoint container |#                 #|line 701|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 702|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 703|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 707|#) #|line 708|#
                  ))
              (cond
                ((not  load_errors)                         #|line 709|#
                  (let (( marg (funcall (quote new_datum_string)   arg  #|line 710|#)))
                    (declare (ignorable  marg))
                    (let (( mev (funcall (quote make_mevent)   ""  marg  #|line 711|#)))
                      (declare (ignorable  mev))
                      (funcall (quote inject)   main_container  mev  #|line 712|#)
                      (queue-as-json-to-stdout (slot-value  main_container 'outq)) #|line 713|#)) #|line 714|#
                  ))
              (live_update  "Live"  "...end")               #|line 715|#)))))) #|line 716|#
  )                                                         #|line 718|# #|  utility functions  |# #|line 719|#
(defun send_int (&optional  eh  port  i  causing_mevent)
  (declare (ignorable  eh  port  i  causing_mevent))        #|line 720|#
  (let ((datum (funcall (quote new_datum_string)  (format nil "~a"  i)  #|line 721|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_mevent  #|line 722|#)) #|line 723|#
  )
(defun send_bang (&optional  eh  port  causing_mevent)
  (declare (ignorable  eh  port  causing_mevent))           #|line 725|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 726|#
    (funcall (quote send)   eh  port  datum  causing_mevent  #|line 727|#)) #|line 728|#
  )
 
#|   intentionally left empty  |#                         #|line 1|#
