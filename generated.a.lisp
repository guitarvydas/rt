
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
    (setf (slot-value  d 'data)  s)                         #|line 41|#
    (setf (slot-value  d 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 42|#)))
    (setf (slot-value  d 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 43|#)))
    (setf (slot-value  d 'srepr)  #'(lambda (&optional )(funcall (quote srepr_datum_string)   d  #|line 44|#)))
    (setf (slot-value  d 'raw) (coerce (slot-value  d 'data) 'simple-vector) #|line 45|#)
    (setf (slot-value  d 'kind)  #'(lambda (&optional ) "string")) #|line 46|#
    (return-from new_datum_string  d)                       #|line 47|#) #|line 48|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 50|#
  (let ((d (funcall (quote new_datum_string)  (slot-value  d 'data)  #|line 51|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                     #|line 52|#) #|line 53|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 55|#
  #| pass |#                                                #|line 56|# #|line 57|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 59|#
  (return-from srepr_datum_string (slot-value  d 'data))    #|line 60|# #|line 61|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 63|#
  (let ((p  (make-instance 'Datum)                          #|line 64|#))
    (declare (ignorable p))
    (setf (slot-value  p 'data)  t)                         #|line 65|#
    (setf (slot-value  p 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 66|#)))
    (setf (slot-value  p 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 67|#)))
    (setf (slot-value  p 'srepr)  #'(lambda (&optional )(funcall (quote srepr_datum_bang) ))) #|line 68|#
    (setf (slot-value  p 'raw)  #'(lambda (&optional )(funcall (quote raw_datum_bang) ))) #|line 69|#
    (setf (slot-value  p 'kind)  #'(lambda (&optional ) "bang")) #|line 70|#
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
    (setf (slot-value  p 'kind)  #'(lambda (&optional ) "tick")) #|line 92|#
    (setf (slot-value  p 'clone)  #'(lambda (&optional )(funcall (quote new_datum_tick) ))) #|line 93|#
    (setf (slot-value  p 'srepr)  #'(lambda (&optional )(funcall (quote srepr_datum_tick) ))) #|line 94|#
    (setf (slot-value  p 'raw)  #'(lambda (&optional )(funcall (quote raw_datum_tick) ))) #|line 95|#
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
  (let ((p  (make-instance 'Datum)                          #|line 108|#))
    (declare (ignorable p))
    (setf (slot-value  p 'data)  b)                         #|line 109|#
    (setf (slot-value  p 'clone)  #'(lambda (&optional )(funcall (quote clone_datum_bytes)   p  #|line 110|#)))
    (setf (slot-value  p 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_datum_bytes)   p  #|line 111|#)))
    (setf (slot-value  p 'srepr)  #'(lambda (&optional )(funcall (quote srepr_datum_bytes)   b  #|line 112|#)))
    (setf (slot-value  p 'raw)  #'(lambda (&optional )(funcall (quote raw_datum_bytes)   b  #|line 113|#)))
    (setf (slot-value  p 'kind)  #'(lambda (&optional ) "bytes")) #|line 114|#
    (return-from new_datum_bytes  p)                        #|line 115|#) #|line 116|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 118|#
  (let ((p  (make-instance 'Datum)                          #|line 119|#))
    (declare (ignorable p))
    (setf (slot-value  p 'clone) (slot-value  src 'clone))  #|line 120|#
    (setf (slot-value  p 'reclaim) (slot-value  src 'reclaim)) #|line 121|#
    (setf (slot-value  p 'srepr) (slot-value  src 'srepr))  #|line 122|#
    (setf (slot-value  p 'raw) (slot-value  src 'raw))      #|line 123|#
    (setf (slot-value  p 'kind) (slot-value  src 'kind))    #|line 124|#
    (setf (slot-value  p 'data) (funcall (slot-value  src 'clone) )) #|line 125|#
    (return-from clone_datum_bytes  p)                      #|line 126|#) #|line 127|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 129|#
  #| pass |#                                                #|line 130|# #|line 131|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 133|#
  (return-from srepr_datum_bytes (funcall (slot-value (slot-value  d 'data) 'decode)   "UTF_8"  #|line 134|#)) #|line 135|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 136|#
  (return-from raw_datum_bytes (slot-value  d 'data))       #|line 137|# #|line 138|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                  #|line 140|#
  (return-from new_datum_handle (funcall (quote new_datum_int)   h  #|line 141|#)) #|line 142|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 144|#
  (let ((p  (make-instance 'Datum)                          #|line 145|#))
    (declare (ignorable p))
    (setf (slot-value  p 'data)  i)                         #|line 146|#
    (setf (slot-value  p 'clone)  #'(lambda (&optional )(funcall (quote clone_int)   i  #|line 147|#)))
    (setf (slot-value  p 'reclaim)  #'(lambda (&optional )(funcall (quote reclaim_int)   i  #|line 148|#)))
    (setf (slot-value  p 'srepr)  #'(lambda (&optional )(funcall (quote srepr_datum_int)   i  #|line 149|#)))
    (setf (slot-value  p 'raw)  #'(lambda (&optional )(funcall (quote raw_datum_int)   i  #|line 150|#)))
    (setf (slot-value  p 'kind)  #'(lambda (&optional ) "int")) #|line 151|#
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
      (setf (slot-value  m 'port)  p)                       #|line 190|#
      (setf (slot-value  m 'datum) (funcall (slot-value  datum 'clone) )) #|line 191|#
      (return-from make_message  m)                         #|line 192|#)) #|line 193|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 195|#
(defun message_clone (&optional  msg)
  (declare (ignorable  msg))                                #|line 196|#
  (let (( m  (make-instance 'Message)                       #|line 197|#))
    (declare (ignorable  m))
    (setf (slot-value  m 'port) (funcall (quote clone_port)  (slot-value  msg 'port)  #|line 198|#))
    (setf (slot-value  m 'datum) (funcall (slot-value (slot-value  msg 'datum) 'clone) )) #|line 199|#
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
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  "⦂"  (concatenate 'string (funcall (slot-value (slot-value  m 'datum) 'srepr) )  "⟫")))) #|line 225|#) #|line 226|#
      ))                                                    #|line 227|#
  )                                                         #|line 229|#
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 234|#
(defun create_down_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 235|#
  #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 236|#
  (let (( connector  (make-instance 'Connector)             #|line 237|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "down")       #|line 238|#
    (setf (slot-value  connector 'sender) (funcall (quote create_Sender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 239|#))
    (let ((target_proto (gethash  "target"  proto_conn)))
      (declare (ignorable target_proto))                    #|line 240|#
      (let ((id_proto (gethash  "id"  target_proto)))
        (declare (ignorable id_proto))                      #|line 241|#
        (let ((target_component (gethash id_proto  children_by_id)))
          (declare (ignorable target_component))            #|line 242|#
          (cond
            (( equal    target_component  nil)              #|line 243|#
              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (gethash  "target"  proto_conn)) ) #|line 244|#
              )
            (t                                              #|line 245|#
              (setf (slot-value  connector 'receiver) (funcall (quote create_Receiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 246|#)) #|line 247|#
              ))
          (return-from create_down_connector  connector)    #|line 248|#)))) #|line 249|#
  )
(defun create_across_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 251|#
  (let (( connector  (make-instance 'Connector)             #|line 252|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "across")     #|line 253|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 254|#
      (let ((target_component (gethash (gethash  "id" (gethash  "target"  proto_conn))  children_by_id)))
        (declare (ignorable target_component))              #|line 255|#
        (cond
          (( equal    source_component  nil)                #|line 256|#
            (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (gethash  "source"  proto_conn))  #|line 257|#)
            )
          (t                                                #|line 258|#
            (setf (slot-value  connector 'sender) (funcall (quote create_Sender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 259|#))
            (cond
              (( equal    target_component  nil)            #|line 260|#
                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (slot-value  proto_conn 'target))  #|line 261|#)
                )
              (t                                            #|line 262|#
                (setf (slot-value  connector 'receiver) (funcall (quote create_Receiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 263|#)) #|line 264|#
                ))                                          #|line 265|#
            ))
        (return-from create_across_connector  connector)    #|line 266|#))) #|line 267|#
  )
(defun create_up_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 269|#
  (let (( connector  (make-instance 'Connector)             #|line 270|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "up")         #|line 271|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 272|#
      (cond
        (( equal    source_component  nil)                  #|line 273|#
          (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (gethash  "source"  proto_conn)) ) #|line 274|#
          )
        (t                                                  #|line 275|#
          (setf (slot-value  connector 'sender) (funcall (quote create_Sender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 276|#))
          (setf (slot-value  connector 'receiver) (funcall (quote create_Receiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 277|#)) #|line 278|#
          ))
      (return-from create_up_connector  connector)          #|line 279|#)) #|line 280|#
  )
(defun create_through_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 282|#
  (let (( connector  (make-instance 'Connector)             #|line 283|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "through")    #|line 284|#
    (setf (slot-value  connector 'sender) (funcall (quote create_Sender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 285|#))
    (setf (slot-value  connector 'receiver) (funcall (quote create_Receiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 286|#))
    (return-from create_through_connector  connector)       #|line 287|#) #|line 288|#
  )                                                         #|line 290|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 291|# #|line 292|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 293|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 294|#
      (let ((children_by_id  (dict-fresh)))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 295|#
        #|  collect children |#                             #|line 296|#
        (loop for child_desc in (gethash  "children"  desc)
          do
            (progn
              child_desc                                    #|line 297|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (gethash  "name"  child_desc)  container  #|line 298|#)))
                (declare (ignorable child_instance))
                (setf  children (append  children (list  child_instance))) #|line 299|#
                (let ((id (gethash  "id"  child_desc)))
                  (declare (ignorable id))                  #|line 300|#
                  (setf (gethash id  children_by_id)  child_instance) #|line 301|# #|line 302|#)) #|line 303|#
              ))
        (setf (slot-value  container 'children)  children)  #|line 304|# #|line 305|#
        (let ((connectors  nil))
          (declare (ignorable connectors))                  #|line 306|#
          (loop for proto_conn in (gethash  "connections"  desc)
            do
              (progn
                proto_conn                                  #|line 307|#
                (let (( connector  (make-instance 'Connector) #|line 308|#))
                  (declare (ignorable  connector))
                  (cond
                    (( equal   (gethash  "dir"  proto_conn)  enumDown) #|line 309|#
                      (setf  connectors (append  connectors (list (funcall (quote create_down_connector)   container  proto_conn  connectors  children_by_id )))) #|line 310|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumAcross) #|line 311|#
                      (setf  connectors (append  connectors (list (funcall (quote create_across_connector)   container  proto_conn  connectors  children_by_id )))) #|line 312|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumUp) #|line 313|#
                      (setf  connectors (append  connectors (list (funcall (quote create_up_connector)   container  proto_conn  connectors  children_by_id )))) #|line 314|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumThrough) #|line 315|#
                      (setf  connectors (append  connectors (list (funcall (quote create_through_connector)   container  proto_conn  connectors  children_by_id )))) #|line 316|# #|line 317|#
                      )))                                   #|line 318|#
                ))
          (setf (slot-value  container 'connections)  connectors) #|line 319|#
          (return-from container_instantiator  container)   #|line 320|#)))) #|line 321|#
  ) #|  The default handler for container components. |#    #|line 323|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 324|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 325|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 326|#
        (funcall (quote step_children)   container  message ) #|line 327|#
        ))                                                  #|line 328|#
  ) #|  Frees the given container and associated data. |#   #|line 330|#
(defun destroy_container (&optional  eh)
  (declare (ignorable  eh))                                 #|line 331|#
  #| pass |#                                                #|line 332|# #|line 333|#
  ) #|  Routing connection for a container component. The `direction` field has |# #|line 335|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 336|# #|  purposes, or for reading by other tools. |# #|line 337|# #|line 338|#
(defclass Connector ()                                      #|line 339|#
  (
    (direction :accessor direction :initarg :direction :initform  nil)  #|  down, across, up, through |# #|line 340|#
    (sender :accessor sender :initarg :sender :initform  nil)  #|line 341|#
    (receiver :accessor receiver :initarg :receiver :initform  nil)  #|line 342|#)) #|line 343|#

                                                            #|line 344|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 345|# #|  based on component ID (pointer) and port name. |# #|line 346|# #|line 347|#
(defclass Sender ()                                         #|line 348|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 349|#
    (component :accessor component :initarg :component :initform  nil)  #|line 350|#
    (port :accessor port :initarg :port :initform  nil)     #|line 351|#)) #|line 352|#

                                                            #|line 353|# #|line 354|# #|line 355|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 356|# #|  to incoming messages to this queue. |# #|line 357|# #|line 358|#
(defclass Receiver ()                                       #|line 359|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 360|#
    (queue :accessor queue :initarg :queue :initform  nil)  #|line 361|#
    (port :accessor port :initarg :port :initform  nil)     #|line 362|#
    (component :accessor component :initarg :component :initform  nil)  #|line 363|#)) #|line 364|#

                                                            #|line 365|#
(defun create_Sender (&optional  name  component  port)
  (declare (ignorable  name  component  port))              #|line 366|#
  (let (( s  (make-instance 'Sender)                        #|line 367|#))
    (declare (ignorable  s))
    (setf (slot-value  s 'name)  name)                      #|line 368|#
    (setf (slot-value  s 'component)  component)            #|line 369|#
    (setf (slot-value  s 'port)  port)                      #|line 370|#
    (return-from create_Sender  s)                          #|line 371|#) #|line 372|#
  )
(defun create_Receiver (&optional  name  component  port  q)
  (declare (ignorable  name  component  port  q))           #|line 374|#
  (let (( r  (make-instance 'Receiver)                      #|line 375|#))
    (declare (ignorable  r))
    (setf (slot-value  r 'name)  name)                      #|line 376|#
    (setf (slot-value  r 'component)  component)            #|line 377|#
    (setf (slot-value  r 'port)  port)                      #|line 378|#
    #|  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. |# #|line 379|#
    (setf (slot-value  r 'queue)  q)                        #|line 380|#
    (return-from create_Receiver  r)                        #|line 381|#) #|line 382|#
  ) #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 384|#
(defun sender_eq (&optional  s1  s2)
  (declare (ignorable  s1  s2))                             #|line 385|#
  (let ((same_components ( equal   (slot-value  s1 'component) (slot-value  s2 'component))))
    (declare (ignorable same_components))                   #|line 386|#
    (let ((same_ports ( equal   (slot-value  s1 'port) (slot-value  s2 'port))))
      (declare (ignorable same_ports))                      #|line 387|#
      (return-from sender_eq ( and   same_components  same_ports)) #|line 388|#)) #|line 389|#
  ) #|  Delivers the given message to the receiver of this connector. |# #|line 391|# #|line 392|#
(defun deposit (&optional  parent  conn  message)
  (declare (ignorable  parent  conn  message))              #|line 393|#
  (let ((new_message (funcall (quote make_message)  (slot-value (slot-value  conn 'receiver) 'port) (slot-value  message 'datum)  #|line 394|#)))
    (declare (ignorable new_message))
    (funcall (quote push_message)   parent (slot-value (slot-value  conn 'receiver) 'component) (slot-value (slot-value  conn 'receiver) 'queue)  new_message  #|line 395|#)) #|line 396|#
  )
(defun force_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 398|#
  (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 399|#)))
    (declare (ignorable tick_msg))
    (funcall (quote push_message)   parent  eh (slot-value  eh 'inq)  tick_msg  #|line 400|#)
    (return-from force_tick  tick_msg)                      #|line 401|#) #|line 402|#
  )
(defun push_message (&optional  parent  receiver  inq  m)
  (declare (ignorable  parent  receiver  inq  m))           #|line 404|#
  (enqueue  inq  m)                                         #|line 405|#
  (enqueue (slot-value  parent 'visit_ordering)  receiver)  #|line 406|# #|line 407|#
  )
(defun is_self (&optional  child  container)
  (declare (ignorable  child  container))                   #|line 409|#
  #|  in an earlier version “self“ was denoted as ϕ |#      #|line 410|#
  (return-from is_self ( equal    child  container))        #|line 411|# #|line 412|#
  )
(defun step_child (&optional  child  msg)
  (declare (ignorable  child  msg))                         #|line 414|#
  (let ((before_state (slot-value  child 'state)))
    (declare (ignorable before_state))                      #|line 415|#
    (funcall (slot-value  child 'handler)   child  msg      #|line 416|#)
    (let ((after_state (slot-value  child 'state)))
      (declare (ignorable after_state))                     #|line 417|#
      (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 418|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 419|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 420|#)) #|line 421|#
  )
(defun step_children (&optional  container  causingMessage)
  (declare (ignorable  container  causingMessage))          #|line 423|#
  (setf (slot-value  container 'state)  "idle")             #|line 424|#
  (loop for child in (queue2list (slot-value  container 'visit_ordering))
    do
      (progn
        child                                               #|line 425|#
        #|  child = container represents self, skip it |#   #|line 426|#
        (cond
          ((not (funcall (quote is_self)   child  container )) #|line 427|#
            (cond
              ((not (empty? (slot-value  child 'inq)))      #|line 428|#
                (let ((msg (dequeue (slot-value  child 'inq)) #|line 429|#))
                  (declare (ignorable msg))
                  (let (( began_long_run  nil))
                    (declare (ignorable  began_long_run))   #|line 430|#
                    (let (( continued_long_run  nil))
                      (declare (ignorable  continued_long_run)) #|line 431|#
                      (let (( ended_long_run  nil))
                        (declare (ignorable  ended_long_run)) #|line 432|#
                        (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 433|#))
                        (cond
                          ( began_long_run                  #|line 434|#
                            #| pass |#                      #|line 435|#
                            )
                          ( continued_long_run              #|line 436|#
                            #| pass |#                      #|line 437|#
                            )
                          ( ended_long_run                  #|line 438|#
                            #| pass |#                      #|line 439|# #|line 440|#
                            ))
                        (funcall (quote destroy_message)   msg ))))) #|line 441|#
                )
              (t                                            #|line 442|#
                (cond
                  ((not (equal  (slot-value  child 'state)  "idle")) #|line 443|#
                    (let ((msg (funcall (quote force_tick)   container  child  #|line 444|#)))
                      (declare (ignorable msg))
                      (funcall (slot-value  child 'handler)   child  msg  #|line 445|#)
                      (funcall (quote destroy_message)   msg ))
                    ))                                      #|line 446|#
                ))                                          #|line 447|#
            (cond
              (( equal   (slot-value  child 'state)  "active") #|line 448|#
                #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 449|#
                (setf (slot-value  container 'state)  "active") #|line 450|#
                ))                                          #|line 451|#
            (loop while (not (empty? (slot-value  child 'outq)))
              do
                (progn                                      #|line 452|#
                  (let ((msg (dequeue (slot-value  child 'outq)) #|line 453|#))
                    (declare (ignorable msg))
                    (funcall (quote route)   container  child  msg  #|line 454|#)
                    (funcall (quote destroy_message)   msg ))
                  ))
            ))                                              #|line 455|#
        ))                                                  #|line 456|# #|line 457|# #|line 458|#
  )
(defun attempt_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 460|#
  (cond
    ((not (equal  (slot-value  eh 'state)  "idle"))         #|line 461|#
      (funcall (quote force_tick)   parent  eh )            #|line 462|#
      ))                                                    #|line 463|#
  )
(defun is_tick (&optional  msg)
  (declare (ignorable  msg))                                #|line 465|#
  (return-from is_tick ( equal    "tick" (funcall (slot-value (slot-value  msg 'datum) 'kind) ))) #|line 466|# #|line 467|#
  ) #|  Routes a single message to all matching destinations, according to |# #|line 469|# #|  the container's connection network. |# #|line 470|# #|line 471|#
(defun route (&optional  container  from_component  message)
  (declare (ignorable  container  from_component  message)) #|line 472|#
  (let (( was_sent  nil))
    (declare (ignorable  was_sent))
    #|  for checking that output went somewhere (at least during bootstrap) |# #|line 473|#
    (let (( fromname  ""))
      (declare (ignorable  fromname))                       #|line 474|#
      (cond
        ((funcall (quote is_tick)   message )               #|line 475|#
          (loop for child in (slot-value  container 'children)
            do
              (progn
                child                                       #|line 476|#
                (funcall (quote attempt_tick)   container  child ) #|line 477|#
                ))
          (setf  was_sent  t)                               #|line 478|#
          )
        (t                                                  #|line 479|#
          (cond
            ((not (funcall (quote is_self)   from_component  container )) #|line 480|#
              (setf  fromname (slot-value  from_component 'name)) #|line 481|#
              ))
          (let ((from_sender (funcall (quote create_Sender)   fromname  from_component (slot-value  message 'port)  #|line 482|#)))
            (declare (ignorable from_sender))               #|line 483|#
            (loop for connector in (slot-value  container 'connections)
              do
                (progn
                  connector                                 #|line 484|#
                  (cond
                    ((funcall (quote sender_eq)   from_sender (slot-value  connector 'sender) ) #|line 485|#
                      (funcall (quote deposit)   container  connector  message  #|line 486|#)
                      (setf  was_sent  t)
                      ))
                  )))                                       #|line 487|#
          ))
      (cond
        ((not  was_sent)                                    #|line 488|#
          (funcall (quote print)   "\n\n*** Error: ***"     #|line 489|#)
          (funcall (quote print)   "***"                    #|line 490|#)
          (funcall (quote print)   (concatenate 'string (slot-value  container 'name)  (concatenate 'string  ": message '"  (concatenate 'string (slot-value  message 'port)  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 491|#)
          (funcall (quote print)   "***"                    #|line 492|#)
          (break)                                           #|line 493|# #|line 494|#
          ))))                                              #|line 495|#
  )
(defun any_child_ready (&optional  container)
  (declare (ignorable  container))                          #|line 497|#
  (loop for child in (slot-value  container 'children)
    do
      (progn
        child                                               #|line 498|#
        (cond
          ((funcall (quote child_is_ready)   child )        #|line 499|#
            (return-from any_child_ready  t)
            ))                                              #|line 500|#
        ))
  (return-from any_child_ready  nil)                        #|line 501|# #|line 502|#
  )
(defun child_is_ready (&optional  eh)
  (declare (ignorable  eh))                                 #|line 504|#
  (return-from child_is_ready ( or  ( or  ( or  (not (empty? (slot-value  eh 'outq))) (not (empty? (slot-value  eh 'inq)))) (not (equal  (slot-value  eh 'state)  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 505|# #|line 506|#
  )
(defun append_routing_descriptor (&optional  container  desc)
  (declare (ignorable  container  desc))                    #|line 508|#
  (enqueue (slot-value  container 'routings)  desc)         #|line 509|# #|line 510|#
  )
(defun container_injector (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 512|#
  (funcall (quote container_handler)   container  message   #|line 513|#) #|line 514|#
  )





