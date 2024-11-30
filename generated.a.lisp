
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
(defun dict-fresh () nil)

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

(defmethod empty ((self Queue))
(null (contents self)))

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
    (data :accessor data :initarg :data :initform  nil)     #|line 31|#
    (clone :accessor clone :initarg :clone :initform  nil)  #|line 32|#
    (reclaim :accessor reclaim :initarg :reclaim :initform  nil)  #|line 33|#
    (srepr :accessor srepr :initarg :srepr :initform  nil)  #|line 34|#
    (kind :accessor kind :initarg :kind :initform  nil)     #|line 35|#
    (raw :accessor raw :initarg :raw :initform  nil)        #|line 36|#)) #|line 37|#

                                                            #|line 38|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                  #|line 39|#
  (let ((d  (make-instance 'Datum)                          #|line 40|#))
    (declare (ignorable d))
    (setf (slot-value 'data  d)  s)                         #|line 41|#
    (setf (slot-value 'clone  d)  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 42|#)))
    (setf (slot-value 'reclaim  d)  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 43|#)))
    (setf (slot-value 'srepr  d)  #'(lambda (&optional )(funcall (quote srepr_datum_string)   d  #|line 44|#)))
    (setf (slot-value 'raw  d) (coerce (slot-value 'data  d) 'simple-vector) #|line 45|#)
    (setf (slot-value 'kind  d)  #'(lambda (&optional ) "string")) #|line 46|#
    (return-from new_datum_string  d)                       #|line 47|#) #|line 48|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 50|#
  (let ((d (funcall (quote new_datum_string)  (slot-value 'data  d)  #|line 51|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                     #|line 52|#) #|line 53|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 55|#
  #| pass |#                                                #|line 56|# #|line 57|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 59|#
  (return-from srepr_datum_string (slot-value 'data  d))    #|line 60|# #|line 61|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 63|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 64|#
    (setf (slot-value 'data  p)  t)                         #|line 65|#
    (setf (slot-value 'clone  p)  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 66|#)))
    (setf (slot-value 'reclaim  p)  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 67|#)))
    (setf (slot-value 'srepr  p)  #'(lambda (&optional )(funcall (quote srepr_datum_bang) ))) #|line 68|#
    (setf (slot-value 'raw  p)  #'(lambda (&optional )(funcall (quote raw_datum_bang) ))) #|line 69|#
    (setf (slot-value 'kind  p)  #'(lambda (&optional ) "bang")) #|line 70|#
    (return-from new_datum_bang  p)                         #|line 71|#) #|line 72|#
  )
(defun clone_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 74|#
  (return-from clone_datum_bang (funcall (quote new_datum_bang) )) #|line 75|# #|line 76|#
  )
(defun reclaim_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 78|#
  #| pass |#                                                #|line 79|# #|line 80|#
  )
(defun srepr_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 82|#
  (return-from srepr_datum_bang  "!")                       #|line 83|# #|line 84|#
  )
(defun raw_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 86|#
  (return-from raw_datum_bang  nil)                         #|line 87|# #|line 88|#
  )
(defun new_datum_tick (&optional )
  (declare (ignorable ))                                    #|line 90|#
  (let ((p (funcall (quote new_datum_bang) )))
    (declare (ignorable p))                                 #|line 91|#
    (setf (slot-value 'kind  p)  #'(lambda (&optional ) "tick")) #|line 92|#
    (setf (slot-value 'clone  p)  #'(lambda (&optional )(funcall (quote new_datum_tick) ))) #|line 93|#
    (setf (slot-value 'srepr  p)  #'(lambda (&optional )(funcall (quote srepr_datum_tick) ))) #|line 94|#
    (setf (slot-value 'raw  p)  #'(lambda (&optional )(funcall (quote raw_datum_tick) ))) #|line 95|#
    (return-from new_datum_tick  p)                         #|line 96|#) #|line 97|#
  )
(defun srepr_datum_tick (&optional )
  (declare (ignorable ))                                    #|line 99|#
  (return-from srepr_datum_tick  ".")                       #|line 100|# #|line 101|#
  )
(defun raw_datum_tick (&optional )
  (declare (ignorable ))                                    #|line 103|#
  (return-from raw_datum_tick  nil)                         #|line 104|# #|line 105|#
  )
(defun new_datum_bytes (&optional  b)
  (declare (ignorable  b))                                  #|line 107|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 108|#
    (setf (slot-value 'data  p)  b)                         #|line 109|#
    (setf (slot-value 'clone  p)  #'(lambda (&optional )(funcall (quote clone_datum_bytes)   p  #|line 110|#)))
    (setf (slot-value 'reclaim  p)  #'(lambda (&optional )(funcall (quote reclaim_datum_bytes)   p  #|line 111|#)))
    (setf (slot-value 'srepr  p)  #'(lambda (&optional )(funcall (quote srepr_datum_bytes)   b  #|line 112|#)))
    (setf (slot-value 'raw  p)  #'(lambda (&optional )(funcall (quote raw_datum_bytes)   b  #|line 113|#)))
    (setf (slot-value 'kind  p)  #'(lambda (&optional ) "bytes")) #|line 114|#
    (return-from new_datum_bytes  p)                        #|line 115|#) #|line 116|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 118|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 119|#
    (setf (slot-value 'clone  p) (slot-value 'clone  src))  #|line 120|#
    (setf (slot-value 'reclaim  p) (slot-value 'reclaim  src)) #|line 121|#
    (setf (slot-value 'srepr  p) (slot-value 'srepr  src))  #|line 122|#
    (setf (slot-value 'raw  p) (slot-value 'raw  src))      #|line 123|#
    (setf (slot-value 'kind  p) (slot-value 'kind  src))    #|line 124|#
    (setf (slot-value 'data  p) (funcall (slot-value 'clone  src) )) #|line 125|#
    (return-from clone_datum_bytes  p)                      #|line 126|#) #|line 127|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 129|#
  #| pass |#                                                #|line 130|# #|line 131|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 133|#
  (return-from srepr_datum_bytes (funcall (slot-value 'decode (slot-value 'data  d))   "UTF_8"  #|line 134|#)) #|line 135|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 136|#
  (return-from raw_datum_bytes (slot-value 'data  d))       #|line 137|# #|line 138|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                  #|line 140|#
  (return-from new_datum_handle (funcall (quote new_datum_int)   h  #|line 141|#)) #|line 142|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 144|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 145|#
    (setf (slot-value 'data  p)  i)                         #|line 146|#
    (setf (slot-value 'clone  p)  #'(lambda (&optional )(funcall (quote clone_int)   i  #|line 147|#)))
    (setf (slot-value 'reclaim  p)  #'(lambda (&optional )(funcall (quote reclaim_int)   i  #|line 148|#)))
    (setf (slot-value 'srepr  p)  #'(lambda (&optional )(funcall (quote srepr_datum_int)   i  #|line 149|#)))
    (setf (slot-value 'raw  p)  #'(lambda (&optional )(funcall (quote raw_datum_int)   i  #|line 150|#)))
    (setf (slot-value 'kind  p)  #'(lambda (&optional ) "int")) #|line 151|#
    (return-from new_datum_int  p)                          #|line 152|#) #|line 153|#
  )
(defun clone_int (&optional  i)
  (declare (ignorable  i))                                  #|line 155|#
  (let ((p (funcall (quote new_datum_int)   i               #|line 156|#)))
    (declare (ignorable p))
    (return-from clone_int  p)                              #|line 157|#) #|line 158|#
  )
(defun reclaim_int (&optional  src)
  (declare (ignorable  src))                                #|line 160|#
  #| pass |#                                                #|line 161|# #|line 162|#
  )
(defun srepr_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 164|#
  (return-from srepr_datum_int (format nil "~a"  i)         #|line 165|#) #|line 166|#
  )
(defun raw_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 168|#
  (return-from raw_datum_int  i)                            #|line 169|# #|line 170|#
  ) #|  Message passed to a leaf component. |#              #|line 172|# #|  |# #|line 173|# #|  `port` refers to the name of the incoming or outgoing port of this component. |# #|line 174|# #|  `datum` is the data attached to this message. |# #|line 175|#
(defclass Message ()                                        #|line 176|#
  (
    (port :accessor port :initarg :port :initform  nil)     #|line 177|#
    (datum :accessor datum :initarg :datum :initform  nil)  #|line 178|#)) #|line 179|#

                                                            #|line 180|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                  #|line 181|#
  (return-from clone_port (funcall (quote clone_string)   s  #|line 182|#)) #|line 183|#
  ) #|  Utility for making a `Message`. Used to safely “seed“ messages |# #|line 185|# #|  entering the very top of a network. |# #|line 186|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                        #|line 187|#
  (let ((p (funcall (quote clone_string)   port             #|line 188|#)))
    (declare (ignorable p))
    (let (( m  (make-instance 'Message)                     #|line 189|#))
      (declare (ignorable  m))
      (setf (slot-value 'port  m)  p)                       #|line 190|#
      (setf (slot-value 'datum  m) (funcall (slot-value 'clone  datum) )) #|line 191|#
      (return-from make_message  m)                         #|line 192|#)) #|line 193|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 195|#
(defun message_clone (&optional  msg)
  (declare (ignorable  msg))                                #|line 196|#
  (let (( m  (make-instance 'Message)                       #|line 197|#))
    (declare (ignorable  m))
    (setf (slot-value 'port  m) (funcall (quote clone_port)  (slot-value 'port  msg)  #|line 198|#))
    (setf (slot-value 'datum  m) (funcall (slot-value 'clone (slot-value 'datum  msg)) )) #|line 199|#
    (return-from message_clone  m)                          #|line 200|#) #|line 201|#
  ) #|  Frees a message. |#                                 #|line 203|#
(defun destroy_message (&optional  msg)
  (declare (ignorable  msg))                                #|line 204|#
  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |# #|line 205|#
  #| pass |#                                                #|line 206|# #|line 207|#
  )
(defun destroy_datum (&optional  msg)
  (declare (ignorable  msg))                                #|line 209|#
  #| pass |#                                                #|line 210|# #|line 211|#
  )
(defun destroy_port (&optional  msg)
  (declare (ignorable  msg))                                #|line 213|#
  #| pass |#                                                #|line 214|# #|line 215|#
  ) #|  |#                                                  #|line 217|#
(defun format_message (&optional  m)
  (declare (ignorable  m))                                  #|line 218|#
  (cond
    (( equal    m  nil)                                     #|line 219|#
      (return-from format_message  "ϕ")                     #|line 220|#
      )
    (t                                                      #|line 221|#
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (slot-value 'port  m)  (concatenate 'string  "⦂"  (concatenate 'string (funcall (slot-value 'srepr (slot-value 'datum  m)) )  "⟫")))) #|line 225|#) #|line 226|#
      ))                                                    #|line 227|#
  )                                                         #|line 229|#
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 234|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 235|# #|line 236|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 237|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 238|#
      (let ((children_by_id  nil))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 239|#
        #|  collect children |#                             #|line 240|#
        (loop for child_desc in (gethash  "children"  desc)
          do
            (progn
              child_desc                                    #|line 241|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (gethash  "name"  child_desc)  container  #|line 242|#)))
                (declare (ignorable child_instance))
                (funcall (slot-value 'append  children)   child_instance  #|line 243|#)
                (let ((id (gethash  "id"  child_desc)))
                  (declare (ignorable id))                  #|line 244|#
                  (setf (gethash id  children_by_id)  child_instance) #|line 245|# #|line 246|#)) #|line 247|#
              ))
        (setf (slot-value 'children  container)  children)  #|line 248|#
        (let ((me  container))
          (declare (ignorable me))                          #|line 249|# #|line 250|#
          (let ((connectors  nil))
            (declare (ignorable connectors))                #|line 251|#
            (loop for proto_conn in (gethash  "connections"  desc)
              do
                (progn
                  proto_conn                                #|line 252|#
                  (let (( connector  (make-instance 'Connector) #|line 253|#))
                    (declare (ignorable  connector))
                    (cond
                      (( equal   (gethash  "dir"  proto_conn)  enumDown) #|line 254|#
                        #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 255|#
                        (setf (slot-value 'direction  connector)  "down") #|line 256|#
                        (setf (slot-value 'sender  connector) (funcall (quote Sender)  (slot-value 'name  me)  me (gethash  "source_port"  proto_conn)  #|line 257|#))
                        (let ((target_component (nth (gethash (gethash  "id"  "target")  proto_conn)  children_by_id)))
                          (declare (ignorable target_component)) #|line 258|#
                          (cond
                            (( equal    target_component  nil) #|line 259|#
                              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (gethash  "target"  proto_conn)) ) #|line 260|#
                              )
                            (t                              #|line 261|#
                              (setf (slot-value 'receiver  connector) (funcall (quote Receiver)  (slot-value 'name  target_component) (slot-value 'inq  target_component) (gethash  "target_port"  proto_conn)  target_component  #|line 262|#))
                              (funcall (slot-value 'append  connectors)   connector )
                              )))                           #|line 263|#
                        )
                      (( equal   (gethash  "dir"  proto_conn)  enumAcross) #|line 264|#
                        (setf (slot-value 'direction  connector)  "across") #|line 265|#
                        (let ((source_component (nth (gethash (gethash  "id"  "source")  proto_conn)  children_by_id)))
                          (declare (ignorable source_component)) #|line 266|#
                          (let ((target_component (nth (gethash (gethash  "id"  "target")  proto_conn)  children_by_id)))
                            (declare (ignorable target_component)) #|line 267|#
                            (cond
                              (( equal    source_component  nil) #|line 268|#
                                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (gethash  "source"  proto_conn)) ) #|line 269|#
                                )
                              (t                            #|line 270|#
                                (setf (slot-value 'sender  connector) (funcall (quote Sender)  (slot-value 'name  source_component)  source_component (gethash  "source_port"  proto_conn)  #|line 271|#))
                                (cond
                                  (( equal    target_component  nil) #|line 272|#
                                    (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (slot-value 'target  proto_conn)) ) #|line 273|#
                                    )
                                  (t                        #|line 274|#
                                    (setf (slot-value 'receiver  connector) (funcall (quote Receiver)  (slot-value 'name  target_component) (slot-value 'inq  target_component) (gethash  "target_port"  proto_conn)  target_component  #|line 275|#))
                                    (funcall (slot-value 'append  connectors)   connector )
                                    ))
                                ))))                        #|line 276|#
                        )
                      (( equal   (gethash  "dir"  proto_conn)  enumUp) #|line 277|#
                        (setf (slot-value 'direction  connector)  "up") #|line 278|#
                        (let ((source_component (nth (gethash (gethash  "id"  "source")  proto_conn)  children_by_id)))
                          (declare (ignorable source_component)) #|line 279|#
                          (cond
                            (( equal    source_component  nil) #|line 280|#
                              (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (gethash  "source"  proto_conn)) ) #|line 281|#
                              )
                            (t                              #|line 282|#
                              (setf (slot-value 'sender  connector) (funcall (quote Sender)  (slot-value 'name  source_component)  source_component (gethash  "source_port"  proto_conn)  #|line 283|#))
                              (setf (slot-value 'receiver  connector) (funcall (quote Receiver)  (slot-value 'name  me) (slot-value 'outq  container) (gethash  "target_port"  proto_conn)  me  #|line 284|#))
                              (funcall (slot-value 'append  connectors)   connector )
                              )))                           #|line 285|#
                        )
                      (( equal   (gethash  "dir"  proto_conn)  enumThrough) #|line 286|#
                        (setf (slot-value 'direction  connector)  "through") #|line 287|#
                        (setf (slot-value 'sender  connector) (funcall (quote Sender)  (slot-value 'name  me)  me (gethash  "source_port"  proto_conn)  #|line 288|#))
                        (setf (slot-value 'receiver  connector) (funcall (quote Receiver)  (slot-value 'name  me) (slot-value 'outq  container) (gethash  "target_port"  proto_conn)  me  #|line 289|#))
                        (funcall (slot-value 'append  connectors)   connector )
                        )))                                 #|line 290|#
                  ))                                        #|line 291|#
            (setf (slot-value 'connections  container)  connectors) #|line 292|#
            (return-from container_instantiator  container) #|line 293|#))))) #|line 294|#
  ) #|  The default handler for container components. |#    #|line 296|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 297|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 298|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 299|#
        (funcall (quote step_children)   container  message ) #|line 300|#
        ))                                                  #|line 301|#
    ) #|  Frees the given container and associated data. |# #|line 303|#
  (defun destroy_container (&optional  eh)
    (declare (ignorable  eh))                               #|line 304|#
    #| pass |#                                              #|line 305|# #|line 306|#
    )
  (defun fifo_is_empty (&optional  fifo)
    (declare (ignorable  fifo))                             #|line 308|#
    (return-from fifo_is_empty (funcall (slot-value 'empty  fifo) )) #|line 309|# #|line 310|#
    ) #|  Routing connection for a container component. The `direction` field has |# #|line 312|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 313|# #|  purposes, or for reading by other tools. |# #|line 314|# #|line 315|#
  (defclass Connector ()                                    #|line 316|#
    (
      (direction :accessor direction :initarg :direction :initform  nil)  #|  down, across, up, through |# #|line 317|#
      (sender :accessor sender :initarg :sender :initform  nil)  #|line 318|#
      (receiver :accessor receiver :initarg :receiver :initform  nil)  #|line 319|#)) #|line 320|#

                                                            #|line 321|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 322|# #|  based on component ID (pointer) and port name. |# #|line 323|# #|line 324|#
  (defclass Sender ()                                       #|line 325|#
    (
      (name :accessor name :initarg :name :initform  name)  #|line 326|#
      (component :accessor component :initarg :component :initform  component)  #|  from |# #|line 327|#
      (port :accessor port :initarg :port :initform  port)  #|  from's port |# #|line 328|#)) #|line 329|#

                                                            #|line 330|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 331|# #|  to incoming messages to this queue. |# #|line 332|# #|line 333|#
  (defclass Receiver ()                                     #|line 334|#
    (
      (name :accessor name :initarg :name :initform  name)  #|line 335|#
      (queue :accessor queue :initarg :queue :initform  queue)  #|  queue (input | output) of receiver |# #|line 336|#
      (port :accessor port :initarg :port :initform  port)  #|  destination port |# #|line 337|#
      (component :accessor component :initarg :component :initform  component)  #|  to (for bootstrap debug) |# #|line 338|#)) #|line 339|#

                                                            #|line 340|# #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 341|#
  (defun sender_eq (&optional  s1  s2)
    (declare (ignorable  s1  s2))                           #|line 342|#
    (let ((same_components ( equal   (slot-value 'component  s1) (slot-value 'component  s2))))
      (declare (ignorable same_components))                 #|line 343|#
      (let ((same_ports ( equal   (slot-value 'port  s1) (slot-value 'port  s2))))
        (declare (ignorable same_ports))                    #|line 344|#
        (return-from sender_eq ( and   same_components  same_ports)) #|line 345|#)) #|line 346|#
    ) #|  Delivers the given message to the receiver of this connector. |# #|line 348|# #|line 349|#
  (defun deposit (&optional  parent  conn  message)
    (declare (ignorable  parent  conn  message))            #|line 350|#
    (let ((new_message (funcall (quote make_message)  (slot-value 'port (slot-value 'receiver  conn)) (slot-value 'datum  message)  #|line 351|#)))
      (declare (ignorable new_message))
      (funcall (quote push_message)   parent (slot-value 'component (slot-value 'receiver  conn)) (slot-value 'queue (slot-value 'receiver  conn))  new_message  #|line 352|#)) #|line 353|#
    )
  (defun force_tick (&optional  parent  eh)
    (declare (ignorable  parent  eh))                       #|line 355|#
    (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 356|#)))
      (declare (ignorable tick_msg))
      (funcall (quote push_message)   parent  eh (slot-value 'inq  eh)  tick_msg  #|line 357|#)
      (return-from force_tick  tick_msg)                    #|line 358|#) #|line 359|#
    )
  (defun push_message (&optional  parent  receiver  inq  m)
    (declare (ignorable  parent  receiver  inq  m))         #|line 361|#
    (enqueue  inq  m)                                       #|line 362|#
    (funcall (slot-value 'put (slot-value 'visit_ordering  parent))   receiver  #|line 363|#) #|line 364|#
    )
  (defun is_self (&optional  child  container)
    (declare (ignorable  child  container))                 #|line 366|#
    #|  in an earlier version “self“ was denoted as ϕ |#    #|line 367|#
    (return-from is_self ( equal    child  container))      #|line 368|# #|line 369|#
    )
  (defun step_child (&optional  child  msg)
    (declare (ignorable  child  msg))                       #|line 371|#
    (let ((before_state (slot-value 'state  child)))
      (declare (ignorable before_state))                    #|line 372|#
      (funcall (slot-value 'handler  child)   child  msg    #|line 373|#)
      (let ((after_state (slot-value 'state  child)))
        (declare (ignorable after_state))                   #|line 374|#
        (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 375|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 376|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 377|#)) #|line 378|#
    )
  (defun save_message (&optional  eh  msg)
    (declare (ignorable  eh  msg))                          #|line 380|#
    (enqueue (slot-value 'saved_messages  eh)  msg)         #|line 381|# #|line 382|#
    )
  (defun fetch_saved_message_and_clear (&optional  eh)
    (declare (ignorable  eh))                               #|line 384|#
    (return-from fetch_saved_message_and_clear (dequeue (slot-value 'saved_messages  eh)) #|line 385|#) #|line 386|#
    )
  (defun step_children (&optional  container  causingMessage)
    (declare (ignorable  container  causingMessage))        #|line 388|#
    (setf (slot-value 'state  container)  "idle")           #|line 389|#
    (loop for child in (funcall (quote list)  (slot-value 'queue (slot-value 'visit_ordering  container)) )
      do
        (progn
          child                                             #|line 390|#
          #|  child = container represents self, skip it |# #|line 391|#
          (cond
            ((not (funcall (quote is_self)   child  container )) #|line 392|#
              (cond
                ((not (funcall (slot-value 'empty (slot-value 'inq  child)) )) #|line 393|#
                  (let ((msg (dequeue (slot-value 'inq  child)) #|line 394|#))
                    (declare (ignorable msg))
                    (let (( began_long_run  nil))
                      (declare (ignorable  began_long_run)) #|line 395|#
                      (let (( continued_long_run  nil))
                        (declare (ignorable  continued_long_run)) #|line 396|#
                        (let (( ended_long_run  nil))
                          (declare (ignorable  ended_long_run)) #|line 397|#
                          (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 398|#))
                          (cond
                            ( began_long_run                #|line 399|#
                              (funcall (quote save_message)   child  msg  #|line 400|#)
                              )
                            ( continued_long_run            #|line 401|#
                              #| pass |#                    #|line 402|# #|line 403|#
                              ))
                          (funcall (quote destroy_message)   msg ))))) #|line 404|#
                  )
                (t                                          #|line 405|#
                  (cond
                    ((not (equal  (slot-value 'state  child)  "idle")) #|line 406|#
                      (let ((msg (funcall (quote force_tick)   container  child  #|line 407|#)))
                        (declare (ignorable msg))
                        (funcall (slot-value 'handler  child)   child  msg  #|line 408|#)
                        (funcall (quote destroy_message)   msg ))
                      ))                                    #|line 409|#
                  ))                                        #|line 410|#
              (cond
                (( equal   (slot-value 'state  child)  "active") #|line 411|#
                  #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 412|#
                  (setf (slot-value 'state  container)  "active") #|line 413|#
                  ))                                        #|line 414|#
              (loop while (not (funcall (slot-value 'empty (slot-value 'outq  child)) ))
                do
                  (progn                                    #|line 415|#
                    (let ((msg (dequeue (slot-value 'outq  child)) #|line 416|#))
                      (declare (ignorable msg))
                      (funcall (quote route)   container  child  msg  #|line 417|#)
                      (funcall (quote destroy_message)   msg ))
                    ))
                ))                                          #|line 418|#
            ))                                              #|line 419|# #|line 420|# #|line 421|#
      )
    (defun attempt_tick (&optional  parent  eh)
      (declare (ignorable  parent  eh))                     #|line 423|#
      (cond
        ((not (equal  (slot-value 'state  eh)  "idle"))     #|line 424|#
          (funcall (quote force_tick)   parent  eh )        #|line 425|#
          ))                                                #|line 426|#
      )
    (defun is_tick (&optional  msg)
      (declare (ignorable  msg))                            #|line 428|#
      (return-from is_tick ( equal    "tick" (funcall (slot-value 'kind (slot-value 'datum  msg)) ))) #|line 429|# #|line 430|#
      ) #|  Routes a single message to all matching destinations, according to |# #|line 432|# #|  the container's connection network. |# #|line 433|# #|line 434|#
    (defun route (&optional  container  from_component  message)
      (declare (ignorable  container  from_component  message)) #|line 435|#
      (let (( was_sent  nil))
        (declare (ignorable  was_sent))
        #|  for checking that output went somewhere (at least during bootstrap) |# #|line 436|#
        (let (( fromname  ""))
          (declare (ignorable  fromname))                   #|line 437|#
          (cond
            ((funcall (quote is_tick)   message )           #|line 438|#
              (loop for child in (slot-value 'children  container)
                do
                  (progn
                    child                                   #|line 439|#
                    (funcall (quote attempt_tick)   container  child ) #|line 440|#
                    ))
              (setf  was_sent  t)                           #|line 441|#
              )
            (t                                              #|line 442|#
              (cond
                ((not (funcall (quote is_self)   from_component  container )) #|line 443|#
                  (setf  fromname (slot-value 'name  from_component)) #|line 444|#
                  ))
              (let ((from_sender (funcall (quote Sender)   fromname  from_component (slot-value 'port  message)  #|line 445|#)))
                (declare (ignorable from_sender))           #|line 446|#
                (loop for connector in (slot-value 'connections  container)
                  do
                    (progn
                      connector                             #|line 447|#
                      (cond
                        ((funcall (quote sender_eq)   from_sender (slot-value 'sender  connector) ) #|line 448|#
                          (funcall (quote deposit)   container  connector  message  #|line 449|#)
                          (setf  was_sent  t)
                          ))
                      )))                                   #|line 450|#
              ))
          (cond
            ((not  was_sent)                                #|line 451|#
              (funcall (quote print)   "\n\n*** Error: ***"  #|line 452|#)
              (funcall (quote print)   "***"                #|line 453|#)
              (funcall (quote print)   (concatenate 'string (slot-value 'name  container)  (concatenate 'string  ": message '"  (concatenate 'string (slot-value 'port  message)  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 454|#)
              (funcall (quote print)   "***"                #|line 455|#)
              (uiop:quit)                                   #|line 456|# #|line 457|#
              ))))                                          #|line 458|#
      )
    (defun any_child_ready (&optional  container)
      (declare (ignorable  container))                      #|line 460|#
      (loop for child in (slot-value 'children  container)
        do
          (progn
            child                                           #|line 461|#
            (cond
              ((funcall (quote child_is_ready)   child )    #|line 462|#
                (return-from any_child_ready  t)
                ))                                          #|line 463|#
            ))
      (return-from any_child_ready  nil)                    #|line 464|# #|line 465|#
      )
    (defun child_is_ready (&optional  eh)
      (declare (ignorable  eh))                             #|line 467|#
      (return-from child_is_ready ( or  ( or  ( or  (not (funcall (slot-value 'empty (slot-value 'outq  eh)) )) (not (funcall (slot-value 'empty (slot-value 'inq  eh)) ))) (not (equal  (slot-value 'state  eh)  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 468|# #|line 469|#
      )
    (defun append_routing_descriptor (&optional  container  desc)
      (declare (ignorable  container  desc))                #|line 471|#
      (enqueue (slot-value 'routings  container)  desc)     #|line 472|# #|line 473|#
      )
    (defun container_injector (&optional  container  message)
      (declare (ignorable  container  message))             #|line 475|#
      (funcall (quote container_handler)   container  message  #|line 476|#) #|line 477|#
      )





