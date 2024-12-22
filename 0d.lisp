
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
      (return-from format_message  (concatenate 'string  "‹"  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  "›:‹"  (concatenate 'string  "ϕ"  "›,")))) #|line 118|#)
      )
    (t                                                      #|line 119|#
      (return-from format_message  (concatenate 'string  "‹"  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  "›:‹"  (concatenate 'string (slot-value (slot-value  m 'datum) 'v)  "›,")))) #|line 120|#) #|line 121|#
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
          (funcall (quote load_error)   (concatenate 'string  "internal error: .Up connection source not ok " (gethash  "name" (gethash  "source"  proto_conn))) ) #|line 168|#
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
  )                                                         #|line 421|# #|line 422|# #|line 423|#
(defclass Component_Registry ()                             #|line 424|#
  (
    (templates :accessor templates :initarg :templates :initform  (dict-fresh))  #|line 425|#)) #|line 426|#

                                                            #|line 427|#
(defclass Template ()                                       #|line 428|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 429|#
    (template_data :accessor template_data :initarg :template_data :initform  nil)  #|line 430|#
    (instantiator :accessor instantiator :initarg :instantiator :initform  nil)  #|line 431|#)) #|line 432|#

                                                            #|line 433|#
(defun mkTemplate (&optional  name  template_data  instantiator)
  (declare (ignorable  name  template_data  instantiator))  #|line 434|#
  (let (( templ  (make-instance 'Template)                  #|line 435|#))
    (declare (ignorable  templ))
    (setf (slot-value  templ 'name)  name)                  #|line 436|#
    (setf (slot-value  templ 'template_data)  template_data) #|line 437|#
    (setf (slot-value  templ 'instantiator)  instantiator)  #|line 438|#
    (return-from mkTemplate  templ)                         #|line 439|#) #|line 440|#
  )
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 442|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (deep-expand (read f)))
                                                            #|line 443|# #|line 444|#
  )
(defun json2internal (&optional  pathname  container_xml)
  (declare (ignorable  pathname  container_xml))            #|line 446|#
  (let ((fname  container_xml                               #|line 447|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   pathname  fname  #|line 448|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                 #|line 449|#)) #|line 450|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                  #|line 452|#
  #| pass |#                                                #|line 453|# #|line 454|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 456|#
  (return-from make_component_registry  (make-instance 'Component_Registry) #|line 457|#) #|line 458|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template  nil )) #|line 460|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (funcall (quote abstracted_register_component)   reg  template  t )) #|line 461|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))     #|line 463|#
  (let ((name (funcall (quote mangle_name)  (slot-value  template 'name)  #|line 464|#)))
    (declare (ignorable name))
    (cond
      (( and  ( dict-in?  ( and  (not (equal   reg  nil))  name) (slot-value  reg 'templates)) (not  ok_to_overwrite)) #|line 465|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (slot-value  template 'name)  "/ already declared"))  #|line 466|#)
        (return-from abstracted_register_component  reg)    #|line 467|#
        )
      (t                                                    #|line 468|#
        (setf (gethash name (slot-value  reg 'templates))  template) #|line 469|#
        (return-from abstracted_register_component  reg)    #|line 470|# #|line 471|#
        )))                                                 #|line 472|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 474|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 475|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (slot-value  reg 'templates)) #|line 476|#
        (let ((template (gethash template_name (slot-value  reg 'templates))))
          (declare (ignorable template))                    #|line 477|#
          (cond
            (( equal    template  nil)                      #|line 478|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 479|#)
              (return-from get_component_instance  nil)     #|line 480|#
              )
            (t                                              #|line 481|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 482|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 483|#
                  (cond
                    ((not (equal   nil  owner))             #|line 484|#
                      (setf  owner_name (slot-value  owner 'name)) #|line 485|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name)) #|line 486|#)
                      )
                    (t                                      #|line 487|#
                      (setf  instance_name  template_name)  #|line 488|# #|line 489|#
                      ))
                  (let ((instance (funcall (slot-value  template 'instantiator)   reg  owner  instance_name (slot-value  template 'template_data)  #|line 490|#)))
                    (declare (ignorable instance))
                    (return-from get_component_instance  instance) #|line 491|#))) #|line 492|#
              )))
        )
      (t                                                    #|line 493|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 494|#)
        (return-from get_component_instance  nil)           #|line 495|# #|line 496|#
        )))                                                 #|line 497|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 499|#
  (funcall (quote nl) )                                     #|line 500|#
  (format *standard-output* "~a~%"  "*** PALETTE ***")      #|line 501|#
  (loop for c in (slot-value  reg 'templates)
    do
      (progn
        c                                                   #|line 502|#
        (funcall (quote print)  (slot-value  c 'name) )     #|line 503|#
        ))
  (format *standard-output* "~a~%"  "***************")      #|line 504|#
  (funcall (quote nl) )                                     #|line 505|# #|line 506|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 508|#
  (format *standard-output* "~a~%"  (concatenate 'string  "registry statistics: " (slot-value  reg 'stats))) #|line 509|# #|line 510|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 512|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 513|#
  (return-from mangle_name  s)                              #|line 514|# #|line 515|#
  )                                                         #|line 517|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 518|# #|  and output queues of messages. |# #|line 519|# #|  |# #|line 520|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 521|# #|  that routes messages to child components according to a list of connections |# #|line 522|# #|  that serve as a message routing table. |# #|line 523|# #|  |# #|line 524|# #|  Child components themselves can be leaves or other containers. |# #|line 525|# #|  |# #|line 526|# #|  `handler` invokes the code that is attached to this component. |# #|line 527|# #|  |# #|line 528|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 529|# #|  function may want whenever it is invoked again. |# #|line 530|# #|  |# #|line 531|# #|line 532|# #|  Eh_States :: enum { idle, active } |# #|line 533|#
(defclass Eh ()                                             #|line 534|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 535|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 536|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 537|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 538|#
    (children :accessor children :initarg :children :initform  nil)  #|line 539|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 540|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 541|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 542|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 543|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 544|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 545|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 546|# #|  bootstrap debugging |# #|line 547|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 548|#)) #|line 549|#

                                                            #|line 550|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 551|# #|  whose handler function is `container_handler`. |# #|line 552|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 553|#
  (let (( eh  (make-instance 'Eh)                           #|line 554|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 555|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 556|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 557|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 558|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 559|#
    (setf (slot-value  eh 'kind)  "container")              #|line 560|#
    (return-from make_container  eh)                        #|line 561|#) #|line 562|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 564|# #|  that will be passed back to your handler when called. |# #|line 565|# #|line 566|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 567|#
  (let (( eh  (make-instance 'Eh)                           #|line 568|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "."  name)) #|line 569|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 570|#
    (setf (slot-value  eh 'handler)  handler)               #|line 571|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 572|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 573|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 574|#
    (return-from make_leaf  eh)                             #|line 575|#) #|line 576|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 578|# #|  of the given component. |# #|line 579|# #|line 580|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 581|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 582|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 583|#)) #|line 584|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 586|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 587|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 588|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 589|#))) #|line 590|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 592|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value  msg 'datum)  #|line 593|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  fwdmsg                #|line 594|#)) #|line 595|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 597|#
  (funcall (slot-value  eh 'finject)   eh  msg              #|line 598|#) #|line 599|#
  ) #|  Returns a list of all output messages on a container. |# #|line 601|# #|  For testing / debugging purposes. |# #|line 602|# #|line 603|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 604|#
  (return-from output_list (slot-value  eh 'outq))          #|line 605|# #|line 606|#
  ) #|  Utility for printing an array of messages. |#       #|line 608|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 609|#
  (format *standard-output* "~a~%"  "{")                    #|line 610|#
  (loop for m in (queue2list (slot-value  eh 'outq))
    do
      (progn
        m                                                   #|line 611|#
        (format *standard-output* "~a~%" (funcall (quote format_message)   m )) #|line 612|# #|line 613|#
        ))
  (format *standard-output* "~a~%"  "}")                    #|line 614|# #|line 615|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 617|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 618|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 619|#
          (setf  s (+  s  " "))                             #|line 620|#
          ))
    (return-from spaces  s)                                 #|line 621|#) #|line 622|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 624|#
  (setf (slot-value  eh 'state)  "active")                  #|line 625|# #|line 626|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 628|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 629|# #|line 630|#
  ) #|  Utility for printing a specific output message. |#  #|line 632|# #|line 633|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 634|#
  (loop for msg in (queue2list (slot-value  eh 'outq))
    do
      (progn
        msg                                                 #|line 635|#
        (cond
          (( equal   (slot-value  msg 'port)  port)         #|line 636|#
            (return-from fetch_first_output (slot-value  msg 'datum))
            ))                                              #|line 637|#
        ))
  (return-from fetch_first_output  nil)                     #|line 638|# #|line 639|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 641|#
  #|  port ∷ “” |#                                          #|line 642|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 643|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a~%" (slot-value  datum 'v)) #|line 644|#) #|line 645|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 646|#
  #|  port ∷ “” |#                                          #|line 647|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 648|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 649|#
    (format *error-output* "~a~%" (slot-value  datum 'v))   #|line 650|#) #|line 651|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 653|#
  (enqueue (slot-value  eh 'outq)  msg)                     #|line 654|# #|line 655|#
  )
(defparameter  root_project  "")                            #|line 657|#
(defparameter  root_0D  "")                                 #|line 658|# #|line 659|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 660|# #|line 661|# #|line 662|#
  (setf  root_project  rproject)                            #|line 663|#
  (setf  root_0D  r0D)                                      #|line 664|# #|line 665|#
  )                                                         #|line 667|#
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 668|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 669|#
  (return-from string_make_persistent  s)                   #|line 670|# #|line 671|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 673|#
  (return-from string_clone  s)                             #|line 674|# #|line 675|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 677|# #|  where ${_00_} is the root directory for the project |# #|line 678|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 679|# #|line 680|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 681|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 682|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 683|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 684|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 685|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 686|#
                  (funcall (quote register_component)   reg (funcall (quote mkTemplate)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 687|#) #|line 688|#
                  )))                                       #|line 689|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 690|#)
    (return-from initialize_component_palette  reg)         #|line 691|#) #|line 692|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 694|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 695|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 696|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (slot-value  err 'v) )))) #|line 697|#
          (format *standard-output* "~a~%"  "___ !!! ERRORS !!! ___") #|line 698|#
          (funcall (quote print_specific_output)   main_container  error_port  #|line 699|#) #|line 700|#
          ))))                                              #|line 701|#
  ) #|  debugging helpers |#                                #|line 703|# #|line 704|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 705|#
  (format *standard-output* "~a~%"  "")                     #|line 706|# #|line 707|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 709|#
  (funcall (quote nl) )                                     #|line 710|#
  (format *standard-output* "~a~%"  "___ Outputs ___")      #|line 711|#
  (funcall (quote print_output_list)   main_container       #|line 712|#) #|line 713|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 715|#
  #|  remove whitespace from front and back of string |#    #|line 716|#
  (return-from trimws (funcall (slot-value  s 'strip) ))    #|line 717|# #|line 718|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 720|#
  (return-from clone_string  s                              #|line 721|# #|line 722|#) #|line 723|#
  )
(defparameter  load_errors  nil)                            #|line 724|#
(defparameter  runtime_errors  nil)                         #|line 725|# #|line 726|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 727|# #|line 728|#
  (format *standard-output* "~a~%"  s)                      #|line 729|#
  (format *standard-output* "
  ")                                                        #|line 730|#
  (setf  load_errors  t)                                    #|line 731|# #|line 732|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 734|# #|line 735|#
  (format *standard-output* "~a~%"  s)                      #|line 736|#
  (setf  runtime_errors  t)                                 #|line 737|# #|line 738|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 740|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 741|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 742|#))) #|line 743|#
  )
(defparameter  rand  0)                                     #|line 745|# #|line 746|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 747|# #|line 748|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 749|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 750|#) #|line 751|#
  )                                                         #|line 753|#
(defclass Switch1star_Instance_Data ()                      #|line 754|#
  (
    (state :accessor state :initarg :state :initform  "1")  #|line 755|#)) #|line 756|#

                                                            #|line 757|#
(defun switch1star_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 758|#
  (let ((name_with_id (funcall (quote gensymbol)   "switch1*"  #|line 759|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Switch1star_Instance_Data) #|line 760|#))
      (declare (ignorable instp))
      (return-from switch1star_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'switch1star_handler  #|line 761|#)))) #|line 762|#
  )
(defun switch1star_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 764|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 765|#
    (let ((whichOutput (slot-value  inst 'state)))
      (declare (ignorable whichOutput))                     #|line 766|#
      (cond
        (( equal    "" (slot-value  msg 'port))             #|line 767|#
          (cond
            (( equal    "1"  whichOutput)                   #|line 768|#
              (funcall (quote forward)   eh  "1"  msg       #|line 769|#)
              (setf (slot-value  inst 'state)  "*")         #|line 770|#
              )
            (( equal    "*"  whichOutput)                   #|line 771|#
              (funcall (quote forward)   eh  "*"  msg       #|line 772|#)
              )
            (t                                              #|line 773|#
              (funcall (quote send)   eh  "✗"  "internal error bad state in switch1*"  msg  #|line 774|#) #|line 775|#
              ))
          )
        (( equal    "reset" (slot-value  msg 'port))        #|line 776|#
          (setf (slot-value  inst 'state)  "1")             #|line 777|#
          )
        (t                                                  #|line 778|#
          (funcall (quote send)   eh  "✗"  "internal error bad message for switch1*"  msg  #|line 779|#) #|line 780|#
          ))))                                              #|line 781|#
  )
(defclass Latch_Instance_Data ()                            #|line 783|#
  (
    (datum :accessor datum :initarg :datum :initform  nil)  #|line 784|#)) #|line 785|#

                                                            #|line 786|#
(defun latch_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 787|#
  (let ((name_with_id (funcall (quote gensymbol)   "latch"  #|line 788|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Latch_Instance_Data)      #|line 789|#))
      (declare (ignorable instp))
      (return-from latch_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'latch_handler  #|line 790|#)))) #|line 791|#
  )
(defun latch_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 793|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 794|#
    (cond
      (( equal    "" (slot-value  msg 'port))               #|line 795|#
        (setf (slot-value  inst 'datum) (slot-value  msg 'datum)) #|line 796|#
        )
      (( equal    "release" (slot-value  msg 'port))        #|line 797|#
        (let (( d (slot-value  inst 'datum)))
          (declare (ignorable  d))                          #|line 798|#
          (funcall (quote send)   eh  ""  d  msg            #|line 799|#)
          (setf (slot-value  inst 'datum)  nil)             #|line 800|#)
        )
      (t                                                    #|line 801|#
        (funcall (quote send)   eh  "✗"  "internal error bad message for latch"  msg  #|line 802|#) #|line 803|#
        )))                                                 #|line 804|#
  ) #|  all of the the built_in leaves are listed here |#   #|line 806|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 807|# #|line 808|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 809|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 810|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 811|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 812|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 813|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 814|#) #|line 815|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 816|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 817|#) #|line 818|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 819|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 820|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "switch1*"  nil  #'switch1star_instantiate )  #|line 821|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "latch"  nil  #'latch_instantiate )  #|line 822|#)
  #|  for fakepipe |#                                       #|line 823|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 824|#) #|line 825|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 827|#
  (return-from argv
    (get-main-args)
                                                            #|line 828|#) #|line 829|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 831|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 832|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 833|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 834|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 835|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 836|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 837|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 838|#)))))) #|line 839|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 841|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 842|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 843|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 844|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 845|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 846|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 847|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 848|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 849|#)
            #|  get entrypoint container |#                 #|line 850|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 851|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 852|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 856|#) #|line 857|#
                  ))
              (cond
                ((not  load_errors)                         #|line 858|#
                  (let (( marg (funcall (quote new_datum_string)   arg  #|line 859|#)))
                    (declare (ignorable  marg))
                    (let (( msg (funcall (quote make_message)   ""  marg  #|line 860|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 861|#)
                      (cond
                        ( show_all_outputs                  #|line 862|#
                          (funcall (quote dump_outputs)   main_container  #|line 863|#)
                          )
                        (t                                  #|line 864|#
                          (funcall (quote print_error_maybe)   main_container  #|line 865|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  "" ⎩86



