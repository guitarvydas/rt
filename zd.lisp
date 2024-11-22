
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
(defun dict-fresh () nil)

(defun dict-lookup (d key-string)
(let ((key (intern (string-upcase key-string) "KEYWORD")))
(let ((pair (assoc key d :test 'equal)))
(if pair
(cdr pair)
nil))))

(defun set-dict-lookup (d key-string v)
(let ((key (intern (string-upcase key-string) "KEYWORD")))
(let ((pair (assoc key d :test 'equal)))
(if pair
(setf (cdr pair) v)
(push (cons key v) d)))))

(defsetf dict-lookup set-dict-lookup)

(defun dict-is-dict? (d) (listp d))

(defun dict-in? (key-string d)
(if (and d (dict-is-dict? d))
(let ((key (intern (string-upcase key-string) "KEYWORD")))
(let ((pair (assoc key d :test 'equal)))
(if pair t nil)))
nil))

(defun field (key obj)
(let ((pair (assoc key obj :test 'equal)))
(if pair (cdr pair) nil)))
(defun set-field (obj key-string v)
(let ((key (intern (string-upcase key-string) "KEYWORD")))
(let ((pair (assoc key obj :test 'equal)))
(if pair
(setf (cdr pair) v)
nil))))

(defsetf field set-field)
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
    (setf (field "data"  d)  s)                             #|line 41|#
    (setf (field "clone"  d)  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 42|#)))
    (setf (field "reclaim"  d)  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 43|#)))
    (setf (field "srepr"  d)  #'(lambda (&optional )(funcall (quote srepr_datum_string)   d  #|line 44|#)))
    (setf (field "raw"  d) (coerce (field "data"  d) 'simple-vector) #|line 45|#)
    (setf (field "kind"  d)  #'(lambda (&optional ) "string")) #|line 46|#
    (return-from new_datum_string  d)                       #|line 47|#) #|line 48|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 50|#
  (let ((d (funcall (quote new_datum_string)  (field "data"  d)  #|line 51|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                     #|line 52|#) #|line 53|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 55|#
  #| pass |#                                                #|line 56|# #|line 57|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 59|#
  (return-from srepr_datum_string (field "data"  d))        #|line 60|# #|line 61|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 63|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 64|#
    (setf (field "data"  p)  t)                             #|line 65|#
    (setf (field "clone"  p)  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 66|#)))
    (setf (field "reclaim"  p)  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 67|#)))
    (setf (field "srepr"  p)  #'(lambda (&optional )(funcall (quote srepr_datum_bang) ))) #|line 68|#
    (setf (field "raw"  p)  #'(lambda (&optional )(funcall (quote raw_datum_bang) ))) #|line 69|#
    (setf (field "kind"  p)  #'(lambda (&optional ) "bang")) #|line 70|#
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
    (setf (field "kind"  p)  #'(lambda (&optional ) "tick")) #|line 92|#
    (setf (field "clone"  p)  #'(lambda (&optional )(funcall (quote new_datum_tick) ))) #|line 93|#
    (setf (field "srepr"  p)  #'(lambda (&optional )(funcall (quote srepr_datum_tick) ))) #|line 94|#
    (setf (field "raw"  p)  #'(lambda (&optional )(funcall (quote raw_datum_tick) ))) #|line 95|#
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
    (setf (field "data"  p)  b)                             #|line 109|#
    (setf (field "clone"  p)  #'(lambda (&optional )(funcall (quote clone_datum_bytes)   p  #|line 110|#)))
    (setf (field "reclaim"  p)  #'(lambda (&optional )(funcall (quote reclaim_datum_bytes)   p  #|line 111|#)))
    (setf (field "srepr"  p)  #'(lambda (&optional )(funcall (quote srepr_datum_bytes)   b  #|line 112|#)))
    (setf (field "raw"  p)  #'(lambda (&optional )(funcall (quote raw_datum_bytes)   b  #|line 113|#)))
    (setf (field "kind"  p)  #'(lambda (&optional ) "bytes")) #|line 114|#
    (return-from new_datum_bytes  p)                        #|line 115|#) #|line 116|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 118|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 119|#
    (setf (field "clone"  p) (field "clone"  src))          #|line 120|#
    (setf (field "reclaim"  p) (field "reclaim"  src))      #|line 121|#
    (setf (field "srepr"  p) (field "srepr"  src))          #|line 122|#
    (setf (field "raw"  p) (field "raw"  src))              #|line 123|#
    (setf (field "kind"  p) (field "kind"  src))            #|line 124|#
    (setf (field "data"  p) (funcall (field "clone"  src) )) #|line 125|#
    (return-from clone_datum_bytes  p)                      #|line 126|#) #|line 127|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 129|#
  #| pass |#                                                #|line 130|# #|line 131|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 133|#
  (return-from srepr_datum_bytes (funcall (field "decode" (field "data"  d))   "UTF_8"  #|line 134|#)) #|line 135|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 136|#
  (return-from raw_datum_bytes (field "data"  d))           #|line 137|# #|line 138|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                  #|line 140|#
  (return-from new_datum_handle (funcall (quote new_datum_int)   h  #|line 141|#)) #|line 142|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 144|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 145|#
    (setf (field "data"  p)  i)                             #|line 146|#
    (setf (field "clone"  p)  #'(lambda (&optional )(funcall (quote clone_int)   i  #|line 147|#)))
    (setf (field "reclaim"  p)  #'(lambda (&optional )(funcall (quote reclaim_int)   i  #|line 148|#)))
    (setf (field "srepr"  p)  #'(lambda (&optional )(funcall (quote srepr_datum_int)   i  #|line 149|#)))
    (setf (field "raw"  p)  #'(lambda (&optional )(funcall (quote raw_datum_int)   i  #|line 150|#)))
    (setf (field "kind"  p)  #'(lambda (&optional ) "int")) #|line 151|#
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
    (let ((m (funcall (quote Message)   p (funcall (field "clone"  datum) )  #|line 189|#)))
      (declare (ignorable m))
      (return-from make_message  m)                         #|line 190|#)) #|line 191|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 193|#
(defun message_clone (&optional  message)
  (declare (ignorable  message))                            #|line 194|#
  (let ((m (funcall (quote Message)  (funcall (quote clone_port)  (field "port"  message) ) (funcall (field "clone" (field "datum"  message)) )  #|line 195|#)))
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
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (field "port"  m)  (concatenate 'string  "⦂"  (concatenate 'string (funcall (field "srepr" (field "datum"  m)) )  "⟫")))) #|line 221|#) #|line 222|#
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
                (funcall (field "append"  children)   child_instance  #|line 239|#)
                (setf (nth (dict-lookup   child_desc  "id")  children_by_id)  child_instance)) #|line 240|#
              ))
        (setf (field "children"  container)  children)      #|line 241|#
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
                        (setf (field "direction"  connector)  "down") #|line 249|#
                        (setf (field "sender"  connector) (funcall (quote Sender)  (field "name"  me)  me (dict-lookup   proto_conn  "source_port")  #|line 250|#))
                        (let ((target_component (nth (dict-lookup   proto_conn (dict-lookup   "target"  "id"))  children_by_id)))
                          (declare (ignorable target_component)) #|line 251|#
                          (cond
                            (( equal    target_component  nil) #|line 252|#
                              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (dict-lookup   proto_conn  "target")) ) #|line 253|#
                              )
                            (t                              #|line 254|#
                              (setf (field "receiver"  connector) (funcall (quote Receiver)  (field "name"  target_component) (field "inq"  target_component) (dict-lookup   proto_conn  "target_port")  target_component  #|line 255|#))
                              (funcall (field "append"  connectors)   connector )
                              )))                           #|line 256|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumAcross) #|line 257|#
                        (setf (field "direction"  connector)  "across") #|line 258|#
                        (let ((source_component (nth (dict-lookup   proto_conn (dict-lookup   "source"  "id"))  children_by_id)))
                          (declare (ignorable source_component)) #|line 259|#
                          (let ((target_component (nth (dict-lookup   proto_conn (dict-lookup   "target"  "id"))  children_by_id)))
                            (declare (ignorable target_component)) #|line 260|#
                            (cond
                              (( equal    source_component  nil) #|line 261|#
                                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (dict-lookup   proto_conn  "source")) ) #|line 262|#
                                )
                              (t                            #|line 263|#
                                (setf (field "sender"  connector) (funcall (quote Sender)  (field "name"  source_component)  source_component (dict-lookup   proto_conn  "source_port")  #|line 264|#))
                                (cond
                                  (( equal    target_component  nil) #|line 265|#
                                    (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (field "target"  proto_conn)) ) #|line 266|#
                                    )
                                  (t                        #|line 267|#
                                    (setf (field "receiver"  connector) (funcall (quote Receiver)  (field "name"  target_component) (field "inq"  target_component) (dict-lookup   proto_conn  "target_port")  target_component  #|line 268|#))
                                    (funcall (field "append"  connectors)   connector )
                                    ))
                                ))))                        #|line 269|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumUp) #|line 270|#
                        (setf (field "direction"  connector)  "up") #|line 271|#
                        (let ((source_component (nth (dict-lookup   proto_conn (dict-lookup   "source"  "id"))  children_by_id)))
                          (declare (ignorable source_component)) #|line 272|#
                          (cond
                            (( equal    source_component  nil) #|line 273|#
                              (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (dict-lookup   proto_conn  "source")) ) #|line 274|#
                              )
                            (t                              #|line 275|#
                              (setf (field "sender"  connector) (funcall (quote Sender)  (field "name"  source_component)  source_component (dict-lookup   proto_conn  "source_port")  #|line 276|#))
                              (setf (field "receiver"  connector) (funcall (quote Receiver)  (field "name"  me) (field "outq"  container) (dict-lookup   proto_conn  "target_port")  me  #|line 277|#))
                              (funcall (field "append"  connectors)   connector )
                              )))                           #|line 278|#
                        )
                      (( equal   (dict-lookup   proto_conn  "dir")  enumThrough) #|line 279|#
                        (setf (field "direction"  connector)  "through") #|line 280|#
                        (setf (field "sender"  connector) (funcall (quote Sender)  (field "name"  me)  me (dict-lookup   proto_conn  "source_port")  #|line 281|#))
                        (setf (field "receiver"  connector) (funcall (quote Receiver)  (field "name"  me) (field "outq"  container) (dict-lookup   proto_conn  "target_port")  me  #|line 282|#))
                        (funcall (field "append"  connectors)   connector )
                        )))                                 #|line 283|#
                  ))                                        #|line 284|#
            (setf (field "connections"  container)  connectors) #|line 285|#
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
    (return-from fifo_is_empty (funcall (field "empty"  fifo) )) #|line 302|# #|line 303|#
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
    (let ((same_components ( equal   (field "component"  s1) (field "component"  s2))))
      (declare (ignorable same_components))                 #|line 336|#
      (let ((same_ports ( equal   (field "port"  s1) (field "port"  s2))))
        (declare (ignorable same_ports))                    #|line 337|#
        (return-from sender_eq ( and   same_components  same_ports)) #|line 338|#)) #|line 339|#
    ) #|  Delivers the given message to the receiver of this connector. |# #|line 341|# #|line 342|#
  (defun deposit (&optional  parent  conn  message)
    (declare (ignorable  parent  conn  message))            #|line 343|#
    (let ((new_message (funcall (quote make_message)  (field "port" (field "receiver"  conn)) (field "datum"  message)  #|line 344|#)))
      (declare (ignorable new_message))
      (funcall (quote push_message)   parent (field "component" (field "receiver"  conn)) (field "queue" (field "receiver"  conn))  new_message  #|line 345|#)) #|line 346|#
    )
  (defun force_tick (&optional  parent  eh)
    (declare (ignorable  parent  eh))                       #|line 348|#
    (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 349|#)))
      (declare (ignorable tick_msg))
      (funcall (quote push_message)   parent  eh (field "inq"  eh)  tick_msg  #|line 350|#)
      (return-from force_tick  tick_msg)                    #|line 351|#) #|line 352|#
    )
  (defun push_message (&optional  parent  receiver  inq  m)
    (declare (ignorable  parent  receiver  inq  m))         #|line 354|#
    (funcall (field "put"  inq)   m                         #|line 355|#)
    (funcall (field "put" (field "visit_ordering"  parent))   receiver  #|line 356|#) #|line 357|#
    )
  (defun is_self (&optional  child  container)
    (declare (ignorable  child  container))                 #|line 359|#
    #|  in an earlier version “self“ was denoted as ϕ |#    #|line 360|#
    (return-from is_self ( equal    child  container))      #|line 361|# #|line 362|#
    )
  (defun step_child (&optional  child  msg)
    (declare (ignorable  child  msg))                       #|line 364|#
    (let ((before_state (field "state"  child)))
      (declare (ignorable before_state))                    #|line 365|#
      (funcall (field "handler"  child)   child  msg        #|line 366|#)
      (let ((after_state (field "state"  child)))
        (declare (ignorable after_state))                   #|line 367|#
        (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 368|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 369|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 370|#)) #|line 371|#
    )
  (defun save_message (&optional  eh  msg)
    (declare (ignorable  eh  msg))                          #|line 373|#
    (funcall (field "put" (field "saved_messages"  eh))   msg  #|line 374|#) #|line 375|#
    )
  (defun fetch_saved_message_and_clear (&optional  eh)
    (declare (ignorable  eh))                               #|line 377|#
    (return-from fetch_saved_message_and_clear (funcall (field "get" (field "saved_messages"  eh)) )) #|line 378|# #|line 379|#
    )
  (defun step_children (&optional  container  causingMessage)
    (declare (ignorable  container  causingMessage))        #|line 381|#
    (setf (field "state"  container)  "idle")               #|line 382|#
    (loop for child in (funcall (quote list)  (field "queue" (field "visit_ordering"  container)) )
      do
        (progn
          child                                             #|line 383|#
          #|  child = container represents self, skip it |# #|line 384|#
          (cond
            ((not (funcall (quote is_self)   child  container )) #|line 385|#
              (cond
                ((not (funcall (field "empty" (field "inq"  child)) )) #|line 386|#
                  (let ((msg (funcall (field "get" (field "inq"  child)) )))
                    (declare (ignorable msg))               #|line 387|#
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
                    ((not (equal  (field "state"  child)  "idle")) #|line 399|#
                      (let ((msg (funcall (quote force_tick)   container  child  #|line 400|#)))
                        (declare (ignorable msg))
                        (funcall (field "handler"  child)   child  msg  #|line 401|#)
                        (funcall (quote destroy_message)   msg ))
                      ))                                    #|line 402|#
                  ))                                        #|line 403|#
              (cond
                (( equal   (field "state"  child)  "active") #|line 404|#
                  #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 405|#
                  (setf (field "state"  container)  "active") #|line 406|#
                  ))                                        #|line 407|#
              (loop while (not (funcall (field "empty" (field "outq"  child)) ))
                do
                  (progn                                    #|line 408|#
                    (let ((msg (funcall (field "get" (field "outq"  child)) )))
                      (declare (ignorable msg))             #|line 409|#
                      (funcall (quote route)   container  child  msg  #|line 410|#)
                      (funcall (quote destroy_message)   msg ))
                    ))
                ))                                          #|line 411|#
            ))                                              #|line 412|# #|line 413|# #|line 414|#
      )
    (defun attempt_tick (&optional  parent  eh)
      (declare (ignorable  parent  eh))                     #|line 416|#
      (cond
        ((not (equal  (field "state"  eh)  "idle"))         #|line 417|#
          (funcall (quote force_tick)   parent  eh )        #|line 418|#
          ))                                                #|line 419|#
      )
    (defun is_tick (&optional  msg)
      (declare (ignorable  msg))                            #|line 421|#
      (return-from is_tick ( equal    "tick" (funcall (field "kind" (field "datum"  msg)) ))) #|line 422|# #|line 423|#
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
              (loop for child in (field "children"  container)
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
                  (setf  fromname (field "name"  from_component)) #|line 437|#
                  ))
              (let ((from_sender (funcall (quote Sender)   fromname  from_component (field "port"  message)  #|line 438|#)))
                (declare (ignorable from_sender))           #|line 439|#
                (loop for connector in (field "connections"  container)
                  do
                    (progn
                      connector                             #|line 440|#
                      (cond
                        ((funcall (quote sender_eq)   from_sender (field "sender"  connector) ) #|line 441|#
                          (funcall (quote deposit)   container  connector  message  #|line 442|#)
                          (setf  was_sent  t)
                          ))
                      )))                                   #|line 443|#
              ))
          (cond
            ((not  was_sent)                                #|line 444|#
              (funcall (quote print)   "\n\n*** Error: ***"  #|line 445|#)
              (funcall (quote print)   "***"                #|line 446|#)
              (funcall (quote print)   (concatenate 'string (field "name"  container)  (concatenate 'string  ": message '"  (concatenate 'string (field "port"  message)  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 447|#)
              (funcall (quote print)   "***"                #|line 448|#)
              (uiop:quit)                                   #|line 449|# #|line 450|#
              ))))                                          #|line 451|#
      )
    (defun any_child_ready (&optional  container)
      (declare (ignorable  container))                      #|line 453|#
      (loop for child in (field "children"  container)
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
      (return-from child_is_ready ( or  ( or  ( or  (not (funcall (field "empty" (field "outq"  eh)) )) (not (funcall (field "empty" (field "inq"  eh)) ))) (not (equal  (field "state"  eh)  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 461|# #|line 462|#
      )
    (defun append_routing_descriptor (&optional  container  desc)
      (declare (ignorable  container  desc))                #|line 464|#
      (funcall (field "put" (field "routings"  container))   desc  #|line 465|#) #|line 466|#
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

  ;; read json from a named file and convert it into internal form (a tree of routings)
  ;; return the routings from the function or raise an error
  (with-open-file (json-stream (format nil "~a/~a" pathname filename) :direction :input)
    (json:decode-json json-stream))
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
  (let ((name (funcall (quote mangle_name)  (field "name"  template)  #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  (dict-in?  name (field "templates"  reg)) (not  ok_to_overwrite)) #|line 37|#
        (funcall (quote load_error)   (concatenate 'string  "Component /"  (concatenate 'string (field "name"  template)  "/ already declared"))  #|line 38|#)
        (return-from abstracted_register_component  reg)    #|line 39|#
        )
      (t                                                    #|line 40|#
        (let ((templates_alist (field "templates"  reg)))
          (declare (ignorable templates_alist))             #|line 41|#
          (setf  reg (cons (cons  "templates" (setf  templates_alist (cons (cons  name  template)  templates_alist)))  reg)) #|line 42|#
          (return-from abstracted_register_component  reg)  #|line 43|#) #|line 44|#
        )))                                                 #|line 45|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 47|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 48|#)))
    (declare (ignorable template_name))
    (cond
      (( dict-in?   template_name (field "templates"  reg)) #|line 49|#
        (let ((template (nth  template_name (field "templates"  reg))))
          (declare (ignorable template))                    #|line 50|#
          (cond
            (( equal    template  nil)                      #|line 51|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error (A): Can;t find component /"  (concatenate 'string  template_name  "/"))  #|line 52|#)
              (return-from get_component_instance  nil)     #|line 53|#
              )
            (t                                              #|line 54|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 55|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 56|#
                  (cond
                    ((not (equal   nil  owner))             #|line 57|#
                      (setf  owner_name (field "name"  owner)) #|line 58|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 59|#
                      )
                    (t                                      #|line 60|#
                      (setf  instance_name  template_name)  #|line 61|#
                      ))
                  (let ((instance (funcall (field "instantiator"  template)   reg  owner  instance_name (field "template_data"  template)  #|line 62|#)))
                    (declare (ignorable instance))
                    (setf (field "depth"  instance) (funcall (quote calculate_depth)   instance  #|line 63|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 64|#
        )
      (t                                                    #|line 65|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error (B): Can't find component /"  (concatenate 'string  template_name  "/"))  #|line 66|#)
        (return-from get_component_instance  nil)           #|line 67|#
        )))                                                 #|line 68|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 69|#
  (cond
    (( equal   (field "owner"  eh)  nil)                    #|line 70|#
      (return-from calculate_depth  0)                      #|line 71|#
      )
    (t                                                      #|line 72|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (field "owner"  eh) ))) #|line 73|#
      ))                                                    #|line 74|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 76|#
  (funcall (quote nl) )                                     #|line 77|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 78|#
  (loop for c in (field "templates"  reg)
    do
      (progn
        c                                                   #|line 79|#
        (funcall (quote print)  (field "name"  c) )         #|line 80|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 81|#
  (funcall (quote nl) )                                     #|line 82|# #|line 83|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 85|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (field "stats"  reg))) #|line 86|# #|line 87|#
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
  (let (( regkvs  reg))
    (declare (ignorable  regkvs))                           #|line 99|#
    (cond
      ((not (equal   nil  container_list))                  #|line 100|#
        (loop for diagram in  container_list
          do
            (progn
              diagram                                       #|line 101|#
              #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 102|#
              #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 103|#
              (loop for child_descriptor in (dict-lookup   diagram  "children")
                do
                  (progn
                    child_descriptor                        #|line 104|#
                    (cond
                      ((funcall (quote first_char_is)  (dict-lookup   child_descriptor  "name")  "$" ) #|line 105|#
                        (let ((name (dict-lookup   child_descriptor  "name")))
                          (declare (ignorable name))        #|line 106|#
                          (let ((cmd (funcall (field "strip"  (subseq  name 1)) )))
                            (declare (ignorable cmd))       #|line 107|#
                            (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 108|#)))
                              (declare (ignorable generated_leaf))
                              (setf  regkvs (cons (funcall (quote register_component)   regkvs  generated_leaf )  regkvs)) #|line 109|#)))
                        )
                      ((funcall (quote first_char_is)  (dict-lookup   child_descriptor  "name")  "'" ) #|line 110|#
                        (let ((name (dict-lookup   child_descriptor  "name")))
                          (declare (ignorable name))        #|line 111|#
                          (let ((s  (subseq  name 1)        #|line 112|#))
                            (declare (ignorable s))
                            (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 113|#)))
                              (declare (ignorable generated_leaf))
                              (setf  regkvs (cons (funcall (quote register_component_allow_overwriting)   regkvs  generated_leaf )  regkvs)) #|line 114|#))) #|line 115|#
                        ))                                  #|line 116|#
                    ))                                      #|line 117|#
              ))                                            #|line 118|#
        ))
    (return-from generate_shell_components  regkvs)         #|line 119|#) #|line 120|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 122|#
  (return-from first_char  (char  s 0)                      #|line 123|#) #|line 124|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 126|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 127|#))) #|line 128|#
  )                                                         #|line 130|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 131|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 132|# #|line 133|# #|line 134|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 135|# #|  and output queues of messages. |# #|line 136|# #|  |# #|line 137|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 138|# #|  that routes messages to child components according to a list of connections |# #|line 139|# #|  that serve as a message routing table. |# #|line 140|# #|  |# #|line 141|# #|  Child components themselves can be leaves or other containers. |# #|line 142|# #|  |# #|line 143|# #|  `handler` invokes the code that is attached to this component. |# #|line 144|# #|  |# #|line 145|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 146|# #|  function may want whenever it is invoked again. |# #|line 147|# #|  |# #|line 148|# #|line 149|# #|  Eh_States :: enum { idle, active } |# #|line 150|#
(defun Eh (&optional )                                      #|line 151|#
  (list
    (cons "name"  "")                                       #|line 152|#
    (cons "inq"  (make-instance 'Queue)                     #|line 153|#)
    (cons "outq"  (make-instance 'Queue)                    #|line 154|#)
    (cons "owner"  nil)                                     #|line 155|#
    (cons "saved_messages"  nil)  #|  stack of saved message(s) |# #|line 156|#
    (cons "children"  nil)                                  #|line 157|#
    (cons "visit_ordering"  (make-instance 'Queue)          #|line 158|#)
    (cons "connections"  nil)                               #|line 159|#
    (cons "routings"  (make-instance 'Queue)                #|line 160|#)
    (cons "handler"  nil)                                   #|line 161|#
    (cons "instance_data"  nil)                             #|line 162|#
    (cons "state"  "idle")                                  #|line 163|# #|  bootstrap debugging |# #|line 164|#
    (cons "kind"  nil)  #|  enum { container, leaf, } |#    #|line 165|#
    (cons "trace"  nil)  #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |# #|line 166|#
    (cons "depth"  0)  #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |# #|line 167|#) #|line 168|#)
                                                            #|line 169|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 170|# #|  whose handler function is `container_handler`. |# #|line 171|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 172|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 173|#
    (setf (field "name"  eh)  name)                         #|line 174|#
    (setf (field "owner"  eh)  owner)                       #|line 175|#
    (setf (field "handler"  eh)  #'container_handler)       #|line 176|#
    (setf (field "inject"  eh)  #'container_injector)       #|line 177|#
    (setf (field "state"  eh)  "idle")                      #|line 178|#
    (setf (field "kind"  eh)  "container")                  #|line 179|#
    (return-from make_container  eh)                        #|line 180|#) #|line 181|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 183|# #|  that will be passed back to your handler when called. |# #|line 184|# #|line 185|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 186|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 187|#
    (setf (field "name"  eh)  (concatenate 'string (field "name"  owner)  (concatenate 'string  "."  name)) #|line 188|#)
    (setf (field "owner"  eh)  owner)                       #|line 189|#
    (setf (field "handler"  eh)  handler)                   #|line 190|#
    (setf (field "instance_data"  eh)  instance_data)       #|line 191|#
    (setf (field "state"  eh)  "idle")                      #|line 192|#
    (setf (field "kind"  eh)  "leaf")                       #|line 193|#
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
  (let ((fwdmsg (funcall (quote make_message)   port (field "datum"  msg)  #|line 212|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 213|#)) #|line 214|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 216|#
  (funcall (field "inject"  eh)   eh  msg                   #|line 217|#) #|line 218|#
  ) #|  Returns a list of all output messages on a container. |# #|line 220|# #|  For testing / debugging purposes. |# #|line 221|# #|line 222|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 223|#
  (return-from output_list (field "outq"  eh))              #|line 224|# #|line 225|#
  ) #|  Utility for printing an array of messages. |#       #|line 227|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 228|#
  (loop for m in (funcall (quote list)  (field "queue" (field "outq"  eh)) )
    do
      (progn
        m                                                   #|line 229|#
        (format *standard-output* "~a" (funcall (quote format_message)   m )) #|line 230|#
        ))                                                  #|line 231|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                  #|line 233|#
  (let (( s  ""))
    (declare (ignorable  s))                                #|line 234|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do
        (progn
          i                                                 #|line 235|#
          (setf  s (+  s  " "))                             #|line 236|#
          ))
    (return-from spaces  s)                                 #|line 237|#) #|line 238|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                 #|line 240|#
  (setf (field "state"  eh)  "active")                      #|line 241|# #|line 242|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 244|#
  (setf (field "state"  eh)  "idle")                        #|line 245|# #|line 246|#
  ) #|  Utility for printing a specific output message. |#  #|line 248|# #|line 249|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 250|#
  (loop for msg in (funcall (quote list)  (field "queue" (field "outq"  eh)) )
    do
      (progn
        msg                                                 #|line 251|#
        (cond
          (( equal   (field "port"  msg)  port)             #|line 252|#
            (return-from fetch_first_output (field "datum"  msg))
            ))                                              #|line 253|#
        ))
  (return-from fetch_first_output  nil)                     #|line 254|# #|line 255|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 257|#
  #|  port ∷ “” |#                                          #|line 258|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 259|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (funcall (field "srepr"  datum) )) #|line 260|#) #|line 261|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 262|#
  #|  port ∷ “” |#                                          #|line 263|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 264|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 265|#
    (format *error-output* "~a" (funcall (field "srepr"  datum) )) #|line 266|#) #|line 267|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 269|#
  (funcall (field "put" (field "outq"  eh))   msg           #|line 270|#) #|line 271|#
  )
(defparameter  root_project  "")                            #|line 273|#
(defparameter  root_0D  "")                                 #|line 274|# #|line 275|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                      #|line 276|# #|line 277|# #|line 278|#
  (setf  root_project  rproject)                            #|line 279|#
  (setf  root_0D  r0D)                                      #|line 280|# #|line 281|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 283|#
  (let ((name_with_id (funcall (quote gensymbol)   "?"      #|line 284|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 285|#))) #|line 286|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 287|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 288|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 289|#))) #|line 290|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 292|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 293|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 294|#))) #|line 295|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 297|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 298|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 299|#))) #|line 300|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 302|#
  (let ((s (funcall (field "srepr" (field "datum"  msg)) )))
    (declare (ignorable s))                                 #|line 303|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (field "name"  eh)  (concatenate 'string  ": "  s)))) #|line 304|#) #|line 305|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 307|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 308|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 309|#))) #|line 310|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 312|#
  #|  to appease dumped_on_floor checker |#                 #|line 313|#
  #| pass |#                                                #|line 314|# #|line 315|#
  )
(defun TwoMessages (&optional  first  second)               #|line 316|#
  (list
    (cons "first"  first)                                   #|line 317|#
    (cons "second"  second)                                 #|line 318|#) #|line 319|#)
                                                            #|line 320|# #|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |# #|line 321|#
(defun Deracer_Instance_Data (&optional  state  buffer)     #|line 322|#
  (list
    (cons "state"  state)                                   #|line 323|#
    (cons "buffer"  buffer)                                 #|line 324|#) #|line 325|#)
                                                            #|line 326|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 327|#
  #| pass |#                                                #|line 328|# #|line 329|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 331|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 332|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Deracer_Instance_Data)   "idle" (funcall (quote TwoMessages)   nil  nil )  #|line 333|#)))
      (declare (ignorable inst))
      (setf (field "state"  inst)  "idle")                  #|line 334|#
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 335|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 336|#))) #|line 337|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 339|#
  (funcall (quote forward)   eh  "1" (field "first" (field "buffer"  inst))  #|line 340|#)
  (funcall (quote forward)   eh  "2" (field "second" (field "buffer"  inst))  #|line 341|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 342|#) #|line 343|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 345|#
  (let (( inst (field "instance_data"  eh)))
    (declare (ignorable  inst))                             #|line 346|#
    (cond
      (( equal   (field "state"  inst)  "idle")             #|line 347|#
        (cond
          (( equal    "1" (field "port"  msg))              #|line 348|#
            (setf (field "first" (field "buffer"  inst))  msg) #|line 349|#
            (setf (field "state"  inst)  "waitingForSecond") #|line 350|#
            )
          (( equal    "2" (field "port"  msg))              #|line 351|#
            (setf (field "second" (field "buffer"  inst))  msg) #|line 352|#
            (setf (field "state"  inst)  "waitingForFirst") #|line 353|#
            )
          (t                                                #|line 354|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (field "port"  msg)) )
            ))                                              #|line 355|#
        )
      (( equal   (field "state"  inst)  "waitingForFirst")  #|line 356|#
        (cond
          (( equal    "1" (field "port"  msg))              #|line 357|#
            (setf (field "first" (field "buffer"  inst))  msg) #|line 358|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 359|#)
            (setf (field "state"  inst)  "idle")            #|line 360|#
            )
          (t                                                #|line 361|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (field "port"  msg)) )
            ))                                              #|line 362|#
        )
      (( equal   (field "state"  inst)  "waitingForSecond") #|line 363|#
        (cond
          (( equal    "2" (field "port"  msg))              #|line 364|#
            (setf (field "second" (field "buffer"  inst))  msg) #|line 365|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 366|#)
            (setf (field "state"  inst)  "idle")            #|line 367|#
            )
          (t                                                #|line 368|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (field "port"  msg)) )
            ))                                              #|line 369|#
        )
      (t                                                    #|line 370|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}" ) #|line 371|#
        )))                                                 #|line 372|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 374|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 375|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 376|#))) #|line 377|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 379|#
  (let ((fname (funcall (field "srepr" (field "datum"  msg)) )))
    (declare (ignorable fname))                             #|line 380|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 381|#) #|line 382|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 384|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 385|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 386|#))) #|line 387|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 389|#
  (cond
    (( equal    "string" (funcall (field "kind" (field "datum"  msg)) )) #|line 390|#
      (funcall (quote forward)   eh  ""  msg )              #|line 391|#
      )
    (t                                                      #|line 392|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (field "datum"  msg)) #|line 393|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 394|#
      ))                                                    #|line 395|#
  )
(defun Syncfilewrite_Data (&optional )                      #|line 397|#
  (list
    (cons "filename"  "")                                   #|line 398|#) #|line 399|#)
                                                            #|line 400|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 401|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 402|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 403|#)))
    (declare (ignorable name_with_id))
    (let ((inst (funcall (quote Syncfilewrite_Data) )))
      (declare (ignorable inst))                            #|line 404|#
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 405|#)))) #|line 406|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 408|#
  (let (( inst (field "instance_data"  eh)))
    (declare (ignorable  inst))                             #|line 409|#
    (cond
      (( equal    "filename" (field "port"  msg))           #|line 410|#
        (setf (field "filename"  inst) (funcall (field "srepr" (field "datum"  msg)) )) #|line 411|#
        )
      (( equal    "input" (field "port"  msg))              #|line 412|#
        (let ((contents (funcall (field "srepr" (field "datum"  msg)) )))
          (declare (ignorable contents))                    #|line 413|#
          (let (( f (funcall (quote open)  (field "filename"  inst)  "w"  #|line 414|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 415|#
                (funcall (field "write"  f)  (funcall (field "srepr" (field "datum"  msg)) )  #|line 416|#)
                (funcall (field "close"  f) )               #|line 417|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 418|#
                )
              (t                                            #|line 419|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (field "filename"  inst))  msg )
                ))))                                        #|line 420|#
        )))                                                 #|line 421|#
  )
(defun StringConcat_Instance_Data (&optional )              #|line 423|#
  (list
    (cons "buffer1"  nil)                                   #|line 424|#
    (cons "buffer2"  nil)                                   #|line 425|#
    (cons "count"  0)                                       #|line 426|#) #|line 427|#)
                                                            #|line 428|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 429|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 430|#)))
    (declare (ignorable name_with_id))
    (let ((instp (funcall (quote StringConcat_Instance_Data) )))
      (declare (ignorable instp))                           #|line 431|#
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 432|#)))) #|line 433|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 435|#
  (let (( inst (field "instance_data"  eh)))
    (declare (ignorable  inst))                             #|line 436|#
    (cond
      (( equal    "1" (field "port"  msg))                  #|line 437|#
        (setf (field "buffer1"  inst) (funcall (quote clone_string)  (funcall (field "srepr" (field "datum"  msg)) )  #|line 438|#))
        (setf (field "count"  inst) (+ (field "count"  inst)  1)) #|line 439|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 440|#
        )
      (( equal    "2" (field "port"  msg))                  #|line 441|#
        (setf (field "buffer2"  inst) (funcall (quote clone_string)  (funcall (field "srepr" (field "datum"  msg)) )  #|line 442|#))
        (setf (field "count"  inst) (+ (field "count"  inst)  1)) #|line 443|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 444|#
        )
      (t                                                    #|line 445|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (field "port"  msg))  #|line 446|#) #|line 447|#
        )))                                                 #|line 448|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 450|#
  (cond
    (( and  ( equal    0 (length (field "buffer1"  inst))) ( equal    0 (length (field "buffer2"  inst)))) #|line 451|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 452|#
      ))
  (cond
    (( >=  (field "count"  inst)  2)                        #|line 453|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 454|#
        (cond
          (( equal    0 (length (field "buffer1"  inst)))   #|line 455|#
            (setf  concatenated_string (field "buffer2"  inst)) #|line 456|#
            )
          (( equal    0 (length (field "buffer2"  inst)))   #|line 457|#
            (setf  concatenated_string (field "buffer1"  inst)) #|line 458|#
            )
          (t                                                #|line 459|#
            (setf  concatenated_string (+ (field "buffer1"  inst) (field "buffer2"  inst))) #|line 460|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 461|#)
        (setf (field "buffer1"  inst)  nil)                 #|line 462|#
        (setf (field "buffer2"  inst)  nil)                 #|line 463|#
        (setf (field "count"  inst)  0))                    #|line 464|#
      ))                                                    #|line 465|#
  ) #|  |#                                                  #|line 467|# #|line 468|# #|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 469|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 470|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 471|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 472|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 473|#)))) #|line 474|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 476|#
  (let ((cmd (field "instance_data"  eh)))
    (declare (ignorable cmd))                               #|line 477|#
    (let ((s (funcall (field "srepr" (field "datum"  msg)) )))
      (declare (ignorable s))                               #|line 478|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 479|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 480|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 481|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 482|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 483|#
              (cond
                ((not (equal   rc  0))                      #|line 484|#
                  (funcall (quote send_string)   eh  "✗"  stderr  msg  #|line 485|#)
                  )
                (t                                          #|line 486|#
                  (funcall (quote send_string)   eh  ""  stdout  msg  #|line 487|#) #|line 488|#
                  ))))))))                                  #|line 489|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 491|# #|line 492|# #|line 493|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 494|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 495|#
      (cond
        ((not (equal   root_project  ""))                   #|line 496|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 497|#) #|line 498|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 499|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 500|#) #|line 501|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 502|#)))) #|line 503|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 505|#
  (let ((s (field "instance_data"  eh)))
    (declare (ignorable s))                                 #|line 506|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 507|#)) #|line 508|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                  #|line 510|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |# #|line 511|#
  (return-from string_make_persistent  s)                   #|line 512|# #|line 513|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                  #|line 515|#
  (return-from string_clone  s)                             #|line 516|# #|line 517|#
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 519|# #|  where ${_00_} is the root directory for the project |# #|line 520|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 521|# #|line 522|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 523|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 524|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 525|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   root_project  diagram_source  #|line 526|#)))
            (declare (ignorable all_containers_within_single_file))
            (setf  reg (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 527|#))
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 528|#
                  (setf  reg (cons (funcall (quote register_component)   reg (funcall (quote Template)  (dict-lookup   container  "name")  #|  template_data= |# container  #|  instantiator= |# #'container_instantiator ) )  reg)) #|line 529|# #|line 530|#
                  )))                                       #|line 531|#
          ))
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
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (funcall (field "srepr"  err) ) )))) #|line 539|#
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
  (return-from trimws (funcall (field "strip"  s) ))        #|line 558|# #|line 559|#
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
  (let (( regkvs (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 599|#)))
    (declare (ignorable  regkvs))
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?"  nil  #'probe_instantiate ) )  regkvs)) #|line 600|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?A"  nil  #'probeA_instantiate ) )  regkvs)) #|line 601|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?B"  nil  #'probeB_instantiate ) )  regkvs)) #|line 602|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "?C"  nil  #'probeC_instantiate ) )  regkvs)) #|line 603|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "trash"  nil  #'trash_instantiate ) )  regkvs)) #|line 604|# #|line 605|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate ) )  regkvs)) #|line 606|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate ) )  regkvs)) #|line 607|# #|line 608|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate ) )  regkvs)) #|line 609|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate ) )  regkvs)) #|line 610|#
    #|  for fakepipe |#                                     #|line 611|#
    (setf  regkvs (cons (funcall (quote register_component)   regkvs (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate ) )  regkvs)) #|line 612|#
    (return-from initialize_stock_components  regkvs)       #|line 613|#) #|line 614|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 616|#

  (get-main-args)
                                                            #|line 617|# #|line 618|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                    #|line 620|#
  (let ((root_of_project  (nth  1 (argv))                   #|line 621|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                      #|line 622|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                           #|line 623|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))         #|line 624|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))          #|line 625|#))
            (declare (ignorable diagram_names))
            (let ((palette (funcall (quote initialize_component_palette)   root_of_project  root_of_0D  diagram_names  #|line 626|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg ))) #|line 627|#)))))) #|line 628|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  nil )       #|line 630|#
  )
(defun start_show_all (&optional  palette  env)
  (declare (ignorable  palette  env))
  (funcall (quote start_helper)   palette  env  t )         #|line 631|#
  )
(defun start_helper (&optional  palette  env  show_all_outputs)
  (declare (ignorable  palette  env  show_all_outputs))     #|line 632|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                   #|line 633|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                      #|line 634|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))           #|line 635|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))               #|line 636|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                       #|line 637|#
            (funcall (quote set_environment)   root_of_project  root_of_0D  #|line 638|#)
            #|  get entrypoint container |#                 #|line 639|#
            (let (( main_container (funcall (quote get_component_instance)   palette  main_container_name  nil  #|line 640|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)            #|line 641|#
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name /"  (concatenate 'string  main_container_name  (concatenate 'string  "/ in files "  (concatenate 'string (format nil "~a"  diagram_names)  " (check tab names, or disable compression?)"))))  #|line 645|#) #|line 646|#
                  ))
              (cond
                ((not  load_errors)                         #|line 647|#
                  (let (( arg (funcall (quote new_datum_string)   arg  #|line 648|#)))
                    (declare (ignorable  arg))
                    (let (( msg (funcall (quote make_message)   ""  arg  #|line 649|#)))
                      (declare (ignorable  msg))
                      (funcall (quote inject)   main_container  msg  #|line 650|#)
                      (cond
                        ( show_all_outputs                  #|line 651|#
                          (funcall (quote dump_outputs)   main_container  #|line 652|#)
                          )
                        (t                                  #|line 653|#
                          (funcall (quote print_error_maybe)   main_container  #|line 654|#)
                          (let ((outp (funcall (quote fetch_first_output)   main_container  ""  #|line 655|#)))
                            (declare (ignorable outp))
                            (cond
                              (( equal    nil  outp)        #|line 656|#
                                (format *standard-output* "~a"  "(no outputs)") #|line 657|#
                                )
                              (t                            #|line 658|#
                                (funcall (quote print_specific_output)   main_container  ""  #|line 659|#) #|line 660|#
                                )))                         #|line 661|#
                          ))
                      (cond
                        ( show_all_outputs                  #|line 662|#
                          (format *standard-output* "~a"  "--- done ---") #|line 663|# #|line 664|#
                          ))))                              #|line 665|#
                  ))))))))                                  #|line 666|#
  )                                                         #|line 668|# #|line 669|# #|  utility functions  |# #|line 670|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))       #|line 671|#
  (let ((datum (funcall (quote new_datum_int)   i           #|line 672|#)))
    (declare (ignorable datum))
    (funcall (quote send)   eh  port  datum  causing_message  #|line 673|#)) #|line 674|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))          #|line 676|#
  (let ((datum (funcall (quote new_datum_bang) )))
    (declare (ignorable datum))                             #|line 677|#
    (funcall (quote send)   eh  port  datum  causing_message  #|line 678|#)) #|line 679|#
  )





