
(ql:quickload :cl-json)
(load "~/quicklisp/setup.lisp")
                                                                                                                        #|line 1|##|line 2|#
(defparameter  counter  0)                                                                                              #|line 3|##|line 4|#
(defparameter  digits (list                                                                                             #|line 5|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" ))#|line 11|##|line 12|##|line 13|#
(defun gensymbol (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 14|##|line 15|#
  (let ((name_with_id  (concatenate 'string  s (subscripted_digit    counter ))                                         #|line 16|#))
    (declare (ignorable name_with_id))
    (setf  counter (+  counter  1))                                                                                     #|line 17|#
    (return-from gensymbol  name_with_id)                                                                               #|line 18|#)#|line 19|#
  )
(defun subscripted_digit (&optional  n)
  (declare (ignorable  n))                                                                                              #|line 21|##|line 22|#
  (cond
    (( and  ( >=   n  0) ( <=   n  29))                                                                                 #|line 23|#
      (return-from subscripted_digit (nth  n  digits))                                                                  #|line 24|#
      )
    (t                                                                                                                  #|line 25|#
      (return-from subscripted_digit  (concatenate 'string  "₊"  n)                                                     #|line 26|#)#|line 27|#
      ))                                                                                                                #|line 28|#
  )
(defun Datum (&optional )                                                                                               #|line 30|#
  (list
    (cons 'data  nil)                                                                                                   #|line 31|#
    (cons 'clone  nil)                                                                                                  #|line 32|#
    (cons 'reclaim  nil)                                                                                                #|line 33|#
    (cons 'srepr  nil)                                                                                                  #|line 34|#
    (cons 'kind  nil)                                                                                                   #|line 35|#
    (cons 'raw  nil)                                                                                                    #|line 36|#)#|line 37|#)
                                                                                                                        #|line 38|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 39|#
  (let ((d  (Datum)                                                                                                     #|line 40|#))
    (declare (ignorable d))
    (setf (cdr (assoc ' data  d))  s)                                                                                   #|line 41|#
    (setf (cdr (assoc ' clone  d))  #'(lambda (&optional )(clone_datum_string    d                                      #|line 42|#)))
    (setf (cdr (assoc ' reclaim  d))  #'(lambda (&optional )(reclaim_datum_string    d                                  #|line 43|#)))
    (setf (cdr (assoc ' srepr  d))  #'(lambda (&optional )(srepr_datum_string    d                                      #|line 44|#)))
    (setf (cdr (assoc ' raw  d))  #'(lambda (&optional )(raw_datum_string    d                                          #|line 45|#)))
    (setf (cdr (assoc ' kind  d))  #'(lambda (&optional ) "string"))                                                    #|line 46|#
    (return-from new_datum_string  d)                                                                                   #|line 47|#)#|line 48|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 50|#
  (let ((d (new_datum_string   (cdr (assoc ' data  d))                                                                  #|line 51|#)))
    (declare (ignorable d))
    (return-from clone_datum_string  d)                                                                                 #|line 52|#)#|line 53|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 55|#
  #| pass |#                                                                                                            #|line 56|##|line 57|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 59|#
  (return-from srepr_datum_string (cdr (assoc ' data  d)))                                                              #|line 60|##|line 61|#
  )
(defun raw_datum_string (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 63|#
  (return-from raw_datum_string (bytearray   (cdr (assoc ' data  d))  "UTF_8"                                           #|line 64|#))#|line 65|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                                                                                #|line 67|#
  (let ((p (Datum  )))
    (declare (ignorable p))                                                                                             #|line 68|#
    (setf (cdr (assoc ' data  p))  t)                                                                                   #|line 69|#
    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bang    p                                        #|line 70|#)))
    (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bang    p                                    #|line 71|#)))
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bang  )))                                        #|line 72|#
    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bang  )))                                            #|line 73|#
    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bang"))                                                      #|line 74|#
    (return-from new_datum_bang  p)                                                                                     #|line 75|#)#|line 76|#
  )
(defun clone_datum_bang (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 78|#
  (return-from clone_datum_bang (new_datum_bang  ))                                                                     #|line 79|##|line 80|#
  )
(defun reclaim_datum_bang (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 82|#
  #| pass |#                                                                                                            #|line 83|##|line 84|#
  )
(defun srepr_datum_bang (&optional )
  (declare (ignorable ))                                                                                                #|line 86|#
  (return-from srepr_datum_bang  "!")                                                                                   #|line 87|##|line 88|#
  )
(defun raw_datum_bang (&optional )
  (declare (ignorable ))                                                                                                #|line 90|#
  (return-from raw_datum_bang  nil)                                                                                     #|line 91|##|line 92|#
  )
(defun new_datum_tick (&optional )
  (declare (ignorable ))                                                                                                #|line 94|#
  (let ((p (new_datum_bang  )))
    (declare (ignorable p))                                                                                             #|line 95|#
    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "tick"))                                                      #|line 96|#
    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(new_datum_tick  )))                                          #|line 97|#
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_tick  )))                                        #|line 98|#
    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_tick  )))                                            #|line 99|#
    (return-from new_datum_tick  p)                                                                                     #|line 100|#)#|line 101|#
  )
(defun srepr_datum_tick (&optional )
  (declare (ignorable ))                                                                                                #|line 103|#
  (return-from srepr_datum_tick  ".")                                                                                   #|line 104|##|line 105|#
  )
(defun raw_datum_tick (&optional )
  (declare (ignorable ))                                                                                                #|line 107|#
  (return-from raw_datum_tick  nil)                                                                                     #|line 108|##|line 109|#
  )
(defun new_datum_bytes (&optional  b)
  (declare (ignorable  b))                                                                                              #|line 111|#
  (let ((p (Datum  )))
    (declare (ignorable p))                                                                                             #|line 112|#
    (setf (cdr (assoc ' data  p))  b)                                                                                   #|line 113|#
    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bytes    p                                       #|line 114|#)))
    (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bytes    p                                   #|line 115|#)))
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bytes    b                                       #|line 116|#)))
    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bytes    b                                           #|line 117|#)))
    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bytes"))                                                     #|line 118|#
    (return-from new_datum_bytes  p)                                                                                    #|line 119|#)#|line 120|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 122|#
  (let ((p (Datum  )))
    (declare (ignorable p))                                                                                             #|line 123|#
    (setf (cdr (assoc ' clone  p)) (cdr (assoc ' clone  src)))                                                          #|line 124|#
    (setf (cdr (assoc ' reclaim  p)) (cdr (assoc ' reclaim  src)))                                                      #|line 125|#
    (setf (cdr (assoc ' srepr  p)) (cdr (assoc ' srepr  src)))                                                          #|line 126|#
    (setf (cdr (assoc ' raw  p)) (cdr (assoc ' raw  src)))                                                              #|line 127|#
    (setf (cdr (assoc ' kind  p)) (cdr (assoc ' kind  src)))                                                            #|line 128|#
    (setf (cdr (assoc ' data  p)) (cdr (assoc '(clone  )  src)))                                                        #|line 129|#
    (return-from clone_datum_bytes  p)                                                                                  #|line 130|#)#|line 131|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 133|#
  #| pass |#                                                                                                            #|line 134|##|line 135|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 137|#
  (return-from srepr_datum_bytes (cdr (assoc '(cdr (assoc '(decode    "UTF_8"                                           #|line 138|#)  data))  d)))#|line 139|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 140|#
  (return-from raw_datum_bytes (cdr (assoc ' data  d)))                                                                 #|line 141|##|line 142|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                                                                              #|line 144|#
  (return-from new_datum_handle (new_datum_int    h                                                                     #|line 145|#))#|line 146|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 148|#
  (let ((p (Datum  )))
    (declare (ignorable p))                                                                                             #|line 149|#
    (setf (cdr (assoc ' data  p))  i)                                                                                   #|line 150|#
    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_int    i                                               #|line 151|#)))
    (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_int    i                                           #|line 152|#)))
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_int    i                                         #|line 153|#)))
    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_int    i                                             #|line 154|#)))
    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "int"))                                                       #|line 155|#
    (return-from new_datum_int  p)                                                                                      #|line 156|#)#|line 157|#
  )
(defun clone_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 159|#
  (let ((p (new_datum_int    i                                                                                          #|line 160|#)))
    (declare (ignorable p))
    (return-from clone_int  p)                                                                                          #|line 161|#)#|line 162|#
  )
(defun reclaim_int (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 164|#
  #| pass |#                                                                                                            #|line 165|##|line 166|#
  )
(defun srepr_datum_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 168|#
  (return-from srepr_datum_int (str    i                                                                                #|line 169|#))#|line 170|#
  )
(defun raw_datum_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 172|#
  (return-from raw_datum_int  i)                                                                                        #|line 173|##|line 174|#
  )#|  Message passed to a leaf component. |#                                                                           #|line 176|##|  |##|line 177|##|  `port` refers to the name of the incoming or outgoing port of this component. |##|line 178|##|  `datum` is the data attached to this message. |##|line 179|#
(defun Message (&optional  port  datum)                                                                                 #|line 180|#
  (list
    (cons 'port  port)                                                                                                  #|line 181|#
    (cons 'datum  datum)                                                                                                #|line 182|#)#|line 183|#)
                                                                                                                        #|line 184|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 185|#
  (return-from clone_port (clone_string    s                                                                            #|line 186|#))#|line 187|#
  )#|  Utility for making a `Message`. Used to safely “seed“ messages |#                                                #|line 189|##|  entering the very top of a network. |##|line 190|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                                                                                    #|line 191|#
  (let ((p (clone_string    port                                                                                        #|line 192|#)))
    (declare (ignorable p))
    (let ((m (Message    p (cdr (assoc '(clone  )  datum))                                                              #|line 193|#)))
      (declare (ignorable m))
      (return-from make_message  m)                                                                                     #|line 194|#))#|line 195|#
  )#|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#             #|line 197|#
(defun message_clone (&optional  message)
  (declare (ignorable  message))                                                                                        #|line 198|#
  (let ((m (Message   (clone_port   (cdr (assoc ' port  message)) ) (cdr (assoc '(cdr (assoc '(clone  )  datum))  message)) #|line 199|#)))
    (declare (ignorable m))
    (return-from message_clone  m)                                                                                      #|line 200|#)#|line 201|#
  )#|  Frees a message. |#                                                                                              #|line 203|#
(defun destroy_message (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 204|#
  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |##|line 205|#
  #| pass |#                                                                                                            #|line 206|##|line 207|#
  )
(defun destroy_datum (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 209|#
  #| pass |#                                                                                                            #|line 210|##|line 211|#
  )
(defun destroy_port (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 213|#
  #| pass |#                                                                                                            #|line 214|##|line 215|#
  )#|  |#                                                                                                               #|line 217|#
(defun format_message (&optional  m)
  (declare (ignorable  m))                                                                                              #|line 218|#
  (cond
    (( equal    m  nil)                                                                                                 #|line 219|#
      (return-from format_message  "ϕ")                                                                                 #|line 220|#
      )
    (t                                                                                                                  #|line 221|#
      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc ' port  m))  (concatenate 'string  "⦂"  (concatenate 'string (cdr (assoc '(cdr (assoc '(srepr  )  datum))  m))  "⟫"))))#|line 225|#)#|line 226|#
      ))                                                                                                                #|line 227|#
  )                                                                                                                     #|line 229|#
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                                                                                          #|line 234|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))                                                               #|line 235|##|line 236|#
  (let ((container (make_container    container_name  owner                                                             #|line 237|#)))
    (declare (ignorable container))
    (let ((children  nil))
      (declare (ignorable children))                                                                                    #|line 238|#
      (let ((children_by_id  nil))
        (declare (ignorable children_by_id))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#                   #|line 239|#
        #|  collect children |#                                                                                         #|line 240|#
        (loop for child_desc in (cdr (assoc 'children  desc))
          do                                                                                                            #|line 241|#
          (let ((child_instance (get_component_instance    reg (cdr (assoc 'name  child_desc))  container               #|line 242|#)))
            (declare (ignorable child_instance))
            (cdr (assoc '(append    child_instance                                                                      #|line 243|#)  children))
            (setf (nth (cdr (assoc 'id  child_desc))  children_by_id)  child_instance))                                 #|line 244|#
          )
        (setf (cdr (assoc ' children  container))  children)                                                            #|line 245|#
        (let ((me  container))
          (declare (ignorable me))                                                                                      #|line 246|##|line 247|#
          (let ((connectors  nil))
            (declare (ignorable connectors))                                                                            #|line 248|#
            (loop for proto_conn in (cdr (assoc 'connections  desc))
              do                                                                                                        #|line 249|#
              (let ((connector (Connector  )))
                (declare (ignorable connector))                                                                         #|line 250|#
                (cond
                  (( equal   (cdr (assoc 'dir  proto_conn))  enumDown)                                                  #|line 251|#
                    #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |##|line 252|#
                    (setf (cdr (assoc ' direction  connector))  "down")                                                 #|line 253|#
                    (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))  me (cdr (assoc 'source_port  proto_conn)) #|line 254|#))
                    (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))
                      (declare (ignorable target_component))                                                            #|line 255|#
                      (cond
                        (( equal    target_component  nil)                                                              #|line 256|#
                          (load_error    (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc 'target  proto_conn))) )#|line 257|#
                          )
                        (t                                                                                              #|line 258|#
                          (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component)) (cdr (assoc ' inq  target_component)) (cdr (assoc 'target_port  proto_conn))  target_component #|line 259|#))
                          (cdr (assoc '(append    connector )  connectors))
                          )))                                                                                           #|line 260|#
                    )
                  (( equal   (cdr (assoc 'dir  proto_conn))  enumAcross)                                                #|line 261|#
                    (setf (cdr (assoc ' direction  connector))  "across")                                               #|line 262|#
                    (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))
                      (declare (ignorable source_component))                                                            #|line 263|#
                      (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))
                        (declare (ignorable target_component))                                                          #|line 264|#
                        (cond
                          (( equal    source_component  nil)                                                            #|line 265|#
                            (load_error    (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 266|#
                            )
                          (t                                                                                            #|line 267|#
                            (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))  source_component (cdr (assoc 'source_port  proto_conn)) #|line 268|#))
                            (cond
                              (( equal    target_component  nil)                                                        #|line 269|#
                                (load_error    (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc ' target  proto_conn))) )#|line 270|#
                                )
                              (t                                                                                        #|line 271|#
                                (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component)) (cdr (assoc ' inq  target_component)) (cdr (assoc 'target_port  proto_conn))  target_component #|line 272|#))
                                (cdr (assoc '(append    connector )  connectors))
                                ))
                            ))))                                                                                        #|line 273|#
                    )
                  (( equal   (cdr (assoc 'dir  proto_conn))  enumUp)                                                    #|line 274|#
                    (setf (cdr (assoc ' direction  connector))  "up")                                                   #|line 275|#
                    (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))
                      (declare (ignorable source_component))                                                            #|line 276|#
                      (cond
                        (( equal    source_component  nil)                                                              #|line 277|#
                          (print    (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 278|#
                          )
                        (t                                                                                              #|line 279|#
                          (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))  source_component (cdr (assoc 'source_port  proto_conn)) #|line 280|#))
                          (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me)) (cdr (assoc ' outq  container)) (cdr (assoc 'target_port  proto_conn))  me #|line 281|#))
                          (cdr (assoc '(append    connector )  connectors))
                          )))                                                                                           #|line 282|#
                    )
                  (( equal   (cdr (assoc 'dir  proto_conn))  enumThrough)                                               #|line 283|#
                    (setf (cdr (assoc ' direction  connector))  "through")                                              #|line 284|#
                    (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))  me (cdr (assoc 'source_port  proto_conn)) #|line 285|#))
                    (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me)) (cdr (assoc ' outq  container)) (cdr (assoc 'target_port  proto_conn))  me #|line 286|#))
                    (cdr (assoc '(append    connector )  connectors))
                    )))                                                                                                 #|line 287|#
              )                                                                                                         #|line 288|#
            (setf (cdr (assoc ' connections  container))  connectors)                                                   #|line 289|#
            (return-from container_instantiator  container)                                                             #|line 290|#)))))#|line 291|#
  )#|  The default handler for container components. |#                                                                 #|line 293|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                                                                             #|line 294|#
  (route    container #|  from=  |# container  message )
  #|  references to 'self' are replaced by the container during instantiation |#                                        #|line 295|#
  (loop while (any_child_ready    container )
    do                                                                                                                  #|line 296|#
    (step_children    container  message )                                                                              #|line 297|#
    )                                                                                                                   #|line 298|#
  )#|  Frees the given container and associated data. |#                                                                #|line 300|#
(defun destroy_container (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 301|#
  #| pass |#                                                                                                            #|line 302|##|line 303|#
  )
(defun fifo_is_empty (&optional  fifo)
  (declare (ignorable  fifo))                                                                                           #|line 305|#
  (return-from fifo_is_empty (cdr (assoc '(empty  )  fifo)))                                                            #|line 306|##|line 307|#
  )#|  Routing connection for a container component. The `direction` field has |#                                       #|line 309|##|  no affect on the default message routing system _ it is there for debugging |##|line 310|##|  purposes, or for reading by other tools. |##|line 311|##|line 312|#
(defun Connector (&optional )                                                                                           #|line 313|#
  (list
    (cons 'direction  nil) #|  down, across, up, through |#                                                             #|line 314|#
    (cons 'sender  nil)                                                                                                 #|line 315|#
    (cons 'receiver  nil)                                                                                               #|line 316|#)#|line 317|#)
                                                                                                                        #|line 318|##|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |##|line 319|##|  based on component ID (pointer) and port name. |##|line 320|##|line 321|#
(defun Sender (&optional  name  component  port)                                                                        #|line 322|#
  (list
    (cons 'name  name)                                                                                                  #|line 323|#
    (cons 'component  component) #|  from |#                                                                            #|line 324|#
    (cons 'port  port) #|  from's port |#                                                                               #|line 325|#)#|line 326|#)
                                                                                                                        #|line 327|##|  `Receiver` is a handle to a destination queue, and a `port` name to assign |##|line 328|##|  to incoming messages to this queue. |##|line 329|##|line 330|#
(defun Receiver (&optional  name  queue  port  component)                                                               #|line 331|#
  (list
    (cons 'name  name)                                                                                                  #|line 332|#
    (cons 'queue  queue) #|  queue (input | output) of receiver |#                                                      #|line 333|#
    (cons 'port  port) #|  destination port |#                                                                          #|line 334|#
    (cons 'component  component) #|  to (for bootstrap debug) |#                                                        #|line 335|#)#|line 336|#)
                                                                                                                        #|line 337|##|  Checks if two senders match, by pointer equality and port name matching. |##|line 338|#
(defun sender_eq (&optional  s1  s2)
  (declare (ignorable  s1  s2))                                                                                         #|line 339|#
  (let ((same_components ( equal   (cdr (assoc ' component  s1)) (cdr (assoc ' component  s2)))))
    (declare (ignorable same_components))                                                                               #|line 340|#
    (let ((same_ports ( equal   (cdr (assoc ' port  s1)) (cdr (assoc ' port  s2)))))
      (declare (ignorable same_ports))                                                                                  #|line 341|#
      (return-from sender_eq ( and   same_components  same_ports))                                                      #|line 342|#))#|line 343|#
  )#|  Delivers the given message to the receiver of this connector. |#                                                 #|line 345|##|line 346|#
(defun deposit (&optional  parent  conn  message)
  (declare (ignorable  parent  conn  message))                                                                          #|line 347|#
  (let ((new_message (make_message   (cdr (assoc '(cdr (assoc ' port  receiver))  conn)) (cdr (assoc ' datum  message)) #|line 348|#)))
    (declare (ignorable new_message))
    (push_message    parent (cdr (assoc '(cdr (assoc ' component  receiver))  conn)) (cdr (assoc '(cdr (assoc ' queue  receiver))  conn))  new_message #|line 349|#))#|line 350|#
  )
(defun force_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                                                                                     #|line 352|#
  (let ((tick_msg (make_message    "." (new_datum_tick  )                                                               #|line 353|#)))
    (declare (ignorable tick_msg))
    (push_message    parent  eh (cdr (assoc ' inq  eh))  tick_msg                                                       #|line 354|#)
    (return-from force_tick  tick_msg)                                                                                  #|line 355|#)#|line 356|#
  )
(defun push_message (&optional  parent  receiver  inq  m)
  (declare (ignorable  parent  receiver  inq  m))                                                                       #|line 358|#
  (cdr (assoc '(put    m                                                                                                #|line 359|#)  inq))
  (cdr (assoc '(cdr (assoc '(put    receiver                                                                            #|line 360|#)  visit_ordering))  parent))#|line 361|#
  )
(defun is_self (&optional  child  container)
  (declare (ignorable  child  container))                                                                               #|line 363|#
  #|  in an earlier version “self“ was denoted as ϕ |#                                                                  #|line 364|#
  (return-from is_self ( equal    child  container))                                                                    #|line 365|##|line 366|#
  )
(defun step_child (&optional  child  msg)
  (declare (ignorable  child  msg))                                                                                     #|line 368|#
  (let ((before_state (cdr (assoc ' state  child))))
    (declare (ignorable before_state))                                                                                  #|line 369|#
    (cdr (assoc '(handler    child  msg                                                                                 #|line 370|#)  child))
    (let ((after_state (cdr (assoc ' state  child))))
      (declare (ignorable after_state))                                                                                 #|line 371|#
      (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle")))      #|line 372|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle"))) #|line 373|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle"))))#|line 374|#))#|line 375|#
  )
(defun save_message (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 377|#
  (cdr (assoc '(cdr (assoc '(put    msg                                                                                 #|line 378|#)  saved_messages))  eh))#|line 379|#
  )
(defun fetch_saved_message_and_clear (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 381|#
  (return-from fetch_saved_message_and_clear (cdr (assoc '(cdr (assoc '(get  )  saved_messages))  eh)))                 #|line 382|##|line 383|#
  )
(defun step_children (&optional  container  causingMessage)
  (declare (ignorable  container  causingMessage))                                                                      #|line 385|#
  (setf (cdr (assoc ' state  container))  "idle")                                                                       #|line 386|#
  (loop for child in (list   (cdr (assoc '(cdr (assoc ' queue  visit_ordering))  container)) )
    do                                                                                                                  #|line 387|#
    #|  child = container represents self, skip it |#                                                                   #|line 388|#
    (cond
      ((not (is_self    child  container ))                                                                             #|line 389|#
        (cond
          ((not (cdr (assoc '(cdr (assoc '(empty  )  inq))  child)))                                                    #|line 390|#
            (let ((msg (cdr (assoc '(cdr (assoc '(get  )  inq))  child))))
              (declare (ignorable msg))                                                                                 #|line 391|#
              (let (( began_long_run  nil))
                (declare (ignorable  began_long_run))                                                                   #|line 392|#
                (let (( continued_long_run  nil))
                  (declare (ignorable  continued_long_run))                                                             #|line 393|#
                  (let (( ended_long_run  nil))
                    (declare (ignorable  ended_long_run))                                                               #|line 394|#
                    (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (step_child    child  msg #|line 395|#))
                    (cond
                      ( began_long_run                                                                                  #|line 396|#
                        (save_message    child  msg                                                                     #|line 397|#)
                        )
                      ( continued_long_run                                                                              #|line 398|#
                        #| pass |#                                                                                      #|line 399|##|line 400|#
                        ))
                    (destroy_message    msg )))))                                                                       #|line 401|#
            )
          (t                                                                                                            #|line 402|#
            (cond
              ((not (equal  (cdr (assoc ' state  child))  "idle"))                                                      #|line 403|#
                (let ((msg (force_tick    container  child                                                              #|line 404|#)))
                  (declare (ignorable msg))
                  (cdr (assoc '(handler    child  msg                                                                   #|line 405|#)  child))
                  (destroy_message    msg ))
                ))                                                                                                      #|line 406|#
            ))                                                                                                          #|line 407|#
        (cond
          (( equal   (cdr (assoc ' state  child))  "active")                                                            #|line 408|#
            #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |#   #|line 409|#
            (setf (cdr (assoc ' state  container))  "active")                                                           #|line 410|#
            ))                                                                                                          #|line 411|#
        (loop while (not (cdr (assoc '(cdr (assoc '(empty  )  outq))  child)))
          do                                                                                                            #|line 412|#
          (let ((msg (cdr (assoc '(cdr (assoc '(get  )  outq))  child))))
            (declare (ignorable msg))                                                                                   #|line 413|#
            (route    container  child  msg                                                                             #|line 414|#)
            (destroy_message    msg ))
          )
        ))                                                                                                              #|line 415|#
    )                                                                                                                   #|line 416|##|line 417|##|line 418|#
  )
(defun attempt_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                                                                                     #|line 420|#
  (cond
    ((not (equal  (cdr (assoc ' state  eh))  "idle"))                                                                   #|line 421|#
      (force_tick    parent  eh )                                                                                       #|line 422|#
      ))                                                                                                                #|line 423|#
  )
(defun is_tick (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 425|#
  (return-from is_tick ( equal    "tick" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg))))                           #|line 426|##|line 427|#
  )#|  Routes a single message to all matching destinations, according to |#                                            #|line 429|##|  the container's connection network. |##|line 430|##|line 431|#
(defun route (&optional  container  from_component  message)
  (declare (ignorable  container  from_component  message))                                                             #|line 432|#
  (let (( was_sent  nil))
    (declare (ignorable  was_sent))
    #|  for checking that output went somewhere (at least during bootstrap) |#                                          #|line 433|#
    (let (( fromname  ""))
      (declare (ignorable  fromname))                                                                                   #|line 434|#
      (cond
        ((is_tick    message )                                                                                          #|line 435|#
          (loop for child in (cdr (assoc ' children  container))
            do                                                                                                          #|line 436|#
            (attempt_tick    container  child )                                                                         #|line 437|#
            )
          (setf  was_sent  t)                                                                                           #|line 438|#
          )
        (t                                                                                                              #|line 439|#
          (cond
            ((not (is_self    from_component  container ))                                                              #|line 440|#
              (setf  fromname (cdr (assoc ' name  from_component)))                                                     #|line 441|#
              ))
          (let ((from_sender (Sender    fromname  from_component (cdr (assoc ' port  message))                          #|line 442|#)))
            (declare (ignorable from_sender))                                                                           #|line 443|#
            (loop for connector in (cdr (assoc ' connections  container))
              do                                                                                                        #|line 444|#
              (cond
                ((sender_eq    from_sender (cdr (assoc ' sender  connector)) )                                          #|line 445|#
                  (deposit    container  connector  message                                                             #|line 446|#)
                  (setf  was_sent  t)
                  ))
              ))                                                                                                        #|line 447|#
          ))
      (cond
        ((not  was_sent)                                                                                                #|line 448|#
          (print    "\n\n*** Error: ***"                                                                                #|line 449|#)
          (dump_possible_connections    container                                                                       #|line 450|#)
          (print_routing_trace    container                                                                             #|line 451|#)
          (print    "***"                                                                                               #|line 452|#)
          (print    (concatenate 'string (cdr (assoc ' name  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor..."))))) #|line 453|#)
          (print    "***"                                                                                               #|line 454|#)
          (exit  )                                                                                                      #|line 455|#
          ))))                                                                                                          #|line 456|#
  )
(defun dump_possible_connections (&optional  container)
  (declare (ignorable  container))                                                                                      #|line 458|#
  (print    (concatenate 'string  "*** possible connections for "  (concatenate 'string (cdr (assoc ' name  container))  ":")) #|line 459|#)
  (loop for connector in (cdr (assoc ' connections  container))
    do                                                                                                                  #|line 460|#
    (print    (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  " "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  sender))  connector))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc '(cdr (assoc ' port  sender))  connector))  (concatenate 'string  " -> "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  receiver))  connector))  (concatenate 'string  "." (cdr (assoc '(cdr (assoc ' port  receiver))  connector)))))))))) )#|line 461|#
    )                                                                                                                   #|line 462|#
  )
(defun any_child_ready (&optional  container)
  (declare (ignorable  container))                                                                                      #|line 464|#
  (loop for child in (cdr (assoc ' children  container))
    do                                                                                                                  #|line 465|#
    (cond
      ((child_is_ready    child )                                                                                       #|line 466|#
        (return-from any_child_ready  t)
        ))                                                                                                              #|line 467|#
    )
  (return-from any_child_ready  nil)                                                                                    #|line 468|##|line 469|#
  )
(defun child_is_ready (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 471|#
  (return-from child_is_ready ( or  ( or  ( or  (not (cdr (assoc '(cdr (assoc '(empty  )  outq))  eh))) (not (cdr (assoc '(cdr (assoc '(empty  )  inq))  eh)))) (not (equal  (cdr (assoc ' state  eh))  "idle"))) (any_child_ready    eh )))#|line 472|##|line 473|#
  )
(defun print_routing_trace (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 475|#
  (print   (routing_trace_all    eh )                                                                                   #|line 476|#)#|line 477|#
  )
(defun append_routing_descriptor (&optional  container  desc)
  (declare (ignorable  container  desc))                                                                                #|line 479|#
  (cdr (assoc '(cdr (assoc '(put    desc                                                                                #|line 480|#)  routings))  container))#|line 481|#
  )
(defun container_injector (&optional  container  message)
  (declare (ignorable  container  message))                                                                             #|line 483|#
  (container_handler    container  message                                                                              #|line 484|#)#|line 485|#
  )





