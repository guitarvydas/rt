
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
                (setf (nth (dict-lookup   child_desc  "id")  children_by_id)  child_instance)) #|line 240|#
              ))
        (setf (field  container "children")  children)      #|line 241|#
        (let ((me  container))
          (declare (ignorable me))                          #|line 242|# #|line 243|#
          (let ((connectors  nil))
            (declare (ignorable connectors))                #|line 244|#
            (loop for proto_conn in (dict-lookup   desc  "connections")
              do
                (progn
                  proto_conn                                #|line 245|#
                  (let ((connector (funcall (quote Connector) )))
                    (declare (ignorable connector))         #|line 246|#
                    (cond
                      (( equal   (dict-lookup   proto_conn  "dir")  enumDown) #|line 247|#
                        #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 248|#
                        (setf (field  connector "direction")  "down") #|line 249|#
                        (setf (field  connector "sender") (funcall (quote Sender)  (field  me "name")  me (dict-lookup   proto_conn  "source_port")  #|line 250|#))
                        (let ((target_component (nth (dict-lookup   proto_conn (dict-lookup   "target"  "id"))  children_by_id)))
                          (declare (ignorable target_component)) #|line 251|#
                          (cond
                            (( equal    target_component  nil) #|line 252|#
                              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (dict-lookup   proto_conn  "target")) ) #|line 253|#
                              )
                            (t                              #|line 254|#
                              (setf (field  connector "receiver") (funcall (quote Receiver)  (field  target_component "name") (field  target_component "inq") (dict-lookup   proto_conn  "target_port")  target_component  #|line 255|#))
                              (funcall (field  connectors "append")   connector )
                              )))                           #|line 256|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumAcross) #|line 257|#
                        (setf (field  connector "direction")  "across") #|line 258|#
                        (let ((source_component (nth (dict-lookup   proto_conn (dict-lookup   "source"  "id"))  children_by_id)))
                          (declare (ignorable source_component)) #|line 259|#
                          (let ((target_component (nth (dict-lookup   proto_conn (dict-lookup   "target"  "id"))  children_by_id)))
                            (declare (ignorable target_component)) #|line 260|#
                            (cond
                              (( equal    source_component  nil) #|line 261|#
                                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (dict-lookup   proto_conn  "source")) ) #|line 262|#
                                )
                              (t                            #|line 263|#
                                (setf (field  connector "sender") (funcall (quote Sender)  (field  source_component "name")  source_component (dict-lookup   proto_conn  "source_port")  #|line 264|#))
                                (cond
                                  (( equal    target_component  nil) #|line 265|#
                                    (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (field  proto_conn "target")) ) #|line 266|#
                                    )
                                  (t                        #|line 267|#
                                    (setf (field  connector "receiver") (funcall (quote Receiver)  (field  target_component "name") (field  target_component "inq") (dict-lookup   proto_conn  "target_port")  target_component  #|line 268|#))
                                    (funcall (field  connectors "append")   connector )
                                    ))
                                ))))                        #|line 269|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumUp) #|line 270|#
                        (setf (field  connector "direction")  "up") #|line 271|#
                        (let ((source_component (nth (dict-lookup   proto_conn (dict-lookup   "source"  "id"))  children_by_id)))
                          (declare (ignorable source_component)) #|line 272|#
                          (cond
                            (( equal    source_component  nil) #|line 273|#
                              (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (dict-lookup   proto_conn  "source")) ) #|line 274|#
                              )
                            (t                              #|line 275|#
                              (setf (field  connector "sender") (funcall (quote Sender)  (field  source_component "name")  source_component (dict-lookup   proto_conn  "source_port")  #|line 276|#))
                              (setf (field  connector "receiver") (funcall (quote Receiver)  (field  me "name") (field  container "outq") (dict-lookup   proto_conn  "target_port")  me  #|line 277|#))
                              (funcall (field  connectors "append")   connector )
                              )))                           #|line 278|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumThrough) #|line 279|#
                        (setf (field  connector "direction")  "through") #|line 280|#
                        (setf (field  connector "sender") (funcall (quote Sender)  (field  me "name")  me (dict-lookup   proto_conn  "source_port")  #|line 281|#))
                        (setf (field  connector "receiver") (funcall (quote Receiver)  (field  me "name") (field  container "outq") (dict-lookup   proto_conn  "target_port")  me  #|line 282|#))
                        (funcall (field  connectors "append")   connector )
                        )))                                 #|line 283|#
                  ))                                        #|line 284|#
            (setf (field  container "connections")  connectors) #|line 285|#
            (return-from container_instantiator  container) #|line 286|#))))) #|line 287|#
  ) #|  The default handler for container components. |#    #|line 289|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 290|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 291|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 292|#
        (funcall (quote step_children)   container  message ) #|line 293|#
        ))                                                  #|line 294|#
    ) #|  Frees the given container and associated data. |# #|line 296|#
  (defun destroy_container (&optional  eh)
    (declare (ignorable  eh))                               #|line 297|#
    #| pass |#                                              #|line 298|# #|line 299|#
    )
  (defun fifo_is_empty (&optional  fifo)
    (declare (ignorable  fifo))                             #|line 301|#
    (return-from fifo_is_empty (funcall (field  fifo "empty") )) #|line 302|# #|line 303|#
    ) #|  Routing connection for a container component. The `direction` field has |# #|line 305|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 306|# #|  purposes, or for reading by other tools. |# #|line 307|# #|line 308|#
  (defun Connector (&optional )                             #|line 309|#
    (list
      (cons "direction"  nil)  #|  down, across, up, through |# #|line 310|#
      (cons "sender"  nil)                                  #|line 311|#
      (cons "receiver"  nil)                                #|line 312|#) #|line 313|#)
                                                            #|line 314|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 315|# #|  based on component ID (pointer) and port name. |# #|line 316|# #|line 317|#
  (defun Sender (&optional  name  component  port)          #|line 318|#
    (list
      (cons "name"  name)                                   #|line 319|#
      (cons "component"  component)  #|  from |#            #|line 320|#
      (cons "port"  port)  #|  from's port |#               #|line 321|#) #|line 322|#)
                                                            #|line 323|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 324|# #|  to incoming messages to this queue. |# #|line 325|# #|line 326|#
  (defun Receiver (&optional  name  queue  port  component) #|line 327|#
    (list
      (cons "name"  name)                                   #|line 328|#
      (cons "queue"  queue)  #|  queue (input | output) of receiver |# #|line 329|#
      (cons "port"  port)  #|  destination port |#          #|line 330|#
      (cons "component"  component)  #|  to (for bootstrap debug) |# #|line 331|#) #|line 332|#)
                                                            #|line 333|# #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 334|#
  (defun sender_eq (&optional  s1  s2)
    (declare (ignorable  s1  s2))                           #|line 335|#
    (let ((same_components ( equal   (field  s1 "component") (field  s2 "component"))))
      (declare (ignorable same_components))                 #|line 336|#
      (let ((same_ports ( equal   (field  s1 "port") (field  s2 "port"))))
        (declare (ignorable same_ports))                    #|line 337|#
        (return-from sender_eq ( and   same_components  same_ports)) #|line 338|#)) #|line 339|#
    ) #|  Delivers the given message to the receiver of this connector. |# #|line 341|# #|line 342|#
  (defun deposit (&optional  parent  conn  message)
    (declare (ignorable  parent  conn  message))            #|line 343|#
    (let ((new_message (funcall (quote make_message)  (field (field  conn "receiver") "port") (field  message "datum")  #|line 344|#)))
      (declare (ignorable new_message))
      (funcall (quote push_message)   parent (field (field  conn "receiver") "component") (field (field  conn "receiver") "queue")  new_message  #|line 345|#)) #|line 346|#
    )
  (defun force_tick (&optional  parent  eh)
    (declare (ignorable  parent  eh))                       #|line 348|#
    (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 349|#)))
      (declare (ignorable tick_msg))
      (funcall (quote push_message)   parent  eh (field  eh "inq")  tick_msg  #|line 350|#)
      (return-from force_tick  tick_msg)                    #|line 351|#) #|line 352|#
    )
  (defun push_message (&optional  parent  receiver  inq  m)
    (declare (ignorable  parent  receiver  inq  m))         #|line 354|#
    (enqueue  inq  m)                                       #|line 355|#
    (funcall (field (field  parent "visit_ordering") "put")   receiver  #|line 356|#) #|line 357|#
    )
  (defun is_self (&optional  child  container)
    (declare (ignorable  child  container))                 #|line 359|#
    #|  in an earlier version “self“ was denoted as ϕ |#    #|line 360|#
    (return-from is_self ( equal    child  container))      #|line 361|# #|line 362|#
    )
  (defun step_child (&optional  child  msg)
    (declare (ignorable  child  msg))                       #|line 364|#
    (let ((before_state (field  child "state")))
      (declare (ignorable before_state))                    #|line 365|#
      (funcall (field  child "handler")   child  msg        #|line 366|#)
      (let ((after_state (field  child "state")))
        (declare (ignorable after_state))                   #|line 367|#
        (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 368|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 369|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 370|#)) #|line 371|#
    )
  (defun save_message (&optional  eh  msg)
    (declare (ignorable  eh  msg))                          #|line 373|#
    (enqueue (field  eh "saved_messages")  msg)             #|line 374|# #|line 375|#
    )
  (defun fetch_saved_message_and_clear (&optional  eh)
    (declare (ignorable  eh))                               #|line 377|#
    (return-from fetch_saved_message_and_clear (dequeue (field  eh "saved_messages")) #|line 378|#) #|line 379|#
    )
  (defun step_children (&optional  container  causingMessage)
    (declare (ignorable  container  causingMessage))        #|line 381|#
    (setf (field  container "state")  "idle")               #|line 382|#
    (loop for child in (funcall (quote list)  (field (field  container "visit_ordering") "queue") )
      do
        (progn
          child                                             #|line 383|#
          #|  child = container represents self, skip it |# #|line 384|#
          (cond
            ((not (funcall (quote is_self)   child  container )) #|line 385|#
              (cond
                ((not (funcall (field (field  child "inq") "empty") )) #|line 386|#
                  (let ((msg (dequeue (field  child "inq")) #|line 387|#))
                    (declare (ignorable msg))
                    (let (( began_long_run  nil))
                      (declare (ignorable  began_long_run)) #|line 388|#
                      (let (( continued_long_run  nil))
                        (declare (ignorable  continued_long_run)) #|line 389|#
                        (let (( ended_long_run  nil))
                          (declare (ignorable  ended_long_run)) #|line 390|#
                          (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 391|#))
                          (cond
                            ( began_long_run                #|line 392|#
                              (funcall (quote save_message)   child  msg  #|line 393|#)
                              )
                            ( continued_long_run            #|line 394|#
                              #| pass |#                    #|line 395|# #|line 396|#
                              ))
                          (funcall (quote destroy_message)   msg ))))) #|line 397|#
                  )
                (t                                          #|line 398|#
                  (cond
                    ((not (equal  (field  child "state")  "idle")) #|line 399|#
                      (let ((msg (funcall (quote force_tick)   container  child  #|line 400|#)))
                        (declare (ignorable msg))
                        (funcall (field  child "handler")   child  msg  #|line 401|#)
                        (funcall (quote destroy_message)   msg ))
                      ))                                    #|line 402|#
                  ))                                        #|line 403|#
              (cond
                (( equal   (field  child "state")  "active") #|line 404|#
                  #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 405|#
                  (setf (field  container "state")  "active") #|line 406|#
                  ))                                        #|line 407|#
              (loop while (not (funcall (field (field  child "outq") "empty") ))
                do
                  (progn                                    #|line 408|#
                    (let ((msg (dequeue (field  child "outq")) #|line 409|#))
                      (declare (ignorable msg))
                      (funcall (quote route)   container  child  msg  #|line 410|#)
                      (funcall (quote destroy_message)   msg ))
                    ))
                ))                                          #|line 411|#
            ))                                              #|line 412|# #|line 413|# #|line 414|#
      )
    (defun attempt_tick (&optional  parent  eh)
      (declare (ignorable  parent  eh))                     #|line 416|#
      (cond
        ((not (equal  (field  eh "state")  "idle"))         #|line 417|#
          (funcall (quote force_tick)   parent  eh )        #|line 418|#
          ))                                                #|line 419|#
      )
    (defun is_tick (&optional  msg)
      (declare (ignorable  msg))                            #|line 421|#
      (return-from is_tick ( equal    "tick" (funcall (field (field  msg "datum") "kind") ))) #|line 422|# #|line 423|#
      ) #|  Routes a single message to all matching destinations, according to |# #|line 425|# #|  the container's connection network. |# #|line 426|# #|line 427|#
    (defun route (&optional  container  from_component  message)
      (declare (ignorable  container  from_component  message)) #|line 428|#
      (let (( was_sent  nil))
        (declare (ignorable  was_sent))
        #|  for checking that output went somewhere (at least during bootstrap) |# #|line 429|#
        (let (( fromname  ""))
          (declare (ignorable  fromname))                   #|line 430|#
          (cond
            ((funcall (quote is_tick)   message )           #|line 431|#
              (loop for child in (field  container "children")
                do
                  (progn
                    child                                   #|line 432|#
                    (funcall (quote attempt_tick)   container  child ) #|line 433|#
                    ))
              (setf  was_sent  t)                           #|line 434|#
              )
            (t                                              #|line 435|#
              (cond
                ((not (funcall (quote is_self)   from_component  container )) #|line 436|#
                  (setf  fromname (field  from_component "name")) #|line 437|#
                  ))
              (let ((from_sender (funcall (quote Sender)   fromname  from_component (field  message "port")  #|line 438|#)))
                (declare (ignorable from_sender))           #|line 439|#
                (loop for connector in (field  container "connections")
                  do
                    (progn
                      connector                             #|line 440|#
                      (cond
                        ((funcall (quote sender_eq)   from_sender (field  connector "sender") ) #|line 441|#
                          (funcall (quote deposit)   container  connector  message  #|line 442|#)
                          (setf  was_sent  t)
                          ))
                      )))                                   #|line 443|#
              ))
          (cond
            ((not  was_sent)                                #|line 444|#
              (funcall (quote print)   "\n\n*** Error: ***"  #|line 445|#)
              (funcall (quote print)   "***"                #|line 446|#)
              (funcall (quote print)   (concatenate 'string (field  container "name")  (concatenate 'string  ": message '"  (concatenate 'string (field  message "port")  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 447|#)
              (funcall (quote print)   "***"                #|line 448|#)
              (uiop:quit)                                   #|line 449|# #|line 450|#
              ))))                                          #|line 451|#
      )
    (defun any_child_ready (&optional  container)
      (declare (ignorable  container))                      #|line 453|#
      (loop for child in (field  container "children")
        do
          (progn
            child                                           #|line 454|#
            (cond
              ((funcall (quote child_is_ready)   child )    #|line 455|#
                (return-from any_child_ready  t)
                ))                                          #|line 456|#
            ))
      (return-from any_child_ready  nil)                    #|line 457|# #|line 458|#
      )
    (defun child_is_ready (&optional  eh)
      (declare (ignorable  eh))                             #|line 460|#
      (return-from child_is_ready ( or  ( or  ( or  (not (funcall (field (field  eh "outq") "empty") )) (not (funcall (field (field  eh "inq") "empty") ))) (not (equal  (field  eh "state")  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 461|# #|line 462|#
      )
    (defun append_routing_descriptor (&optional  container  desc)
      (declare (ignorable  container  desc))                #|line 464|#
      (enqueue (field  container "routings")  desc)         #|line 465|# #|line 466|#
      )
    (defun container_injector (&optional  container  message)
      (declare (ignorable  container  message))             #|line 468|#
      (funcall (quote container_handler)   container  message  #|line 469|#) #|line 470|#
      )





