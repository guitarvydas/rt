
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






(ql:quickload :cl-json)
#|line 1|##|line 2|##|line 3|#
(defun Component_Registry (&optional )                                                                                  #|line 4|#
  (list
    (cons 'templates  nil)                                                                                              #|line 5|#)#|line 6|#)
#|line 7|#
(defun Template (&optional  name  template_data  instantiator)                                                          #|line 8|#
  (list
    (cons 'name  name)                                                                                                  #|line 9|#
    (cons 'template_data  template_data)                                                                                #|line 10|#
    (cons 'instantiator  instantiator)                                                                                  #|line 11|#)#|line 12|#)
#|line 13|#
(defun read_and_convert_json_file (&optional  filename)
  (declare (ignorable  filename))                                                                                       #|line 14|#

  ;; read json from a named file and convert it into internal form (a tree of routings)
  ;; return the routings from the function or raise an error
  (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
    (json:decode-json json-stream))
  #|line 15|##|line 16|#
  )
(defun json2internal (&optional  container_xml)
  (declare (ignorable  container_xml))                                                                                  #|line 18|#
  (let ((fname (let ((p (parse-namestring  container_xml)))(format nil "~a.~a" (pathname-name p) (pathname-type p)))    #|line 19|#))
    (declare (ignorable fname))
    (let ((routings (read_and_convert_json_file    fname                                                                #|line 20|#)))
      (declare (ignorable routings))
      (return-from json2internal  routings)                                                                             #|line 21|#))#|line 22|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 24|#
  #| pass |#                                                                                                            #|line 25|##|line 26|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                                                                                #|line 28|#
  (return-from make_component_registry (Component_Registry  ))                                                          #|line 29|##|line 30|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (abstracted_register_component    reg  template  nil ))                               #|line 32|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component_allow_overwriting (abstracted_register_component    reg  template  t ))               #|line 33|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))                                                                 #|line 35|#
  (let ((name (mangle_name   (cdr (assoc ' name  template))                                                             #|line 36|#)))
    (declare (ignorable name))
    (cond
      (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                       #|line 37|#
        (load_error    (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 38|#
        ))
    (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                         #|line 39|#
    (return-from abstracted_register_component  reg)                                                                    #|line 40|#)#|line 41|#
  )
(defun register_multiple_components (&optional  reg  templates)
  (declare (ignorable  reg  templates))                                                                                 #|line 43|#
  (loop for template in  templates
    do                                                                                                                  #|line 44|#
    (register_component    reg  template )                                                                              #|line 45|#
    )                                                                                                                   #|line 46|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))                                                                          #|line 48|#
  (let ((template_name (mangle_name    full_name                                                                        #|line 49|#)))
    (declare (ignorable template_name))
    (cond
      (( in   template_name (cdr (assoc ' templates  reg)))                                                             #|line 50|#
        (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))
          (declare (ignorable template))                                                                                #|line 51|#
          (cond
            (( equal    template  nil)                                                                                  #|line 52|#
              (load_error    (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 53|#)
              (return-from get_component_instance  nil)                                                                 #|line 54|#
              )
            (t                                                                                                          #|line 55|#
              (let ((owner_name  ""))
                (declare (ignorable owner_name))                                                                        #|line 56|#
                (let ((instance_name  template_name))
                  (declare (ignorable instance_name))                                                                   #|line 57|#
                  (cond
                    ((not (equal   nil  owner))                                                                         #|line 58|#
                      (setf  owner_name (cdr (assoc ' name  owner)))                                                    #|line 59|#
                      (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name)))#|line 60|#
                      )
                    (t                                                                                                  #|line 61|#
                      (setf  instance_name  template_name)                                                              #|line 62|#
                      ))
                  (let ((instance (cdr (assoc '(instantiator    reg  owner  instance_name (cdr (assoc ' template_data  template)) #|line 63|#)  template))))
                    (declare (ignorable instance))
                    (setf (cdr (assoc ' depth  instance)) (calculate_depth    instance                                  #|line 64|#))
                    (return-from get_component_instance  instance))))
              )))                                                                                                       #|line 65|#
        )
      (t                                                                                                                #|line 66|#
        (load_error    (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 67|#)
        (return-from get_component_instance  nil)                                                                       #|line 68|#
        )))                                                                                                             #|line 69|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 70|#
  (cond
    (( equal   (cdr (assoc ' owner  eh))  nil)                                                                          #|line 71|#
      (return-from calculate_depth  0)                                                                                  #|line 72|#
      )
    (t                                                                                                                  #|line 73|#
      (return-from calculate_depth (+  1 (calculate_depth   (cdr (assoc ' owner  eh)) )))                               #|line 74|#
      ))                                                                                                                #|line 75|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 77|#
  (nl  )                                                                                                                #|line 78|#
  (format *standard-output* "~a"  "*** PALETTE ***")                                                                    #|line 79|#
  (loop for c in (cdr (assoc ' templates  reg))
    do                                                                                                                  #|line 80|#
    (print   (cdr (assoc ' name  c)) )                                                                                  #|line 81|#
    )
  (format *standard-output* "~a"  "***************")                                                                    #|line 82|#
  (nl  )                                                                                                                #|line 83|##|line 84|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 86|#
  (format *standard-output* "~a"  (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg))))            #|line 87|##|line 88|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 90|#
  #|  trim name to remove code from Container component names _ deferred until later (or never) |#                      #|line 91|#
  (return-from mangle_name  s)                                                                                          #|line 92|##|line 93|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                                                                            #|line 95|#
  #|  [ |#                                                                                                              #|line 96|#
  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 97|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                              #|line 98|#
  #|  ] |#                                                                                                              #|line 99|#
  (cond
    ((not (equal   nil  container_list))                                                                                #|line 100|#
      (loop for diagram in  container_list
        do                                                                                                              #|line 101|#
        #|  loop through every component in the diagram and look for names that start with “$“ |#                       #|line 102|#
        #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 103|#
        (loop for child_descriptor in (cdr (assoc 'children  diagram))
          do                                                                                                            #|line 104|#
          (cond
            ((first_char_is   (cdr (assoc 'name  child_descriptor))  "$" )                                              #|line 105|#
              (let ((name (cdr (assoc 'name  child_descriptor))))
                (declare (ignorable name))                                                                              #|line 106|#
                (let ((cmd (cdr (assoc '(strip  )  (subseq  name 1)))))
                  (declare (ignorable cmd))                                                                             #|line 107|#
                  (let ((generated_leaf (Template    name  #'shell_out_instantiate  cmd                                 #|line 108|#)))
                    (declare (ignorable generated_leaf))
                    (register_component    reg  generated_leaf                                                          #|line 109|#))))
              )
            ((first_char_is   (cdr (assoc 'name  child_descriptor))  "'" )                                              #|line 110|#
              (let ((name (cdr (assoc 'name  child_descriptor))))
                (declare (ignorable name))                                                                              #|line 111|#
                (let ((s  (subseq  name 1)                                                                              #|line 112|#))
                  (declare (ignorable s))
                  (let ((generated_leaf (Template    name  #'string_constant_instantiate  s                             #|line 113|#)))
                    (declare (ignorable generated_leaf))
                    (register_component_allow_overwriting    reg  generated_leaf                                        #|line 114|#))))#|line 115|#
              ))                                                                                                        #|line 116|#
          )                                                                                                             #|line 117|#
        )                                                                                                               #|line 118|#
      ))                                                                                                                #|line 119|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 121|#
  (return-from first_char  (car  s)                                                                                     #|line 122|#)#|line 123|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                                                                                           #|line 125|#
  (return-from first_char_is ( equal    c (first_char    s                                                              #|line 126|#)))#|line 127|#
  )#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 129|##|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 130|#
(defun run_command (&optional  eh  cmd  s)
  (declare (ignorable  eh  cmd  s))                                                                                     #|line 131|#
  #|  capture_output ∷ ⊤ |#                                                                                             #|line 132|#
  (let ((ret (cdr (assoc '(run    cmd  s  "UTF_8"                                                                       #|line 133|#)  subprocess))))
    (declare (ignorable ret))
    (cond
      ((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                              #|line 134|#
        (cond
          ((not (equal  (cdr (assoc ' stderr  ret))  nil))                                                              #|line 135|#
            (return-from run_command (values  "" (cdr (assoc ' stderr  ret))))                                          #|line 136|#
            )
          (t                                                                                                            #|line 137|#
            (return-from run_command (values  ""  (concatenate 'string  "error in shell_out " (cdr (assoc ' returncode  ret)))))
            ))                                                                                                          #|line 138|#
        )
      (t                                                                                                                #|line 139|#
        (return-from run_command (values (cdr (assoc ' stdout  ret))  nil))                                             #|line 140|#
        )))                                                                                                             #|line 141|#
  )#|  Data for an asyncronous component _ effectively, a function with input |#                                        #|line 143|##|  and output queues of messages. |##|line 144|##|  |##|line 145|##|  Components can either be a user_supplied function (“lea“), or a “container“ |##|line 146|##|  that routes messages to child components according to a list of connections |##|line 147|##|  that serve as a message routing table. |##|line 148|##|  |##|line 149|##|  Child components themselves can be leaves or other containers. |##|line 150|##|  |##|line 151|##|  `handler` invokes the code that is attached to this component. |##|line 152|##|  |##|line 153|##|  `instance_data` is a pointer to instance data that the `leaf_handler` |##|line 154|##|  function may want whenever it is invoked again. |##|line 155|##|  |##|line 156|##|line 157|##|  Eh_States :: enum { idle, active } |##|line 158|#
(defun Eh (&optional )                                                                                                  #|line 159|#
  (list
    (cons 'name  "")                                                                                                    #|line 160|#
    (cons 'inq  (make-instance 'Queue)                                                                                  #|line 161|#)
    (cons 'outq  (make-instance 'Queue)                                                                                 #|line 162|#)
    (cons 'owner  nil)                                                                                                  #|line 163|#
    (cons 'saved_messages  nil) #|  stack of saved message(s) |#                                                        #|line 164|#
    (cons 'children  nil)                                                                                               #|line 165|#
    (cons 'visit_ordering  (make-instance 'Queue)                                                                       #|line 166|#)
    (cons 'connections  nil)                                                                                            #|line 167|#
    (cons 'routings  (make-instance 'Queue)                                                                             #|line 168|#)
    (cons 'handler  nil)                                                                                                #|line 169|#
    (cons 'instance_data  nil)                                                                                          #|line 170|#
    (cons 'state  "idle")                                                                                               #|line 171|##|  bootstrap debugging |##|line 172|#
    (cons 'kind  nil) #|  enum { container, leaf, } |#                                                                  #|line 173|#
    (cons 'trace  nil) #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |##|line 174|#
    (cons 'depth  0) #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |##|line 175|#)#|line 176|#)
#|line 177|##|  Creates a component that acts as a container. It is the same as a `Eh` instance |##|line 178|##|  whose handler function is `container_handler`. |##|line 179|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                                                                                    #|line 180|#
  (let ((eh (Eh  )))
    (declare (ignorable eh))                                                                                            #|line 181|#
    (setf (cdr (assoc ' name  eh))  name)                                                                               #|line 182|#
    (setf (cdr (assoc ' owner  eh))  owner)                                                                             #|line 183|#
    (setf (cdr (assoc ' handler  eh))  #'container_handler)                                                             #|line 184|#
    (setf (cdr (assoc ' inject  eh))  #'container_injector)                                                             #|line 185|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 186|#
    (setf (cdr (assoc ' kind  eh))  "container")                                                                        #|line 187|#
    (return-from make_container  eh)                                                                                    #|line 188|#)#|line 189|#
  )#|  Creates a new leaf component out of a handler function, and a data parameter |#                                  #|line 191|##|  that will be passed back to your handler when called. |##|line 192|##|line 193|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler))                                                            #|line 194|#
  (let ((eh (Eh  )))
    (declare (ignorable eh))                                                                                            #|line 195|#
    (setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)) #|line 196|#)
    (setf (cdr (assoc ' owner  eh))  owner)                                                                             #|line 197|#
    (setf (cdr (assoc ' handler  eh))  handler)                                                                         #|line 198|#
    (setf (cdr (assoc ' instance_data  eh))  instance_data)                                                             #|line 199|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 200|#
    (setf (cdr (assoc ' kind  eh))  "leaf")                                                                             #|line 201|#
    (return-from make_leaf  eh)                                                                                         #|line 202|#)#|line 203|#
  )#|  Sends a message on the given `port` with `data`, placing it on the output |#                                     #|line 205|##|  of the given component. |##|line 206|##|line 207|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))                                                                #|line 208|#
  (let ((msg (make_message    port  datum                                                                               #|line 209|#)))
    (declare (ignorable msg))
    (put_output    eh  msg                                                                                              #|line 210|#))#|line 211|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))                                                                    #|line 213|#
  (let ((datum (new_datum_string    s                                                                                   #|line 214|#)))
    (declare (ignorable datum))
    (let ((msg (make_message    port  datum                                                                             #|line 215|#)))
      (declare (ignorable msg))
      (put_output    eh  msg                                                                                            #|line 216|#)))#|line 217|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                                                                                  #|line 219|#
  (let ((fwdmsg (make_message    port (cdr (assoc ' datum  msg))                                                        #|line 220|#)))
    (declare (ignorable fwdmsg))
    (put_output    eh  msg                                                                                              #|line 221|#))#|line 222|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 224|#
  (cdr (assoc '(inject    eh  msg                                                                                       #|line 225|#)  eh))#|line 226|#
  )#|  Returns a list of all output messages on a container. |#                                                         #|line 228|##|  For testing / debugging purposes. |##|line 229|##|line 230|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 231|#
  (return-from output_list (cdr (assoc ' outq  eh)))                                                                    #|line 232|##|line 233|#
  )#|  Utility for printing an array of messages. |#                                                                    #|line 235|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 236|#
  (loop for m in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
    do                                                                                                                  #|line 237|#
    (format *standard-output* "~a" (format_message    m ))                                                              #|line 238|#
    )                                                                                                                   #|line 239|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                                                                              #|line 241|#
  (let (( s  ""))
    (declare (ignorable  s))                                                                                            #|line 242|#
    (loop for i in (loop for n from 0 below  n by 1 collect n)
      do                                                                                                                #|line 243|#
      (setf  s (+  s  " "))                                                                                             #|line 244|#
      )
    (return-from spaces  s)                                                                                             #|line 245|#)#|line 246|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 248|#
  (setf (cdr (assoc ' state  eh))  "active")                                                                            #|line 249|##|line 250|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 252|#
  (setf (cdr (assoc ' state  eh))  "idle")                                                                              #|line 253|##|line 254|#
  )#|  Utility for printing a specific output message. |#                                                               #|line 256|##|line 257|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 258|#
  (loop for msg in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
    do                                                                                                                  #|line 259|#
    (cond
      (( equal   (cdr (assoc ' port  msg))  port)                                                                       #|line 260|#
        (return-from fetch_first_output (cdr (assoc ' datum  msg)))
        ))                                                                                                              #|line 261|#
    )
  (return-from fetch_first_output  nil)                                                                                 #|line 262|##|line 263|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 265|#
  #|  port ∷ “” |#                                                                                                      #|line 266|#
  (let (( datum (fetch_first_output    eh  port                                                                         #|line 267|#)))
    (declare (ignorable  datum))
    (format *standard-output* "~a" (cdr (assoc '(srepr  )  datum)))                                                     #|line 268|#)#|line 269|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 270|#
  #|  port ∷ “” |#                                                                                                      #|line 271|#
  (let (( datum (fetch_first_output    eh  port                                                                         #|line 272|#)))
    (declare (ignorable  datum))
    #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |#        #|line 273|#
    (format *error-output* "~a" (cdr (assoc '(srepr  )  datum)))                                                        #|line 274|#)#|line 275|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 277|#
  (cdr (assoc '(cdr (assoc '(put    msg                                                                                 #|line 278|#)  outq))  eh))#|line 279|#
  )
(defun injector_NIY (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 281|#
  #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#        #|line 282|#
  (format *standard-output* "~a"  (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))))#|line 287|#
  (exit  )                                                                                                              #|line 288|##|line 289|#
  )
(defparameter  root_project  "")                                                                                        #|line 291|#
(defparameter  root_0D  "")                                                                                             #|line 292|##|line 293|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                                                                                  #|line 294|##|line 295|##|line 296|#
  (setf  root_project  rproject)                                                                                        #|line 297|#
  (setf  root_0D  r0D)                                                                                                  #|line 298|##|line 299|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 301|#
  (let ((name_with_id (gensymbol    "?"                                                                                 #|line 302|#)))
    (declare (ignorable name_with_id))
    (return-from probe_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                              #|line 303|#)))#|line 304|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 305|#
  (let ((name_with_id (gensymbol    "?A"                                                                                #|line 306|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                             #|line 307|#)))#|line 308|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 310|#
  (let ((name_with_id (gensymbol    "?B"                                                                                #|line 311|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                             #|line 312|#)))#|line 313|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 315|#
  (let ((name_with_id (gensymbol    "?C"                                                                                #|line 316|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (make_leaf    name_with_id  owner  nil  #'probe_handler                             #|line 317|#)))#|line 318|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 320|#
  (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
    (declare (ignorable s))                                                                                             #|line 321|#
    (format *error-output* "~a"  (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))))#|line 322|#)#|line 323|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 325|#
  (let ((name_with_id (gensymbol    "trash"                                                                             #|line 326|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (make_leaf    name_with_id  owner  nil  #'trash_handler                              #|line 327|#)))#|line 328|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 330|#
  #|  to appease dumped_on_floor checker |#                                                                             #|line 331|#
  #| pass |#                                                                                                            #|line 332|##|line 333|#
  )
(defun TwoMessages (&optional  first  second)                                                                           #|line 334|#
  (list
    (cons 'first  first)                                                                                                #|line 335|#
    (cons 'second  second)                                                                                              #|line 336|#)#|line 337|#)
#|line 338|##|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |##|line 339|#
(defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 340|#
  (list
    (cons 'state  state)                                                                                                #|line 341|#
    (cons 'buffer  buffer)                                                                                              #|line 342|#)#|line 343|#)
#|line 344|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                                                                                           #|line 345|#
  #| pass |#                                                                                                            #|line 346|##|line 347|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 349|#
  (let ((name_with_id (gensymbol    "deracer"                                                                           #|line 350|#)))
    (declare (ignorable name_with_id))
    (let ((inst (Deracer_Instance_Data    "idle" (TwoMessages    nil  nil )                                             #|line 351|#)))
      (declare (ignorable inst))
      (setf (cdr (assoc ' state  inst))  "idle")                                                                        #|line 352|#
      (let ((eh (make_leaf    name_with_id  owner  inst  #'deracer_handler                                              #|line 353|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)                                                                           #|line 354|#)))#|line 355|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                                                                                       #|line 357|#
  (forward    eh  "1" (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                                #|line 358|#)
  (forward    eh  "2" (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                               #|line 359|#)
  (reclaim_Buffers_from_heap    inst                                                                                    #|line 360|#)#|line 361|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 363|#
  (let (( inst (cdr (assoc ' instance_data  eh))))
    (declare (ignorable  inst))                                                                                         #|line 364|#
    (cond
      (( equal   (cdr (assoc ' state  inst))  "idle")                                                                   #|line 365|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 366|#
            (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                              #|line 367|#
            (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                                      #|line 368|#
            )
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 369|#
            (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                             #|line 370|#
            (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                                       #|line 371|#
            )
          (t                                                                                                            #|line 372|#
            (runtime_error    (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
            ))                                                                                                          #|line 373|#
        )
      (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                        #|line 374|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 375|#
            (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                              #|line 376|#
            (send_first_then_second    eh  inst                                                                         #|line 377|#)
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 378|#
            )
          (t                                                                                                            #|line 379|#
            (runtime_error    (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
            ))                                                                                                          #|line 380|#
        )
      (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                       #|line 381|#
        (cond
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 382|#
            (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                             #|line 383|#
            (send_first_then_second    eh  inst                                                                         #|line 384|#)
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 385|#
            )
          (t                                                                                                            #|line 386|#
            (runtime_error    (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
            ))                                                                                                          #|line 387|#
        )
      (t                                                                                                                #|line 388|#
        (runtime_error    "bad state for deracer {eh.state}" )                                                          #|line 389|#
        )))                                                                                                             #|line 390|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 392|#
  (let ((name_with_id (gensymbol    "Low Level Read Text File"                                                          #|line 393|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (make_leaf    name_with_id  owner  nil  #'low_level_read_text_file_handler #|line 394|#)))#|line 395|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 397|#
  (let ((fname (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
    (declare (ignorable fname))                                                                                         #|line 398|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
    #|line 399|#)#|line 400|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 402|#
  (let ((name_with_id (gensymbol    "Ensure String Datum"                                                               #|line 403|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (make_leaf    name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 404|#)))#|line 405|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 407|#
  (cond
    (( equal    "string" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg)))                                            #|line 408|#
      (forward    eh  ""  msg )                                                                                         #|line 409|#
      )
    (t                                                                                                                  #|line 410|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))#|line 411|#))
        (declare (ignorable emsg))
        (send_string    eh  "✗"  emsg  msg ))                                                                           #|line 412|#
      ))                                                                                                                #|line 413|#
  )
(defun Syncfilewrite_Data (&optional )                                                                                  #|line 415|#
  (list
    (cons 'filename  "")                                                                                                #|line 416|#)#|line 417|#)
#|line 418|##|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |##|line 419|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 420|#
  (let ((name_with_id (gensymbol    "syncfilewrite"                                                                     #|line 421|#)))
    (declare (ignorable name_with_id))
    (let ((inst (Syncfilewrite_Data  )))
      (declare (ignorable inst))                                                                                        #|line 422|#
      (return-from syncfilewrite_instantiate (make_leaf    name_with_id  owner  inst  #'syncfilewrite_handler           #|line 423|#))))#|line 424|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 426|#
  (let (( inst (cdr (assoc ' instance_data  eh))))
    (declare (ignorable  inst))                                                                                         #|line 427|#
    (cond
      (( equal    "filename" (cdr (assoc ' port  msg)))                                                                 #|line 428|#
        (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)))                       #|line 429|#
        )
      (( equal    "input" (cdr (assoc ' port  msg)))                                                                    #|line 430|#
        (let ((contents (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
          (declare (ignorable contents))                                                                                #|line 431|#
          (let (( f (open   (cdr (assoc ' filename  inst))  "w"                                                         #|line 432|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                                                                                   #|line 433|#
                (cdr (assoc '(write   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))                               #|line 434|#)  f))
                (cdr (assoc '(close  )  f))                                                                             #|line 435|#
                (send    eh  "done" (new_datum_bang  )  msg )                                                           #|line 436|#
                )
              (t                                                                                                        #|line 437|#
                (send_string    eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))  msg )
                ))))                                                                                                    #|line 438|#
        )))                                                                                                             #|line 439|#
  )
(defun StringConcat_Instance_Data (&optional )                                                                          #|line 441|#
  (list
    (cons 'buffer1  nil)                                                                                                #|line 442|#
    (cons 'buffer2  nil)                                                                                                #|line 443|#
    (cons 'count  0)                                                                                                    #|line 444|#)#|line 445|#)
#|line 446|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 447|#
  (let ((name_with_id (gensymbol    "stringconcat"                                                                      #|line 448|#)))
    (declare (ignorable name_with_id))
    (let ((instp (StringConcat_Instance_Data  )))
      (declare (ignorable instp))                                                                                       #|line 449|#
      (return-from stringconcat_instantiate (make_leaf    name_with_id  owner  instp  #'stringconcat_handler            #|line 450|#))))#|line 451|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 453|#
  (let (( inst (cdr (assoc ' instance_data  eh))))
    (declare (ignorable  inst))                                                                                         #|line 454|#
    (cond
      (( equal    "1" (cdr (assoc ' port  msg)))                                                                        #|line 455|#
        (setf (cdr (assoc ' buffer1  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))         #|line 456|#))
        (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                           #|line 457|#
        (maybe_stringconcat    eh  inst  msg )                                                                          #|line 458|#
        )
      (( equal    "2" (cdr (assoc ' port  msg)))                                                                        #|line 459|#
        (setf (cdr (assoc ' buffer2  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))         #|line 460|#))
        (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                           #|line 461|#
        (maybe_stringconcat    eh  inst  msg )                                                                          #|line 462|#
        )
      (t                                                                                                                #|line 463|#
        (runtime_error    (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))            #|line 464|#)#|line 465|#
        )))                                                                                                             #|line 466|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                                                                                  #|line 468|#
  (cond
    (( and  ( equal    0 (len   (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len   (cdr (assoc ' buffer2  inst)) )))  #|line 469|#
      (runtime_error    "something is wrong in stringconcat, both strings are 0 length" )                               #|line 470|#
      ))
  (cond
    (( >=  (cdr (assoc ' count  inst))  2)                                                                              #|line 471|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))                                                                      #|line 472|#
        (cond
          (( equal    0 (len   (cdr (assoc ' buffer1  inst)) ))                                                         #|line 473|#
            (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                                   #|line 474|#
            )
          (( equal    0 (len   (cdr (assoc ' buffer2  inst)) ))                                                         #|line 475|#
            (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                                   #|line 476|#
            )
          (t                                                                                                            #|line 477|#
            (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst))))                 #|line 478|#
            ))
        (send_string    eh  ""  concatenated_string  msg                                                                #|line 479|#)
        (setf (cdr (assoc ' buffer1  inst))  nil)                                                                       #|line 480|#
        (setf (cdr (assoc ' buffer2  inst))  nil)                                                                       #|line 481|#
        (setf (cdr (assoc ' count  inst))  0))                                                                          #|line 482|#
      ))                                                                                                                #|line 483|#
  )#|  |#                                                                                                               #|line 485|##|line 486|##|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 487|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 488|#
  (let ((name_with_id (gensymbol    "shell_out"                                                                         #|line 489|#)))
    (declare (ignorable name_with_id))
    ( equal    cmd (split-sequence '(#\space)  template_data)                                                           #|line 490|#)
    (return-from shell_out_instantiate (make_leaf    name_with_id  owner  cmd  #'shell_out_handler                      #|line 491|#)))#|line 492|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 494|#
  (let ((cmd (cdr (assoc ' instance_data  eh))))
    (declare (ignorable cmd))                                                                                           #|line 495|#
    (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))
      (declare (ignorable s))                                                                                           #|line 496|#
      (let (( stdout  nil))
        (declare (ignorable  stdout))                                                                                   #|line 497|#
        (let (( stderr  nil))
          (declare (ignorable  stderr))                                                                                 #|line 498|#
          (multiple-value-setq ( stdout  stderr) (run_command    eh  cmd  s                                             #|line 499|#))
          (cond
            ((not (equal   stderr  nil))                                                                                #|line 500|#
              (send_string    eh  "✗"  stderr  msg )                                                                    #|line 501|#
              )
            (t                                                                                                          #|line 502|#
              (send_string    eh  ""  stdout  msg )                                                                     #|line 503|#
              ))))))                                                                                                    #|line 504|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 506|##|line 507|##|line 508|#
  (let ((name_with_id (gensymbol    "strconst"                                                                          #|line 509|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                                                                                          #|line 510|#
      (cond
        ((not (equal   root_project  ""))                                                                               #|line 511|#
          (setf  s (cdr (assoc '(sub    "_00_"  root_project  s )  re)))                                                #|line 512|#
          ))
      (cond
        ((not (equal   root_0D  ""))                                                                                    #|line 513|#
          (setf  s (cdr (assoc '(sub    "_0D_"  root_0D  s )  re)))                                                     #|line 514|#
          ))
      (return-from string_constant_instantiate (make_leaf    name_with_id  owner  s  #'string_constant_handler          #|line 515|#))))#|line 516|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 518|#
  (let ((s (cdr (assoc ' instance_data  eh))))
    (declare (ignorable s))                                                                                             #|line 519|#
    (send_string    eh  ""  s  msg                                                                                      #|line 520|#))#|line 521|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 523|#
  #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                        #|line 524|#
  (return-from string_make_persistent  s)                                                                               #|line 525|##|line 526|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 528|#
  (return-from string_clone  s)                                                                                         #|line 529|##|line 530|#
  )#|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |#                                   #|line 532|##|  where ${_00_} is the root directory for the project |##|line 533|##|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |##|line 534|##|line 535|##|line 536|##|line 537|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files))                                                    #|line 538|#
  (let ((reg (make_component_registry  )))
    (declare (ignorable reg))                                                                                           #|line 539|#
    (loop for diagram_source in  diagram_source_files
      do                                                                                                                #|line 540|#
      (let ((all_containers_within_single_file (json2internal    diagram_source                                         #|line 541|#)))
        (declare (ignorable all_containers_within_single_file))
        (generate_shell_components    reg  all_containers_within_single_file                                            #|line 542|#)
        (loop for container in  all_containers_within_single_file
          do                                                                                                            #|line 543|#
          (register_component    reg (Template   (cdr (assoc 'name  container)) #|  template_data =  |# container #|  instantiator =  |# #'container_instantiator ) )
          ))                                                                                                            #|line 544|#
      )
    (initialize_stock_components    reg                                                                                 #|line 545|#)
    (return-from initialize_component_palette  reg)                                                                     #|line 546|#)#|line 547|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 549|#
  (let ((error_port  "✗"))
    (declare (ignorable error_port))                                                                                    #|line 550|#
    (let ((err (fetch_first_output    main_container  error_port                                                        #|line 551|#)))
      (declare (ignorable err))
      (cond
        (( and  (not (equal   err  nil)) ( <   0 (len   (trimws   (cdr (assoc '(srepr  )  err)) ) )))                   #|line 552|#
          (format *standard-output* "~a"  "___ !!! ERRORS !!! ___")                                                     #|line 553|#
          (print_specific_output    main_container  error_port  nil )                                                   #|line 554|#
          ))))                                                                                                          #|line 555|#
  )#|  debugging helpers |#                                                                                             #|line 557|##|line 558|#
(defun nl (&optional )
  (declare (ignorable ))                                                                                                #|line 559|#
  (format *standard-output* "~a"  "")                                                                                   #|line 560|##|line 561|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 563|#
  (nl  )                                                                                                                #|line 564|#
  (format *standard-output* "~a"  "___ Outputs ___")                                                                    #|line 565|#
  (print_output_list    main_container                                                                                  #|line 566|#)#|line 567|#
  )
(defun trace_outputs (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 569|#
  (nl  )                                                                                                                #|line 570|#
  (format *standard-output* "~a"  "___ Message Traces ___")                                                             #|line 571|#
  (print_routing_trace    main_container                                                                                #|line 572|#)#|line 573|#
  )
(defun dump_hierarchy (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 575|#
  (nl  )                                                                                                                #|line 576|#
  (format *standard-output* "~a"  (concatenate 'string  "___ Hierarchy ___" (build_hierarchy    main_container )))      #|line 577|##|line 578|#
  )
(defun build_hierarchy (&optional  c)
  (declare (ignorable  c))                                                                                              #|line 580|#
  (let (( s  ""))
    (declare (ignorable  s))                                                                                            #|line 581|#
    (loop for child in (cdr (assoc ' children  c))
      do                                                                                                                #|line 582|#
      (setf  s  (concatenate 'string  s (build_hierarchy    child )))                                                   #|line 583|#
      )
    (let (( indent  ""))
      (declare (ignorable  indent))                                                                                     #|line 584|#
      (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
        do                                                                                                              #|line 585|#
        (setf  indent (+  indent  "  "))                                                                                #|line 586|#
        )
      (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")")))))#|line 587|#)))#|line 588|#
  )
(defun dump_connections (&optional  c)
  (declare (ignorable  c))                                                                                              #|line 590|#
  (nl  )                                                                                                                #|line 591|#
  (format *standard-output* "~a"  "___ connections ___")                                                                #|line 592|#
  (dump_possible_connections    c                                                                                       #|line 593|#)
  (loop for child in (cdr (assoc ' children  c))
    do                                                                                                                  #|line 594|#
    (nl  )                                                                                                              #|line 595|#
    (dump_possible_connections    child )                                                                               #|line 596|#
    )                                                                                                                   #|line 597|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 599|#
  #|  remove whitespace from front and back of string |#                                                                #|line 600|#
  (return-from trimws (cdr (assoc '(strip  )  s)))                                                                      #|line 601|##|line 602|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 604|#
  (return-from clone_string  s                                                                                          #|line 605|##|line 606|#)#|line 607|#
  )
(defparameter  load_errors  nil)                                                                                        #|line 608|#
(defparameter  runtime_errors  nil)                                                                                     #|line 609|##|line 610|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 611|##|line 612|#
  (format *standard-output* "~a"  s)                                                                                    #|line 613|#
  (quit  )                                                                                                              #|line 614|#
  (setf  load_errors  t)                                                                                                #|line 615|##|line 616|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 618|##|line 619|#
  (format *standard-output* "~a"  s)                                                                                    #|line 620|#
  (quit  )                                                                                                              #|line 621|#
  (setf  runtime_errors  t)                                                                                             #|line 622|##|line 623|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 625|#
  (let ((instance_name (gensymbol    "fakepipe"                                                                         #|line 626|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (make_leaf    instance_name  owner  nil  #'fakepipename_handler               #|line 627|#)))#|line 628|#
  )
(defparameter  rand  0)                                                                                                 #|line 630|##|line 631|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 632|##|line 633|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ 'rand' must be unique within a single run |#                                   #|line 634|#
  (send_string    eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg                                             #|line 635|#)#|line 636|#
  )                                                                                                                     #|line 638|##|  all of the the built_in leaves are listed here |##|line 639|##|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 640|##|line 641|##|line 642|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 643|#
  (register_component    reg (Template    "1then2"  nil  #'deracer_instantiate )                                        #|line 644|#)
  (register_component    reg (Template    "?"  nil  #'probe_instantiate )                                               #|line 645|#)
  (register_component    reg (Template    "?A"  nil  #'probeA_instantiate )                                             #|line 646|#)
  (register_component    reg (Template    "?B"  nil  #'probeB_instantiate )                                             #|line 647|#)
  (register_component    reg (Template    "?C"  nil  #'probeC_instantiate )                                             #|line 648|#)
  (register_component    reg (Template    "trash"  nil  #'trash_instantiate )                                           #|line 649|#)#|line 650|#
  (register_component    reg (Template    "Low Level Read Text File"  nil  #'low_level_read_text_file_instantiate )     #|line 651|#)
  (register_component    reg (Template    "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )               #|line 652|#)#|line 653|#
  (register_component    reg (Template    "syncfilewrite"  nil  #'syncfilewrite_instantiate )                           #|line 654|#)
  (register_component    reg (Template    "stringconcat"  nil  #'stringconcat_instantiate )                             #|line 655|#)
  #|  for fakepipe |#                                                                                                   #|line 656|#
  (register_component    reg (Template    "fakepipename"  nil  #'fakepipename_instantiate )                             #|line 657|#)#|line 658|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                                                                                #|line 660|#

  (error 'NIY)
  #|line 661|##|line 662|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                                                                                #|line 664|#
  (let ((root_of_project  (nth  1 (argv))                                                                               #|line 665|#))
    (declare (ignorable root_of_project))
    (let ((root_of_0D  (nth  2 (argv))                                                                                  #|line 666|#))
      (declare (ignorable root_of_0D))
      (let ((arg  (nth  3 (argv))                                                                                       #|line 667|#))
        (declare (ignorable arg))
        (let ((main_container_name  (nth  4 (argv))                                                                     #|line 668|#))
          (declare (ignorable main_container_name))
          (let ((diagram_names  (nthcdr  5 (argv))                                                                      #|line 669|#))
            (declare (ignorable diagram_names))
            (let ((palette (initialize_component_palette    root_project  root_0D  diagram_names                        #|line 670|#)))
              (declare (ignorable palette))
              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg )))#|line 671|#))))))#|line 672|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
  (start_with_debug    palette  env  nil  nil  nil  nil )                                                               #|line 674|#
  )
(defun start_with_debug (&optional  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs)
  (declare (ignorable  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs))                  #|line 675|#
  #|  show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥ |#                                        #|line 676|#
  (let ((root_of_project (nth  0  env)))
    (declare (ignorable root_of_project))                                                                               #|line 677|#
    (let ((root_of_0D (nth  1  env)))
      (declare (ignorable root_of_0D))                                                                                  #|line 678|#
      (let ((main_container_name (nth  2  env)))
        (declare (ignorable main_container_name))                                                                       #|line 679|#
        (let ((diagram_names (nth  3  env)))
          (declare (ignorable diagram_names))                                                                           #|line 680|#
          (let ((arg (nth  4  env)))
            (declare (ignorable arg))                                                                                   #|line 681|#
            (set_environment    root_of_project  root_of_0D                                                             #|line 682|#)
            #|  get entrypoint container |#                                                                             #|line 683|#
            (let (( main_container (get_component_instance    palette  main_container_name  nil                         #|line 684|#)))
              (declare (ignorable  main_container))
              (cond
                (( equal    nil  main_container)                                                                        #|line 685|#
                  (load_error    (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)")))) #|line 689|#)#|line 690|#
                  ))
              (cond
                ( show_hierarchy                                                                                        #|line 691|#
                  (dump_hierarchy    main_container                                                                     #|line 692|#)#|line 693|#
                  ))
              (cond
                ( show_connections                                                                                      #|line 694|#
                  (dump_connections    main_container                                                                   #|line 695|#)#|line 696|#
                  ))
              (cond
                ((not  load_errors)                                                                                     #|line 697|#
                  (let (( arg (new_datum_string    arg                                                                  #|line 698|#)))
                    (declare (ignorable  arg))
                    (let (( msg (make_message    ""  arg                                                                #|line 699|#)))
                      (declare (ignorable  msg))
                      (inject    main_container  msg                                                                    #|line 700|#)
                      (cond
                        ( show_all_outputs                                                                              #|line 701|#
                          (dump_outputs    main_container                                                               #|line 702|#)
                          )
                        (t                                                                                              #|line 703|#
                          (print_error_maybe    main_container                                                          #|line 704|#)
                          (print_specific_output    main_container  ""                                                  #|line 705|#)
                          (cond
                            ( show_traces                                                                               #|line 706|#
                              (format *standard-output* "~a"  "--- routing traces ---")                                 #|line 707|#
                              (format *standard-output* "~a" (routing_trace_all    main_container ))                    #|line 708|##|line 709|#
                              ))                                                                                        #|line 710|#
                          ))
                      (cond
                        ( show_all_outputs                                                                              #|line 711|#
                          (format *standard-output* "~a"  "--- done ---")                                               #|line 712|##|line 713|#
                          ))))                                                                                          #|line 714|#
                  ))))))))                                                                                              #|line 715|#
  )                                                                                                                     #|line 717|##|line 718|##|  utility functions  |##|line 719|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))                                                                   #|line 720|#
  (let ((datum (new_datum_int    i                                                                                      #|line 721|#)))
    (declare (ignorable datum))
    (send    eh  port  datum  causing_message                                                                           #|line 722|#))#|line 723|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))                                                                      #|line 725|#
  (let ((datum (new_datum_bang  )))
    (declare (ignorable datum))                                                                                         #|line 726|#
    (send    eh  port  datum  causing_message                                                                           #|line 727|#))#|line 728|#
  )





