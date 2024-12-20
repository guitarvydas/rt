
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
(defparameter  counter  0)                                  #|line 3|# #|line 4|#
(defparameter  digits (list                                 #|line 5|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" )) #|line 11|# #|line 12|# #|line 13|#
(defun gensymbol (&optional  s)
  (declare (ignorable  s))                                  #|line 14|# #|line 15|#
  (let ((name_with_id  (concatenate 'string  s (funcall (quote subscripted_digit)   counter )) #|line 16|#))
    (declare (ignorable name_with_id))
    (setf  counter (+  counter  1))                         #|line 17|#
    (return-from gensymbol  name_with_id)                   #|line 18|#) #|line 19|#
  )
(defun subscripted_digit (&optional  n)
  (declare (ignorable  n))                                  #|line 21|# #|line 22|#
  (cond
    (( and  ( >=   n  0) ( <=   n  29))                     #|line 23|#
      (return-from subscripted_digit (nth  n  digits))      #|line 24|#
      )
    (t                                                      #|line 25|#
      (return-from subscripted_digit  (concatenate 'string  "₊"  n) #|line 26|#) #|line 27|#
      ))                                                    #|line 28|#
  )
(defclass Datum ()                                          #|line 30|#
  (
    (v :accessor v :initarg :v :initform  nil)              #|line 31|#
    (clone :accessor clone :initarg :clone :initform  nil)  #|line 32|#
    (reclaim :accessor reclaim :initarg :reclaim :initform  nil)  #|line 33|#
    (other :accessor other :initarg :other :initform  nil)  #|  reserved for use on per-project basis  |# #|line 34|#)) #|line 35|#

                                                            #|line 36|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                  #|line 37|#
  (let ((d  (make-instance 'Datum)                          #|line 38|#))
    (declare (ignorable d))
    (setf (slot-value  d 'v)  s)                            #|line 39|#
    (setf (slot-value  d 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 40|#)))
    (setf (slot-value  d 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 41|#)))
    (return-from new_datum_string  d)                       #|line 42|#) #|line 43|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 45|#
  (let ((newd (funcall (quote new_datum_string)  (slot-value  d 'v)  #|line 46|#)))
    (declare (ignorable newd))
    (return-from clone_datum_string  newd)                  #|line 47|#) #|line 48|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 50|#
  #| pass |#                                                #|line 51|# #|line 52|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 54|#
  (let ((p  (make-instance 'Datum)                          #|line 55|#))
    (declare (ignorable p))
    (setf (slot-value  p 'v)  "")                           #|line 56|#
    (setf (slot-value  p 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 57|#)))
    (setf (slot-value  p 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 58|#)))
    (return-from new_datum_bang  p)                         #|line 59|#) #|line 60|#
  )
(defun clone_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 62|#
  (return-from clone_datum_bang (funcall (quote new_datum_bang) )) #|line 63|# #|line 64|#
  )
(defun reclaim_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 66|#
  #| pass |#                                                #|line 67|# #|line 68|#
  ) #|  Message passed to a leaf component. |#              #|line 70|# #|  |# #|line 71|# #|  `port` refers to the name of the incoming or outgoing port of this component. |# #|line 72|# #|  `datum` is the data attached to this message. |# #|line 73|#
(defclass Message ()                                        #|line 74|#
  (
    (port :accessor port :initarg :port :initform  nil)     #|line 75|#
    (datum :accessor datum :initarg :datum :initform  nil)  #|line 76|#)) #|line 77|#

                                                            #|line 78|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                  #|line 79|#
  (return-from clone_port (funcall (quote clone_string)   s  #|line 80|#)) #|line 81|#
  ) #|  Utility for making a `Message`. Used to safely “seed“ messages |# #|line 83|# #|  entering the very top of a network. |# #|line 84|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                        #|line 85|#
  (let ((p (funcall (quote clone_string)   port             #|line 86|#)))
    (declare (ignorable p))
    (let (( m  (make-instance 'Message)                     #|line 87|#))
      (declare (ignorable  m))
      (setf (slot-value  m 'port)  p)                       #|line 88|#
      (setf (slot-value  m 'datum) (funcall (slot-value  datum 'clone) )) #|line 89|#
      (return-from make_message  m)                         #|line 90|#)) #|line 91|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 93|#
(defun message_clone (&optional  msg)
  (declare (ignorable  msg))                                #|line 94|#
  (let (( m  (make-instance 'Message)                       #|line 95|#))
    (declare (ignorable  m))
    (setf (slot-value  m 'port) (funcall (quote clone_port)  (slot-value  msg 'port)  #|line 96|#))
    (setf (slot-value  m 'datum) (funcall (slot-value (slot-value  msg 'datum) 'clone) )) #|line 97|#
    (return-from message_clone  m)                          #|line 98|#) #|line 99|#
  ) #|  Frees a message. |#                                 #|line 101|#
(defun destroy_message (&optional  msg)
  (declare (ignorable  msg))                                #|line 102|#
  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |# #|line 103|#
  #| pass |#                                                #|line 104|# #|line 105|#
  )
(defun destroy_datum (&optional  msg)
  (declare (ignorable  msg))                                #|line 107|#
  #| pass |#                                                #|line 108|# #|line 109|#
  )
(defun destroy_port (&optional  msg)
  (declare (ignorable  msg))                                #|line 111|#
  #| pass |#                                                #|line 112|# #|line 113|#
  ) #|  |#                                                  #|line 115|#
(defun format_message (&optional  m)
  (declare (ignorable  m))                                  #|line 116|#
  (cond
    (( equal    m  nil)                                     #|line 117|#
      (return-from format_message  (concatenate 'string  "%5C“"  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  "%5C”:%5C“"  (concatenate 'string  "ϕ"  "%5C”,")))) #|line 118|#)
      )
    (t                                                      #|line 119|#
      (return-from format_message  (concatenate 'string  "%5C“"  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  "%5C”:%5C“"  (concatenate 'string (slot-value (slot-value  m 'datum) 'v)  "%5C”,")))) #|line 120|#) #|line 121|#
      ))                                                    #|line 122|#
  )
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 128|#
(defun create_down_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 129|#
  #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 130|#
  (let (( connector  (make-instance 'Connector)             #|line 131|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "down")       #|line 132|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 133|#))
    (let ((target_proto (gethash  "target"  proto_conn)))
      (declare (ignorable target_proto))                    #|line 134|#
      (let ((id_proto (gethash  "id"  target_proto)))
        (declare (ignorable id_proto))                      #|line 135|#
        (let ((target_component (gethash id_proto  children_by_id)))
          (declare (ignorable target_component))            #|line 136|#
          (cond
            (( equal    target_component  nil)              #|line 137|#
              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (gethash  "name" (gethash  "target"  proto_conn))) ) #|line 138|#
              )
            (t                                              #|line 139|#
              (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 140|#)) #|line 141|#
              ))
          (return-from create_down_connector  connector)    #|line 142|#)))) #|line 143|#
  )
(defun create_across_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 145|#
  (let (( connector  (make-instance 'Connector)             #|line 146|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "across")     #|line 147|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 148|#
      (let ((target_component (gethash (gethash  "id" (gethash  "target"  proto_conn))  children_by_id)))
        (declare (ignorable target_component))              #|line 149|#
        (cond
          (( equal    source_component  nil)                #|line 150|#
            (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (gethash  "name" (gethash  "source"  proto_conn)))  #|line 151|#)
            )
          (t                                                #|line 152|#
            (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 153|#))
            (cond
              (( equal    target_component  nil)            #|line 154|#
                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (gethash  "name" (gethash  "target"  proto_conn)))  #|line 155|#)
                )
              (t                                            #|line 156|#
                (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 157|#)) #|line 158|#
                ))                                          #|line 159|#
            ))
        (return-from create_across_connector  connector)    #|line 160|#))) #|line 161|#
  )
(defun create_up_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 163|#
  (let (( connector  (make-instance 'Connector)             #|line 164|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "up")         #|line 165|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 166|#
      (cond
        (( equal    source_component  nil)                  #|line 167|#
          (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (gethash  "name" (gethash  "source"  proto_conn))) ) #|line 168|#
          )
        (t                                                  #|line 169|#
          (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 170|#))
          (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 171|#)) #|line 172|#
          ))
      (return-from create_up_connector  connector)          #|line 173|#)) #|line 174|#
  )
(defun create_through_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 176|#
  (let (( connector  (make-instance 'Connector)             #|line 177|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "through")    #|line 178|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 179|#))
    (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 180|#))
    (return-from create_through_connector  connector)       #|line 181|#) #|line 182|#
  )                                                         #|line 184|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 185|# #|line 186|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 187|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 188|#
      (let ((children_by_id  (dict-fresh)))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 189|#
        #|  collect children |#                             #|line 190|#
        (loop for child_desc in (gethash  "children"  desc)
          do
            (progn
              child_desc                                    #|line 191|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (gethash  "name"  child_desc)  container  #|line 192|#)))
                (declare (ignorable child_instance))
                (setf  children (append  children (list  child_instance))) #|line 193|#
                (let ((id (gethash  "id"  child_desc)))
                  (declare (ignorable id))                  #|line 194|#
                  (setf (gethash id  children_by_id)  child_instance) #|line 195|# #|line 196|#)) #|line 197|#
              ))
        (setf (slot-value  container 'children)  children)  #|line 198|# #|line 199|#
        (let ((connectors  nil))
          (declare (ignorable connectors))                  #|line 200|#
          (loop for proto_conn in (gethash  "connections"  desc)
            do
              (progn
                proto_conn                                  #|line 201|#
                (let (( connector  (make-instance 'Connector) #|line 202|#))
                  (declare (ignorable  connector))
                  (cond
                    (( equal   (gethash  "dir"  proto_conn)  enumDown) #|line 203|#
                      (setf  connectors (append  connectors (list (funcall (quote create_down_connector)   container  proto_conn  connectors  children_by_id )))) #|line 204|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumAcross) #|line 205|#
                      (setf  connectors (append  connectors (list (funcall (quote create_across_connector)   container  proto_conn  connectors  children_by_id )))) #|line 206|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumUp) #|line 207|#
                      (setf  connectors (append  connectors (list (funcall (quote create_up_connector)   container  proto_conn  connectors  children_by_id )))) #|line 208|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumThrough) #|line 209|#
                      (setf  connectors (append  connectors (list (funcall (quote create_through_connector)   container  proto_conn  connectors  children_by_id )))) #|line 210|# #|line 211|#
                      )))                                   #|line 212|#
                ))
          (setf (slot-value  container 'connections)  connectors) #|line 213|#
          (return-from container_instantiator  container)   #|line 214|#)))) #|line 215|#
  ) #|  The default handler for container components. |#    #|line 217|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 218|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 219|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 220|#
        (funcall (quote step_children)   container  message ) #|line 221|#
        ))                                                  #|line 222|#
  ) #|  Frees the given container and associated data. |#   #|line 224|#
(defun destroy_container (&optional  eh)
  (declare (ignorable  eh))                                 #|line 225|#
  #| pass |#                                                #|line 226|# #|line 227|#
  ) #|  Routing connection for a container component. The `direction` field has |# #|line 229|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 230|# #|  purposes, or for reading by other tools. |# #|line 231|# #|line 232|#
(defclass Connector ()                                      #|line 233|#
  (
    (direction :accessor direction :initarg :direction :initform  nil)  #|  down, across, up, through |# #|line 234|#
    (sender :accessor sender :initarg :sender :initform  nil)  #|line 235|#
    (receiver :accessor receiver :initarg :receiver :initform  nil)  #|line 236|#)) #|line 237|#

                                                            #|line 238|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 239|# #|  based on component ID (pointer) and port name. |# #|line 240|# #|line 241|#
(defclass Sender ()                                         #|line 242|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 243|#
    (component :accessor component :initarg :component :initform  nil)  #|line 244|#
    (port :accessor port :initarg :port :initform  nil)     #|line 245|#)) #|line 246|#

                                                            #|line 247|# #|line 248|# #|line 249|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 250|# #|  to incoming messages to this queue. |# #|line 251|# #|line 252|#
(defclass Receiver ()                                       #|line 253|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 254|#
    (queue :accessor queue :initarg :queue :initform  nil)  #|line 255|#
    (port :accessor port :initarg :port :initform  nil)     #|line 256|#
    (component :accessor component :initarg :component :initform  nil)  #|line 257|#)) #|line 258|#

                                                            #|line 259|#
(defun mkSender (&optional  name  component  port)
  (declare (ignorable  name  component  port))              #|line 260|#
  (let (( s  (make-instance 'Sender)                        #|line 261|#))
    (declare (ignorable  s))
    (setf (slot-value  s 'name)  name)                      #|line 262|#
    (setf (slot-value  s 'component)  component)            #|line 263|#
    (setf (slot-value  s 'port)  port)                      #|line 264|#
    (return-from mkSender  s)                               #|line 265|#) #|line 266|#
  )
(defun mkReceiver (&optional  name  component  port  q)
  (declare (ignorable  name  component  port  q))           #|line 268|#
  (let (( r  (make-instance 'Receiver)                      #|line 269|#))
    (declare (ignorable  r))
    (setf (slot-value  r 'name)  name)                      #|line 270|#
    (setf (slot-value  r 'component)  component)            #|line 271|#
    (setf (slot-value  r 'port)  port)                      #|line 272|#
    #|  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. |# #|line 273|#
    (setf (slot-value  r 'queue)  q)                        #|line 274|#
    (return-from mkReceiver  r)                             #|line 275|#) #|line 276|#
  ) #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 278|#
(defun sender_eq (&optional  s1  s2)
  (declare (ignorable  s1  s2))                             #|line 279|#
  (let ((same_components ( equal   (slot-value  s1 'component) (slot-value  s2 'component))))
    (declare (ignorable same_components))                   #|line 280|#
    (let ((same_ports ( equal   (slot-value  s1 'port) (slot-value  s2 'port))))
      (declare (ignorable same_ports))                      #|line 281|#
      (return-from sender_eq ( and   same_components  same_ports)) #|line 282|#)) #|line 283|#
  ) #|  Delivers the given message to the receiver of this connector. |# #|line 285|# #|line 286|#
(defun deposit (&optional  parent  conn  message)
  (declare (ignorable  parent  conn  message))              #|line 287|#
  (let ((new_message (funcall (quote make_message)  (slot-value (slot-value  conn 'receiver) 'port) (slot-value  message 'datum)  #|line 288|#)))
    (declare (ignorable new_message))
    (funcall (quote push_message)   parent (slot-value (slot-value  conn 'receiver) 'component) (slot-value (slot-value  conn 'receiver) 'queue)  new_message  #|line 289|#)) #|line 290|#
  )
(defun force_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 292|#
  (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_bang) )  #|line 293|#)))
    (declare (ignorable tick_msg))
    (funcall (quote push_message)   parent  eh (slot-value  eh 'inq)  tick_msg  #|line 294|#)
    (return-from force_tick  tick_msg)                      #|line 295|#) #|line 296|#
  )
(defun push_message (&optional  parent  receiver  inq  m)
  (declare (ignorable  parent  receiver  inq  m))           #|line 298|#
  (enqueue  inq  m)                                         #|line 299|#
  (enqueue (slot-value  parent 'visit_ordering)  receiver)  #|line 300|# #|line 301|#
  )
(defun is_self (&optional  child  container)
  (declare (ignorable  child  container))                   #|line 303|#
  #|  in an earlier version “self“ was denoted as ϕ |#      #|line 304|#
  (return-from is_self ( equal    child  container))        #|line 305|# #|line 306|#
  )
(defun step_child (&optional  child  msg)
  (declare (ignorable  child  msg))                         #|line 308|#
  (let ((before_state (slot-value  child 'state)))
    (declare (ignorable before_state))                      #|line 309|#
    (funcall (slot-value  child 'handler)   child  msg      #|line 310|#)
    (let ((after_state (slot-value  child 'state)))
      (declare (ignorable after_state))                     #|line 311|#
      (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 312|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 313|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 314|#)) #|line 315|#
  )
(defun step_children (&optional  container  causingMessage)
  (declare (ignorable  container  causingMessage))          #|line 317|#
  (setf (slot-value  container 'state)  "idle")             #|line 318|#
  (loop for child in (queue2list (slot-value  container 'visit_ordering))
    do
      (progn
        child                                               #|line 319|#
        #|  child = container represents self, skip it |#   #|line 320|#
        (cond
          ((not (funcall (quote is_self)   child  container )) #|line 321|#
            (cond
              ((not (empty? (slot-value  child 'inq)))      #|line 322|#
                (let ((msg (dequeue (slot-value  child 'inq)) #|line 323|#))
                  (declare (ignorable msg))
                  (let (( began_long_run  nil))
                    (declare (ignorable  began_long_run))   #|line 324|#
                    (let (( continued_long_run  nil))
                      (declare (ignorable  continued_long_run)) #|line 325|#
                      (let (( ended_long_run  nil))
                        (declare (ignorable  ended_long_run)) #|line 326|#
                        (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 327|#))
                        (cond
                          ( began_long_run                  #|line 328|#
                            #| pass |#                      #|line 329|#
                            )
                          ( continued_long_run              #|line 330|#
                            #| pass |#                      #|line 331|#
                            )
                          ( ended_long_run                  #|line 332|#
                            #| pass |#                      #|line 333|# #|line 334|#
                            ))
                        (funcall (quote destroy_message)   msg  #|line 335|#)))))
                )
              (t                                            #|line 336|#
                (cond
                  ((not (equal  (slot-value  child 'state)  "idle")) #|line 337|#
                    (let ((msg (funcall (quote force_tick)   container  child  #|line 338|#)))
                      (declare (ignorable msg))
                      (funcall (slot-value  child 'handler)   child  msg  #|line 339|#)
                      (funcall (quote destroy_message)   msg  #|line 340|#)) #|line 341|#
                    ))                                      #|line 342|#
                ))                                          #|line 343|#
            (cond
              (( equal   (slot-value  child 'state)  "active") #|line 344|#
                #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 345|#
                (setf (slot-value  container 'state)  "active") #|line 346|# #|line 347|#
                ))                                          #|line 348|#
            (loop while (not (empty? (slot-value  child 'outq)))
              do
                (progn                                      #|line 349|#
                  (let ((msg (dequeue (slot-value  child 'outq)) #|line 350|#))
                    (declare (ignorable msg))
                    (funcall (quote route)   container  child  msg  #|line 351|#)
                    (funcall (quote destroy_message)   msg  #|line 352|#)) #|line 353|#
                  ))                                        #|line 354|#
            ))                                              #|line 355|#
        ))                                                  #|line 356|#
  )
(defun attempt_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 358|#
  (cond
    ((not (equal  (slot-value  eh 'state)  "idle"))         #|line 359|#
      (funcall (quote force_tick)   parent  eh              #|line 360|#) #|line 361|#
      ))                                                    #|line 362|#
  )
(defun is_tick (&optional  msg)
  (declare (ignorable  msg))                                #|line 364|#
  (return-from is_tick ( equal    "." (slot-value  msg 'port))
    #|  assume that any message that is sent to port "." is a tick  |# #|line 365|#) #|line 366|#
  ) #|  Routes a single message to all matching destinations, according to |# #|line 368|# #|  the container's connection network. |# #|line 369|# #|line 370|#
(defun route (&optional  container  from_component  message)
  (declare (ignorable  container  from_component  message)) #|line 371|#
  (let (( was_sent  nil))
    (declare (ignorable  was_sent))
    #|  for checking that output went somewhere (at least during bootstrap) |# #|line 372|#
    (let (( fromname  ""))
      (declare (ignorable  fromname))                       #|line 373|#
      (cond
        ((funcall (quote is_tick)   message )               #|line 374|#
          (loop for child in (slot-value  container 'children)
            do
              (progn
                child                                       #|line 375|#
                (funcall (quote attempt_tick)   container  child ) #|line 376|#
                ))
          (setf  was_sent  t)                               #|line 377|#
          )
        (t                                                  #|line 378|#
          (cond
            ((not (funcall (quote is_self)   from_component  container )) #|line 379|#
              (setf  fromname (slot-value  from_component 'name)) #|line 380|# #|line 381|#
              ))
          (let ((from_sender (funcall (quote mkSender)   fromname  from_component (slot-value  message 'port)  #|line 382|#)))
            (declare (ignorable from_sender))               #|line 383|#
            (loop for connector in (slot-value  container 'connections)
              do
                (progn
                  connector                                 #|line 384|#
                  (cond
                    ((funcall (quote sender_eq)   from_sender (slot-value  connector 'sender) ) #|line 385|#
                      (funcall (quote deposit)   container  connector  message  #|line 386|#)
                      (setf  was_sent  t)                   #|line 387|# #|line 388|#
                      ))                                    #|line 389|#
                  )))                                       #|line 390|#
          ))
      (cond
        ((not  was_sent)                                    #|line 391|#
          (funcall (quote print)   "\n\n*** Error: ***"     #|line 392|#)
          (funcall (quote print)   "***"                    #|line 393|#)
          (funcall (quote print)   (concatenate 'string (slot-value  container 'name)  (concatenate 'string  ": message '"  (concatenate 'string (slot-value  message 'port)  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 394|#)
          (funcall (quote print)   "***"                    #|line 395|#)
          (break)                                           #|line 396|# #|line 397|#
          ))))                                              #|line 398|#
  )
(defun any_child_ready (&optional  container)
  (declare (ignorable  container))                          #|line 400|#
  (loop for child in (slot-value  container 'children)
    do
      (progn
        child                                               #|line 401|#
        (cond
          ((funcall (quote child_is_ready)   child )        #|line 402|#
            (return-from any_child_ready  t)                #|line 403|# #|line 404|#
            ))                                              #|line 405|#
        ))
  (return-from any_child_ready  nil)                        #|line 406|# #|line 407|#
  )
(defun child_is_ready (&optional  eh)
  (declare (ignorable  eh))                                 #|line 409|#
  (return-from child_is_ready ( or  ( or  ( or  (not (empty? (slot-value  eh 'outq))) (not (empty? (slot-value  eh 'inq)))) (not (equal  (slot-value  eh 'state)  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 410|# #|line 411|#
  )
(defun append_routing_descriptor (&optional  container  desc)
  (declare (ignorable  container  desc))                    #|line 413|#
  (enqueue (slot-value  container 'routings)  desc)         #|line 414|# #|line 415|#
  )
(defun container_injector (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 417|#
  (funcall (quote container_handler)   container  message   #|line 418|#) #|line 419|#
  )






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
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 97|#
  #|  [ |#                                                  #|line 98|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 99|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 100|#
  #|  ] |#                                                  #|line 101|#
  (cond
    ((not (equal   nil  container_list))                    #|line 102|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 103|#
            #|  loop through every component in the diagram and look for names that start with “$“ or “'“  |# #|line 104|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 105|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 106|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 107|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 108|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 109|#
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  cmd  #'shell_out_instantiate  #|line 110|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 111|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 112|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 113|#
                        (let ((s  (subseq  name 1)          #|line 114|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  s  #'string_constant_instantiate  #|line 115|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 116|#)))) #|line 117|#
                      ))                                    #|line 118|#
                  ))                                        #|line 119|#
            ))                                              #|line 120|#
      ))
  (return-from generate_shell_components  reg)              #|line 121|# #|line 122|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 124|#
  (return-from first_char  (char  s 0)                      #|line 125|#) #|line 126|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 128|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 129|#))) #|line 130|#
  )                                                         #|line 132|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 133|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 134|# #|line 135|# #|line 136|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 137|# #|  and output queues of messages. |# #|line 138|# #|  |# #|line 139|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 140|# #|  that routes messages to child components according to a list of connections |# #|line 141|# #|  that serve as a message routing table. |# #|line 142|# #|  |# #|line 143|# #|  Child components themselves can be leaves or other containers. |# #|line 144|# #|  |# #|line 145|# #|  `handler` invokes the code that is attached to this component. |# #|line 146|# #|  |# #|line 147|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 148|# #|  function may want whenever it is invoked again. |# #|line 149|# #|  |# #|line 150|# #|line 151|# #|  Eh_States :: enum { idle, active } |# #|line 152|#
(defclass Eh ()                                             #|line 153|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 154|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 155|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 156|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 157|#
    (children :accessor children :initarg :children :initform  nil)  #|line 158|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 159|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 160|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 161|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 162|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 163|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 164|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 165|# #|  bootstrap debugging |# #|line 166|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 167|#)) #|line 168|#

                                                            #|line 169|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 170|# #|  whose handler function is `container_handler`. |# #|line 171|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 172|#
  (let (( eh  (make-instance 'Eh)                           #|line 173|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 174|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 175|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 176|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 177|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 178|#
    (setf (slot-value  eh 'kind)  "container")              #|line 179|#
    (return-from make_container  eh)                        #|line 180|#) #|line 181|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 183|# #|  that will be passed back to your handler when called. |# #|line 184|# #|line 185|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 186|#
  (let (( eh  (make-instance 'Eh)                           #|line 187|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "."  name)) #|line 188|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 189|#
    (setf (slot-value  eh 'handler)  handler)               #|line 190|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 191|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 192|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 193|#
    (return-from make_leaf  eh)                             #|line 194|#) #|line 195|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 197|# #|  of the given component. |# #|line 198|# #|line 199|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 200|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 201|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 202|#)) #|line 203|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 205|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 206|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 207|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 208|#))) #|line 209|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 211|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value  msg 'datum)  #|line 212|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 213|#)) #|line 214|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 216|#
  (funcall (slot-value  eh 'finject)   eh  msg              #|line 217|#) #|line 218|#
  ) #|  Returns a list of all output messages on a container. |# #|line 220|# #|  For testing / debugging purposes. |# #|line 221|# #|line 222|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 223|#
  (return-from output_list (slot-value  eh 'outq))          #|line 224|# #|line 225|#
  ) #|  Utility for printing an array of messages. |#       #|line 227|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 228|#
  (format *standard-output* "~a~%"  "{")                    #|line 229|#
  (loop for m in (queue2list (slot-value  eh 'outq))
    do
      (progn
        m                                                   #|line 230|#
        (format *standard-output* "~a~%" (funcall (quote format_message)   m )) #|line 231|# #|line 232|#
        ))
  (format *standard-output* "~a~%"  "}")                    #|line 233|# #|line 234|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 236|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 237|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 238|#
          (setf  s (+  s  " "))                             #|line 239|#
          ))
    (return-from spaces  s)                                 #|line 240|#) #|line 241|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 243|#
  (setf (slot-value  eh 'state)  "active")                  #|line 244|# #|line 245|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 247|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 248|# #|line 249|#
  ) #|  Utility for printing a specific output message. |#  #|line 251|# #|line 252|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 253|#
  (loop for msg in (queue2list (slot-value  eh 'outq))
    do
      (progn
        msg                                                 #|line 254|#
        (cond
          (( equal   (slot-value  msg 'port)  port)         #|line 255|#
            (return-from fetch_first_output (slot-value  msg 'datum))
            ))                                              #|line 256|#
        ))
  (return-from fetch_first_output  nil)                     #|line 257|# #|line 258|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 260|#
  #|  port ∷ “” |#                                          #|line 261|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 262|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a~%" (funcall (slot-value  datum 'srepr) )) #|line 263|#) #|line 264|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 265|#
  #|  port ∷ “” |#                                          #|line 266|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 267|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 268|#
    (format *error-output* "~a~%" (funcall (slot-value  datum 'srepr) )) #|line 269|#) #|line 270|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 272|#
  (enqueue (slot-value  eh 'outq)  msg)                     #|line 273|# #|line 274|#
  )
(defparameter  root_project  "")                            #|line 276|#
(defparameter  root_0D  "")                                 #|line 277|# #|line 278|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 279|# #|line 280|# #|line 281|#
  (setf  root_project  rproject)                            #|line 282|#
  (setf  root_0D  r0D)                                      #|line 283|# #|line 284|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 286|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 287|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 288|#))) #|line 289|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 291|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 292|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 293|#))) #|line 294|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 296|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 297|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 298|#))) #|line 299|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 301|#
  (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable s))                                 #|line 302|#
    (format *error-output* "~a~%"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "  s)))) #|line 303|#) #|line 304|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 306|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 307|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 308|#))) #|line 309|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 311|#
  #|  to appease dumped_on_floor checker |#                 #|line 312|#
  #| pass |#                                                #|line 313|# #|line 314|#
  )
(defclass TwoMessages ()                                    #|line 315|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  nil)  #|line 316|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  nil)  #|line 317|#)) #|line 318|#

                                                            #|line 319|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 320|#
(defclass Deracer_Instance_Data ()                          #|line 321|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 322|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 323|#)) #|line 324|#

                                                            #|line 325|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 326|#
  #| pass |#                                                #|line 327|# #|line 328|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 330|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 331|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 332|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 333|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMessages) #|line 334|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 335|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 336|#))) #|line 337|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 339|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmsg)  #|line 340|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmsg)  #|line 341|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 342|#) #|line 343|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 345|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 346|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 347|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 348|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 349|#
            (setf (slot-value  inst 'state)  "waitingForSecondmsg") #|line 350|#
            )
          (( equal    "2" (slot-value  msg 'port))          #|line 351|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 352|#
            (setf (slot-value  inst 'state)  "waitingForFirstmsg") #|line 353|#
            )
          (t                                                #|line 354|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value  msg 'port))  #|line 355|#) #|line 356|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmsg") #|line 357|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 358|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 359|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 360|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 361|#
            )
          (t                                                #|line 362|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value  msg 'port))  #|line 363|#) #|line 364|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmsg") #|line 365|#
        (cond
          (( equal    "2" (slot-value  msg 'port))          #|line 366|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 367|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 368|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 369|#
            )
          (t                                                #|line 370|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value  msg 'port))  #|line 371|#) #|line 372|#
            ))
        )
      (t                                                    #|line 373|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}"  #|line 374|#) #|line 375|#
        )))                                                 #|line 376|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 378|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 379|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 380|#))) #|line 381|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 383|#
  (let ((fname (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable fname))                             #|line 384|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 385|#) #|line 386|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 388|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 389|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 390|#))) #|line 391|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 393|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  msg 'datum) 'kind) )) #|line 394|#
      (funcall (quote forward)   eh  ""  msg                #|line 395|#)
      )
    (t                                                      #|line 396|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  msg 'datum)) #|line 397|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg   #|line 398|#)) #|line 399|#
      ))                                                    #|line 400|#
  )
(defclass Syncfilewrite_Data ()                             #|line 402|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 403|#)) #|line 404|#

                                                            #|line 405|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 406|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 407|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 408|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 409|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 410|#)))) #|line 411|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 413|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 414|#
    (cond
      (( equal    "filename" (slot-value  msg 'port))       #|line 415|#
        (setf (slot-value  inst 'filename) (funcall (slot-value (slot-value  msg 'datum) 'srepr) )) #|line 416|#
        )
      (( equal    "input" (slot-value  msg 'port))          #|line 417|#
        (let ((contents (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
          (declare (ignorable contents))                    #|line 418|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 419|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 420|#
                (funcall (slot-value  f 'write)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 421|#)
                (funcall (slot-value  f 'close) )           #|line 422|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg  #|line 423|#)
                )
              (t                                            #|line 424|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  msg  #|line 425|#) #|line 426|#
                ))))                                        #|line 427|#
        )))                                                 #|line 428|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 430|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 431|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 432|#
    (scount :accessor scount :initarg :scount :initform  0)  #|line 433|#)) #|line 434|#

                                                            #|line 435|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 436|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 437|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 438|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 439|#)))) #|line 440|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 442|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 443|#
    (cond
      (( equal    "1" (slot-value  msg 'port))              #|line 444|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 445|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 446|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg  #|line 447|#)
        )
      (( equal    "2" (slot-value  msg 'port))              #|line 448|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 449|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 450|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg  #|line 451|#)
        )
      (t                                                    #|line 452|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value  msg 'port))  #|line 453|#) #|line 454|#
        )))                                                 #|line 455|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 457|#
  (cond
    (( and  ( equal    0 (length (slot-value  inst 'buffer1))) ( equal    0 (length (slot-value  inst 'buffer2)))) #|line 458|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length"  #|line 459|#) #|line 460|#
      ))
  (cond
    (( >=  (slot-value  inst 'scount)  2)                   #|line 461|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 462|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 463|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 464|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 465|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 466|#
            )
          (t                                                #|line 467|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 468|# #|line 469|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 470|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 471|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 472|#
        (setf (slot-value  inst 'scount)  0))               #|line 473|#
      ))                                                    #|line 474|#
  ) #|  |#                                                  #|line 476|# #|line 477|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 478|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 479|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 480|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 481|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 482|#)))) #|line 483|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 485|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 486|#
    (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
      (declare (ignorable s))                               #|line 487|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 488|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 489|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 490|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 491|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 492|#
              (cond
                ((not (equal   rc  0))                      #|line 493|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 494|#)
                  )
                (t                                          #|line 495|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 496|#) #|line 497|#
                  ))))))))                                  #|line 498|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 500|# #|line 501|# #|line 502|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 503|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 504|#
      (cond
        ((not (equal   root_project  ""))                   #|line 505|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 506|#) #|line 507|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 508|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 509|#) #|line 510|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 511|#)))) #|line 512|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 514|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 515|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 516|#)) #|line 517|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 519|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 520|#
  (return-from string_make_persistent  s)                   #|line 521|# #|line 522|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 524|#
  (return-from string_clone  s)                             #|line 525|# #|line 526|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 528|# #|  where ${_00_} is the root directory for the project |# #|line 529|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 530|# #|line 531|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 532|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 533|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 534|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 535|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 536|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 537|#
                  (funcall (quote register_component)   reg (funcall (quote mkTemplate)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 538|#) #|line 539|#
                  )))                                       #|line 540|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 541|#)
    (return-from initialize_component_palette  reg)         #|line 542|#) #|line 543|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 545|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 546|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 547|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (slot-value  err 'srepr) ) )))) #|line 548|#
          (format *standard-output* "~a~%"  "___ !!! ERRORS !!! ___") #|line 549|#
          (funcall (quote print_specific_output)   main_container  error_port  #|line 550|#) #|line 551|#
          ))))                                              #|line 552|#
  ) #|  debugging helpers |#                                #|line 554|# #|line 555|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 556|#
  (format *standard-output* "~a~%"  "")                     #|line 557|# #|line 558|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 560|#
  (funcall (quote nl) )                                     #|line 561|#
  (format *standard-output* "~a~%"  "___ Outputs ___")      #|line 562|#
  (funcall (quote print_output_list)   main_container       #|line 563|#) #|line 564|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 566|#
  #|  remove whitespace from front and back of string |#    #|line 567|#
  (return-from trimws (funcall (slot-value  s 'strip) ))    #|line 568|# #|line 569|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 571|#
  (return-from clone_string  s                              #|line 572|# #|line 573|#) #|line 574|#
  )
(defparameter  load_errors  nil)                            #|line 575|#
(defparameter  runtime_errors  nil)                         #|line 576|# #|line 577|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 578|# #|line 579|#
  (format *standard-output* "~a~%"  s)                      #|line 580|#
  (format *standard-output* "
  ")                                                        #|line 581|#
  (setf  load_errors  t)                                    #|line 582|# #|line 583|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 585|# #|line 586|#
  (format *standard-output* "~a~%"  s)                      #|line 587|#
  (setf  runtime_errors  t)                                 #|line 588|# #|line 589|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 591|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 592|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 593|#))) #|line 594|#
  )
(defparameter  rand  0)                                     #|line 596|# #|line 597|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 598|# #|line 599|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 600|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 601|#) #|line 602|#
  )                                                         #|line 604|# #|  all of the the built_in leaves are listed here |# #|line 605|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 606|# #|line 607|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 608|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 609|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 610|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 611|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 612|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 613|#) #|line 614|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 615|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 616|#) #|line 617|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 618|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 619|#)
  #|  for fakepipe |#                                       #|line 620|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 621|#) #|line 622|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 624|#
  (return-from argv
    (get-main-args)
                                                            #|line 625|#) #|line 626|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 628|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 629|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 630|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 631|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 632|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 633|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 634|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 635|#)))))) #|line 636|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 638|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 639|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 640|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 641|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 642|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 643|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 644|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 645|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 646|#)
            #|  get entrypoint container |#                 #|line 647|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 648|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 649|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 653|#) #|line 654|#
                  ))
              (cond
                ((not  load_errors)                         #|line 655|#
                  (let (( marg (funcall (quote new_datum_string)   arg  #|line 656|#)))
                    (declare (ignorable  marg))
                    (let (( msg (funcall (quote make_message)   ""  marg  #|line 657|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 658|#)
                      (cond
                        ( show_all_outputs                  #|line 659|#
                          (funcall (quote dump_outputs)   main_container  #|line 660|#)
                          )
                        (t                                  #|line 661|#
                          (funcall (quote print_error_maybe)   main_container  #|line 662|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 663|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 664|#
                                (format *standard-output* "~a~%"  "(no outputs)") #|line 665|#
                                )
                              (t                            #|line 666|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 667|#) #|line 668|#
                                )))                         #|line 669|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 670|#
                          (format *standard-output* "~a~%"  "--- done ---") #|line 671|# #|line 672|#
                          ))))                              #|line 673|#
                  ))))))))                                  #|line 674|#
  )                                                         #|line 676|# #|line 677|# #|  utility functions  |# #|line 678|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 679|#
  (let ((datum (funcall (quote new_datum_string)  (format nil "~a"  i)  #|line 680|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 681|#)) #|line 682|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 684|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 685|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 686|#)) #|line 687|#
  )







(defparameter  count_counter  0)                            #|line 1|#
(defparameter  count_direction  1)                          #|line 2|# #|line 3|#
(defun count_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 4|# #|line 5|#
  (cond
    (( equal   (slot-value  msg 'port)  "adv")              #|line 6|#
      (setf  count_counter (+  count_counter  count_direction)) #|line 7|#
      (funcall (quote send_int)   eh  ""  count_counter  msg  #|line 8|#)
      )
    (( equal   (slot-value  msg 'port)  "rev")              #|line 9|#
      (setf  count_direction (-  count_direction)           #|line 10|#) #|line 11|#
      ))                                                    #|line 12|#
  )
(defun count_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 14|#
  (let ((name_with_id (funcall (quote gensymbol)   "Count"  #|line 15|#)))
    (declare (ignorable name_with_id))
    (return-from count_instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  #'count_handler  #|line 16|#))) #|line 17|#
  )
(defun count_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 19|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Count"  nil  #'count_instantiator )  #|line 20|#) #|line 21|#
  )







(defun decode_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Decode"  nil  #'decode_instantiator )  #|line 2|#) #|line 3|#
  )
(defun decode_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 5|# #|line 6|#
  (let ((s (slot-value (slot-value  msg 'datum) 'v)))
    (declare (ignorable s))                                 #|line 7|#
    (let (( i (parse-integer  s)                            #|line 8|#))
      (declare (ignorable  i))
      (cond
        (( and  ( >=   i  0) ( <=   i  9))                  #|line 9|#
          (funcall (quote send_string)   eh  s  s  msg      #|line 10|#) #|line 11|#
          ))
      (funcall (quote send_bang)   eh  "done"  msg          #|line 12|#))) #|line 13|#
  )
(defun decode_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 15|#
  (let ((name_with_id (funcall (quote gensymbol)   "Decode"  #|line 16|#)))
    (declare (ignorable name_with_id))
    (return-from decode_instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  #'decode_handler  #|line 17|#)))
  )







(defun reverser_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Reverser"  nil  #'reverser_instantiator )  #|line 2|#) #|line 3|#
  )
(defparameter  reverser_state  "J")                         #|line 5|# #|line 6|#
(defun reverser_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 7|# #|line 8|#
  (cond
    (( equal    reverser_state  "K")                        #|line 9|#
      (cond
        (( equal   (slot-value  msg 'port)  "J")            #|line 10|#
          (funcall (quote send_bang)   eh  ""  msg          #|line 11|#)
          (setf  reverser_state  "J")                       #|line 12|#
          )
        (t                                                  #|line 13|#
          #| pass |#                                        #|line 14|# #|line 15|#
          ))
      )
    (( equal    reverser_state  "J")                        #|line 16|#
      (cond
        (( equal   (slot-value  msg 'port)  "K")            #|line 17|#
          (funcall (quote send_bang)   eh  ""  msg          #|line 18|#)
          (setf  reverser_state  "K")                       #|line 19|#
          )
        (t                                                  #|line 20|#
          #| pass |#                                        #|line 21|# #|line 22|#
          ))                                                #|line 23|#
      ))                                                    #|line 24|#
  )
(defun reverser_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 26|#
  (let ((name_with_id (funcall (quote gensymbol)   "Reverser"  #|line 27|#)))
    (declare (ignorable name_with_id))
    (return-from reverser_instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  #'reverser_handler  #|line 28|#))) #|line 29|#
  )







(defun delay_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Delay"  nil  #'delay_instantiator )  #|line 2|#) #|line 3|#
  )
(defclass Delay_Info ()                                     #|line 5|#
  (
    (counter :accessor counter :initarg :counter :initform  0)  #|line 6|#
    (saved_message :accessor saved_message :initarg :saved_message :initform  nil)  #|line 7|#)) #|line 8|#

                                                            #|line 9|#
(defun delay_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 10|#
  (let ((name_with_id (funcall (quote gensymbol)   "delay"  #|line 11|#)))
    (declare (ignorable name_with_id))
    (let ((info  (make-instance 'Delay_Info)                #|line 12|#))
      (declare (ignorable info))
      (return-from delay_instantiator (funcall (quote make_leaf)   name_with_id  owner  info  #'delay_handler  #|line 13|#)))) #|line 14|#
  )
(defparameter  DELAYDELAY  5000)                            #|line 16|# #|line 17|#
(defun first_time (&optional  m)
  (declare (ignorable  m))                                  #|line 18|#
  (return-from first_time (not (funcall (quote is_tick)   m  #|line 19|#))) #|line 20|#
  )
(defun delay_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 22|#
  (let ((info (slot-value  eh 'instance_data)))
    (declare (ignorable info))                              #|line 23|#
    (cond
      ((funcall (quote first_time)   msg )                  #|line 24|#
        (setf (slot-value  info 'saved_message)  msg)       #|line 25|#
        (funcall (quote set_active)   eh )
        #|  tell engine to keep running this component with ;ticks'  |# #|line 26|# #|line 27|#
        ))                                                  #|line 28|#
    (let ((count (slot-value  info 'counter)))
      (declare (ignorable count))                           #|line 29|#
      (let (( next (+  count  1)))
        (declare (ignorable  next))                         #|line 30|#
        (cond
          (( >=  (slot-value  info 'counter)  DELAYDELAY)   #|line 31|#
            (funcall (quote set_idle)   eh )
            #|  tell engine that we're finally done  |#     #|line 32|#
            (funcall (quote forward)   eh  "" (slot-value  info 'saved_message)  #|line 33|#)
            (setf  next  0)                                 #|line 34|# #|line 35|#
            ))
        (setf (slot-value  info 'counter)  next)            #|line 36|#))) #|line 37|#
  )







(defun monitor_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "@"  nil  #'monitor_instantiator )  #|line 2|#) #|line 3|#
  )
(defun monitor_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 5|#
  (let ((name_with_id (funcall (quote gensymbol)   "@"      #|line 6|#)))
    (declare (ignorable name_with_id))
    (return-from monitor_instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  #'monitor_handler  #|line 7|#))) #|line 8|#
  )
(defun monitor_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 10|#
  (let (( s (slot-value (slot-value  msg 'datum) 'v)))
    (declare (ignorable  s))                                #|line 11|#
    (let (( i (parse-integer  s)                            #|line 12|#))
      (declare (ignorable  i))
      (loop while ( >   i  0)
        do
          (progn                                            #|line 13|#
            (setf  s  (concatenate 'string  " "  s)         #|line 14|#)
            (setf  i (-  i  1))                             #|line 15|# #|line 16|#
            ))
      (format *standard-output* "~a~%"  s)                  #|line 17|#)) #|line 18|#
  )





