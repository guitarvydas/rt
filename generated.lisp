
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






                                                            #|line 1|# #|line 2|# #|line 3|#
(defun Component_Registry (&optional )                      #|line 4|#
  (list
    (cons "templates"  nil)                                 #|line 5|#) #|line 6|#)
                                                            #|line 7|#
(defun Template (&optional  name  template_data  instantiator) #|line 8|#
  (list
    (cons "name"  name)                                     #|line 9|#
    (cons "template_data"  template_data)                   #|line 10|#
    (cons "instantiator"  instantiator)                     #|line 11|#) #|line 12|#)
                                                            #|line 13|#
(defun read_and_convert_json_file (&optional  pathname  filename)
  (declare (ignorable  pathname  filename))                 #|line 14|#

  ;; read json from a named file and convert it into internal form (a list of Container alists)
  (with-open-file (f (format nil "~a/~a.lisp" pathname filename) :direction :input)
    (read f))
                                                            #|line 15|# #|line 16|#
  )
(defun json2internal (&optional  pathname  container_xml)
  (declare (ignorable  pathname  container_xml))            #|line 18|#
  (let ((fname  container_xml                               #|line 19|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   pathname  fname  #|line 20|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                 #|line 21|#)) #|line 22|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                  #|line 24|#
  #| pass |#                                                #|line 25|# #|line 26|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 28|#
  (return-from make_component_registry (funcall (quote Component_Registry) )) #|line 29|# #|line 30|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template  nil )) #|line 32|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (funcall (quote abstracted_register_component)   reg  template  t )) #|line 33|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))     #|line 35|#
  (let ((name (funcall (quote mangle_name)  (field  template "name")  #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  (dict-in?  name (field  reg "templates")) (not  ok_to_overwrite)) #|line 37|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (field  template "name")  "/ already declared"))  #|line 38|#)
        (return-from abstracted_register_component  reg)    #|line 39|#
        )
      (t                                                    #|line 40|#
        (setf (field  reg "templates") (cons (cons  name  template) (field  reg "templates"))) #|line 41|#
        (return-from abstracted_register_component  reg)    #|line 42|# #|line 43|#
        )))                                                 #|line 44|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 46|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 47|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (field  reg "templates")) #|line 48|#
        (let ((template (dict-lookup  (field  reg "templates")  template_name)))
          (declare (ignorable template))                    #|line 49|#
          (cond
            (( equal    template  nil)                      #|line 50|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can;t find component /"  (concatenate 'string  template_name  "/"))  #|line 51|#)
              (return-from get_component_instance  nil)     #|line 52|#
              )
            (t                                              #|line 53|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 54|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 55|#
                  (cond
                    ((not (equal   nil  owner))             #|line 56|#
                      (setf  owner_name (field  owner "name")) #|line 57|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 58|#
                      )
                    (t                                      #|line 59|#
                      (setf  instance_name  template_name)  #|line 60|#
                      ))
                  (let ((instance (funcall (field  template "instantiator")   reg  owner  instance_name (field  template "template_data")  #|line 61|#)))
                    (declare (ignorable instance))
                    (setf (field  instance "depth") (funcall (quote calculate_depth)   instance  #|line 62|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 63|#
        )
      (t                                                    #|line 64|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 65|#)
        (return-from get_component_instance  nil)           #|line 66|#
        )))                                                 #|line 67|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 68|#
  (cond
    (( equal   (field  eh "owner")  nil)                    #|line 69|#
      (return-from calculate_depth  0)                      #|line 70|#
      )
    (t                                                      #|line 71|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (field  eh "owner") ))) #|line 72|#
      ))                                                    #|line 73|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 75|#
  (funcall (quote nl) )                                     #|line 76|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 77|#
  (loop for c in (field  reg "templates")
    do
      (progn
        c                                                   #|line 78|#
        (funcall (quote print)  (field  c "name") )         #|line 79|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 80|#
  (funcall (quote nl) )                                     #|line 81|# #|line 82|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 84|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (field  reg "stats"))) #|line 85|# #|line 86|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 88|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 89|#
  (return-from mangle_name  s)                              #|line 90|# #|line 91|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 93|#
  #|  [ |#                                                  #|line 94|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 95|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 96|#
  #|  ] |#                                                  #|line 97|#
  (cond
    ((not (equal   nil  container_list))                    #|line 98|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 99|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 100|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 101|#
            (loop for child_descriptor in (dict-lookup   diagram  "children")
              do
                (progn
                  child_descriptor                          #|line 102|#
                  (cond
                    ((funcall (quote first_char_is)  (dict-lookup   child_descriptor  "name")  "$" ) #|line 103|#
                      (let ((name (dict-lookup   child_descriptor  "name")))
                        (declare (ignorable name))          #|line 104|#
                        (let ((cmd (funcall (field  (subseq  name 1) "strip") )))
                          (declare (ignorable cmd))         #|line 105|#
                          (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 106|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 107|#))))
                      )
                    ((funcall (quote first_char_is)  (dict-lookup   child_descriptor  "name")  "'" ) #|line 108|#
                      (let ((name (dict-lookup   child_descriptor  "name")))
                        (declare (ignorable name))          #|line 109|#
                        (let ((s  (subseq  name 1)          #|line 110|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 111|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 112|#)))) #|line 113|#
                      ))                                    #|line 114|#
                  ))                                        #|line 115|#
            ))                                              #|line 116|#
      ))
  (return-from generate_shell_components  reg)              #|line 117|# #|line 118|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 120|#
  (return-from first_char  (char  s 0)                      #|line 121|#) #|line 122|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 124|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 125|#))) #|line 126|#
  )                                                         #|line 128|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 129|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 130|# #|line 131|# #|line 132|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 133|# #|  and output queues of messages. |# #|line 134|# #|  |# #|line 135|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 136|# #|  that routes messages to child components according to a list of connections |# #|line 137|# #|  that serve as a message routing table. |# #|line 138|# #|  |# #|line 139|# #|  Child components themselves can be leaves or other containers. |# #|line 140|# #|  |# #|line 141|# #|  `handler` invokes the code that is attached to this component. |# #|line 142|# #|  |# #|line 143|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 144|# #|  function may want whenever it is invoked again. |# #|line 145|# #|  |# #|line 146|# #|line 147|# #|  Eh_States :: enum { idle, active } |# #|line 148|#
(defun Eh (&optional )                                      #|line 149|#
  (list
    (cons "name"  "")                                       #|line 150|#
    (cons "inq"  (make-instance 'Queue)                     #|line 151|#)
    (cons "outq"  (make-instance 'Queue)                    #|line 152|#)
    (cons "owner"  nil)                                     #|line 153|#
    (cons "saved_messages"  nil)  #|  stack of saved message(s) |# #|line 154|#
    (cons "children"  nil)                                  #|line 155|#
    (cons "visit_ordering"  (make-instance 'Queue)          #|line 156|#)
    (cons "connections"  nil)                               #|line 157|#
    (cons "routings"  (make-instance 'Queue)                #|line 158|#)
    (cons "handler"  nil)                                   #|line 159|#
    (cons "inject"  nil)                                    #|line 160|#
    (cons "instance_data"  nil)                             #|line 161|#
    (cons "state"  "idle")                                  #|line 162|# #|  bootstrap debugging |# #|line 163|#
    (cons "kind"  nil)  #|  enum { container, leaf, } |#    #|line 164|#
    (cons "trace"  nil)  #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |# #|line 165|#
    (cons "depth"  0)  #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |# #|line 166|#) #|line 167|#)
                                                            #|line 168|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 169|# #|  whose handler function is `container_handler`. |# #|line 170|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 171|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 172|#
    (setf (field  eh "name")  name)                         #|line 173|#
    (setf (field  eh "owner")  owner)                       #|line 174|#
    (setf (field  eh "handler")  #'container_handler)       #|line 175|#
    (setf (field  eh "inject")  #'container_injector)       #|line 176|#
    (setf (field  eh "state")  "idle")                      #|line 177|#
    (setf (field  eh "kind")  "container")                  #|line 178|#
    (return-from make_container  eh)                        #|line 179|#) #|line 180|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 182|# #|  that will be passed back to your handler when called. |# #|line 183|# #|line 184|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 185|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 186|#
    (setf (field  eh "name")  (concatenate 'string (field  owner "name")  (concatenate 'string  "."  name)) #|line 187|#)
    (setf (field  eh "owner")  owner)                       #|line 188|#
    (setf (field  eh "handler")  handler)                   #|line 189|#
    (setf (field  eh "instance_data")  instance_data)       #|line 190|#
    (setf (field  eh "state")  "idle")                      #|line 191|#
    (setf (field  eh "kind")  "leaf")                       #|line 192|#
    (return-from make_leaf  eh)                             #|line 193|#) #|line 194|#
  ) #|  Sends a message on the given `port` with `data`, placing it on the output |# #|line 196|# #|  of the given component. |# #|line 197|# #|line 198|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))    #|line 199|#
  (let ((msg (funcall (quote make_message)   port  datum    #|line 200|#)))
    (declare (ignorable msg))
    (funcall (quote put_output)   eh  msg                   #|line 201|#)) #|line 202|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))        #|line 204|#
  (let ((datum (funcall (quote new_datum_string)   s        #|line 205|#)))
    (declare (ignorable datum))
    (let ((msg (funcall (quote make_message)   port  datum  #|line 206|#)))
      (declare (ignorable msg))
      (funcall (quote put_output)   eh  msg                 #|line 207|#))) #|line 208|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                      #|line 210|#
  (let ((fwdmsg (funcall (quote make_message)   port (field  msg "datum")  #|line 211|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 212|#)) #|line 213|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 215|#
  (funcall (field  eh "inject")   eh  msg                   #|line 216|#) #|line 217|#
  ) #|  Returns a list of all output messages on a container. |# #|line 219|# #|  For testing / debugging purposes. |# #|line 220|# #|line 221|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 222|#
  (return-from output_list (field  eh "outq"))              #|line 223|# #|line 224|#
  ) #|  Utility for printing an array of messages. |#       #|line 226|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 227|#
  (loop for m in (funcall (quote list)  (field (field  eh "outq") "queue") )
    do
      (progn
        m                                                   #|line 228|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 229|#
        ))                                                  #|line 230|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 232|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 233|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 234|#
          (setf  s (+  s  " "))                             #|line 235|#
          ))
    (return-from spaces  s)                                 #|line 236|#) #|line 237|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 239|#
  (setf (field  eh "state")  "active")                      #|line 240|# #|line 241|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 243|#
  (setf (field  eh "state")  "idle")                        #|line 244|# #|line 245|#
  ) #|  Utility for printing a specific output message. |#  #|line 247|# #|line 248|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 249|#
  (loop for msg in (funcall (quote list)  (field (field  eh "outq") "queue") )
    do
      (progn
        msg                                                 #|line 250|#
        (cond
          (( equal   (field  msg "port")  port)             #|line 251|#
            (return-from fetch_first_output (field  msg "datum"))
            ))                                              #|line 252|#
        ))
  (return-from fetch_first_output  nil)                     #|line 253|# #|line 254|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 256|#
  #|  port ∷ “” |#                                          #|line 257|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 258|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (field  datum "srepr") )) #|line 259|#) #|line 260|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 261|#
  #|  port ∷ “” |#                                          #|line 262|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 263|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 264|#
    (format *error-output* "~a" (funcall (field  datum "srepr") )) #|line 265|#) #|line 266|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 268|#
  (funcall (field (field  eh "outq") "put")   msg           #|line 269|#) #|line 270|#
  )
(defparameter  root_project  "")                            #|line 272|#
(defparameter  root_0D  "")                                 #|line 273|# #|line 274|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 275|# #|line 276|# #|line 277|#
  (setf  root_project  rproject)                            #|line 278|#
  (setf  root_0D  r0D)                                      #|line 279|# #|line 280|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 282|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 283|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 284|#))) #|line 285|#
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
  (let ((s (funcall (field (field  msg "datum") "srepr") )))
    (declare (ignorable s))                                 #|line 302|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (field  eh "name")  (concatenate 'string  ": "  s)))) #|line 303|#) #|line 304|#
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
(defun TwoMessages (&optional  first  second)               #|line 315|#
  (list
    (cons "first"  first)                                   #|line 316|#
    (cons "second"  second)                                 #|line 317|#) #|line 318|#)
                                                            #|line 319|# #|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |# #|line 320|#
(defun Deracer_Instance_Data (&optional  state  buffer)     #|line 321|#
  (list
    (cons "state"  state)                                   #|line 322|#
    (cons "buffer"  buffer)                                 #|line 323|#) #|line 324|#)
                                                            #|line 325|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 326|#
  #| pass |#                                                #|line 327|# #|line 328|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 330|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 331|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Deracer_Instance_Data)   "idle" (funcall (quote TwoMessages)   nil  nil )  #|line 332|#)))
      (declare (ignorable inst))
      (setf (field  inst "state")  "idle")                  #|line 333|#
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 334|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 335|#))) #|line 336|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 338|#
  (funcall (quote forward)   eh  "1" (field (field  inst "buffer") "first")  #|line 339|#)
  (funcall (quote forward)   eh  "2" (field (field  inst "buffer") "second")  #|line 340|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 341|#) #|line 342|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 344|#
  (let (( inst (field  eh "instance_data")))
    (declare (ignorable  inst))                             #|line 345|#
    (cond
      (( equal   (field  inst "state")  "idle")             #|line 346|#
        (cond
          (( equal    "1" (field  msg "port"))              #|line 347|#
            (setf (field (field  inst "buffer") "first")  msg) #|line 348|#
            (setf (field  inst "state")  "waitingForSecond") #|line 349|#
            )
          (( equal    "2" (field  msg "port"))              #|line 350|#
            (setf (field (field  inst "buffer") "second")  msg) #|line 351|#
            (setf (field  inst "state")  "waitingForFirst") #|line 352|#
            )
          (t                                                #|line 353|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (field  msg "port")) )
            ))                                              #|line 354|#
        )
      (( equal   (field  inst "state")  "waitingForFirst")  #|line 355|#
        (cond
          (( equal    "1" (field  msg "port"))              #|line 356|#
            (setf (field (field  inst "buffer") "first")  msg) #|line 357|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 358|#)
            (setf (field  inst "state")  "idle")            #|line 359|#
            )
          (t                                                #|line 360|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (field  msg "port")) )
            ))                                              #|line 361|#
        )
      (( equal   (field  inst "state")  "waitingForSecond") #|line 362|#
        (cond
          (( equal    "2" (field  msg "port"))              #|line 363|#
            (setf (field (field  inst "buffer") "second")  msg) #|line 364|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 365|#)
            (setf (field  inst "state")  "idle")            #|line 366|#
            )
          (t                                                #|line 367|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (field  msg "port")) )
            ))                                              #|line 368|#
        )
      (t                                                    #|line 369|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 370|#
        )))                                                 #|line 371|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 373|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 374|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 375|#))) #|line 376|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 378|#
  (let ((fname (funcall (field (field  msg "datum") "srepr") )))
    (declare (ignorable fname))                             #|line 379|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 380|#) #|line 381|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 383|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 384|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 385|#))) #|line 386|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 388|#
  (cond
    (( equal    "string" (funcall (field (field  msg "datum") "kind") )) #|line 389|#
      (funcall (quote forward)   eh  ""  msg )              #|line 390|#
      )
    (t                                                      #|line 391|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (field  msg "datum")) #|line 392|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 393|#
      ))                                                    #|line 394|#
  )
(defun Syncfilewrite_Data (&optional )                      #|line 396|#
  (list
    (cons "filename"  "")                                   #|line 397|#) #|line 398|#)
                                                            #|line 399|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 400|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 401|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 402|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Syncfilewrite_Data) )))
      (declare (ignorable inst))                            #|line 403|#
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 404|#)))) #|line 405|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 407|#
  (let (( inst (field  eh "instance_data")))
    (declare (ignorable  inst))                             #|line 408|#
    (cond
      (( equal    "filename" (field  msg "port"))           #|line 409|#
        (setf (field  inst "filename") (funcall (field (field  msg "datum") "srepr") )) #|line 410|#
        )
      (( equal    "input" (field  msg "port"))              #|line 411|#
        (let ((contents (funcall (field (field  msg "datum") "srepr") )))
          (declare (ignorable contents))                    #|line 412|#
          (let (( f (funcall (quote open)  (field  inst "filename")  "w"  #|line 413|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 414|#
                (funcall (field  f "write")  (funcall (field (field  msg "datum") "srepr") )  #|line 415|#)
                (funcall (field  f "close") )               #|line 416|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 417|#
                )
              (t                                            #|line 418|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (field  inst "filename"))  msg )
                ))))                                        #|line 419|#
        )))                                                 #|line 420|#
  )
(defun StringConcat_Instance_Data (&optional )              #|line 422|#
  (list
    (cons "buffer1"  nil)                                   #|line 423|#
    (cons "buffer2"  nil)                                   #|line 424|#
    (cons "count"  0)                                       #|line 425|#) #|line 426|#)
                                                            #|line 427|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 428|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 429|#)))
    (declare (ignorable name_with_id))
    (let ((instp (funcall (quote StringConcat_Instance_Data) )))
      (declare (ignorable instp))                           #|line 430|#
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 431|#)))) #|line 432|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 434|#
  (let (( inst (field  eh "instance_data")))
    (declare (ignorable  inst))                             #|line 435|#
    (cond
      (( equal    "1" (field  msg "port"))                  #|line 436|#
        (setf (field  inst "buffer1") (funcall (quote clone_string)  (funcall (field (field  msg "datum") "srepr") )  #|line 437|#))
        (setf (field  inst "count") (+ (field  inst "count")  1)) #|line 438|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 439|#
        )
      (( equal    "2" (field  msg "port"))                  #|line 440|#
        (setf (field  inst "buffer2") (funcall (quote clone_string)  (funcall (field (field  msg "datum") "srepr") )  #|line 441|#))
        (setf (field  inst "count") (+ (field  inst "count")  1)) #|line 442|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 443|#
        )
      (t                                                    #|line 444|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (field  msg "port"))  #|line 445|#) #|line 446|#
        )))                                                 #|line 447|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 449|#
  (cond
    (( and  ( equal    0 (length (field  inst "buffer1"))) ( equal    0 (length (field  inst "buffer2")))) #|line 450|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 451|#
      ))
  (cond
    (( >=  (field  inst "count")  2)                        #|line 452|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 453|#
        (cond
          (( equal    0 (length (field  inst "buffer1")))   #|line 454|#
            (setf  concatenated_string (field  inst "buffer2")) #|line 455|#
            )
          (( equal    0 (length (field  inst "buffer2")))   #|line 456|#
            (setf  concatenated_string (field  inst "buffer1")) #|line 457|#
            )
          (t                                                #|line 458|#
            (setf  concatenated_string (+ (field  inst "buffer1") (field  inst "buffer2"))) #|line 459|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 460|#)
        (setf (field  inst "buffer1")  nil)                 #|line 461|#
        (setf (field  inst "buffer2")  nil)                 #|line 462|#
        (setf (field  inst "count")  0))                    #|line 463|#
      ))                                                    #|line 464|#
  ) #|  |#                                                  #|line 466|# #|line 467|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 468|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 469|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 470|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 471|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 472|#)))) #|line 473|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 475|#
  (let ((cmd (field  eh "instance_data")))
    (declare (ignorable cmd))                               #|line 476|#
    (let ((s (funcall (field (field  msg "datum") "srepr") )))
      (declare (ignorable s))                               #|line 477|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 478|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 479|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 480|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 481|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 482|#
              (cond
                ((not (equal   rc  0))                      #|line 483|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 484|#)
                  )
                (t                                          #|line 485|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 486|#) #|line 487|#
                  ))))))))                                  #|line 488|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 490|# #|line 491|# #|line 492|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 493|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 494|#
      (cond
        ((not (equal   root_project  ""))                   #|line 495|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 496|#) #|line 497|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 498|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 499|#) #|line 500|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 501|#)))) #|line 502|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 504|#
  (let ((s (field  eh "instance_data")))
    (declare (ignorable s))                                 #|line 505|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 506|#)) #|line 507|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 509|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 510|#
  (return-from string_make_persistent  s)                   #|line 511|# #|line 512|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 514|#
  (return-from string_clone  s)                             #|line 515|# #|line 516|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 518|# #|  where ${_00_} is the root directory for the project |# #|line 519|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 520|# #|line 521|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 522|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 523|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 524|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 525|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 526|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 527|#
                  (funcall (quote register_component)   reg (funcall (quote Template)  (dict-lookup   container  "name")  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator )  #|line 528|#) #|line 529|#
                  )))                                       #|line 530|#
          ))
    (format *standard-output* "~a"  reg)                    #|line 531|#
    (setf  reg (funcall (quote initialize_stock_components)   reg  #|line 532|#))
    (return-from initialize_component_palette  reg)         #|line 533|#) #|line 534|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 536|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 537|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 538|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (field  err "srepr") ) )))) #|line 539|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 540|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 541|#
          ))))                                              #|line 542|#
  ) #|  debugging helpers |#                                #|line 544|# #|line 545|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 546|#
  (format *standard-output* "~a"  "")                       #|line 547|# #|line 548|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 550|#
  (funcall (quote nl) )                                     #|line 551|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 552|#
  (funcall (quote print_output_list)   main_container       #|line 553|#) #|line 554|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 556|#
  #|  remove whitespace from front and back of string |#    #|line 557|#
  (return-from trimws (funcall (field  s "strip") ))        #|line 558|# #|line 559|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 561|#
  (return-from clone_string  s                              #|line 562|# #|line 563|#) #|line 564|#
  )
(defparameter  load_errors  nil)                            #|line 565|#
(defparameter  runtime_errors  nil)                         #|line 566|# #|line 567|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 568|# #|line 569|#
  (format *standard-output* "~a"  s)                        #|line 570|#
  (format *standard-output* "
  ")                                                        #|line 571|#
  (setf  load_errors  t)                                    #|line 572|# #|line 573|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 575|# #|line 576|#
  (format *standard-output* "~a"  s)                        #|line 577|#
  (setf  runtime_errors  t)                                 #|line 578|# #|line 579|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 581|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 582|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 583|#))) #|line 584|#
  )
(defparameter  rand  0)                                     #|line 586|# #|line 587|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 588|# #|line 589|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |# #|line 590|#
  (funcall (quote send_string)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg  #|line 591|#) #|line 592|#
  )                                                         #|line 594|# #|  all of the the built_in leaves are listed here |# #|line 595|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 596|# #|line 597|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 598|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 599|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?"  nil  #'probe_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?A"  nil  #'probeA_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?B"  nil  #'probeB_instantiate )  #|line 602|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?C"  nil  #'probeC_instantiate )  #|line 603|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "trash"  nil  #'trash_instantiate )  #|line 604|#) #|line 605|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 606|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 607|#) #|line 608|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 609|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 610|#)
  #|  for fakepipe |#                                       #|line 611|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 612|#) #|line 613|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 615|#

  (get-main-args)
                                                            #|line 616|# #|line 617|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 619|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 620|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 621|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 622|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 623|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 624|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 625|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 626|#)))))) #|line 627|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 629|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 630|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 631|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 632|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 633|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 634|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 635|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 636|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 637|#)
            #|  get entrypoint container |#                 #|line 638|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 639|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 640|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 644|#) #|line 645|#
                  ))
              (cond
                ((not  load_errors)                         #|line 646|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 647|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 648|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 649|#)
                      (cond
                        ( show_all_outputs                  #|line 650|#
                          (funcall (quote dump_outputs)   main_container  #|line 651|#)
                          )
                        (t                                  #|line 652|#
                          (funcall (quote print_error_maybe)   main_container  #|line 653|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 654|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 655|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 656|#
                                )
                              (t                            #|line 657|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 658|#) #|line 659|#
                                )))                         #|line 660|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 661|#
                          (format *standard-output* "~a"  "--- done ---") #|line 662|# #|line 663|#
                          ))))                              #|line 664|#
                  ))))))))                                  #|line 665|#
  )                                                         #|line 667|# #|line 668|# #|  utility functions  |# #|line 669|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 670|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 671|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 672|#)) #|line 673|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 675|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 676|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 677|#)) #|line 678|#
  )







(defparameter  count_counter  0)                            #|line 1|#
(defparameter  direction  1)                                #|line 2|# #|line 3|#
(defun count_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 4|# #|line 5|#
  (cond
    (( equal   (field  msg "port")  "adv")                  #|line 6|#
      (setf  count_counter (+  count_counter  direction))   #|line 7|#
      (funcall (quote send_int)   eh  ""  count_counter  msg  #|line 8|#)
      )
    (( equal   (field  msg "port")  "rev")                  #|line 9|#
      (setf  direction (*  direction  - 1))                 #|line 10|# #|line 11|#
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
  (funcall (quote register_component)   reg (funcall (quote Template)   "Count"  nil  #'count_instantiator )  #|line 20|#) #|line 21|#
  )







(defun decode_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Decode"  nil  #'decode_instantiator )  #|line 2|#) #|line 3|#
  )
(defparameter  decode_digits (list   "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9" )) #|line 5|#
(defun decode_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 6|# #|line 7|#
  (let (( i (parse-integer (funcall (field (field  msg "datum") "raw") )) #|line 8|#))
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
  (funcall (quote register_component)   reg (funcall (quote Template)   "Reverser"  nil  #'reverser_instantiator )  #|line 2|#) #|line 3|#
  )
(defparameter  reverser_state  "J")                         #|line 5|# #|line 6|#
(defun reverser_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 7|# #|line 8|#
  (cond
    (( equal    reverser_state  "K")                        #|line 9|#
      (cond
        (( equal   (field  msg "port")  "J")                #|line 10|#
          (funcall (quote send_bang)   eh  ""  msg          #|line 11|#)
          (setf  reverser_state  "J")                       #|line 12|#
          )
        (t                                                  #|line 13|#
          #| pass |#                                        #|line 14|# #|line 15|#
          ))
      )
    (( equal    reverser_state  "J")                        #|line 16|#
      (cond
        (( equal   (field  msg "port")  "K")                #|line 17|#
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
  (funcall (quote register_component)   reg (funcall (quote Template)   "Delay"  nil  #'delay_instantiator )  #|line 2|#) #|line 3|#
  )
(defun Delay_Info (&optional )                              #|line 5|#
  (list
    (cons "counter"  0)                                     #|line 6|#
    (cons "saved_message"  nil)                             #|line 7|#) #|line 8|#)
                                                            #|line 9|#
(defun delay_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 10|#
  (let ((name_with_id (funcall (quote gensymbol)   "delay"  #|line 11|#)))
    (declare (ignorable name_with_id))
    (let ((info (funcall (quote Delay_Info) )))
      (declare (ignorable info))                            #|line 12|#
      (return-from delay_instantiator (funcall (quote make_leaf)   name_with_id  owner  info  #'delay_handler  #|line 13|#)))) #|line 14|#
  )
(defparameter  DELAYDELAY  50000)                           #|line 16|# #|line 17|#
(defun first_time (&optional  m)
  (declare (ignorable  m))                                  #|line 18|#
  (return-from first_time (not (funcall (quote is_tick)   m  #|line 19|#))) #|line 20|#
  )
(defun delay_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 22|#
  (let ((info (field  eh "instance_data")))
    (declare (ignorable info))                              #|line 23|#
    (cond
      ((funcall (quote first_time)   msg )                  #|line 24|#
        (setf (field  info "saved_message")  msg)           #|line 25|#
        (funcall (quote set_active)   eh )
        #|  tell engine to keep running this component with ;ticks'  |# #|line 26|# #|line 27|#
        ))                                                  #|line 28|#
    (let ((count (field  info "counter")))
      (declare (ignorable count))                           #|line 29|#
      (let (( next (+  count  1)))
        (declare (ignorable  next))                         #|line 30|#
        (cond
          (( >=  (field  info "counter")  DELAYDELAY)       #|line 31|#
            (funcall (quote set_idle)   eh )
            #|  tell engine that we're finally done  |#     #|line 32|#
            (funcall (quote forward)   eh  "" (field  info "saved_message")  #|line 33|#)
            (setf  next  0)                                 #|line 34|# #|line 35|#
            ))
        (setf (field  info "counter")  next)                #|line 36|#))) #|line 37|#
  )







(defun monitor_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "@"  nil  #'monitor_instantiator )  #|line 2|#) #|line 3|#
  )
(defun monitor_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 5|#
  (let ((name_with_id (funcall (quote gensymbol)   "@"      #|line 6|#)))
    (declare (ignorable name_with_id))
    (return-from monitor_instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  #'monitor_handler  #|line 7|#))) #|line 8|#
  )
(defun monitor_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 10|#
  (let (( s (funcall (field (field  msg "datum") "srepr") )))
    (declare (ignorable  s))                                #|line 11|#
    (let (( i (parse-integer  s)                            #|line 12|#))
      (declare (ignorable  i))
      (loop while ( >   i  0)
        do
          (progn                                            #|line 13|#
            (setf  s  (concatenate 'string  " "  s)         #|line 14|#)
            (setf  i (-  i  1))                             #|line 15|# #|line 16|#
            ))
        (funcall (quote print)   s                          #|line 17|#))) #|line 18|#
    )





