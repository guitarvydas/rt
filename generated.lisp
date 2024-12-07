
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
  (let ((newd (funcall (quote new_datum_string)  (slot-value  d 'data)  #|line 51|#)))
    (declare (ignorable newd))
    (return-from clone_datum_string  newd)                  #|line 52|#) #|line 53|#
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
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 239|#))
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
              (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 246|#)) #|line 247|#
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
            (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 259|#))
            (cond
              (( equal    target_component  nil)            #|line 260|#
                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (slot-value  proto_conn 'target))  #|line 261|#)
                )
              (t                                            #|line 262|#
                (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 263|#)) #|line 264|#
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
          (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 276|#))
          (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 277|#)) #|line 278|#
          ))
      (return-from create_up_connector  connector)          #|line 279|#)) #|line 280|#
  )
(defun create_through_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 282|#
  (let (( connector  (make-instance 'Connector)             #|line 283|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "through")    #|line 284|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 285|#))
    (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 286|#))
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
(defun mkSender (&optional  name  component  port)
  (declare (ignorable  name  component  port))              #|line 366|#
  (let (( s  (make-instance 'Sender)                        #|line 367|#))
    (declare (ignorable  s))
    (setf (slot-value  s 'name)  name)                      #|line 368|#
    (setf (slot-value  s 'component)  component)            #|line 369|#
    (setf (slot-value  s 'port)  port)                      #|line 370|#
    (return-from mkSender  s)                               #|line 371|#) #|line 372|#
  )
(defun mkReceiver (&optional  name  component  port  q)
  (declare (ignorable  name  component  port  q))           #|line 374|#
  (let (( r  (make-instance 'Receiver)                      #|line 375|#))
    (declare (ignorable  r))
    (setf (slot-value  r 'name)  name)                      #|line 376|#
    (setf (slot-value  r 'component)  component)            #|line 377|#
    (setf (slot-value  r 'port)  port)                      #|line 378|#
    #|  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. |# #|line 379|#
    (setf (slot-value  r 'queue)  q)                        #|line 380|#
    (return-from mkReceiver  r)                             #|line 381|#) #|line 382|#
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
          (let ((from_sender (funcall (quote mkSender)   fromname  from_component (slot-value  message 'port)  #|line 482|#)))
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
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 66|#
                      )
                    (t                                      #|line 67|#
                      (setf  instance_name  template_name)  #|line 68|#
                      ))
                  (let ((instance (funcall (slot-value  template 'instantiator)   reg  owner  instance_name (slot-value  template 'template_data)  #|line 69|#)))
                    (declare (ignorable instance))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 70|#
        )
      (t                                                    #|line 71|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 72|#)
        (return-from get_component_instance  nil)           #|line 73|#
        )))                                                 #|line 74|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 76|#
  (funcall (quote nl) )                                     #|line 77|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 78|#
  (loop for c in (slot-value  reg 'templates)
    do
      (progn
        c                                                   #|line 79|#
        (funcall (quote print)  (slot-value  c 'name) )     #|line 80|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 81|#
  (funcall (quote nl) )                                     #|line 82|# #|line 83|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 85|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (slot-value  reg 'stats))) #|line 86|# #|line 87|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 89|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 90|#
  (return-from mangle_name  s)                              #|line 91|# #|line 92|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 94|#
  #|  [ |#                                                  #|line 95|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 96|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 97|#
  #|  ] |#                                                  #|line 98|#
  (cond
    ((not (equal   nil  container_list))                    #|line 99|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 100|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 101|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 102|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 103|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 104|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 105|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 106|#
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  #'shell_out_instantiate  cmd  #|line 107|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 108|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 109|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 110|#
                        (let ((s  (subseq  name 1)          #|line 111|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  #'string_constant_instantiate  s  #|line 112|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 113|#)))) #|line 114|#
                      ))                                    #|line 115|#
                  ))                                        #|line 116|#
            ))                                              #|line 117|#
      ))
  (return-from generate_shell_components  reg)              #|line 118|# #|line 119|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 121|#
  (return-from first_char  (char  s 0)                      #|line 122|#) #|line 123|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 125|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 126|#))) #|line 127|#
  )                                                         #|line 129|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 130|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 131|# #|line 132|# #|line 133|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 134|# #|  and output queues of messages. |# #|line 135|# #|  |# #|line 136|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 137|# #|  that routes messages to child components according to a list of connections |# #|line 138|# #|  that serve as a message routing table. |# #|line 139|# #|  |# #|line 140|# #|  Child components themselves can be leaves or other containers. |# #|line 141|# #|  |# #|line 142|# #|  `handler` invokes the code that is attached to this component. |# #|line 143|# #|  |# #|line 144|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 145|# #|  function may want whenever it is invoked again. |# #|line 146|# #|  |# #|line 147|# #|line 148|# #|  Eh_States :: enum { idle, active } |# #|line 149|#
(defclass Eh ()                                             #|line 150|#
  (
    (name :accessor name :initarg :name :initform  "")      #|line 151|#
    (inq :accessor inq :initarg :inq :initform  (make-instance 'Queue) #|line 152|#)
    (outq :accessor outq :initarg :outq :initform  (make-instance 'Queue) #|line 153|#)
    (owner :accessor owner :initarg :owner :initform  nil)  #|line 154|#
    (children :accessor children :initarg :children :initform  nil)  #|line 155|#
    (visit_ordering :accessor visit_ordering :initarg :visit_ordering :initform  (make-instance 'Queue) #|line 156|#)
    (connections :accessor connections :initarg :connections :initform  nil)  #|line 157|#
    (routings :accessor routings :initarg :routings :initform  (make-instance 'Queue) #|line 158|#)
    (handler :accessor handler :initarg :handler :initform  nil)  #|line 159|#
    (finject :accessor finject :initarg :finject :initform  nil)  #|line 160|#
    (instance_data :accessor instance_data :initarg :instance_data :initform  nil)  #|line 161|#
    (state :accessor state :initarg :state :initform  "idle")  #|line 162|# #|  bootstrap debugging |# #|line 163|#
    (kind :accessor kind :initarg :kind :initform  nil)  #|  enum { container, leaf, } |# #|line 164|#)) #|line 165|#

                                                            #|line 166|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 167|# #|  whose handler function is `container_handler`. |# #|line 168|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 169|#
  (let (( eh  (make-instance 'Eh)                           #|line 170|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  name)                     #|line 171|#
    (setf (slot-value  eh 'owner)  owner)                   #|line 172|#
    (setf (slot-value  eh 'handler)  #'container_handler)   #|line 173|#
    (setf (slot-value  eh 'finject)  #'container_injector)  #|line 174|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 175|#
    (setf (slot-value  eh 'kind)  "container")              #|line 176|#
    (return-from make_container  eh)                        #|line 177|#) #|line 178|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 180|# #|  that will be passed back to your handler when called. |# #|line 181|# #|line 182|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 183|#
  (let (( eh  (make-instance 'Eh)                           #|line 184|#))
    (declare (ignorable  eh))
    (setf (slot-value  eh 'name)  (concatenate 'string (slot-value  owner 'name)  (concatenate 'string  "."  name)) #|line 185|#)
    (setf (slot-value  eh 'owner)  owner)                   #|line 186|#
    (setf (slot-value  eh 'handler)  handler)               #|line 187|#
    (setf (slot-value  eh 'instance_data)  instance_data)   #|line 188|#
    (setf (slot-value  eh 'state)  "idle")                  #|line 189|#
    (setf (slot-value  eh 'kind)  "leaf")                   #|line 190|#
    (return-from make_leaf  eh)                             #|line 191|#) #|line 192|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 194|# #|  of the given component. |# #|line 195|# #|line 196|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 197|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 198|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 199|#)) #|line 200|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 202|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 203|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 204|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 205|#))) #|line 206|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 208|#
  (let ((fwdmsg (funcall (quote make_message)   port (slot-value  msg 'datum)  #|line 209|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 210|#)) #|line 211|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 213|#
  (funcall (slot-value  eh 'finject)   eh  msg              #|line 214|#) #|line 215|#
  ) #|  Returns a list of all output messages on a container. |# #|line 217|# #|  For testing / debugging purposes. |# #|line 218|# #|line 219|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 220|#
  (return-from output_list (slot-value  eh 'outq))          #|line 221|# #|line 222|#
  ) #|  Utility for printing an array of messages. |#       #|line 224|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 225|#
  (loop for m in (queue2list (slot-value  eh 'outq))
    do
      (progn
        m                                                   #|line 226|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 227|#
        ))                                                  #|line 228|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 230|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 231|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 232|#
          (setf  s (+  s  " "))                             #|line 233|#
          ))
    (return-from spaces  s)                                 #|line 234|#) #|line 235|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 237|#
  (setf (slot-value  eh 'state)  "active")                  #|line 238|# #|line 239|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 241|#
  (setf (slot-value  eh 'state)  "idle")                    #|line 242|# #|line 243|#
  ) #|  Utility for printing a specific output message. |#  #|line 245|# #|line 246|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 247|#
  (loop for msg in (queue2list (slot-value  eh 'outq))
    do
      (progn
        msg                                                 #|line 248|#
        (cond
          (( equal   (slot-value  msg 'port)  port)         #|line 249|#
            (return-from fetch_first_output (slot-value  msg 'datum))
            ))                                              #|line 250|#
        ))
  (return-from fetch_first_output  nil)                     #|line 251|# #|line 252|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 254|#
  #|  port ∷ “” |#                                          #|line 255|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 256|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (slot-value  datum 'srepr) )) #|line 257|#) #|line 258|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 259|#
  #|  port ∷ “” |#                                          #|line 260|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 261|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 262|#
    (format *error-output* "~a" (funcall (slot-value  datum 'srepr) )) #|line 263|#) #|line 264|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 266|#
  (enqueue (slot-value  eh 'outq)  msg)                     #|line 267|# #|line 268|#
  )
(defparameter  root_project  "")                            #|line 270|#
(defparameter  root_0D  "")                                 #|line 271|# #|line 272|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 273|# #|line 274|# #|line 275|#
  (setf  root_project  rproject)                            #|line 276|#
  (setf  root_0D  r0D)                                      #|line 277|# #|line 278|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 280|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 281|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 282|#))) #|line 283|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 284|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 285|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 286|#))) #|line 287|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 289|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 290|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 291|#))) #|line 292|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 294|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 295|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 296|#))) #|line 297|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 299|#
  (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable s))                                 #|line 300|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "  s)))) #|line 301|#) #|line 302|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 304|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 305|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 306|#))) #|line 307|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 309|#
  #|  to appease dumped_on_floor checker |#                 #|line 310|#
  #| pass |#                                                #|line 311|# #|line 312|#
  )
(defclass TwoMessages ()                                    #|line 313|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  nil)  #|line 314|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  nil)  #|line 315|#)) #|line 316|#

                                                            #|line 317|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 318|#
(defclass Deracer_Instance_Data ()                          #|line 319|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 320|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 321|#)) #|line 322|#

                                                            #|line 323|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 324|#
  #| pass |#                                                #|line 325|# #|line 326|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 328|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 329|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 330|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 331|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMessages) #|line 332|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 333|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 334|#))) #|line 335|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 337|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmsg)  #|line 338|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmsg)  #|line 339|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 340|#) #|line 341|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 343|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 344|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 345|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 346|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 347|#
            (setf (slot-value  inst 'state)  "waitingForSecondmsg") #|line 348|#
            )
          (( equal    "2" (slot-value  msg 'port))          #|line 349|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 350|#
            (setf (slot-value  inst 'state)  "waitingForFirstmsg") #|line 351|#
            )
          (t                                                #|line 352|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 353|#
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmsg") #|line 354|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 355|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 356|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 357|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 358|#
            )
          (t                                                #|line 359|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 360|#
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmsg") #|line 361|#
        (cond
          (( equal    "2" (slot-value  msg 'port))          #|line 362|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 363|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 364|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 365|#
            )
          (t                                                #|line 366|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value  msg 'port)) )
            ))                                              #|line 367|#
        )
      (t                                                    #|line 368|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 369|#
        )))                                                 #|line 370|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 372|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 373|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 374|#))) #|line 375|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 377|#
  (let ((fname (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable fname))                             #|line 378|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 379|#) #|line 380|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 382|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 383|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 384|#))) #|line 385|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 387|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  msg 'datum) 'kind) )) #|line 388|#
      (funcall (quote forward)   eh  ""  msg )              #|line 389|#
      )
    (t                                                      #|line 390|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  msg 'datum)) #|line 391|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 392|#
      ))                                                    #|line 393|#
  )
(defclass Syncfilewrite_Data ()                             #|line 395|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 396|#)) #|line 397|#

                                                            #|line 398|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 399|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 400|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 401|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 402|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 403|#)))) #|line 404|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 406|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 407|#
    (cond
      (( equal    "filename" (slot-value  msg 'port))       #|line 408|#
        (setf (slot-value  inst 'filename) (funcall (slot-value (slot-value  msg 'datum) 'srepr) )) #|line 409|#
        )
      (( equal    "input" (slot-value  msg 'port))          #|line 410|#
        (let ((contents (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
          (declare (ignorable contents))                    #|line 411|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 412|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 413|#
                (funcall (slot-value  f 'write)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 414|#)
                (funcall (slot-value  f 'close) )           #|line 415|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 416|#
                )
              (t                                            #|line 417|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  msg )
                ))))                                        #|line 418|#
        )))                                                 #|line 419|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 421|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 422|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 423|#
    (scount :accessor scount :initarg :scount :initform  0)  #|line 424|#)) #|line 425|#

                                                            #|line 426|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 427|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 428|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 429|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 430|#)))) #|line 431|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 433|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 434|#
    (cond
      (( equal    "1" (slot-value  msg 'port))              #|line 435|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 436|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 437|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 438|#
        )
      (( equal    "2" (slot-value  msg 'port))              #|line 439|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (funcall (slot-value (slot-value  msg 'datum) 'srepr) )  #|line 440|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 441|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 442|#
        )
      (t                                                    #|line 443|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value  msg 'port))  #|line 444|#) #|line 445|#
        )))                                                 #|line 446|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 448|#
  (cond
    (( and  ( equal    0 (length (slot-value  inst 'buffer1))) ( equal    0 (length (slot-value  inst 'buffer2)))) #|line 449|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 450|#
      ))
  (cond
    (( >=  (slot-value  inst 'scount)  2)                   #|line 451|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 452|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 453|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 454|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 455|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 456|#
            )
          (t                                                #|line 457|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 458|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 459|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 460|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 461|#
        (setf (slot-value  inst 'scount)  0))               #|line 462|#
      ))                                                    #|line 463|#
  ) #|  |#                                                  #|line 465|# #|line 466|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 467|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 468|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 469|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 470|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 471|#)))) #|line 472|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 474|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 475|#
    (let ((s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
      (declare (ignorable s))                               #|line 476|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 477|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 478|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 479|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 480|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 481|#
              (cond
                ((not (equal   rc  0))                      #|line 482|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 483|#)
                  )
                (t                                          #|line 484|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 485|#) #|line 486|#
                  ))))))))                                  #|line 487|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 489|# #|line 490|# #|line 491|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 492|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 493|#
      (cond
        ((not (equal   root_project  ""))                   #|line 494|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 495|#) #|line 496|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 497|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 498|#) #|line 499|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 500|#)))) #|line 501|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 503|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 504|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 505|#)) #|line 506|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 508|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 509|#
  (return-from string_make_persistent  s)                   #|line 510|# #|line 511|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 513|#
  (return-from string_clone  s)                             #|line 514|# #|line 515|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 517|# #|  where ${_00_} is the root directory for the project |# #|line 518|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 519|# #|line 520|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 521|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 522|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 523|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 524|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 525|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 526|#
                  (funcall (quote register_component)   reg (funcall (quote mkTemplate)  (gethash  "name"  container)  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 527|#) #|line 528|#
                  )))                                       #|line 529|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 530|#)
    (return-from initialize_component_palette  reg)         #|line 531|#) #|line 532|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 534|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 535|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 536|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (slot-value  err 'srepr) ) )))) #|line 537|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 538|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 539|#
          ))))                                              #|line 540|#
  ) #|  debugging helpers |#                                #|line 542|# #|line 543|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 544|#
  (format *standard-output* "~a"  "")                       #|line 545|# #|line 546|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 548|#
  (funcall (quote nl) )                                     #|line 549|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 550|#
  (funcall (quote print_output_list)   main_container       #|line 551|#) #|line 552|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 554|#
  #|  remove whitespace from front and back of string |#    #|line 555|#
  (return-from trimws (funcall (slot-value  s 'strip) ))    #|line 556|# #|line 557|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 559|#
  (return-from clone_string  s                              #|line 560|# #|line 561|#) #|line 562|#
  )
(defparameter  load_errors  nil)                            #|line 563|#
(defparameter  runtime_errors  nil)                         #|line 564|# #|line 565|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 566|# #|line 567|#
  (format *standard-output* "~a"  s)                        #|line 568|#
  (format *standard-output* "
  ")                                                        #|line 569|#
  (setf  load_errors  t)                                    #|line 570|# #|line 571|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 573|# #|line 574|#
  (format *standard-output* "~a"  s)                        #|line 575|#
  (setf  runtime_errors  t)                                 #|line 576|# #|line 577|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 579|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 580|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 581|#))) #|line 582|#
  )
(defparameter  rand  0)                                     #|line 584|# #|line 585|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 586|# #|line 587|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 588|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 589|#) #|line 590|#
  )                                                         #|line 592|# #|  all of the the built_in leaves are listed here |# #|line 593|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 594|# #|line 595|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 596|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 597|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?"  nil  #'probe_instantiate )  #|line 598|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 599|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 602|#) #|line 603|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 604|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 605|#) #|line 606|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 607|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 608|#)
  #|  for fakepipe |#                                       #|line 609|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 610|#) #|line 611|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 613|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 614|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 615|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 616|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 617|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 618|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 619|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 620|#)))))) #|line 621|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 623|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 624|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 625|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 626|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 627|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 628|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 629|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 630|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 631|#)
            #|  get entrypoint container |#                 #|line 632|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 633|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 634|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 638|#) #|line 639|#
                  ))
              (cond
                ((not  load_errors)                         #|line 640|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 641|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 642|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 643|#)
                      (cond
                        ( show_all_outputs                  #|line 644|#
                          (funcall (quote dump_outputs)   main_container  #|line 645|#)
                          )
                        (t                                  #|line 646|#
                          (funcall (quote print_error_maybe)   main_container  #|line 647|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 648|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 649|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 650|#
                                )
                              (t                            #|line 651|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 652|#) #|line 653|#
                                )))                         #|line 654|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 655|#
                          (format *standard-output* "~a"  "--- done ---") #|line 656|# #|line 657|#
                          ))))                              #|line 658|#
                  ))))))))                                  #|line 659|#
  )                                                         #|line 661|# #|line 662|# #|  utility functions  |# #|line 663|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 664|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 665|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 666|#)) #|line 667|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 669|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 670|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 671|#)) #|line 672|#
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
(defparameter  decode_digits (list   "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9" )) #|line 5|#
(defun decode_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 6|# #|line 7|#
  (let (( i (parse-integer (funcall (slot-value (slot-value  msg 'datum) 'srepr) )) #|line 8|#))
    (declare (ignorable  i))
    (cond
      (( and  ( >=   i  0) ( <=   i  9))                    #|line 9|#
        (funcall (quote send_string)   eh (nth  i  decode_digits) (nth  i  decode_digits)  msg  #|line 10|#) #|line 11|#
        ))
    (funcall (quote send_bang)   eh  "done"  msg            #|line 12|#)) #|line 13|#
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
  (let (( s (funcall (slot-value (slot-value  msg 'datum) 'srepr) )))
    (declare (ignorable  s))                                #|line 11|#
    (let (( i (parse-integer  s)                            #|line 12|#))
      (declare (ignorable  i))
      (loop while ( >   i  0)
        do
          (progn                                            #|line 13|#
            (setf  s  (concatenate 'string  " "  s)         #|line 14|#)
            (setf  i (-  i  1))                             #|line 15|# #|line 16|#
            ))
      (funcall (quote print)   s                            #|line 17|#))) #|line 18|#
  )





