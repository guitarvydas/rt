
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
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
    (cons (quote data)  nil)                                #|line 31|#
    (cons (quote clone)  nil)                               #|line 32|#
    (cons (quote reclaim)  nil)                             #|line 33|#
    (cons (quote srepr)  nil)                               #|line 34|#
    (cons (quote kind)  nil)                                #|line 35|#
    (cons (quote raw)  nil)                                 #|line 36|#) #|line 37|#)
                                                            #|line 38|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                  #|line 39|#
  (let ((d  (Datum)                                         #|line 40|#))
    (declare (ignorable d))
    (setf (cdr (assoc  data  d))  s)                        #|line 41|#
    (setf (cdr (assoc  clone  d))  #'(lambda (&optional )(funcall (quote clone_datum_string)   d  #|line 42|#)))
    (setf (cdr (assoc  reclaim  d))  #'(lambda (&optional )(funcall (quote reclaim_datum_string)   d  #|line 43|#)))
    (setf (cdr (assoc  srepr  d))  #'(lambda (&optional )(funcall (quote srepr_datum_string)   d  #|line 44|#)))
    (setf (cdr (assoc  raw  d)) (coerce (cdr (assoc  data  d)) 'simple-vector) #|line 45|#)
    (setf (cdr (assoc  kind  d))  #'(lambda (&optional ) "string")) #|line 46|#
    (return-from new_datum_string  d)                       #|line 47|#) #|line 48|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 50|#
  (let ((d (funcall (quote new_datum_string)  (cdr (assoc  data  d))  #|line 51|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                     #|line 52|#) #|line 53|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                #|line 55|#
  #| pass |#                                                #|line 56|# #|line 57|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                  #|line 59|#
  (return-from srepr_datum_string (cdr (assoc  data  d)))   #|line 60|# #|line 61|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                    #|line 63|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 64|#
    (setf (cdr (assoc  data  p))  t)                        #|line 65|#
    (setf (cdr (assoc  clone  p))  #'(lambda (&optional )(funcall (quote clone_datum_bang)   p  #|line 66|#)))
    (setf (cdr (assoc  reclaim  p))  #'(lambda (&optional )(funcall (quote reclaim_datum_bang)   p  #|line 67|#)))
    (setf (cdr (assoc  srepr  p))  #'(lambda (&optional )(funcall (quote srepr_datum_bang) ))) #|line 68|#
    (setf (cdr (assoc  raw  p))  #'(lambda (&optional )(funcall (quote raw_datum_bang) ))) #|line 69|#
    (setf (cdr (assoc  kind  p))  #'(lambda (&optional ) "bang")) #|line 70|#
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
    (setf (cdr (assoc  kind  p))  #'(lambda (&optional ) "tick")) #|line 92|#
    (setf (cdr (assoc  clone  p))  #'(lambda (&optional )(funcall (quote new_datum_tick) ))) #|line 93|#
    (setf (cdr (assoc  srepr  p))  #'(lambda (&optional )(funcall (quote srepr_datum_tick) ))) #|line 94|#
    (setf (cdr (assoc  raw  p))  #'(lambda (&optional )(funcall (quote raw_datum_tick) ))) #|line 95|#
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
    (setf (cdr (assoc  data  p))  b)                        #|line 109|#
    (setf (cdr (assoc  clone  p))  #'(lambda (&optional )(funcall (quote clone_datum_bytes)   p  #|line 110|#)))
    (setf (cdr (assoc  reclaim  p))  #'(lambda (&optional )(funcall (quote reclaim_datum_bytes)   p  #|line 111|#)))
    (setf (cdr (assoc  srepr  p))  #'(lambda (&optional )(funcall (quote srepr_datum_bytes)   b  #|line 112|#)))
    (setf (cdr (assoc  raw  p))  #'(lambda (&optional )(funcall (quote raw_datum_bytes)   b  #|line 113|#)))
    (setf (cdr (assoc  kind  p))  #'(lambda (&optional ) "bytes")) #|line 114|#
    (return-from new_datum_bytes  p)                        #|line 115|#) #|line 116|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 118|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 119|#
    (setf (cdr (assoc  clone  p)) (cdr (assoc  clone  src))) #|line 120|#
    (setf (cdr (assoc  reclaim  p)) (cdr (assoc  reclaim  src))) #|line 121|#
    (setf (cdr (assoc  srepr  p)) (cdr (assoc  srepr  src))) #|line 122|#
    (setf (cdr (assoc  raw  p)) (cdr (assoc  raw  src)))    #|line 123|#
    (setf (cdr (assoc  kind  p)) (cdr (assoc  kind  src)))  #|line 124|#
    (setf (cdr (assoc  data  p)) (cdr (assoc (funcall (quote clone) )  src))) #|line 125|#
    (return-from clone_datum_bytes  p)                      #|line 126|#) #|line 127|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                #|line 129|#
  #| pass |#                                                #|line 130|# #|line 131|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 133|#
  (return-from srepr_datum_bytes (cdr (assoc (cdr (assoc (funcall (quote decode)   "UTF_8"  #|line 134|#)  data))  d))) #|line 135|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                  #|line 136|#
  (return-from raw_datum_bytes (cdr (assoc  data  d)))      #|line 137|# #|line 138|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                  #|line 140|#
  (return-from new_datum_handle (funcall (quote new_datum_int)   h  #|line 141|#)) #|line 142|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                  #|line 144|#
  (let ((p (funcall (quote Datum) )))
    (declare (ignorable p))                                 #|line 145|#
    (setf (cdr (assoc  data  p))  i)                        #|line 146|#
    (setf (cdr (assoc  clone  p))  #'(lambda (&optional )(funcall (quote clone_int)   i  #|line 147|#)))
    (setf (cdr (assoc  reclaim  p))  #'(lambda (&optional )(funcall (quote reclaim_int)   i  #|line 148|#)))
    (setf (cdr (assoc  srepr  p))  #'(lambda (&optional )(funcall (quote srepr_datum_int)   i  #|line 149|#)))
    (setf (cdr (assoc  raw  p))  #'(lambda (&optional )(funcall (quote raw_datum_int)   i  #|line 150|#)))
    (setf (cdr (assoc  kind  p))  #'(lambda (&optional ) "int")) #|line 151|#
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
    (cons (quote port)  port)                               #|line 177|#
    (cons (quote datum)  datum)                             #|line 178|#) #|line 179|#)
                                                            #|line 180|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                  #|line 181|#
  (return-from clone_port (funcall (quote clone_string)   s  #|line 182|#)) #|line 183|#
  ) #|  Utility for making a `Message`. Used to safely “seed“ messages |# #|line 185|# #|  entering the very top of a network. |# #|line 186|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                        #|line 187|#
  (let ((p (funcall (quote clone_string)   port             #|line 188|#)))
    (declare (ignorable p))
    (let ((m (funcall (quote Message)   p (cdr (assoc (funcall (quote clone) )  datum))  #|line 189|#)))
      (declare (ignorable m))
      (return-from make_message  m)                         #|line 190|#)) #|line 191|#
  ) #|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |# #|line 193|#
(defun message_clone (&optional  message)
  (declare (ignorable  message))                            #|line 194|#
  (let ((m (funcall (quote Message)  (funcall (quote clone_port)  (cdr (assoc  port  message)) ) (cdr (assoc (cdr (assoc (funcall (quote clone) )  datum))  message))  #|line 195|#)))
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
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc  port  m))  (concatenate 'string  "⦂"  (concatenate 'string (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  m))  "⟫")))) #|line 221|#) #|line 222|#
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
        (loop for child_desc in (cdr (assoc (quote children)  desc))
          do
            (progn
              child_desc                                    #|line 237|#
              (let ((child_instance (funcall (quote get_component_instance)   reg (cdr (assoc (quote name)  child_desc))  container  #|line 238|#)))
                (declare (ignorable child_instance))
                (cdr (assoc (funcall (quote append)   child_instance  #|line 239|#)  children))
                (setf (nth (cdr (assoc (quote id)  child_desc))  children_by_id)  child_instance)) #|line 240|#
              ))
        (setf (cdr (assoc  children  container))  children) #|line 241|#
        (let ((me  container))
          (declare (ignorable me))                          #|line 242|# #|line 243|#
          (let ((connectors  nil))
            (declare (ignorable connectors))                #|line 244|#
            (loop for proto_conn in (cdr (assoc (quote connections)  desc))
              do
                (progn
                  proto_conn                                #|line 245|#
                  (let ((connector (funcall (quote Connector) )))
                    (declare (ignorable connector))         #|line 246|#
                    (cond
                      (( equal   (cdr (assoc (quote dir)  proto_conn))  enumDown) #|line 247|#
                        #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |# #|line 248|#
                        (setf (cdr (assoc  direction  connector))  "down") #|line 249|#
                        (setf (cdr (assoc  sender  connector)) (funcall (quote Sender)  (cdr (assoc  name  me))  me (cdr (assoc (quote source_port)  proto_conn))  #|line 250|#))
                        (let ((target_component (nth (cdr (assoc (quote id) (cdr (assoc (quote target)  proto_conn))))  children_by_id)))
                          (declare (ignorable target_component)) #|line 251|#
                          (cond
                            (( equal    target_component  nil) #|line 252|#
                              (funcall (quote load_error)   (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc (quote target)  proto_conn))) ) #|line 253|#
                              )
                            (t                              #|line 254|#
                              (setf (cdr (assoc  receiver  connector)) (funcall (quote Receiver)  (cdr (assoc  name  target_component)) (cdr (assoc  inq  target_component)) (cdr (assoc (quote target_port)  proto_conn))  target_component  #|line 255|#))
                              (cdr (assoc (funcall (quote append)   connector )  connectors))
                              )))                           #|line 256|#
                        )
                      (( equal   (cdr (assoc (quote dir)  proto_conn))  enumAcross) #|line 257|#
                        (setf (cdr (assoc  direction  connector))  "across") #|line 258|#
                        (let ((source_component (nth (cdr (assoc (quote id) (cdr (assoc (quote source)  proto_conn))))  children_by_id)))
                          (declare (ignorable source_component)) #|line 259|#
                          (let ((target_component (nth (cdr (assoc (quote id) (cdr (assoc (quote target)  proto_conn))))  children_by_id)))
                            (declare (ignorable target_component)) #|line 260|#
                            (cond
                              (( equal    source_component  nil) #|line 261|#
                                (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc (quote source)  proto_conn))) ) #|line 262|#
                                )
                              (t                            #|line 263|#
                                (setf (cdr (assoc  sender  connector)) (funcall (quote Sender)  (cdr (assoc  name  source_component))  source_component (cdr (assoc (quote source_port)  proto_conn))  #|line 264|#))
                                (cond
                                  (( equal    target_component  nil) #|line 265|#
                                    (funcall (quote load_error)   (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc  target  proto_conn))) ) #|line 266|#
                                    )
                                  (t                        #|line 267|#
                                    (setf (cdr (assoc  receiver  connector)) (funcall (quote Receiver)  (cdr (assoc  name  target_component)) (cdr (assoc  inq  target_component)) (cdr (assoc (quote target_port)  proto_conn))  target_component  #|line 268|#))
                                    (cdr (assoc (funcall (quote append)   connector )  connectors))
                                    ))
                                ))))                        #|line 269|#
                        )
                      (( equal   (cdr (assoc (quote dir)  proto_conn))  enumUp) #|line 270|#
                        (setf (cdr (assoc  direction  connector))  "up") #|line 271|#
                        (let ((source_component (nth (cdr (assoc (quote id) (cdr (assoc (quote source)  proto_conn))))  children_by_id)))
                          (declare (ignorable source_component)) #|line 272|#
                          (cond
                            (( equal    source_component  nil) #|line 273|#
                              (funcall (quote print)   (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc (quote source)  proto_conn))) ) #|line 274|#
                              )
                            (t                              #|line 275|#
                              (setf (cdr (assoc  sender  connector)) (funcall (quote Sender)  (cdr (assoc  name  source_component))  source_component (cdr (assoc (quote source_port)  proto_conn))  #|line 276|#))
                              (setf (cdr (assoc  receiver  connector)) (funcall (quote Receiver)  (cdr (assoc  name  me)) (cdr (assoc  outq  container)) (cdr (assoc (quote target_port)  proto_conn))  me  #|line 277|#))
                              (cdr (assoc (funcall (quote append)   connector )  connectors))
                              )))                           #|line 278|#
                        )
                      (( equal   (cdr (assoc (quote dir)  proto_conn))  enumThrough) #|line 279|#
                        (setf (cdr (assoc  direction  connector))  "through") #|line 280|#
                        (setf (cdr (assoc  sender  connector)) (funcall (quote Sender)  (cdr (assoc  name  me))  me (cdr (assoc (quote source_port)  proto_conn))  #|line 281|#))
                        (setf (cdr (assoc  receiver  connector)) (funcall (quote Receiver)  (cdr (assoc  name  me)) (cdr (assoc  outq  container)) (cdr (assoc (quote target_port)  proto_conn))  me  #|line 282|#))
                        (cdr (assoc (funcall (quote append)   connector )  connectors))
                        )))                                 #|line 283|#
                  ))                                        #|line 284|#
            (setf (cdr (assoc  connections  container))  connectors) #|line 285|#
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
    (return-from fifo_is_empty (cdr (assoc (funcall (quote empty) )  fifo))) #|line 302|# #|line 303|#
    ) #|  Routing connection for a container component. The `direction` field has |# #|line 305|# #|  no affect on the default message routing system _ it is there for debugging |# #|line 306|# #|  purposes, or for reading by other tools. |# #|line 307|# #|line 308|#
  (defun Connector (&optional )                             #|line 309|#
    (list
      (cons (quote direction)  nil)  #|  down, across, up, through |# #|line 310|#
      (cons (quote sender)  nil)                            #|line 311|#
      (cons (quote receiver)  nil)                          #|line 312|#) #|line 313|#)
                                                            #|line 314|# #|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |# #|line 315|# #|  based on component ID (pointer) and port name. |# #|line 316|# #|line 317|#
  (defun Sender (&optional  name  component  port)          #|line 318|#
    (list
      (cons (quote name)  name)                             #|line 319|#
      (cons (quote component)  component)  #|  from |#      #|line 320|#
      (cons (quote port)  port)  #|  from's port |#         #|line 321|#) #|line 322|#)
                                                            #|line 323|# #|  `Receiver` is a handle to a destination queue, and a `port` name to assign |# #|line 324|# #|  to incoming messages to this queue. |# #|line 325|# #|line 326|#
  (defun Receiver (&optional  name  queue  port  component) #|line 327|#
    (list
      (cons (quote name)  name)                             #|line 328|#
      (cons (quote queue)  queue)  #|  queue (input | output) of receiver |# #|line 329|#
      (cons (quote port)  port)  #|  destination port |#    #|line 330|#
      (cons (quote component)  component)  #|  to (for bootstrap debug) |# #|line 331|#) #|line 332|#)
                                                            #|line 333|# #|  Checks if two senders match, by pointer equality and port name matching. |# #|line 334|#
  (defun sender_eq (&optional  s1  s2)
    (declare (ignorable  s1  s2))                           #|line 335|#
    (let ((same_components ( equal   (cdr (assoc  component  s1)) (cdr (assoc  component  s2)))))
      (declare (ignorable same_components))                 #|line 336|#
      (let ((same_ports ( equal   (cdr (assoc  port  s1)) (cdr (assoc  port  s2)))))
        (declare (ignorable same_ports))                    #|line 337|#
        (return-from sender_eq ( and   same_components  same_ports)) #|line 338|#)) #|line 339|#
    ) #|  Delivers the given message to the receiver of this connector. |# #|line 341|# #|line 342|#
  (defun deposit (&optional  parent  conn  message)
    (declare (ignorable  parent  conn  message))            #|line 343|#
    (let ((new_message (funcall (quote make_message)  (cdr (assoc (cdr (assoc  port  receiver))  conn)) (cdr (assoc  datum  message))  #|line 344|#)))
      (declare (ignorable new_message))
      (funcall (quote push_message)   parent (cdr (assoc (cdr (assoc  component  receiver))  conn)) (cdr (assoc (cdr (assoc  queue  receiver))  conn))  new_message  #|line 345|#)) #|line 346|#
    )
  (defun force_tick (&optional  parent  eh)
    (declare (ignorable  parent  eh))                       #|line 348|#
    (let ((tick_msg (funcall (quote make_message)   "." (funcall (quote new_datum_tick) )  #|line 349|#)))
      (declare (ignorable tick_msg))
      (funcall (quote push_message)   parent  eh (cdr (assoc  inq  eh))  tick_msg  #|line 350|#)
      (return-from force_tick  tick_msg)                    #|line 351|#) #|line 352|#
    )
  (defun push_message (&optional  parent  receiver  inq  m)
    (declare (ignorable  parent  receiver  inq  m))         #|line 354|#
    (cdr (assoc (funcall (quote put)   m                    #|line 355|#)  inq))
    (cdr (assoc (cdr (assoc (funcall (quote put)   receiver  #|line 356|#)  visit_ordering))  parent)) #|line 357|#
    )
  (defun is_self (&optional  child  container)
    (declare (ignorable  child  container))                 #|line 359|#
    #|  in an earlier version “self“ was denoted as ϕ |#    #|line 360|#
    (return-from is_self ( equal    child  container))      #|line 361|# #|line 362|#
    )
  (defun step_child (&optional  child  msg)
    (declare (ignorable  child  msg))                       #|line 364|#
    (let ((before_state (cdr (assoc  state  child))))
      (declare (ignorable before_state))                    #|line 365|#
      (cdr (assoc (funcall (quote handler)   child  msg     #|line 366|#)  child))
      (let ((after_state (cdr (assoc  state  child))))
        (declare (ignorable after_state))                   #|line 367|#
        (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))  #|line 368|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle")))  #|line 369|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle")))) #|line 370|#)) #|line 371|#
    )
  (defun save_message (&optional  eh  msg)
    (declare (ignorable  eh  msg))                          #|line 373|#
    (cdr (assoc (cdr (assoc (funcall (quote put)   msg      #|line 374|#)  saved_messages))  eh)) #|line 375|#
    )
  (defun fetch_saved_message_and_clear (&optional  eh)
    (declare (ignorable  eh))                               #|line 377|#
    (return-from fetch_saved_message_and_clear (cdr (assoc (cdr (assoc (funcall (quote get) )  saved_messages))  eh))) #|line 378|# #|line 379|#
    )
  (defun step_children (&optional  container  causingMessage)
    (declare (ignorable  container  causingMessage))        #|line 381|#
    (setf (cdr (assoc  state  container))  "idle")          #|line 382|#
    (loop for child in (funcall (quote list)  (cdr (assoc (cdr (assoc  queue  visit_ordering))  container)) )
      do
        (progn
          child                                             #|line 383|#
          #|  child = container represents self, skip it |# #|line 384|#
          (cond
            ((not (funcall (quote is_self)   child  container )) #|line 385|#
              (cond
                ((not (cdr (assoc (cdr (assoc (funcall (quote empty) )  inq))  child))) #|line 386|#
                  (let ((msg (cdr (assoc (cdr (assoc (funcall (quote get) )  inq))  child))))
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
                    ((not (equal  (cdr (assoc  state  child))  "idle")) #|line 399|#
                      (let ((msg (funcall (quote force_tick)   container  child  #|line 400|#)))
                        (declare (ignorable msg))
                        (cdr (assoc (funcall (quote handler)   child  msg  #|line 401|#)  child))
                        (funcall (quote destroy_message)   msg ))
                      ))                                    #|line 402|#
                  ))                                        #|line 403|#
              (cond
                (( equal   (cdr (assoc  state  child))  "active") #|line 404|#
                  #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |# #|line 405|#
                  (setf (cdr (assoc  state  container))  "active") #|line 406|#
                  ))                                        #|line 407|#
              (loop while (not (cdr (assoc (cdr (assoc (funcall (quote empty) )  outq))  child)))
                do
                  (progn                                    #|line 408|#
                    (let ((msg (cdr (assoc (cdr (assoc (funcall (quote get) )  outq))  child))))
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
        ((not (equal  (cdr (assoc  state  eh))  "idle"))    #|line 417|#
          (funcall (quote force_tick)   parent  eh )        #|line 418|#
          ))                                                #|line 419|#
      )
    (defun is_tick (&optional  msg)
      (declare (ignorable  msg))                            #|line 421|#
      (return-from is_tick ( equal    "tick" (cdr (assoc (cdr (assoc (funcall (quote kind) )  datum))  msg)))) #|line 422|# #|line 423|#
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
              (loop for child in (cdr (assoc  children  container))
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
                  (setf  fromname (cdr (assoc  name  from_component))) #|line 437|#
                  ))
              (let ((from_sender (funcall (quote Sender)   fromname  from_component (cdr (assoc  port  message))  #|line 438|#)))
                (declare (ignorable from_sender))           #|line 439|#
                (loop for connector in (cdr (assoc  connections  container))
                  do
                    (progn
                      connector                             #|line 440|#
                      (cond
                        ((funcall (quote sender_eq)   from_sender (cdr (assoc  sender  connector)) ) #|line 441|#
                          (funcall (quote deposit)   container  connector  message  #|line 442|#)
                          (setf  was_sent  t)
                          ))
                      )))                                   #|line 443|#
              ))
          (cond
            ((not  was_sent)                                #|line 444|#
              (funcall (quote print)   "\n\n*** Error: ***"  #|line 445|#)
              (funcall (quote print)   "***"                #|line 446|#)
              (funcall (quote print)   (concatenate 'string (cdr (assoc  name  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc  port  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor...")))))  #|line 447|#)
              (funcall (quote print)   "***"                #|line 448|#)
              (uiop:quit)                                   #|line 449|# #|line 450|#
              ))))                                          #|line 451|#
      )
    (defun any_child_ready (&optional  container)
      (declare (ignorable  container))                      #|line 453|#
      (loop for child in (cdr (assoc  children  container))
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
      (return-from child_is_ready ( or  ( or  ( or  (not (cdr (assoc (cdr (assoc (funcall (quote empty) )  outq))  eh))) (not (cdr (assoc (cdr (assoc (funcall (quote empty) )  inq))  eh)))) (not (equal  (cdr (assoc  state  eh))  "idle"))) (funcall (quote any_child_ready)   eh ))) #|line 461|# #|line 462|#
      )
    (defun append_routing_descriptor (&optional  container  desc)
      (declare (ignorable  container  desc))                #|line 464|#
      (cdr (assoc (cdr (assoc (funcall (quote put)   desc   #|line 465|#)  routings))  container)) #|line 466|#
      )
    (defun container_injector (&optional  container  message)
      (declare (ignorable  container  message))             #|line 468|#
      (funcall (quote container_handler)   container  message  #|line 469|#) #|line 470|#
      )






                                                            #|line 1|# #|line 2|# #|line 3|#
(defun Component_Registry (&optional )                      #|line 4|#
  (list
    (cons (quote templates)  nil)                           #|line 5|#) #|line 6|#)
                                                            #|line 7|#
(defun Template (&optional  name  template_data  instantiator) #|line 8|#
  (list
    (cons (quote name)  name)                               #|line 9|#
    (cons (quote template_data)  template_data)             #|line 10|#
    (cons (quote instantiator)  instantiator)               #|line 11|#) #|line 12|#)
                                                            #|line 13|#
(defun read_and_convert_json_file (&optional  filename)
  (declare (ignorable  filename))                           #|line 14|#

  ;; read json from a named file and convert it into internal form (a tree of routings)
  ;; return the routings from the function or raise an error
  (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
    (json:decode-json json-stream))
                                                            #|line 15|# #|line 16|#
  )
(defun json2internal (&optional  container_xml)
  (declare (ignorable  container_xml))                      #|line 18|#
  (let ((fname (let ((p (parse-namestring  container_xml)))(format nil "~a.~a" (pathname-name p) (pathname-type p))) #|line 19|#))
    (declare (ignorable fname))
    (let ((routings (funcall (quote read_and_convert_json_file)   fname  #|line 20|#)))
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
  (let ((name (funcall (quote mangle_name)  (cdr (assoc  name  template))  #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  ( assoc   name (cdr (assoc  templates  reg))) (not  ok_to_overwrite)) #|line 37|#
        (funcall (quote load_error)   (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc  name  template))  " already declared")) ) #|line 38|#
        ))
    (setf (cdr (assoc (cdr (assoc  name  templates))  reg))  template) #|line 39|#
    (return-from abstracted_register_component  reg)        #|line 40|#) #|line 41|#
  )
(defun register_multiple_components (&optional  reg  templates)
  (declare (ignorable  reg  templates))                     #|line 43|#
  (loop for template in  templates
    do
      (progn
        template                                            #|line 44|#
        (funcall (quote register_component)   reg  template ) #|line 45|#
        ))                                                  #|line 46|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))              #|line 48|#
  (let ((template_name (funcall (quote mangle_name)   full_name  #|line 49|#)))
    (declare (ignorable template_name))
    (cond
      (( assoc   template_name (cdr (assoc  templates  reg))) #|line 50|#
        (let ((template (cdr (assoc (nth  template_name  templates)  reg))))
          (declare (ignorable template))                    #|line 51|#
          (cond
            (( equal    template  nil)                      #|line 52|#
              (funcall (quote load_error)   (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?"))  #|line 53|#)
              (return-from get_component_instance  nil)     #|line 54|#
              )
            (t                                              #|line 55|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))            #|line 56|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))       #|line 57|#
                  (cond
                    ((not (equal   nil  owner))             #|line 58|#
                      (setf  owner_name (cdr (assoc  name  owner))) #|line 59|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))) #|line 60|#
                      )
                    (t                                      #|line 61|#
                      (setf  instance_name  template_name)  #|line 62|#
                      ))
                  (let ((instance (cdr (assoc (funcall (quote instantiator)   reg  owner  instance_name (cdr (assoc  template_data  template))  #|line 63|#)  template))))
                    (declare (ignorable instance))
                    (setf (cdr (assoc  depth  instance)) (funcall (quote calculate_depth)   instance  #|line 64|#))
                    (return-from get_component_instance  instance))))
              )))                                           #|line 65|#
        )
      (t                                                    #|line 66|#
        (funcall (quote load_error)   (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?"))  #|line 67|#)
        (return-from get_component_instance  nil)           #|line 68|#
        )))                                                 #|line 69|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                 #|line 70|#
  (cond
    (( equal   (cdr (assoc  owner  eh))  nil)               #|line 71|#
      (return-from calculate_depth  0)                      #|line 72|#
      )
    (t                                                      #|line 73|#
      (return-from calculate_depth (+  1 (funcall (quote calculate_depth)  (cdr (assoc  owner  eh)) ))) #|line 74|#
      ))                                                    #|line 75|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                #|line 77|#
  (funcall (quote nl) )                                     #|line 78|#
  (format *standard-output* "~a"  "*** PALETTE ***")        #|line 79|#
  (loop for c in (cdr (assoc  templates  reg))
    do
      (progn
        c                                                   #|line 80|#
        (funcall (quote print)  (cdr (assoc  name  c)) )    #|line 81|#
        ))
  (format *standard-output* "~a"  "***************")        #|line 82|#
  (funcall (quote nl) )                                     #|line 83|# #|line 84|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                #|line 86|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (cdr (assoc  stats  reg)))) #|line 87|# #|line 88|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                  #|line 90|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |# #|line 91|#
  (return-from mangle_name  s)                              #|line 92|# #|line 93|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 95|#
  #|  [ |#                                                  #|line 96|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 97|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 98|#
  #|  ] |#                                                  #|line 99|#
  (cond
    ((not (equal   nil  container_list))                    #|line 100|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 101|#
            #|  loop through every component in the diagram and look for names that start with “$“ |# #|line 102|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 103|#
            (loop for child_descriptor in (cdr (assoc (quote children)  diagram))
              do
                (progn
                  child_descriptor                          #|line 104|#
                  (cond
                    ((funcall (quote first_char_is)  (cdr (assoc (quote name)  child_descriptor))  "$" ) #|line 105|#
                      (let ((name (cdr (assoc (quote name)  child_descriptor))))
                        (declare (ignorable name))          #|line 106|#
                        (let ((cmd (cdr (assoc (funcall (quote strip) )  (subseq  name 1)))))
                          (declare (ignorable cmd))         #|line 107|#
                          (let ((generated_leaf (funcall (quote Template)   name  #'shell_out_instantiate  cmd  #|line 108|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 109|#))))
                      )
                    ((funcall (quote first_char_is)  (cdr (assoc (quote name)  child_descriptor))  "'" ) #|line 110|#
                      (let ((name (cdr (assoc (quote name)  child_descriptor))))
                        (declare (ignorable name))          #|line 111|#
                        (let ((s  (subseq  name 1)          #|line 112|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote Template)   name  #'string_constant_instantiate  s  #|line 113|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 114|#)))) #|line 115|#
                      ))                                    #|line 116|#
                  ))                                        #|line 117|#
            ))                                              #|line 118|#
      ))                                                    #|line 119|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 121|#
  (return-from first_char  (car  s)                         #|line 122|#) #|line 123|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 125|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 126|#))) #|line 127|#
  )                                                         #|line 129|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 130|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 131|# #|line 132|# #|line 133|# #|  Data for an asyncronous component _ effectively, a function with input |# #|line 134|# #|  and output queues of messages. |# #|line 135|# #|  |# #|line 136|# #|  Components can either be a user_supplied function (“lea“), or a “container“ |# #|line 137|# #|  that routes messages to child components according to a list of connections |# #|line 138|# #|  that serve as a message routing table. |# #|line 139|# #|  |# #|line 140|# #|  Child components themselves can be leaves or other containers. |# #|line 141|# #|  |# #|line 142|# #|  `handler` invokes the code that is attached to this component. |# #|line 143|# #|  |# #|line 144|# #|  `instance_data` is a pointer to instance data that the `leaf_handler` |# #|line 145|# #|  function may want whenever it is invoked again. |# #|line 146|# #|  |# #|line 147|# #|line 148|# #|  Eh_States :: enum { idle, active } |# #|line 149|#
(defun Eh (&optional )                                      #|line 150|#
  (list
    (cons (quote name)  "")                                 #|line 151|#
    (cons (quote inq)  (make-instance 'Queue)               #|line 152|#)
    (cons (quote outq)  (make-instance 'Queue)              #|line 153|#)
    (cons (quote owner)  nil)                               #|line 154|#
    (cons (quote saved_messages)  nil)  #|  stack of saved message(s) |# #|line 155|#
    (cons (quote children)  nil)                            #|line 156|#
    (cons (quote visit_ordering)  (make-instance 'Queue)    #|line 157|#)
    (cons (quote connections)  nil)                         #|line 158|#
    (cons (quote routings)  (make-instance 'Queue)          #|line 159|#)
    (cons (quote handler)  nil)                             #|line 160|#
    (cons (quote instance_data)  nil)                       #|line 161|#
    (cons (quote state)  "idle")                            #|line 162|# #|  bootstrap debugging |# #|line 163|#
    (cons (quote kind)  nil)  #|  enum { container, leaf, } |# #|line 164|#
    (cons (quote trace)  nil)  #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |# #|line 165|#
    (cons (quote depth)  0)  #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |# #|line 166|#) #|line 167|#)
                                                            #|line 168|# #|  Creates a component that acts as a container. It is the same as a `Eh` instance |# #|line 169|# #|  whose handler function is `container_handler`. |# #|line 170|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                        #|line 171|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 172|#
    (setf (cdr (assoc  name  eh))  name)                    #|line 173|#
    (setf (cdr (assoc  owner  eh))  owner)                  #|line 174|#
    (setf (cdr (assoc  handler  eh))  #'container_handler)  #|line 175|#
    (setf (cdr (assoc  inject  eh))  #'container_injector)  #|line 176|#
    (setf (cdr (assoc  state  eh))  "idle")                 #|line 177|#
    (setf (cdr (assoc  kind  eh))  "container")             #|line 178|#
    (return-from make_container  eh)                        #|line 179|#) #|line 180|#
  ) #|  Creates a new leaf component out of a handler function, and a data parameter |# #|line 182|# #|  that will be passed back to your handler when called. |# #|line 183|# #|line 184|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler)) #|line 185|#
  (let ((eh (funcall (quote Eh) )))
    (declare (ignorable eh))                                #|line 186|#
    (setf (cdr (assoc  name  eh))  (concatenate 'string (cdr (assoc  name  owner))  (concatenate 'string  "."  name)) #|line 187|#)
    (setf (cdr (assoc  owner  eh))  owner)                  #|line 188|#
    (setf (cdr (assoc  handler  eh))  handler)              #|line 189|#
    (setf (cdr (assoc  instance_data  eh))  instance_data)  #|line 190|#
    (setf (cdr (assoc  state  eh))  "idle")                 #|line 191|#
    (setf (cdr (assoc  kind  eh))  "leaf")                  #|line 192|#
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
  (let ((fwdmsg (funcall (quote make_message)   port (cdr (assoc  datum  msg))  #|line 211|#)))
    (declare (ignorable fwdmsg))
    (funcall (quote put_output)   eh  msg                   #|line 212|#)) #|line 213|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 215|#
  (cdr (assoc (funcall (quote inject)   eh  msg             #|line 216|#)  eh)) #|line 217|#
  ) #|  Returns a list of all output messages on a container. |# #|line 219|# #|  For testing / debugging purposes. |# #|line 220|# #|line 221|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 222|#
  (return-from output_list (cdr (assoc  outq  eh)))         #|line 223|# #|line 224|#
  ) #|  Utility for printing an array of messages. |#       #|line 226|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                 #|line 227|#
  (loop for m in (funcall (quote list)  (cdr (assoc (cdr (assoc  queue  outq))  eh)) )
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
  (setf (cdr (assoc  state  eh))  "active")                 #|line 240|# #|line 241|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                 #|line 243|#
  (setf (cdr (assoc  state  eh))  "idle")                   #|line 244|# #|line 245|#
  ) #|  Utility for printing a specific output message. |#  #|line 247|# #|line 248|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 249|#
  (loop for msg in (funcall (quote list)  (cdr (assoc (cdr (assoc  queue  outq))  eh)) )
    do
      (progn
        msg                                                 #|line 250|#
        (cond
          (( equal   (cdr (assoc  port  msg))  port)        #|line 251|#
            (return-from fetch_first_output (cdr (assoc  datum  msg)))
            ))                                              #|line 252|#
        ))
  (return-from fetch_first_output  nil)                     #|line 253|# #|line 254|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 256|#
  #|  port ∷ “” |#                                          #|line 257|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 258|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (cdr (assoc (funcall (quote srepr) )  datum))) #|line 259|#) #|line 260|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                           #|line 261|#
  #|  port ∷ “” |#                                          #|line 262|#
  (let (( datum (funcall (quote fetch_first_output)   eh  port  #|line 263|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |# #|line 264|#
    (format *error-output* "~a" (cdr (assoc (funcall (quote srepr) )  datum))) #|line 265|#) #|line 266|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 268|#
  (cdr (assoc (cdr (assoc (funcall (quote put)   msg        #|line 269|#)  outq))  eh)) #|line 270|#
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
  (let ((s (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))))
    (declare (ignorable s))                                 #|line 302|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc  name  eh))  (concatenate 'string  ": "  s)))) #|line 303|#) #|line 304|#
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
    (cons (quote first)  first)                             #|line 316|#
    (cons (quote second)  second)                           #|line 317|#) #|line 318|#)
                                                            #|line 319|# #|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |# #|line 320|#
(defun Deracer_Instance_Data (&optional  state  buffer)     #|line 321|#
  (list
    (cons (quote state)  state)                             #|line 322|#
    (cons (quote buffer)  buffer)                           #|line 323|#) #|line 324|#)
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
      (setf (cdr (assoc  state  inst))  "idle")             #|line 333|#
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 334|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 335|#))) #|line 336|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 338|#
  (funcall (quote forward)   eh  "1" (cdr (assoc (cdr (assoc  first  buffer))  inst))  #|line 339|#)
  (funcall (quote forward)   eh  "2" (cdr (assoc (cdr (assoc  second  buffer))  inst))  #|line 340|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 341|#) #|line 342|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 344|#
  (let (( inst (cdr (assoc  instance_data  eh))))
    (declare (ignorable  inst))                             #|line 345|#
    (cond
      (( equal   (cdr (assoc  state  inst))  "idle")        #|line 346|#
        (cond
          (( equal    "1" (cdr (assoc  port  msg)))         #|line 347|#
            (setf (cdr (assoc (cdr (assoc  first  buffer))  inst))  msg) #|line 348|#
            (setf (cdr (assoc  state  inst))  "waitingForSecond") #|line 349|#
            )
          (( equal    "2" (cdr (assoc  port  msg)))         #|line 350|#
            (setf (cdr (assoc (cdr (assoc  second  buffer))  inst))  msg) #|line 351|#
            (setf (cdr (assoc  state  inst))  "waitingForFirst") #|line 352|#
            )
          (t                                                #|line 353|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc  port  msg))) )
            ))                                              #|line 354|#
        )
      (( equal   (cdr (assoc  state  inst))  "waitingForFirst") #|line 355|#
        (cond
          (( equal    "1" (cdr (assoc  port  msg)))         #|line 356|#
            (setf (cdr (assoc (cdr (assoc  first  buffer))  inst))  msg) #|line 357|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 358|#)
            (setf (cdr (assoc  state  inst))  "idle")       #|line 359|#
            )
          (t                                                #|line 360|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc  port  msg))) )
            ))                                              #|line 361|#
        )
      (( equal   (cdr (assoc  state  inst))  "waitingForSecond") #|line 362|#
        (cond
          (( equal    "2" (cdr (assoc  port  msg)))         #|line 363|#
            (setf (cdr (assoc (cdr (assoc  second  buffer))  inst))  msg) #|line 364|#
            (funcall (quote send_first_then_second)   eh  inst  #|line 365|#)
            (setf (cdr (assoc  state  inst))  "idle")       #|line 366|#
            )
          (t                                                #|line 367|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc  port  msg))) )
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
  (let ((fname (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))))
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
    (( equal    "string" (cdr (assoc (cdr (assoc (funcall (quote kind) )  datum))  msg))) #|line 389|#
      (funcall (quote forward)   eh  ""  msg )              #|line 390|#
      )
    (t                                                      #|line 391|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc  datum  msg))) #|line 392|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg )) #|line 393|#
      ))                                                    #|line 394|#
  )
(defun Syncfilewrite_Data (&optional )                      #|line 396|#
  (list
    (cons (quote filename)  "")                             #|line 397|#) #|line 398|#)
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
  (let (( inst (cdr (assoc  instance_data  eh))))
    (declare (ignorable  inst))                             #|line 408|#
    (cond
      (( equal    "filename" (cdr (assoc  port  msg)))      #|line 409|#
        (setf (cdr (assoc  filename  inst)) (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))) #|line 410|#
        )
      (( equal    "input" (cdr (assoc  port  msg)))         #|line 411|#
        (let ((contents (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))))
          (declare (ignorable contents))                    #|line 412|#
          (let (( f (funcall (quote open)  (cdr (assoc  filename  inst))  "w"  #|line 413|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 414|#
                (cdr (assoc (funcall (quote write)  (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))  #|line 415|#)  f))
                (cdr (assoc (funcall (quote close) )  f))   #|line 416|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg ) #|line 417|#
                )
              (t                                            #|line 418|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc  filename  inst)))  msg )
                ))))                                        #|line 419|#
        )))                                                 #|line 420|#
  )
(defun StringConcat_Instance_Data (&optional )              #|line 422|#
  (list
    (cons (quote buffer1)  nil)                             #|line 423|#
    (cons (quote buffer2)  nil)                             #|line 424|#
    (cons (quote count)  0)                                 #|line 425|#) #|line 426|#)
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
  (let (( inst (cdr (assoc  instance_data  eh))))
    (declare (ignorable  inst))                             #|line 435|#
    (cond
      (( equal    "1" (cdr (assoc  port  msg)))             #|line 436|#
        (setf (cdr (assoc  buffer1  inst)) (funcall (quote clone_string)  (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))  #|line 437|#))
        (setf (cdr (assoc  count  inst)) (+ (cdr (assoc  count  inst))  1)) #|line 438|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 439|#
        )
      (( equal    "2" (cdr (assoc  port  msg)))             #|line 440|#
        (setf (cdr (assoc  buffer2  inst)) (funcall (quote clone_string)  (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))  #|line 441|#))
        (setf (cdr (assoc  count  inst)) (+ (cdr (assoc  count  inst))  1)) #|line 442|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg ) #|line 443|#
        )
      (t                                                    #|line 444|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc  port  msg)))  #|line 445|#) #|line 446|#
        )))                                                 #|line 447|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 449|#
  (cond
    (( and  ( equal    0 (length (cdr (assoc  buffer1  inst)))) ( equal    0 (length (cdr (assoc  buffer2  inst))))) #|line 450|#
      (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length" ) #|line 451|#
      ))
  (cond
    (( >=  (cdr (assoc  count  inst))  2)                   #|line 452|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 453|#
        (cond
          (( equal    0 (length (cdr (assoc  buffer1  inst)))) #|line 454|#
            (setf  concatenated_string (cdr (assoc  buffer2  inst))) #|line 455|#
            )
          (( equal    0 (length (cdr (assoc  buffer2  inst)))) #|line 456|#
            (setf  concatenated_string (cdr (assoc  buffer1  inst))) #|line 457|#
            )
          (t                                                #|line 458|#
            (setf  concatenated_string (+ (cdr (assoc  buffer1  inst)) (cdr (assoc  buffer2  inst)))) #|line 459|#
            ))
        (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 460|#)
        (setf (cdr (assoc  buffer1  inst))  nil)            #|line 461|#
        (setf (cdr (assoc  buffer2  inst))  nil)            #|line 462|#
        (setf (cdr (assoc  count  inst))  0))               #|line 463|#
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
  (let ((cmd (cdr (assoc  instance_data  eh))))
    (declare (ignorable cmd))                               #|line 476|#
    (let ((s (cdr (assoc (cdr (assoc (funcall (quote srepr) )  datum))  msg))))
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
  (let ((s (cdr (assoc  instance_data  eh))))
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
  ) #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |# #|line 518|# #|  where ${_00_} is the root directory for the project |# #|line 519|# #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |# #|line 520|# #|line 521|# #|line 522|# #|line 523|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files)) #|line 524|#
  (let ((reg (funcall (quote make_component_registry) )))
    (declare (ignorable reg))                               #|line 525|#
    (loop for diagram_source in  diagram_source_files
      do
        (progn
          diagram_source                                    #|line 526|#
          (let ((all_containers_within_single_file (funcall (quote json2internal)   diagram_source  #|line 527|#)))
            (declare (ignorable all_containers_within_single_file))
            (funcall (quote generate_shell_components)   reg  all_containers_within_single_file  #|line 528|#)
            (loop for container in  all_containers_within_single_file
              do
                (progn
                  container                                 #|line 529|#
                  (funcall (quote register_component)   reg (funcall (quote Template)  (cdr (assoc (quote name)  container))  #|  template_data =  |# container  #|  instantiator =  |# #'container_instantiator ) )
                  )))                                       #|line 530|#
          ))
    (funcall (quote initialize_stock_components)   reg      #|line 531|#)
    (return-from initialize_component_palette  reg)         #|line 532|#) #|line 533|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 535|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                        #|line 536|#
    (let ((err (funcall (quote fetch_first_output)   main_container  error_port  #|line 537|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (length (funcall (quote trimws)  (cdr (assoc (funcall (quote srepr) )  err)) )))) #|line 538|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___") #|line 539|#
          (funcall (quote print_specific_output)   main_container  error_port ) #|line 540|#
          ))))                                              #|line 541|#
  ) #|  debugging helpers |#                                #|line 543|# #|line 544|#
(defun nl (&optional )
  (declare (ignorable ))                                    #|line 545|#
  (format *standard-output* "~a"  "")                       #|line 546|# #|line 547|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                     #|line 549|#
  (funcall (quote nl) )                                     #|line 550|#
  (format *standard-output* "~a"  "___ Outputs ___")        #|line 551|#
  (funcall (quote print_output_list)   main_container       #|line 552|#) #|line 553|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                  #|line 555|#
  #|  remove whitespace from front and back of string |#    #|line 556|#
  (return-from trimws (cdr (assoc (funcall (quote strip) )  s))) #|line 557|# #|line 558|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                  #|line 560|#
  (return-from clone_string  s                              #|line 561|# #|line 562|#) #|line 563|#
  )
(defparameter  load_errors  nil)                            #|line 564|#
(defparameter  runtime_errors  nil)                         #|line 565|# #|line 566|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                  #|line 567|# #|line 568|#
  (format *standard-output* "~a"  s)                        #|line 569|#
  (funcall (quote quit) )                                   #|line 570|#
  (setf  load_errors  t)                                    #|line 571|# #|line 572|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                  #|line 574|# #|line 575|#
  (format *standard-output* "~a"  s)                        #|line 576|#
  (funcall (quote quit) )                                   #|line 577|#
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
  )                                                         #|line 594|# #|  all of the the built_in leaves are listed here |# #|line 595|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 596|# #|line 597|# #|line 598|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 599|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "1then2"  nil  #'deracer_instantiate )  #|line 600|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?"  nil  #'probe_instantiate )  #|line 601|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?A"  nil  #'probeA_instantiate )  #|line 602|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?B"  nil  #'probeB_instantiate )  #|line 603|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "?C"  nil  #'probeC_instantiate )  #|line 604|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "trash"  nil  #'trash_instantiate )  #|line 605|#) #|line 606|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 607|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 608|#) #|line 609|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 610|#)
  (funcall (quote register_component)   reg (funcall (quote Template)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 611|#)
  #|  for fakepipe |#                                       #|line 612|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 613|#) #|line 614|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                    #|line 616|#

  (or
  #+CLISP *args*
  #+SBCL *posix-argv*
  #+LISPWORKS system:*line-arguments-list*
  #+CMU extensions:*command-line-words*
  nil)
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
            (let ((palette (funcall (quote initialize_component_palette)   root_project  root_0D  diagram_names  #|line 626|#)))
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
                  (funcall (quote load_error)   (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)"))))  #|line 645|#) #|line 646|#
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





