
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
                                                            #|line 1|# #|line 2|#
(defparameter  counter  0)                                  #|line 3|# #|line 4|#
(defparameter  digits (list                                 #|line 5|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" )) #|line 11|# #|line 12|# #|line 13|#
(defun gensymbol (&optional  s)
  (declare (ignorable  s))                                  #|line 14|# #|line 15|#
  (funcall (quote print)   counter                          #|line 16|#)
  (let ((name_with_id  (concatenate 'string  s (funcall (quote subscripted_digit)   counter )) #|line 17|#))
    (declare (ignorable name_with_id))
    (setf  counter (+  counter  1))                         #|line 18|#
    (return-from gensymbol  name_with_id)                   #|line 19|#) #|line 20|#
  )
(defun subscripted_digit (&optional  n)
  (declare (ignorable  n))                                  #|line 22|# #|line 23|#
  (cond
    (( and  ( >=   n  0) ( <=   n  29))                     #|line 24|#
      (return-from subscripted_digit (nth  n  digits))      #|line 25|#
      )
    (t                                                      #|line 26|#
      (return-from subscripted_digit  (concatenate 'string  "₊"  n) #|line 27|#) #|line 28|#
      ))                                                    #|line 29|#
  )
(defun Datum (&optional )                                   #|line 31|#
  (list
    (cons (quot data)  nil)                                 #|line 32|#
    (cons (quot clone)  nil)                                #|line 33|#
    (cons (quot reclaim)  nil)                              #|line 34|#
    (cons (quot srepr)  nil)                                #|line 35|#
    (cons (quot kind)  nil)                                 #|line 36|#
    (cons (quot raw)  nil)                                  #|line 37|#) #|line 38|#)
                                                            #|line 39|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                  #|line 40|#
  (let ((d  (Datum)                                         #|line 41|#))
    (declare (ignorable d))
    (setf (cdr (assoc (quote data)  d))  s)                 #|line 42|#
    (setf (cdr (assoc (quote clone)  d))  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 43|#)))
    (setf (cdr (assoc (quote reclaim)  d))  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 44|#)))
    (setf (cdr (assoc (quote srepr)  d))  #'(lambda (&optional )(funcall (quote srepr_datum_string)   d  #|line 45|#)))
    (setf (cdr (assoc (quote raw)  d)) (coerce (cdr (assoc (quote data)  d)) 'simple-vector) #|line 46|#)
    (setf (cdr (assoc (quote kind)  d))  #'(lambda (&optional ) "string")) #|line 47|#
    (return-from new_datum_string  d)                       #|line 48|#) #|line 49|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 51|#
  (let ((d (funcall (quote new_datum_string)  (cdr (assoc (quote data)  d))  #|line 52|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                     #|line 53|#) #|line 54|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 56|#
  #| pass |#                                                #|line 57|# #|line 58|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 60|#
  (return-from srepr_datum_string (cdr (assoc (quote data)  d))) #|line 61|# #|line 62|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 64|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 65|#
    (setf (cdr (assoc (quote data)  p))  t)                 #|line 66|#
    (setf (cdr (assoc (quote clone)  p))  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 67|#)))
    (setf (cdr (assoc (quote reclaim)  p))  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 68|#)))
    (setf (cdr (assoc (quote srepr)  p))  #'(lambda (&optional )(funcall (quote srepr_datum_bang) ))) #|line 69|#
    (setf (cdr (assoc (quote raw)  p))  #'(lambda (&optional )(funcall (quote raw_datum_bang) ))) #|line 70|#
    (setf (cdr (assoc (quote kind)  p))  #'(lambda (&optional ) "bang")) #|line 71|#
    (return-from new_datum_bang  p)                         #|line 72|#) #|line 73|#
  )
(defun clone_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 75|#
  (return-from clone_datum_bang (funcall (quote new_datum_bang) )) #|line 76|# #|line 77|#
  )
(defun reclaim_datum_bang (&optional  d)
  (declare (ignorable  d))                                  #|line 79|#
  #| pass |#                                                #|line 80|# #|line 81|#
  )
(defun srepr_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 83|#
  (return-from srepr_datum_bang  "!")                       #|line 84|# #|line 85|#
  )
(defun raw_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 87|#
  (return-from raw_datum_bang  nil)                         #|line 88|# #|line 89|#
  )
(defun new_datum_tick (&optional )
  (declare (ignorable ))                                    #|line 91|#
  (let ((p (funcall (quote new_datum_bang) )))
    (declare (ignorable p))                                 #|line 92|#
    (setf (cdr (assoc (quote kind)  p))  #'(lambda (&optional ) "tick")) #|line 93|#
    (setf (cdr (assoc (quote clone)  p))  #'(lambda (&optional )(funcall (quote new_datum_tick) ))) #|line 94|#
    (setf (cdr (assoc (quote srepr)  p))  #'(lambda (&optional )(funcall (quote srepr_datum_tick) ))) #|line 95|#
    (setf (cdr (assoc (quote raw)  p))  #'(lambda (&optional )(funcall (quote raw_datum_tick) ))) #|line 96|#
    (return-from new_datum_tick  p)                         #|line 97|#) #|line 98|#
  )
(defun srepr_datum_tick (&optional )
  (declare (ignorable ))                                    #|line 100|#
  (return-from srepr_datum_tick  ".")                       #|line 101|# #|line 102|#
  )
(defun raw_datum_tick (&optional )
  (declare (ignorable ))                                    #|line 104|#
  (return-from raw_datum_tick  nil)                         #|line 105|# #|line 106|#
  )
(defun new_datum_bytes (&optional  b)
  (declare (ignorable  b))                                  #|line 108|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 109|#
    (setf (cdr (assoc (quote data)  p))  b)                 #|line 110|#
    (setf (cdr (assoc (quote clone)  p))  #'(lambda (&optional )(funcall (quote clone_datum_bytes)   p  #|line 111|#)))
    (setf (cdr (assoc (quote reclaim)  p))  #'(lambda (&optional )(funcall (quote reclaim_datum_bytes)   p  #|line 112|#)))
    (setf (cdr (assoc (quote srepr)  p))  #'(lambda (&optional )(funcall (quote srepr_datum_bytes)   b  #|line 113|#)))
    (setf (cdr (assoc (quote raw)  p))  #'(lambda (&optional )(funcall (quote raw_datum_bytes)   b  #|line 114|#)))
    (setf (cdr (assoc (quote kind)  p))  #'(lambda (&optional ) "bytes")) #|line 115|#
    (return-from new_datum_bytes  p)                        #|line 116|#) #|line 117|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 119|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 120|#
    (setf (cdr (assoc (quote clone)  p)) (cdr (assoc (quote clone)  src))) #|line 121|#
    (setf (cdr (assoc (quote reclaim)  p)) (cdr (assoc (quote reclaim)  src))) #|line 122|#
    (setf (cdr (assoc (quote srepr)  p)) (cdr (assoc (quote srepr)  src))) #|line 123|#
    (setf (cdr (assoc (quote raw)  p)) (cdr (assoc (quote raw)  src))) #|line 124|#
    (setf (cdr (assoc (quote kind)  p)) (cdr (assoc (quote kind)  src))) #|line 125|#
    (setf (cdr (assoc (quote data)  p)) (cdr (assoc (quote(funcall (quote clone) ))  src))) #|line 126|#
    (return-from clone_datum_bytes  p)                      #|line 127|#) #|line 128|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 130|#
  #| pass |#                                                #|line 131|# #|line 132|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 134|#
  (return-from srepr_datum_bytes (cdr (assoc (quote(cdr (assoc (quote(funcall (quote decode)   "UTF_8"  #|line 135|#))  data)))  d))) #|line 136|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 137|#
  (return-from raw_datum_bytes (cdr (assoc (quote data)  d))) #|line 138|# #|line 139|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                  #|line 141|#
  (return-from new_datum_handle (funcall (quote new_datum_int)   h  #|line 142|#)) #|line 143|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 145|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 146|#
    (setf (cdr (assoc (quote data)  p))  i)                 #|line 147|#
    (setf (cdr (assoc (quote clone)  p))  #'(lambda (&optional )(funcall (quote clone_int)   i  #|line 148|#)))
    (setf (cdr (assoc (quote reclaim)  p))  #'(lambda (&optional )(funcall (quote reclaim_int)   i  #|line 149|#)))
    (setf (cdr (assoc (quote srepr)  p))  #'(lambda (&optional )(funcall (quote srepr_datum_int)   i  #|line 150|#)))
    (setf (cdr (assoc (quote raw)  p))  #'(lambda (&optional )(funcall (quote raw_datum_int)   i  #|line 151|#)))
    (setf (cdr (assoc (quote kind)  p))  #'(lambda (&optional ) "int")) #|line 152|#
    (return-from new_datum_int  p)                          #|line 153|#) #|line 154|#
  )
(defun clone_int (&optional  i)
  (declare (ignorable  i))                                  #|line 156|#
  (let ((p (funcall (quote new_datum_int)   i               #|line 157|#)))
    (declare (ignorable p))
    (return-from clone_int  p)                              #|line 158|#) #|line 159|#
  )
(defun reclaim_int (&optional  src)
  (declare (ignorable  src))                                #|line 161|#
  #| pass |#                                                #|line 162|# #|line 163|#
  )
(defun srepr_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 165|#
  (return-from srepr_datum_int (format nil "~a"  i)         #|line 166|#) #|line 167|#
  )
(defun raw_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 169|#
  (return-from raw_datum_int  i)                            #|line 170|# #|line 171|#
  ) #|  Message passed to a leaf component. |#              #|line 173|# #|  |# #|line 174|# #|  `port` refers to the name of the incoming or outgoing port of this component. |# #|line 175|# #|  `datum` is the data attached to this message. |# #|line 176|#
(defun Message (&optional  port  datum)                     #|line 177|#
  (list
    (cons (quot port)  port)                                #|line 178|#
    (cons (quot datum)  datum)                              #|line 179|#) #|line 180|#)
                                                            #|line 181|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                  #|line 182|#
  (return-from clone_port (funcall (quote clone_string)   s  #|line 183|#)) #|line 184|#
  ) #|  Utility for making a `Message`. Used to safely “seed“ messages |# #|line 186|# #|  entering the very top of a network. |# #|line 187|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                        #|line 188|#
  (let ((p (funcall (quote clone_string)   port             #|line 189|#)))
    (declare (ignorable p))
    (let ((m (funcall (quote Message)   p (cdr (assoc (quote(funcall (quote clone) ))  datum))  #|line 190|#)))
      (declare (ignorable m))
      (return-from make_message  m)                         #|line 191|#)) #|line 192|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 194|#
(defun message_clone (&optional  message)
  (declare (ignorable  message))                            #|line 195|#
  (let ((m (funcall (quote Message)  (funcall (quote clone_port)  (cdr (assoc (quote port)  message)) ) (cdr (assoc (quote(cdr (assoc (quote(funcall (quote clone) ))  datum)))  message))  #|line 196|#)))
    (declare (ignorable m))
    (return-from message_clone  m)                          #|line 197|#) #|line 198|#
  ) #|  Frees a message. |#                                 #|line 200|#
(defun destroy_message (&optional  msg)
  (declare (ignorable  msg))                                #|line 201|#
  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |# #|line 202|#
  #| pass |#                                                #|line 203|# #|line 204|#
  )
(defun destroy_datum (&optional  msg)
  (declare (ignorable  msg))                                #|line 206|#
  #| pass |#                                                #|line 207|# #|line 208|#
  )
(defun destroy_port (&optional  msg)
  (declare (ignorable  msg))                                #|line 210|#
  #| pass |#                                                #|line 211|# #|line 212|#
  ) #|  |#                                                  #|line 214|#
(defun format_message (&optional  m)
  (declare (ignorable  m))                                  #|line 215|#
  (cond
    (( equal    m  nil)                                     #|line 216|#
      (return-from format_message  "ϕ")                     #|line 217|#
      )
    (t                                                      #|line 218|#
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc (quote port)  m))  (concatenate 'string  "⦂"  (concatenate 'string (cdr (assoc (quote(cdr (assoc (quote(funcall (quote srepr) ))  datum)))  m))  "⟫")))) #|line 222|#) #|line 223|#
      ))                                                    #|line 224|#
  )                                                         #|line 226|#
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                              #|line 231|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))   #|line 232|# #|line 233|#
  (let ((container (funcall (quote make_container)   container_name  owner  #|line 234|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                        #|line 235|#
      (let ((children_by_id  nil))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |# #|line 236|#
        #|  collect children |#                             #|line 237|#
        (loop for child_desc in (cdr (assoc (quotechildren)  desc))
          do                                                #|line 238|#
          (let ((child_instance (funcall (quote get_component_instance)   reg (cdr (assoc (quotename)  child_desc))  container  #|line 239|#)))
            (declare (ignorable child_instance))
            (cdr (assoc (quote(funcall (quote append)   child_instance  #|line 240|#))  children))
            (setf (nth (cdr (assoc (quoteid)  child_desc))  children_by_id)  child_instance)) #|line 241|#
          )
        (setf (cdr (assoc (quote children)  container))  children) #|line 242|#
        (let ((me  container))
          (declare (ignorable me))                          #|line 243|# #|line 244|#
          (let ((connectors  nil))
            (declare (ignorable connectors))                #|line 245|#
            (loop for proto_conn in (cdr (assoc (quoteconnections)  desc))
              do                                            #|line 246|#
              (let ((connector (funcall (quote Connector) )))
                (declare (ignorable connector))             #|line 247|#
                (cond
                  (( equal   (cdr (assoc (quotedir)  proto_conn))  enumDown) #|line 248|#
                    #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 249|#
                    (setf (cdr (assoc (quote direction)  connector))  "down") #|line 250|#
                    (setf (cdr (assoc (quote sender)  connector)) (funcall (quote Sender)  (cdr (assoc (quote name)  me))  me (cdr (assoc (quotesource_port)  proto_conn))  #|line 251|#))
                    (let ((target_component (nth (cdr (assoc (quoteid) (cdr (assoc (quotetarget)  proto_conn))))  children_by_id)))
                      (declare (ignorable target_component)) #|line 252|#
                      (cond
                        (( equal    target_component  nil)  #|line 253|#
                          (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc (quotetarget)  proto_conn))) ) #|line 254|#
                          )
                        (t                                  #|line 255|#
                          (setf (cdr (assoc (quote receiver)  connector)) (funcall (quote Receiver)  (cdr (assoc (quote name)  target_component)) (cdr (assoc (quote inq)  target_component)) (cdr (assoc (quotetarget_port)  proto_conn))  target_component  #|line 256|#))
                          (cdr (assoc (quote(funcall (quote append)   connector ))  connectors))
                          )))                               #|line 257|#
                    )
                  (( equal   (cdr (assoc (quotedir)  proto_conn))  enumAcross) #|line 258|#
                    (setf (cdr (assoc (quote direction)  connector))  "across") #|line 259|#
                    (let ((source_component (nth (cdr (assoc (quoteid) (cdr (assoc (quotesource)  proto_conn))))  children_by_id)))
                      (declare (ignorable source_component)) #|line 260|#
                      (let ((target_component (nth (cdr (assoc (quoteid) (cdr (assoc (quotetarget)  proto_conn))))  children_by_id)))
                        (declare (ignorable target_component)) #|line 261|#
                        (cond
                          (( equal    source_component  nil) #|line 262|#
                            (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc (quotesource)  proto_conn))) ) #|line 263|#
                            )
                          (t                                #|line 264|#
                            (setf (cdr (assoc (quote sender)  connector)) (funcall (quote Sender)  (cdr (assoc (quote name)  source_component))  source_component (cdr (assoc (quotesource_port)  proto_conn))  #|line 265|#))
                            (cond
                              (( equal    target_component  nil) #|line 266|#
                                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc (quote target)  proto_conn))) ) #|line 267|#
                                )
                              (t                            #|line 268|#
                                (setf (cdr (assoc (quote receiver)  connector)) (funcall (quote Receiver)  (cdr (assoc (quote name)  target_component)) (cdr (assoc (quote inq)  target_component)) (cdr (assoc (quotetarget_port)  proto_conn))  target_component  #|line 269|#))
                                (cdr (assoc (quote(funcall (quote append)   connector ))  connectors))
                                ))
                            ))))                            #|line 270|#
                    )
                  (( equal   (cdr (assoc (quotedir)  proto_conn))  enumUp) #|line 271|#
                    (setf (cdr (assoc (quote direction)  connector))  "up") #|line 272|#
                    (let ((source_component (nth (cdr (assoc (quoteid) (cdr (assoc (quotesource)  proto_conn))))  children_by_id)))
                      (declare (ignorable source_component)) #|line 273|#
                      (cond
                        (( equal    source_component  nil)  #|line 274|#
                          (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc (quotesource)  proto_conn))) ) #|line 275|#
                          )
                        (t                                  #|line 276|#
                          (setf (cdr (assoc (quote sender)  connector)) (funcall (quote Sender)  (cdr (assoc (quote name)  source_component))  source_component (cdr (assoc (quotesource_port)  proto_conn))  #|line 277|#))
                          (setf (cdr (assoc (quote receiver)  connector)) (funcall (quote Receiver)  (cdr (assoc (quote name)  me)) (cdr (assoc (quote outq)  container)) (cdr (assoc (quotetarget_port)  proto_conn))  me  #|line 278|#))
                          (cdr (assoc (quote(funcall (quote append)   connector ))  connectors))
                          )))                               #|line 279|#
                    )
                  (( equal   (cdr (assoc (quotedir)  proto_conn))  enumThrough) #|line 280|#
                    (setf (cdr (assoc (quote direction)  connector))  "through") #|line 281|#
                    (setf (cdr (assoc (quote sender)  connector)) (funcall (quote Sender)  (cdr (assoc (quote name)  me))  me (cdr (assoc (quotesource_port)  proto_conn))  #|line 282|#))
                    (setf (cdr (assoc (quote receiver)  connector)) (funcall (quote Receiver)  (cdr (assoc (quote name)  me)) (cdr (assoc (quote outq)  container)) (cdr (assoc (quotetarget_port)  proto_conn))  me  #|line 283|#))
                    (cdr (assoc (quote(funcall (quote append)   connector ))  connectors))
                    )))                                     #|line 284|#
              )                                             #|line 285|#
            (setf (cdr (assoc (quote connections)  container))  connectors) #|line 286|#
            (return-from container_instantiator  container) #|line 287|#))))) #|line 288|#
  ) #|  The default handler for container components. |#    #|line 290|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                 #|line 291|#
  (funcall (quote route)   container  #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |# #|line 292|#
  (loop while (funcall (quote any_child_ready)   container )
    do
      (progn                                                #|line 293|#
        (funcall (quote step_children)   container  message ) #|line 294|#
        ))                                                  #|line 295|#
    ) #|  Frees the given container and associated data. |# #|line 297|#
  (defun destroy_container (&optional  eh)
    (declare (ignorable  eh))                               #|line 298|#
    #| pass |#                                              #|line 299|# #|line 300|#
    )
  (defun fifo_is_empty (&optional  fifo)
    (declare (ignorable  fifo))                             #|line 302|#
    (return-from fifo_is_empty (cdr (assoc (quote(funcall (quote empty) ))  fifo))) #|line 303|# #|line 304|#
    ) #|  Routing connection for a container component. The `direction` field has |# #|line 306|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 307|# #|  purposes, or for reading by other tools. |# #|line 308|# #|line 309|#
  (defun Connector (&optional )                             #|line 310|#
    (list
      (cons (quot direction)  nil)  #|  down, across, up, through |# #|line 311|#
      (cons (quot sender)  nil)                             #|line 312|#
      (cons (quot receiver)  nil)                           #|line 313|#) #|line 314|#)
                                                            #|line 315|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 316|# #|  based on component ID (pointer) and port name. |# #|line 317|# #|line 318|#
  (defun Sender (&optional  name  component  port)          #|line 319|#
    (list
      (cons (quot name)  name)                              #|line 320|#
      (cons (quot component)  component)  #|  from |#       #|line 321|#
      (cons (quot port)  port)  #|  from's port |#          #|line 322|#) #|line 323|#)
                                                            #|line 324|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 325|# #|  to incoming messages to this queue. |# #|line 326|# #|line 327|#
  (defun Receiver (&optional  name  queue  port  component) #|line 328|#
    (list
      (cons (quot name)  name)                              #|line 329|#
      (cons (quot queue)  queue)  #|  queue (input | output) of receiver |# #|line 330|#
      (cons (quot port)  port)  #|  destination port |#     #|line 331|#
      (cons (quot component)  component)  #|  to (for bootstrap debug) |# #|line 332|#) #|line 333|#)
                                                            #|line 334|# #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 335|#
  (defun sender_eq (&optional  s1  s2)
    (declare (ignorable  s1  s2))                           #|line 336|#
    (let ((same_components ( equal   (cdr (assoc (quote component)  s1)) (cdr (assoc (quote component)  s2)))))
      (declare (ignorable same_components))                 #|line 337|#
      (let ((same_ports ( equal   (cdr (assoc (quote port)  s1)) (cdr (assoc (quote port)  s2)))))
        (declare (ignorable same_ports))                    #|line 338|#
        (return-from sender_eq ( and   same_components  same_ports)) #|line 339|#)) #|line 340|#
    ) #|  Delivers the given message to the receiver of this connector. |# #|line 342|# #|line 343|#
  (defun deposit (&optional  parent  conn  message)
    (declare (ignorable  parent  conn  message))            #|line 344|#
    (let ((new_message (funcall (quote make_message)  (cdr (assoc (quote(cdr (assoc (quote port)  receiver)))  conn)) (cdr (assoc (quote datum)  message))  #|line 345|#)))
      (declare (ignorable new_message))
      (funcall (quote push_message)   parent (cdr (assoc (quote(cdr (assoc (quote component)  receiver)))  conn)) (cdr (assoc (quote(cdr (assoc (quote queue)  receiver)))  conn))  new_message  #|line 346|#)) #|line 347|#
    )
  (defun force_tick (&optional  parent  eh)
    (declare (ignorable  parent  eh))                       #|line 349|#
    (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 350|#)))
      (declare (ignorable tick_msg))
      (funcall (quote push_message)   parent  eh (cdr (assoc (quote inq)  eh))  tick_msg  #|line 351|#)
      (return-from force_tick  tick_msg)                    #|line 352|#) #|line 353|#
    )
  (defun push_message (&optional  parent  receiver  inq  m)
    (declare (ignorable  parent  receiver  inq  m))         #|line 355|#
    (cdr (assoc (quote(funcall (quote put)   m              #|line 356|#))  inq))
    (cdr (assoc (quote(cdr (assoc (quote(funcall (quote put)   receiver  #|line 357|#))  visit_ordering)))  parent)) #|line 358|#
    )
  (defun is_self (&optional  child  container)
    (declare (ignorable  child  container))                 #|line 360|#
    #|  in an earlier version “self“ was denoted as ϕ |#    #|line 361|#
    (return-from is_self ( equal    child  container))      #|line 362|# #|line 363|#
    )
  (defun step_child (&optional  child  msg)
    (declare (ignorable  child  msg))                       #|line 365|#
    (let ((before_state (cdr (assoc (quote state)  child))))
      (declare (ignorable before_state))                    #|line 366|#
      (cdr (assoc (quote(funcall (quote handler)   child  msg  #|line 367|#))  child))
      (let ((after_state (cdr (assoc (quote state)  child))))
        (declare (ignorable after_state))                   #|line 368|#
        (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 369|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 370|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 371|#)) #|line 372|#
    )
  (defun save_message (&optional  eh  msg)
    (declare (ignorable  eh  msg))                          #|line 374|#
    (cdr (assoc (quote(cdr (assoc (quote(funcall (quote put)   msg  #|line 375|#))  saved_messages)))  eh)) #|line 376|#
    )
  (defun fetch_saved_message_and_clear (&optional  eh)
    (declare (ignorable  eh))                               #|line 378|#
    (return-from fetch_saved_message_and_clear (cdr (assoc (quote(cdr (assoc (quote(funcall (quote get) ))  saved_messages)))  eh))) #|line 379|# #|line 380|#
    )
  (defun step_children (&optional  container  causingMessage)
    (declare (ignorable  container  causingMessage))        #|line 382|#
    (setf (cdr (assoc (quote state)  container))  "idle")   #|line 383|#
    (loop for child in (funcall (quote list)  (cdr (assoc (quote(cdr (assoc (quote queue)  visit_ordering)))  container)) )
      do                                                    #|line 384|#
      #|  child = container represents self, skip it |#     #|line 385|#
      (cond
        ((not (funcall (quote is_self)   child  container )) #|line 386|#
          (cond
            ((not (cdr (assoc (quote(cdr (assoc (quote(funcall (quote empty) ))  inq)))  child))) #|line 387|#
              (let ((msg (cdr (assoc (quote(cdr (assoc (quote(funcall (quote get) ))  inq)))  child))))
                (declare (ignorable msg))                   #|line 388|#
                (let (( began_long_run  nil))
                  (declare (ignorable  began_long_run))     #|line 389|#
                  (let (( continued_long_run  nil))
                    (declare (ignorable  continued_long_run)) #|line 390|#
                    (let (( ended_long_run  nil))
                      (declare (ignorable  ended_long_run)) #|line 391|#
                      (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall (quote step_child)   child  msg  #|line 392|#))
                      (cond
                        ( began_long_run                    #|line 393|#
                          (funcall (quote save_message)   child  msg  #|line 394|#)
                          )
                        ( continued_long_run                #|line 395|#
                          #| pass |#                        #|line 396|# #|line 397|#
                          ))
                      (funcall (quote destroy_message)   msg ))))) #|line 398|#
              )
            (t                                              #|line 399|#
              (cond
                ((not (equal  (cdr (assoc (quote state)  child))  "idle")) #|line 400|#
                  (let ((msg (funcall (quote force_tick)   container  child  #|line 401|#)))
                    (declare (ignorable msg))
                    (cdr (assoc (quote(funcall (quote handler)   child  msg  #|line 402|#))  child))
                    (funcall (quote destroy_message)   msg ))
                  ))                                        #|line 403|#
              ))                                            #|line 404|#
          (cond
            (( equal   (cdr (assoc (quote state)  child))  "active") #|line 405|#
              #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 406|#
              (setf (cdr (assoc (quote state)  container))  "active") #|line 407|#
              ))                                            #|line 408|#
          (loop while (not (cdr (assoc (quote(cdr (assoc (quote(funcall (quote empty) ))  outq)))  child)))
            do
              (progn                                        #|line 409|#
                (let ((msg (cdr (assoc (quote(cdr (assoc (quote(funcall (quote get) ))  outq)))  child))))
                  (declare (ignorable msg))                 #|line 410|#
                  (funcall (quote route)   container  child  msg  #|line 411|#)
                  (funcall (quote destroy_message)   msg ))
                ))
            ))                                              #|line 412|#
        )                                                   #|line 413|# #|line 414|# #|line 415|#
      )
    (defun attempt_tick (&optional  parent  eh)
      (declare (ignorable  parent  eh))                     #|line 417|#
      (cond
        ((not (equal  (cdr (assoc (quote state)  eh))  "idle")) #|line 418|#
          (funcall (quote force_tick)   parent  eh )        #|line 419|#
          ))                                                #|line 420|#
      )
    (defun is_tick (&optional  msg)
      (declare (ignorable  msg))                            #|line 422|#
      (return-from is_tick ( equal    "tick" (cdr (assoc (quote(cdr (assoc (quote(funcall (quote kind) ))  datum)))  msg)))) #|line 423|# #|line 424|#
      ) #|  Routes a single message to all matching destinations, according to |# #|line 426|# #|  the container's connection network. |# #|line 427|# #|line 428|#
    (defun route (&optional  container  from_component  message)
      (declare (ignorable  container  from_component  message)) #|line 429|#
      (let (( was_sent  nil))
        (declare (ignorable  was_sent))
        #|  for checking that output went somewhere (at least during bootstrap) |# #|line 430|#
        (let (( fromname  ""))
          (declare (ignorable  fromname))                   #|line 431|#
          (cond
            ((funcall (quote is_tick)   message )           #|line 432|#
              (loop for child in (cdr (assoc (quote children)  container))
                do                                          #|line 433|#
                (funcall (quote attempt_tick)   container  child ) #|line 434|#
                )
              (setf  was_sent  t)                           #|line 435|#
              )
            (t                                              #|line 436|#
              (cond
                ((not (funcall (quote is_self)   from_component  container )) #|line 437|#
                  (setf  fromname (cdr (assoc (quote name)  from_component))) #|line 438|#
                  ))
              (let ((from_sender (funcall (quote Sender)   fromname  from_component (cdr (assoc (quote port)  message))  #|line 439|#)))
                (declare (ignorable from_sender))           #|line 440|#
                (loop for connector in (cdr (assoc (quote connections)  container))
                  do                                        #|line 441|#
                  (cond
                    ((funcall (quote sender_eq)   from_sender (cdr (assoc (quote sender)  connector)) ) #|line 442|#
                      (funcall (quote deposit)   container  connector  message  #|line 443|#)
                      (setf  was_sent  t)
                      ))
                  ))                                        #|line 444|#
              ))
          (cond
            ((not  was_sent)                                #|line 445|#
              (funcall (quote print)   "\n\n*** Error: ***"  #|line 446|#)
              (funcall (quote print)   "***"                #|line 447|#)
              (funcall (quote print)   (concatenate 'string (cdr (assoc (quote name)  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc (quote port)  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 448|#)
              (funcall (quote print)   "***"                #|line 449|#)
              (uiop:quit)                                   #|line 450|# #|line 451|#
              ))))                                          #|line 452|#
      )
    (defun any_child_ready (&optional  container)
      (declare (ignorable  container))                      #|line 454|#
      (loop for child in (cdr (assoc (quote children)  container))
        do                                                  #|line 455|#
        (cond
          ((funcall (quote child_is_ready)   child )        #|line 456|#
            (return-from any_child_ready  t)
            ))                                              #|line 457|#
        )
      (return-from any_child_ready  nil)                    #|line 458|# #|line 459|#
      )
    (defun child_is_ready (&optional  eh)
      (declare (ignorable  eh))                             #|line 461|#
      (return-from child_is_ready ( or  ( or  ( or  (not (cdr (assoc (quote(cdr (assoc (quote(funcall (quote empty) ))  outq)))  eh))) (not (cdr (assoc (quote(cdr (assoc (quote(funcall (quote empty) ))  inq)))  eh)))) (not (equal  (cdr (assoc (quote state)  eh))  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 462|# #|line 463|#
      )
    (defun append_routing_descriptor (&optional  container  desc)
      (declare (ignorable  container  desc))                #|line 465|#
      (cdr (assoc (quote(cdr (assoc (quote(funcall (quote put)   desc  #|line 466|#))  routings)))  container)) #|line 467|#
      )
    (defun container_injector (&optional  container  message)
      (declare (ignorable  container  message))             #|line 469|#
      (funcall (quote container_handler)   container  message  #|line 470|#) #|line 471|#
      )





