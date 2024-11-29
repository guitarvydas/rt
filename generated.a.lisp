
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
(defun dict-fresh () nil)

(defun key-mangle (s) s)

(defun dict-lookup (d key-string)
(let ((pair (assoc (key-mangle key-string) d :test 'equal)))
(if pair
(cdr pair)
nil)))

(defun dict-is-dict? (d) (listp d))

(defun dict-in? (key-string d)
(if (and d (dict-is-dict? d))
(let ((pair (assoc (key-mangle key-string) d :test 'equal)))
(if pair t nil))
nil))

(defun field (obj key)
(let ((pair (assoc key obj :test 'equal)))
(if pair (cdr pair) nil)))

(defun (setf field) (v obj key)
(let ((pair (assoc key obj :test 'equal)))
(if pair
(setf (cdr pair) v)
(error (format nil "error in setf field, key ~s not found" key)))))

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
(defun Datum (&optional )                                   #|line 30|#
  (list
    (cons "data"  nil)                                      #|line 31|#
    (cons "clone"  nil)                                     #|line 32|#
    (cons "reclaim"  nil)                                   #|line 33|#
    (cons "srepr"  nil)                                     #|line 34|#
    (cons "kind"  nil)                                      #|line 35|#
    (cons "raw"  nil)                                       #|line 36|#) #|line 37|#)
                                                            #|line 38|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                  #|line 39|#
  (let ((d  (Datum)                                         #|line 40|#))
    (declare (ignorable d))
    (setf (field  d "data")  s)                             #|line 41|#
    (setf (field  d "clone")  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 42|#)))
    (setf (field  d "reclaim")  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 43|#)))
    (setf (field  d "srepr")  #'(lambda (&optional )(funcall (quote srepr_datum_string)   d  #|line 44|#)))
    (setf (field  d "raw") (coerce (field  d "data") 'simple-vector) #|line 45|#)
    (setf (field  d "kind")  #'(lambda (&optional ) "string")) #|line 46|#
    (return-from new_datum_string  d)                       #|line 47|#) #|line 48|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 50|#
  (let ((d (funcall (quote new_datum_string)  (field  d "data")  #|line 51|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                     #|line 52|#) #|line 53|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 55|#
  #| pass |#                                                #|line 56|# #|line 57|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 59|#
  (return-from srepr_datum_string (field  d "data"))        #|line 60|# #|line 61|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 63|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 64|#
    (setf (field  p "data")  t)                             #|line 65|#
    (setf (field  p "clone")  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 66|#)))
    (setf (field  p "reclaim")  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 67|#)))
    (setf (field  p "srepr")  #'(lambda (&optional )(funcall (quote srepr_datum_bang) ))) #|line 68|#
    (setf (field  p "raw")  #'(lambda (&optional )(funcall (quote raw_datum_bang) ))) #|line 69|#
    (setf (field  p "kind")  #'(lambda (&optional ) "bang")) #|line 70|#
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
    (setf (field  p "kind")  #'(lambda (&optional ) "tick")) #|line 92|#
    (setf (field  p "clone")  #'(lambda (&optional )(funcall (quote new_datum_tick) ))) #|line 93|#
    (setf (field  p "srepr")  #'(lambda (&optional )(funcall (quote srepr_datum_tick) ))) #|line 94|#
    (setf (field  p "raw")  #'(lambda (&optional )(funcall (quote raw_datum_tick) ))) #|line 95|#
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
    (setf (field  p "data")  b)                             #|line 109|#
    (setf (field  p "clone")  #'(lambda (&optional )(funcall (quote clone_datum_bytes)   p  #|line 110|#)))
    (setf (field  p "reclaim")  #'(lambda (&optional )(funcall (quote reclaim_datum_bytes)   p  #|line 111|#)))
    (setf (field  p "srepr")  #'(lambda (&optional )(funcall (quote srepr_datum_bytes)   b  #|line 112|#)))
    (setf (field  p "raw")  #'(lambda (&optional )(funcall (quote raw_datum_bytes)   b  #|line 113|#)))
    (setf (field  p "kind")  #'(lambda (&optional ) "bytes")) #|line 114|#
    (return-from new_datum_bytes  p)                        #|line 115|#) #|line 116|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 118|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 119|#
    (setf (field  p "clone") (field  src "clone"))          #|line 120|#
    (setf (field  p "reclaim") (field  src "reclaim"))      #|line 121|#
    (setf (field  p "srepr") (field  src "srepr"))          #|line 122|#
    (setf (field  p "raw") (field  src "raw"))              #|line 123|#
    (setf (field  p "kind") (field  src "kind"))            #|line 124|#
    (setf (field  p "data") (funcall (field  src "clone") )) #|line 125|#
    (return-from clone_datum_bytes  p)                      #|line 126|#) #|line 127|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 129|#
  #| pass |#                                                #|line 130|# #|line 131|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 133|#
  (return-from srepr_datum_bytes (funcall (field (field  d "data") "decode")   "UTF_8"  #|line 134|#)) #|line 135|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 136|#
  (return-from raw_datum_bytes (field  d "data"))           #|line 137|# #|line 138|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                  #|line 140|#
  (return-from new_datum_handle (funcall (quote new_datum_int)   h  #|line 141|#)) #|line 142|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 144|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 145|#
    (setf (field  p "data")  i)                             #|line 146|#
    (setf (field  p "clone")  #'(lambda (&optional )(funcall (quote clone_int)   i  #|line 147|#)))
    (setf (field  p "reclaim")  #'(lambda (&optional )(funcall (quote reclaim_int)   i  #|line 148|#)))
    (setf (field  p "srepr")  #'(lambda (&optional )(funcall (quote srepr_datum_int)   i  #|line 149|#)))
    (setf (field  p "raw")  #'(lambda (&optional )(funcall (quote raw_datum_int)   i  #|line 150|#)))
    (setf (field  p "kind")  #'(lambda (&optional ) "int")) #|line 151|#
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
(defun Message (&optional  port  datum)                     #|line 176|#
  (list
    (cons "port"  port)                                     #|line 177|#
    (cons "datum"  datum)                                   #|line 178|#) #|line 179|#)
                                                            #|line 180|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                  #|line 181|#
  (return-from clone_port (funcall (quote clone_string)   s  #|line 182|#)) #|line 183|#
  ) #|  Utility for making a `Message`. Used to safely “seed“ messages |# #|line 185|# #|  entering the very top of a network. |# #|line 186|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                        #|line 187|#
  (let ((p (funcall (quote clone_string)   port             #|line 188|#)))
    (declare (ignorable p))
    (let ((m (funcall (quote Message)   p (funcall (field  datum "clone") )  #|line 189|#)))
      (declare (ignorable m))
      (return-from make_message  m)                         #|line 190|#)) #|line 191|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 193|#
(defun message_clone (&optional  message)
  (declare (ignorable  message))                            #|line 194|#
  (let ((m (funcall (quote Message)  (funcall (quote clone_port)  (field  message "port") ) (funcall (field (field  message "datum") "clone") )  #|line 195|#)))
    (declare (ignorable m))
    (return-from message_clone  m)                          #|line 196|#) #|line 197|#
  ) #|  Frees a message. |#                                 #|line 199|#
(defun destroy_message (&optional  msg)
  (declare (ignorable  msg))                                #|line 200|#
  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |# #|line 201|#
  #| pass |#                                                #|line 202|# #|line 203|#
  )
(defun destroy_datum (&optional  msg)
  (declare (ignorable  msg))                                #|line 205|#
  #| pass |#                                                #|line 206|# #|line 207|#
  )
(defun destroy_port (&optional  msg)
  (declare (ignorable  msg))                                #|line 209|#
  #| pass |#                                                #|line 210|# #|line 211|#
  ) #|  |#                                                  #|line 213|#
(defun format_message (&optional  m)
  (declare (ignorable  m))                                  #|line 214|#
  (cond
    (( equal    m  nil)                                     #|line 215|#
      (return-from format_message  "ϕ")                     #|line 216|#
      )
    (t                                                      #|line 217|#
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (field  m "port")  (concatenate 'string  "⦂"  (concatenate 'string (funcall (field (field  m "datum") "srepr") )  "⟫")))) #|line 221|#) #|line 222|#
      ))                                                    #|line 223|#
  )                                                         #|line 225|#
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 230|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 231|# #|line 232|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 233|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 234|#
      (let ((children_by_id  nil))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 235|#
        #|  collect children |#                             #|line 236|#
        (loop for child_desc in (dict-lookup   desc  "children")
          do
            (progn
              child_desc                                    #|line 237|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (dict-lookup   child_desc  "name")  container  #|line 238|#)))
                (declare (ignorable child_instance))
                (funcall (field  children "append")   child_instance  #|line 239|#)
                (let ((id (dict-lookup   child_desc  "id")))
                  (declare (ignorable id))                  #|line 240|#
                  (setf (dict-lookup  children_by_id id)  child_instance) #|line 241|# #|line 242|#)) #|line 243|#
              ))
        (setf (field  container "children")  children)      #|line 244|#
        (let ((me  container))
          (declare (ignorable me))                          #|line 245|# #|line 246|#
          (let ((connectors  nil))
            (declare (ignorable connectors))                #|line 247|#
            (loop for proto_conn in (dict-lookup   desc  "connections")
              do
                (progn
                  proto_conn                                #|line 248|#
                  (let ((connector (funcall (quote Connector) )))
                    (declare (ignorable connector))         #|line 249|#
                    (cond
                      (( equal   (dict-lookup   proto_conn  "dir")  enumDown) #|line 250|#
                        #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 251|#
                        (setf (field  connector "direction")  "down") #|line 252|#
                        (setf (field  connector "sender") (funcall (quote Sender)  (field  me "name")  me (dict-lookup   proto_conn  "source_port")  #|line 253|#))
                        (let ((target_component (nth (dict-lookup   proto_conn (dict-lookup   "target"  "id"))  children_by_id)))
                          (declare (ignorable target_component)) #|line 254|#
                          (cond
                            (( equal    target_component  nil) #|line 255|#
                              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (dict-lookup   proto_conn  "target")) ) #|line 256|#
                              )
                            (t                              #|line 257|#
                              (setf (field  connector "receiver") (funcall (quote Receiver)  (field  target_component "name") (field  target_component "inq") (dict-lookup   proto_conn  "target_port")  target_component  #|line 258|#))
                              (funcall (field  connectors "append")   connector )
                              )))                           #|line 259|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumAcross) #|line 260|#
                        (setf (field  connector "direction")  "across") #|line 261|#
                        (let ((source_component (nth (dict-lookup   proto_conn (dict-lookup   "source"  "id"))  children_by_id)))
                          (declare (ignorable source_component)) #|line 262|#
                          (let ((target_component (nth (dict-lookup   proto_conn (dict-lookup   "target"  "id"))  children_by_id)))
                            (declare (ignorable target_component)) #|line 263|#
                            (cond
                              (( equal    source_component  nil) #|line 264|#
                                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (dict-lookup   proto_conn  "source")) ) #|line 265|#
                                )
                              (t                            #|line 266|#
                                (setf (field  connector "sender") (funcall (quote Sender)  (field  source_component "name")  source_component (dict-lookup   proto_conn  "source_port")  #|line 267|#))
                                (cond
                                  (( equal    target_component  nil) #|line 268|#
                                    (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (field  proto_conn "target")) ) #|line 269|#
                                    )
                                  (t                        #|line 270|#
                                    (setf (field  connector "receiver") (funcall (quote Receiver)  (field  target_component "name") (field  target_component "inq") (dict-lookup   proto_conn  "target_port")  target_component  #|line 271|#))
                                    (funcall (field  connectors "append")   connector )
                                    ))
                                ))))                        #|line 272|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumUp) #|line 273|#
                        (setf (field  connector "direction")  "up") #|line 274|#
                        (let ((source_component (nth (dict-lookup   proto_conn (dict-lookup   "source"  "id"))  children_by_id)))
                          (declare (ignorable source_component)) #|line 275|#
                          (cond
                            (( equal    source_component  nil) #|line 276|#
                              (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (dict-lookup   proto_conn  "source")) ) #|line 277|#
                              )
                            (t                              #|line 278|#
                              (setf (field  connector "sender") (funcall (quote Sender)  (field  source_component "name")  source_component (dict-lookup   proto_conn  "source_port")  #|line 279|#))
                              (setf (field  connector "receiver") (funcall (quote Receiver)  (field  me "name") (field  container "outq") (dict-lookup   proto_conn  "target_port")  me  #|line 280|#))
                              (funcall (field  connectors "append")   connector )
                              )))                           #|line 281|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumThrough) #|line 282|#
                        (setf (field  connector "direction")  "through") #|line 283|#
                        (setf (field  connector "sender") (funcall (quote Sender)  (field  me "name")  me (dict-lookup   proto_conn  "source_port")  #|line 284|#))
                        (setf (field  connector "receiver") (funcall (quote Receiver)  (field  me "name") (field  container "outq") (dict-lookup   proto_conn  "target_port")  me  #|line 285|#))
                        (funcall (field  connectors "append")   connector )
                        )))                                 #|line 286|#
                  ))                                        #|line 287|#
            (setf (field  container "connections")  connectors) #|line 288|#
            (return-from container_instantiator  container) #|line 289|#))))) #|line 290|#
  ) #|  The default handler for container components. |#    #|line 292|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 293|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 294|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 295|#
        (funcall (quote step_children)   container  message ) #|line 296|#
        ))                                                  #|line 297|#
    ) #|  Frees the given container and associated data. |# #|line 299|#
  (defun destroy_container (&optional  eh)
    (declare (ignorable  eh))                               #|line 300|#
    #| pass |#                                              #|line 301|# #|line 302|#
    )
  (defun fifo_is_empty (&optional  fifo)
    (declare (ignorable  fifo))                             #|line 304|#
    (return-from fifo_is_empty (funcall (field  fifo "empty") )) #|line 305|# #|line 306|#
    ) #|  Routing connection for a container component. The `direction` field has |# #|line 308|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 309|# #|  purposes, or for reading by other tools. |# #|line 310|# #|line 311|#
  (defun Connector (&optional )                             #|line 312|#
    (list
      (cons "direction"  nil)  #|  down, across, up, through |# #|line 313|#
      (cons "sender"  nil)                                  #|line 314|#
      (cons "receiver"  nil)                                #|line 315|#) #|line 316|#)
                                                            #|line 317|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 318|# #|  based on component ID (pointer) and port name. |# #|line 319|# #|line 320|#
  (defun Sender (&optional  name  component  port)          #|line 321|#
    (list
      (cons "name"  name)                                   #|line 322|#
      (cons "component"  component)  #|  from |#            #|line 323|#
      (cons "port"  port)  #|  from's port |#               #|line 324|#) #|line 325|#)
                                                            #|line 326|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 327|# #|  to incoming messages to this queue. |# #|line 328|# #|line 329|#
  (defun Receiver (&optional  name  queue  port  component) #|line 330|#
    (list
      (cons "name"  name)                                   #|line 331|#
      (cons "queue"  queue)  #|  queue (input | output) of receiver |# #|line 332|#
      (cons "port"  port)  #|  destination port |#          #|line 333|#
      (cons "component"  component)  #|  to (for bootstrap debug) |# #|line 334|#) #|line 335|#)
                                                            #|line 336|# #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 337|#
  (defun sender_eq (&optional  s1  s2)
    (declare (ignorable  s1  s2))                           #|line 338|#
    (let ((same_components ( equal   (field  s1 "component") (field  s2 "component"))))
      (declare (ignorable same_components))                 #|line 339|#
      (let ((same_ports ( equal   (field  s1 "port") (field  s2 "port"))))
        (declare (ignorable same_ports))                    #|line 340|#
        (return-from sender_eq ( and   same_components  same_ports)) #|line 341|#)) #|line 342|#
    ) #|  Delivers the given message to the receiver of this connector. |# #|line 344|# #|line 345|#
  (defun deposit (&optional  parent  conn  message)
    (declare (ignorable  parent  conn  message))            #|line 346|#
    (let ((new_message (funcall (quote make_message)  (field (field  conn "receiver") "port") (field  message "datum")  #|line 347|#)))
      (declare (ignorable new_message))
      (funcall (quote push_message)   parent (field (field  conn "receiver") "component") (field (field  conn "receiver") "queue")  new_message  #|line 348|#)) #|line 349|#
    )
  (defun force_tick (&optional  parent  eh)
    (declare (ignorable  parent  eh))                       #|line 351|#
    (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 352|#)))
      (declare (ignorable tick_msg))
      (funcall (quote push_message)   parent  eh (field  eh "inq")  tick_msg  #|line 353|#)
      (return-from force_tick  tick_msg)                    #|line 354|#) #|line 355|#
    )
  (defun push_message (&optional  parent  receiver  inq  m)
    (declare (ignorable  parent  receiver  inq  m))         #|line 357|#
    (enqueue  inq  m)                                       #|line 358|#
    (funcall (field (field  parent "visit_ordering") "put")   receiver  #|line 359|#) #|line 360|#
    )
  (defun is_self (&optional  child  container)
    (declare (ignorable  child  container))                 #|line 362|#
    #|  in an earlier version “self“ was denoted as ϕ |#    #|line 363|#
    (return-from is_self ( equal    child  container))      #|line 364|# #|line 365|#
    )
  (defun step_child (&optional  child  msg)
    (declare (ignorable  child  msg))                       #|line 367|#
    (let ((before_state (field  child "state")))
      (declare (ignorable before_state))                    #|line 368|#
      (funcall (field  child "handler")   child  msg        #|line 369|#)
      (let ((after_state (field  child "state")))
        (declare (ignorable after_state))                   #|line 370|#
        (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 371|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 372|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 373|#)) #|line 374|#
    )
  (defun save_message (&optional  eh  msg)
    (declare (ignorable  eh  msg))                          #|line 376|#
    (enqueue (field  eh "saved_messages")  msg)             #|line 377|# #|line 378|#
    )
  (defun fetch_saved_message_and_clear (&optional  eh)
    (declare (ignorable  eh))                               #|line 380|#
    (return-from fetch_saved_message_and_clear (dequeue (field  eh "saved_messages")) #|line 381|#) #|line 382|#
    )
  (defun step_children (&optional  container  causingMessage)
    (declare (ignorable  container  causingMessage))        #|line 384|#
    (setf (field  container "state")  "idle")               #|line 385|#
    (loop for child in (funcall (quote list)  (field (field  container "visit_ordering") "queue") )
      do
        (progn
          child                                             #|line 386|#
          #|  child = container represents self, skip it |# #|line 387|#
          (cond
            ((not (funcall (quote is_self)   child  container )) #|line 388|#
              (cond
                ((not (funcall (field (field  child "inq") "empty") )) #|line 389|#
                  (let ((msg (dequeue (field  child "inq")) #|line 390|#))
                    (declare (ignorable msg))
                    (let (( began_long_run  nil))
                      (declare (ignorable  began_long_run)) #|line 391|#
                      (let (( continued_long_run  nil))
                        (declare (ignorable  continued_long_run)) #|line 392|#
                        (let (( ended_long_run  nil))
                          (declare (ignorable  ended_long_run)) #|line 393|#
                          (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 394|#))
                          (cond
                            ( began_long_run                #|line 395|#
                              (funcall (quote save_message)   child  msg  #|line 396|#)
                              )
                            ( continued_long_run            #|line 397|#
                              #| pass |#                    #|line 398|# #|line 399|#
                              ))
                          (funcall (quote destroy_message)   msg ))))) #|line 400|#
                  )
                (t                                          #|line 401|#
                  (cond
                    ((not (equal  (field  child "state")  "idle")) #|line 402|#
                      (let ((msg (funcall (quote force_tick)   container  child  #|line 403|#)))
                        (declare (ignorable msg))
                        (funcall (field  child "handler")   child  msg  #|line 404|#)
                        (funcall (quote destroy_message)   msg ))
                      ))                                    #|line 405|#
                  ))                                        #|line 406|#
              (cond
                (( equal   (field  child "state")  "active") #|line 407|#
                  #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 408|#
                  (setf (field  container "state")  "active") #|line 409|#
                  ))                                        #|line 410|#
              (loop while (not (funcall (field (field  child "outq") "empty") ))
                do
                  (progn                                    #|line 411|#
                    (let ((msg (dequeue (field  child "outq")) #|line 412|#))
                      (declare (ignorable msg))
                      (funcall (quote route)   container  child  msg  #|line 413|#)
                      (funcall (quote destroy_message)   msg ))
                    ))
                ))                                          #|line 414|#
            ))                                              #|line 415|# #|line 416|# #|line 417|#
      )
    (defun attempt_tick (&optional  parent  eh)
      (declare (ignorable  parent  eh))                     #|line 419|#
      (cond
        ((not (equal  (field  eh "state")  "idle"))         #|line 420|#
          (funcall (quote force_tick)   parent  eh )        #|line 421|#
          ))                                                #|line 422|#
      )
    (defun is_tick (&optional  msg)
      (declare (ignorable  msg))                            #|line 424|#
      (return-from is_tick ( equal    "tick" (funcall (field (field  msg "datum") "kind") ))) #|line 425|# #|line 426|#
      ) #|  Routes a single message to all matching destinations, according to |# #|line 428|# #|  the container's connection network. |# #|line 429|# #|line 430|#
    (defun route (&optional  container  from_component  message)
      (declare (ignorable  container  from_component  message)) #|line 431|#
      (let (( was_sent  nil))
        (declare (ignorable  was_sent))
        #|  for checking that output went somewhere (at least during bootstrap) |# #|line 432|#
        (let (( fromname  ""))
          (declare (ignorable  fromname))                   #|line 433|#
          (cond
            ((funcall (quote is_tick)   message )           #|line 434|#
              (loop for child in (field  container "children")
                do
                  (progn
                    child                                   #|line 435|#
                    (funcall (quote attempt_tick)   container  child ) #|line 436|#
                    ))
              (setf  was_sent  t)                           #|line 437|#
              )
            (t                                              #|line 438|#
              (cond
                ((not (funcall (quote is_self)   from_component  container )) #|line 439|#
                  (setf  fromname (field  from_component "name")) #|line 440|#
                  ))
              (let ((from_sender (funcall (quote Sender)   fromname  from_component (field  message "port")  #|line 441|#)))
                (declare (ignorable from_sender))           #|line 442|#
                (loop for connector in (field  container "connections")
                  do
                    (progn
                      connector                             #|line 443|#
                      (cond
                        ((funcall (quote sender_eq)   from_sender (field  connector "sender") ) #|line 444|#
                          (funcall (quote deposit)   container  connector  message  #|line 445|#)
                          (setf  was_sent  t)
                          ))
                      )))                                   #|line 446|#
              ))
          (cond
            ((not  was_sent)                                #|line 447|#
              (funcall (quote print)   "\n\n*** Error: ***"  #|line 448|#)
              (funcall (quote print)   "***"                #|line 449|#)
              (funcall (quote print)   (concatenate 'string (field  container "name")  (concatenate 'string  ": message '"  (concatenate 'string (field  message "port")  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 450|#)
              (funcall (quote print)   "***"                #|line 451|#)
              (uiop:quit)                                   #|line 452|# #|line 453|#
              ))))                                          #|line 454|#
      )
    (defun any_child_ready (&optional  container)
      (declare (ignorable  container))                      #|line 456|#
      (loop for child in (field  container "children")
        do
          (progn
            child                                           #|line 457|#
            (cond
              ((funcall (quote child_is_ready)   child )    #|line 458|#
                (return-from any_child_ready  t)
                ))                                          #|line 459|#
            ))
      (return-from any_child_ready  nil)                    #|line 460|# #|line 461|#
      )
    (defun child_is_ready (&optional  eh)
      (declare (ignorable  eh))                             #|line 463|#
      (return-from child_is_ready ( or  ( or  ( or  (not (funcall (field (field  eh "outq") "empty") )) (not (funcall (field (field  eh "inq") "empty") ))) (not (equal  (field  eh "state")  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 464|# #|line 465|#
      )
    (defun append_routing_descriptor (&optional  container  desc)
      (declare (ignorable  container  desc))                #|line 467|#
      (enqueue (field  container "routings")  desc)         #|line 468|# #|line 469|#
      )
    (defun container_injector (&optional  container  message)
      (declare (ignorable  container  message))             #|line 471|#
      (funcall (quote container_handler)   container  message  #|line 472|#) #|line 473|#
      )





