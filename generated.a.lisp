
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
      (return-from format_message  (concatenate 'string (slot-value  m 'port)  (concatenate 'string  ":"  (concatenate 'string (funcall (slot-value (slot-value  m 'datum) 'srepr) )  ","))) #|line 224|#) #|line 225|#
      ))                                                    #|line 226|#
  )
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 232|#
(defun create_down_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 233|#
  #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 234|#
  (let (( connector  (make-instance 'Connector)             #|line 235|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "down")       #|line 236|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 237|#))
    (let ((target_proto (gethash  "target"  proto_conn)))
      (declare (ignorable target_proto))                    #|line 238|#
      (let ((id_proto (gethash  "id"  target_proto)))
        (declare (ignorable id_proto))                      #|line 239|#
        (let ((target_component (gethash id_proto  children_by_id)))
          (declare (ignorable target_component))            #|line 240|#
          (cond
            (( equal    target_component  nil)              #|line 241|#
              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (gethash  "name" (gethash  "target"  proto_conn))) ) #|line 242|#
              )
            (t                                              #|line 243|#
              (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 244|#)) #|line 245|#
              ))
          (return-from create_down_connector  connector)    #|line 246|#)))) #|line 247|#
  )
(defun create_across_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 249|#
  (let (( connector  (make-instance 'Connector)             #|line 250|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "across")     #|line 251|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 252|#
      (let ((target_component (gethash (gethash  "id" (gethash  "target"  proto_conn))  children_by_id)))
        (declare (ignorable target_component))              #|line 253|#
        (cond
          (( equal    source_component  nil)                #|line 254|#
            (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (gethash  "name" (gethash  "source"  proto_conn)))  #|line 255|#)
            )
          (t                                                #|line 256|#
            (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 257|#))
            (cond
              (( equal    target_component  nil)            #|line 258|#
                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (gethash  "name" (gethash  "target"  proto_conn)))  #|line 259|#)
                )
              (t                                            #|line 260|#
                (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  target_component 'name)  target_component (gethash  "target_port"  proto_conn) (slot-value  target_component 'inq)  #|line 261|#)) #|line 262|#
                ))                                          #|line 263|#
            ))
        (return-from create_across_connector  connector)    #|line 264|#))) #|line 265|#
  )
(defun create_up_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 267|#
  (let (( connector  (make-instance 'Connector)             #|line 268|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "up")         #|line 269|#
    (let ((source_component (gethash (gethash  "id" (gethash  "source"  proto_conn))  children_by_id)))
      (declare (ignorable source_component))                #|line 270|#
      (cond
        (( equal    source_component  nil)                  #|line 271|#
          (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (gethash  "name" (gethash  "source"  proto_conn))) ) #|line 272|#
          )
        (t                                                  #|line 273|#
          (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  source_component 'name)  source_component (gethash  "source_port"  proto_conn)  #|line 274|#))
          (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 275|#)) #|line 276|#
          ))
      (return-from create_up_connector  connector)          #|line 277|#)) #|line 278|#
  )
(defun create_through_connector (&optional  container  proto_conn  connectors  children_by_id)
  (declare (ignorable  container  proto_conn  connectors  children_by_id)) #|line 280|#
  (let (( connector  (make-instance 'Connector)             #|line 281|#))
    (declare (ignorable  connector))
    (setf (slot-value  connector 'direction)  "through")    #|line 282|#
    (setf (slot-value  connector 'sender) (funcall (quote mkSender)  (slot-value  container 'name)  container (gethash  "source_port"  proto_conn)  #|line 283|#))
    (setf (slot-value  connector 'receiver) (funcall (quote mkReceiver)  (slot-value  container 'name)  container (gethash  "target_port"  proto_conn) (slot-value  container 'outq)  #|line 284|#))
    (return-from create_through_connector  connector)       #|line 285|#) #|line 286|#
  )                                                         #|line 288|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 289|# #|line 290|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 291|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 292|#
      (let ((children_by_id  (dict-fresh)))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 293|#
        #|  collect children |#                             #|line 294|#
        (loop for child_desc in (gethash  "children"  desc)
          do
            (progn
              child_desc                                    #|line 295|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (gethash  "name"  child_desc)  container  #|line 296|#)))
                (declare (ignorable child_instance))
                (setf  children (append  children (list  child_instance))) #|line 297|#
                (let ((id (gethash  "id"  child_desc)))
                  (declare (ignorable id))                  #|line 298|#
                  (setf (gethash id  children_by_id)  child_instance) #|line 299|# #|line 300|#)) #|line 301|#
              ))
        (setf (slot-value  container 'children)  children)  #|line 302|# #|line 303|#
        (let ((connectors  nil))
          (declare (ignorable connectors))                  #|line 304|#
          (loop for proto_conn in (gethash  "connections"  desc)
            do
              (progn
                proto_conn                                  #|line 305|#
                (let (( connector  (make-instance 'Connector) #|line 306|#))
                  (declare (ignorable  connector))
                  (cond
                    (( equal   (gethash  "dir"  proto_conn)  enumDown) #|line 307|#
                      (setf  connectors (append  connectors (list (funcall (quote create_down_connector)   container  proto_conn  connectors  children_by_id )))) #|line 308|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumAcross) #|line 309|#
                      (setf  connectors (append  connectors (list (funcall (quote create_across_connector)   container  proto_conn  connectors  children_by_id )))) #|line 310|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumUp) #|line 311|#
                      (setf  connectors (append  connectors (list (funcall (quote create_up_connector)   container  proto_conn  connectors  children_by_id )))) #|line 312|#
                      )
                    (( equal   (gethash  "dir"  proto_conn)  enumThrough) #|line 313|#
                      (setf  connectors (append  connectors (list (funcall (quote create_through_connector)   container  proto_conn  connectors  children_by_id )))) #|line 314|# #|line 315|#
                      )))                                   #|line 316|#
                ))
          (setf (slot-value  container 'connections)  connectors) #|line 317|#
          (return-from container_instantiator  container)   #|line 318|#)))) #|line 319|#
  ) #|  The default handler for container components. |#    #|line 321|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 322|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 323|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 324|#
        (funcall (quote step_children)   container  message ) #|line 325|#
        ))                                                  #|line 326|#
  ) #|  Frees the given container and associated data. |#   #|line 328|#
(defun destroy_container (&optional  eh)
  (declare (ignorable  eh))                                 #|line 329|#
  #| pass |#                                                #|line 330|# #|line 331|#
  ) #|  Routing connection for a container component. The `direction` field has |# #|line 333|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 334|# #|  purposes, or for reading by other tools. |# #|line 335|# #|line 336|#
(defclass Connector ()                                      #|line 337|#
  (
    (direction :accessor direction :initarg :direction :initform  nil)  #|  down, across, up, through |# #|line 338|#
    (sender :accessor sender :initarg :sender :initform  nil)  #|line 339|#
    (receiver :accessor receiver :initarg :receiver :initform  nil)  #|line 340|#)) #|line 341|#

                                                            #|line 342|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 343|# #|  based on component ID (pointer) and port name. |# #|line 344|# #|line 345|#
(defclass Sender ()                                         #|line 346|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 347|#
    (component :accessor component :initarg :component :initform  nil)  #|line 348|#
    (port :accessor port :initarg :port :initform  nil)     #|line 349|#)) #|line 350|#

                                                            #|line 351|# #|line 352|# #|line 353|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 354|# #|  to incoming messages to this queue. |# #|line 355|# #|line 356|#
(defclass Receiver ()                                       #|line 357|#
  (
    (name :accessor name :initarg :name :initform  nil)     #|line 358|#
    (queue :accessor queue :initarg :queue :initform  nil)  #|line 359|#
    (port :accessor port :initarg :port :initform  nil)     #|line 360|#
    (component :accessor component :initarg :component :initform  nil)  #|line 361|#)) #|line 362|#

                                                            #|line 363|#
(defun mkSender (&optional  name  component  port)
  (declare (ignorable  name  component  port))              #|line 364|#
  (let (( s  (make-instance 'Sender)                        #|line 365|#))
    (declare (ignorable  s))
    (setf (slot-value  s 'name)  name)                      #|line 366|#
    (setf (slot-value  s 'component)  component)            #|line 367|#
    (setf (slot-value  s 'port)  port)                      #|line 368|#
    (return-from mkSender  s)                               #|line 369|#) #|line 370|#
  )
(defun mkReceiver (&optional  name  component  port  q)
  (declare (ignorable  name  component  port  q))           #|line 372|#
  (let (( r  (make-instance 'Receiver)                      #|line 373|#))
    (declare (ignorable  r))
    (setf (slot-value  r 'name)  name)                      #|line 374|#
    (setf (slot-value  r 'component)  component)            #|line 375|#
    (setf (slot-value  r 'port)  port)                      #|line 376|#
    #|  We need a way to determine which queue to target. "Down" and "Across" go to inq, "Up" and "Through" go to outq. |# #|line 377|#
    (setf (slot-value  r 'queue)  q)                        #|line 378|#
    (return-from mkReceiver  r)                             #|line 379|#) #|line 380|#
  ) #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 382|#
(defun sender_eq (&optional  s1  s2)
  (declare (ignorable  s1  s2))                             #|line 383|#
  (let ((same_components ( equal   (slot-value  s1 'component) (slot-value  s2 'component))))
    (declare (ignorable same_components))                   #|line 384|#
    (let ((same_ports ( equal   (slot-value  s1 'port) (slot-value  s2 'port))))
      (declare (ignorable same_ports))                      #|line 385|#
      (return-from sender_eq ( and   same_components  same_ports)) #|line 386|#)) #|line 387|#
  ) #|  Delivers the given message to the receiver of this connector. |# #|line 389|# #|line 390|#
(defun deposit (&optional  parent  conn  message)
  (declare (ignorable  parent  conn  message))              #|line 391|#
  (let ((new_message (funcall (quote make_message)  (slot-value (slot-value  conn 'receiver) 'port) (slot-value  message 'datum)  #|line 392|#)))
    (declare (ignorable new_message))
    (funcall (quote push_message)   parent (slot-value (slot-value  conn 'receiver) 'component) (slot-value (slot-value  conn 'receiver) 'queue)  new_message  #|line 393|#)) #|line 394|#
  )
(defun force_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 396|#
  (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 397|#)))
    (declare (ignorable tick_msg))
    (funcall (quote push_message)   parent  eh (slot-value  eh 'inq)  tick_msg  #|line 398|#)
    (return-from force_tick  tick_msg)                      #|line 399|#) #|line 400|#
  )
(defun push_message (&optional  parent  receiver  inq  m)
  (declare (ignorable  parent  receiver  inq  m))           #|line 402|#
  (enqueue  inq  m)                                         #|line 403|#
  (enqueue (slot-value  parent 'visit_ordering)  receiver)  #|line 404|# #|line 405|#
  )
(defun is_self (&optional  child  container)
  (declare (ignorable  child  container))                   #|line 407|#
  #|  in an earlier version “self“ was denoted as ϕ |#      #|line 408|#
  (return-from is_self ( equal    child  container))        #|line 409|# #|line 410|#
  )
(defun step_child (&optional  child  msg)
  (declare (ignorable  child  msg))                         #|line 412|#
  (let ((before_state (slot-value  child 'state)))
    (declare (ignorable before_state))                      #|line 413|#
    (funcall (slot-value  child 'handler)   child  msg      #|line 414|#)
    (let ((after_state (slot-value  child 'state)))
      (declare (ignorable after_state))                     #|line 415|#
      (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 416|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 417|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 418|#)) #|line 419|#
  )
(defun step_children (&optional  container  causingMessage)
  (declare (ignorable  container  causingMessage))          #|line 421|#
  (setf (slot-value  container 'state)  "idle")             #|line 422|#
  (loop for child in (queue2list (slot-value  container 'visit_ordering))
    do
      (progn
        child                                               #|line 423|#
        #|  child = container represents self, skip it |#   #|line 424|#
        (cond
          ((not (funcall (quote is_self)   child  container )) #|line 425|#
            (cond
              ((not (empty? (slot-value  child 'inq)))      #|line 426|#
                (let ((msg (dequeue (slot-value  child 'inq)) #|line 427|#))
                  (declare (ignorable msg))
                  (let (( began_long_run  nil))
                    (declare (ignorable  began_long_run))   #|line 428|#
                    (let (( continued_long_run  nil))
                      (declare (ignorable  continued_long_run)) #|line 429|#
                      (let (( ended_long_run  nil))
                        (declare (ignorable  ended_long_run)) #|line 430|#
                        (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 431|#))
                        (cond
                          ( began_long_run                  #|line 432|#
                            #| pass |#                      #|line 433|#
                            )
                          ( continued_long_run              #|line 434|#
                            #| pass |#                      #|line 435|#
                            )
                          ( ended_long_run                  #|line 436|#
                            #| pass |#                      #|line 437|# #|line 438|#
                            ))
                        (funcall (quote destroy_message)   msg ))))) #|line 439|#
                )
              (t                                            #|line 440|#
                (cond
                  ((not (equal  (slot-value  child 'state)  "idle")) #|line 441|#
                    (let ((msg (funcall (quote force_tick)   container  child  #|line 442|#)))
                      (declare (ignorable msg))
                      (funcall (slot-value  child 'handler)   child  msg  #|line 443|#)
                      (funcall (quote destroy_message)   msg ))
                    ))                                      #|line 444|#
                ))                                          #|line 445|#
            (cond
              (( equal   (slot-value  child 'state)  "active") #|line 446|#
                #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 447|#
                (setf (slot-value  container 'state)  "active") #|line 448|#
                ))                                          #|line 449|#
            (loop while (not (empty? (slot-value  child 'outq)))
              do
                (progn                                      #|line 450|#
                  (let ((msg (dequeue (slot-value  child 'outq)) #|line 451|#))
                    (declare (ignorable msg))
                    (funcall (quote route)   container  child  msg  #|line 452|#)
                    (funcall (quote destroy_message)   msg ))
                  ))
            ))                                              #|line 453|#
        ))                                                  #|line 454|# #|line 455|# #|line 456|#
  )
(defun attempt_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                         #|line 458|#
  (cond
    ((not (equal  (slot-value  eh 'state)  "idle"))         #|line 459|#
      (funcall (quote force_tick)   parent  eh )            #|line 460|#
      ))                                                    #|line 461|#
  )
(defun is_tick (&optional  msg)
  (declare (ignorable  msg))                                #|line 463|#
  (return-from is_tick ( equal    "tick" (funcall (slot-value (slot-value  msg 'datum) 'kind) ))) #|line 464|# #|line 465|#
  ) #|  Routes a single message to all matching destinations, according to |# #|line 467|# #|  the container's connection network. |# #|line 468|# #|line 469|#
(defun route (&optional  container  from_component  message)
  (declare (ignorable  container  from_component  message)) #|line 470|#
  (let (( was_sent  nil))
    (declare (ignorable  was_sent))
    #|  for checking that output went somewhere (at least during bootstrap) |# #|line 471|#
    (let (( fromname  ""))
      (declare (ignorable  fromname))                       #|line 472|#
      (cond
        ((funcall (quote is_tick)   message )               #|line 473|#
          (loop for child in (slot-value  container 'children)
            do
              (progn
                child                                       #|line 474|#
                (funcall (quote attempt_tick)   container  child ) #|line 475|#
                ))
          (setf  was_sent  t)                               #|line 476|#
          )
        (t                                                  #|line 477|#
          (cond
            ((not (funcall (quote is_self)   from_component  container )) #|line 478|#
              (setf  fromname (slot-value  from_component 'name)) #|line 479|#
              ))
          (let ((from_sender (funcall (quote mkSender)   fromname  from_component (slot-value  message 'port)  #|line 480|#)))
            (declare (ignorable from_sender))               #|line 481|#
            (loop for connector in (slot-value  container 'connections)
              do
                (progn
                  connector                                 #|line 482|#
                  (cond
                    ((funcall (quote sender_eq)   from_sender (slot-value  connector 'sender) ) #|line 483|#
                      (funcall (quote deposit)   container  connector  message  #|line 484|#)
                      (setf  was_sent  t)
                      ))
                  )))                                       #|line 485|#
          ))
      (cond
        ((not  was_sent)                                    #|line 486|#
          (funcall (quote print)   "\n\n*** Error: ***"     #|line 487|#)
          (funcall (quote print)   "***"                    #|line 488|#)
          (funcall (quote print)   (concatenate 'string (slot-value  container 'name)  (concatenate 'string  ": message '"  (concatenate 'string (slot-value  message 'port)  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 489|#)
          (funcall (quote print)   "***"                    #|line 490|#)
          (break)                                           #|line 491|# #|line 492|#
          ))))                                              #|line 493|#
  )
(defun any_child_ready (&optional  container)
  (declare (ignorable  container))                          #|line 495|#
  (loop for child in (slot-value  container 'children)
    do
      (progn
        child                                               #|line 496|#
        (cond
          ((funcall (quote child_is_ready)   child )        #|line 497|#
            (return-from any_child_ready  t)
            ))                                              #|line 498|#
        ))
  (return-from any_child_ready  nil)                        #|line 499|# #|line 500|#
  )
(defun child_is_ready (&optional  eh)
  (declare (ignorable  eh))                                 #|line 502|#
  (return-from child_is_ready ( or  ( or  ( or  (not (empty? (slot-value  eh 'outq))) (not (empty? (slot-value  eh 'inq)))) (not (equal  (slot-value  eh 'state)  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 503|# #|line 504|#
  )
(defun append_routing_descriptor (&optional  container  desc)
  (declare (ignorable  container  desc))                    #|line 506|#
  (enqueue (slot-value  container 'routings)  desc)         #|line 507|# #|line 508|#
  )
(defun container_injector (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 510|#
  (funcall (quote container_handler)   container  message   #|line 511|#) #|line 512|#
  )





