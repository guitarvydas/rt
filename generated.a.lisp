
(ql:quickload :cl-json)

(defparameter  counter  0)                                                                                              #|line 1|##|line 2|#
(defparameter  digits (list                                                                                             #|line 3|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" ))#|line 9|##|line 10|##|line 11|#
(defun gensymbol (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 12|##|line 13|#
        (let ((name_with_id  (concatenate 'string  s (subscripted_digit    counter ))))                                 #|line 14|#
            (setf  counter (+  counter  1))                                                                             #|line 15|#
              (return-from gensymbol  name_with_id)                                                                     #|line 16|#)#|line 17|#
  )
(defun subscripted_digit (&optional  n)
  (declare (ignorable  n))                                                                                              #|line 19|##|line 20|#
        (cond
          (( and  ( >=   n  0) ( <=   n  29))                                                                           #|line 21|#
                (return-from subscripted_digit (nth  n  digits))                                                        #|line 22|#
            )
          (t                                                                                                            #|line 23|#
                (return-from subscripted_digit  (concatenate 'string  "₊"  n))                                          #|line 24|##|line 25|#
            ))                                                                                                          #|line 26|#
  )
(defun Datum (&optional )                                                                                               #|line 28|#
  (list
    (cons 'data  nil)                                                                                                   #|line 29|#
    (cons 'clone  nil)                                                                                                  #|line 30|#
    (cons 'reclaim  nil)                                                                                                #|line 31|#
    (cons 'srepr  nil)                                                                                                  #|line 32|#
    (cons 'kind  nil)                                                                                                   #|line 33|#
    (cons 'raw  nil)                                                                                                    #|line 34|#)#|line 35|#)
                                                                                                                        #|line 36|#
(defun new_datum_string (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 37|#
      (let ((d  (Datum)))                                                                                               #|line 38|#
          (setf (cdr (assoc ' data  d))  s)                                                                             #|line 39|#
            (setf (cdr (assoc ' clone  d))  #'(lambda (&optional )(clone_datum_string    d                              #|line 40|#)))
              (setf (cdr (assoc ' reclaim  d))  #'(lambda (&optional )(reclaim_datum_string    d                        #|line 41|#)))
                (setf (cdr (assoc ' srepr  d))  #'(lambda (&optional )(srepr_datum_string    d                          #|line 42|#)))
                  (setf (cdr (assoc ' raw  d))  #'(lambda (&optional )(raw_datum_string    d                            #|line 43|#)))
                    (setf (cdr (assoc ' kind  d))  #'(lambda (&optional ) "string"))                                    #|line 44|#
                      (return-from new_datum_string  d)                                                                 #|line 45|#)#|line 46|#
  )
(defun clone_datum_string (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 48|#
      (let ((d (new_datum_string   (cdr (assoc ' data  d))                                                              #|line 49|#)))
          (return-from clone_datum_string  d)                                                                           #|line 50|#)#|line 51|#
  )
(defun reclaim_datum_string (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 53|#
      #| pass |#                                                                                                        #|line 54|##|line 55|#
  )
(defun srepr_datum_string (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 57|#
      (return-from srepr_datum_string (cdr (assoc ' data  d)))                                                          #|line 58|##|line 59|#
  )
(defun raw_datum_string (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 61|#
      (return-from raw_datum_string (bytearray   (cdr (assoc ' data  d))  "UTF_8"                                       #|line 62|#))#|line 63|#
  )
(defun new_datum_bang (&optional )
  (declare (ignorable ))                                                                                                #|line 65|#
      (let ((p (Datum  )))                                                                                              #|line 66|#
          (setf (cdr (assoc ' data  p))  t)                                                                             #|line 67|#
            (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bang    p                                #|line 68|#)))
              (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bang    p                          #|line 69|#)))
                (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bang  )))                            #|line 70|#
                  (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bang  )))                              #|line 71|#
                    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bang"))                                      #|line 72|#
                      (return-from new_datum_bang  p)                                                                   #|line 73|#)#|line 74|#
  )
(defun clone_datum_bang (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 76|#
      (return-from clone_datum_bang (new_datum_bang  ))                                                                 #|line 77|##|line 78|#
  )
(defun reclaim_datum_bang (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 80|#
      #| pass |#                                                                                                        #|line 81|##|line 82|#
  )
(defun srepr_datum_bang (&optional )
  (declare (ignorable ))                                                                                                #|line 84|#
      (return-from srepr_datum_bang  "!")                                                                               #|line 85|##|line 86|#
  )
(defun raw_datum_bang (&optional )
  (declare (ignorable ))                                                                                                #|line 88|#
      (return-from raw_datum_bang  nil)                                                                                 #|line 89|##|line 90|#
  )
(defun new_datum_tick (&optional )
  (declare (ignorable ))                                                                                                #|line 92|#
      (let ((p (new_datum_bang  )))                                                                                     #|line 93|#
          (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "tick"))                                                #|line 94|#
            (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(new_datum_tick  )))                                  #|line 95|#
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_tick  )))                              #|line 96|#
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_tick  )))                                #|line 97|#
                  (return-from new_datum_tick  p)                                                                       #|line 98|#)#|line 99|#
  )
(defun srepr_datum_tick (&optional )
  (declare (ignorable ))                                                                                                #|line 101|#
      (return-from srepr_datum_tick  ".")                                                                               #|line 102|##|line 103|#
  )
(defun raw_datum_tick (&optional )
  (declare (ignorable ))                                                                                                #|line 105|#
      (return-from raw_datum_tick  nil)                                                                                 #|line 106|##|line 107|#
  )
(defun new_datum_bytes (&optional  b)
  (declare (ignorable  b))                                                                                              #|line 109|#
      (let ((p (Datum  )))                                                                                              #|line 110|#
          (setf (cdr (assoc ' data  p))  b)                                                                             #|line 111|#
            (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bytes    p                               #|line 112|#)))
              (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bytes    p                         #|line 113|#)))
                (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bytes    b                           #|line 114|#)))
                  (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bytes    b                             #|line 115|#)))
                    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bytes"))                                     #|line 116|#
                      (return-from new_datum_bytes  p)                                                                  #|line 117|#)#|line 118|#
  )
(defun clone_datum_bytes (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 120|#
      (let ((p (Datum  )))                                                                                              #|line 121|#
          (setf (cdr (assoc ' clone  p)) (cdr (assoc ' clone  src)))                                                    #|line 122|#
            (setf (cdr (assoc ' reclaim  p)) (cdr (assoc ' reclaim  src)))                                              #|line 123|#
              (setf (cdr (assoc ' srepr  p)) (cdr (assoc ' srepr  src)))                                                #|line 124|#
                (setf (cdr (assoc ' raw  p)) (cdr (assoc ' raw  src)))                                                  #|line 125|#
                  (setf (cdr (assoc ' kind  p)) (cdr (assoc ' kind  src)))                                              #|line 126|#
                    (setf (cdr (assoc ' data  p)) (cdr (assoc '(clone  )  src)))                                        #|line 127|#
                      (return-from clone_datum_bytes  p)                                                                #|line 128|#)#|line 129|#
  )
(defun reclaim_datum_bytes (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 131|#
      #| pass |#                                                                                                        #|line 132|##|line 133|#
  )
(defun srepr_datum_bytes (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 135|#
      (return-from srepr_datum_bytes (cdr (assoc '(cdr (assoc '(decode    "UTF_8"                                       #|line 136|#)  data))  d)))#|line 137|#
  )
(defun raw_datum_bytes (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 138|#
      (return-from raw_datum_bytes (cdr (assoc ' data  d)))                                                             #|line 139|##|line 140|#
  )
(defun new_datum_handle (&optional  h)
  (declare (ignorable  h))                                                                                              #|line 142|#
      (return-from new_datum_handle (new_datum_int    h                                                                 #|line 143|#))#|line 144|#
  )
(defun new_datum_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 146|#
      (let ((p (Datum  )))                                                                                              #|line 147|#
          (setf (cdr (assoc ' data  p))  i)                                                                             #|line 148|#
            (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_int    i                                       #|line 149|#)))
              (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_int    i                                 #|line 150|#)))
                (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_int    i                             #|line 151|#)))
                  (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_int    i                               #|line 152|#)))
                    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "int"))                                       #|line 153|#
                      (return-from new_datum_int  p)                                                                    #|line 154|#)#|line 155|#
  )
(defun clone_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 157|#
      (let ((p (new_datum_int    i                                                                                      #|line 158|#)))
          (return-from clone_int  p)                                                                                    #|line 159|#)#|line 160|#
  )
(defun reclaim_int (&optional  src)
  (declare (ignorable  src))                                                                                            #|line 162|#
      #| pass |#                                                                                                        #|line 163|##|line 164|#
  )
(defun srepr_datum_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 166|#
      (return-from srepr_datum_int (str    i                                                                            #|line 167|#))#|line 168|#
  )
(defun raw_datum_int (&optional  i)
  (declare (ignorable  i))                                                                                              #|line 170|#
      (return-from raw_datum_int  i)                                                                                    #|line 171|##|line 172|#
  )#|  Message passed to a leaf component. |#                                                                           #|line 174|##|  |##|line 175|##|  `port` refers to the name of the incoming or outgoing port of this component. |##|line 176|##|  `datum` is the data attached to this message. |##|line 177|#
(defun Message (&optional  port  datum)                                                                                 #|line 178|#
  (list
    (cons 'port  port)                                                                                                  #|line 179|#
    (cons 'datum  datum)                                                                                                #|line 180|#)#|line 181|#)
                                                                                                                        #|line 182|#
(defun clone_port (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 183|#
      (return-from clone_port (clone_string    s                                                                        #|line 184|#))#|line 185|#
  )#|  Utility for making a `Message`. Used to safely “seed“ messages |#                                                #|line 187|##|  entering the very top of a network. |##|line 188|#
(defun make_message (&optional  port  datum)
  (declare (ignorable  port  datum))                                                                                    #|line 189|#
      (let ((p (clone_string    port                                                                                    #|line 190|#)))
          (let ((m (Message    p (cdr (assoc '(clone  )  datum))                                                        #|line 191|#)))
              (return-from make_message  m)                                                                             #|line 192|#))#|line 193|#
  )#|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#             #|line 195|#
(defun message_clone (&optional  message)
  (declare (ignorable  message))                                                                                        #|line 196|#
      (let ((m (Message   (clone_port   (cdr (assoc ' port  message)) ) (cdr (assoc '(cdr (assoc '(clone  )  datum))  message)) #|line 197|#)))
          (return-from message_clone  m)                                                                                #|line 198|#)#|line 199|#
  )#|  Frees a message. |#                                                                                              #|line 201|#
(defun destroy_message (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 202|#
      #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |##|line 203|#
        #| pass |#                                                                                                      #|line 204|##|line 205|#
  )
(defun destroy_datum (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 207|#
      #| pass |#                                                                                                        #|line 208|##|line 209|#
  )
(defun destroy_port (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 211|#
      #| pass |#                                                                                                        #|line 212|##|line 213|#
  )#|  |#                                                                                                               #|line 215|#
(defun format_message (&optional  m)
  (declare (ignorable  m))                                                                                              #|line 216|#
      (cond
        (( equal    m  nil)                                                                                             #|line 217|#
              (return-from format_message  "ϕ")                                                                         #|line 218|#
          )
        (t                                                                                                              #|line 219|#
              (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc ' port  m))  (concatenate 'string  "⦂"  (concatenate 'string (cdr (assoc '(cdr (assoc '(srepr  )  datum))  m))  "⟫")))))#|line 223|##|line 224|#
          ))                                                                                                            #|line 225|#
  )                                                                                                                     #|line 227|#
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                                                                                          #|line 232|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)
  (declare (ignorable  reg  owner  container_name  desc))                                                               #|line 233|##|line 234|#
        (let ((container (make_container    container_name  owner                                                       #|line 235|#)))
            (let ((children  nil))                                                                                      #|line 236|#
                (let ((children_by_id  nil))
                    #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#       #|line 237|#
                      #|  collect children |#                                                                           #|line 238|#
                        (loop for child_desc in (cdr (assoc 'children  desc))
                          do                                                                                            #|line 239|#
                              (let ((child_instance (get_component_instance    reg (cdr (assoc 'name  child_desc))  container #|line 240|#)))
                                  (cdr (assoc '(append    child_instance                                                #|line 241|#)  children))
                                    (setf (nth (cdr (assoc 'id  child_desc))  children_by_id)  child_instance))         #|line 242|#
                          )
                          (setf (cdr (assoc ' children  container))  children)                                          #|line 243|#
                            (let ((me  container))                                                                      #|line 244|##|line 245|#
                                  (let ((connectors  nil))                                                              #|line 246|#
                                      (loop for proto_conn in (cdr (assoc 'connections  desc))
                                        do                                                                              #|line 247|#
                                            (let ((connector (Connector  )))                                            #|line 248|#
                                                (cond
                                                  (( equal   (cdr (assoc 'dir  proto_conn))  enumDown)                  #|line 249|#
                                                        #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |##|line 250|#
                                                          (setf (cdr (assoc ' direction  connector))  "down")           #|line 251|#
                                                            (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))  me (cdr (assoc 'source_port  proto_conn)) #|line 252|#))
                                                              (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 253|#
                                                                  (cond
                                                                    (( equal    target_component  nil)                  #|line 254|#
                                                                          (load_error    (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc 'target  proto_conn))) )#|line 255|#
                                                                      )
                                                                    (t                                                  #|line 256|#
                                                                          (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component)) (cdr (assoc ' inq  target_component)) (cdr (assoc 'target_port  proto_conn))  target_component #|line 257|#))
                                                                            (cdr (assoc '(append    connector )  connectors))
                                                                      )))                                               #|line 258|#
                                                    )
                                                  (( equal   (cdr (assoc 'dir  proto_conn))  enumAcross)                #|line 259|#
                                                        (setf (cdr (assoc ' direction  connector))  "across")           #|line 260|#
                                                          (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 261|#
                                                              (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 262|#
                                                                  (cond
                                                                    (( equal    source_component  nil)                  #|line 263|#
                                                                          (load_error    (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 264|#
                                                                      )
                                                                    (t                                                  #|line 265|#
                                                                          (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))  source_component (cdr (assoc 'source_port  proto_conn)) #|line 266|#))
                                                                            (cond
                                                                              (( equal    target_component  nil)        #|line 267|#
                                                                                    (load_error    (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc ' target  proto_conn))) )#|line 268|#
                                                                                )
                                                                              (t                                        #|line 269|#
                                                                                    (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component)) (cdr (assoc ' inq  target_component)) (cdr (assoc 'target_port  proto_conn))  target_component #|line 270|#))
                                                                                      (cdr (assoc '(append    connector )  connectors))
                                                                                ))
                                                                      ))))                                              #|line 271|#
                                                    )
                                                  (( equal   (cdr (assoc 'dir  proto_conn))  enumUp)                    #|line 272|#
                                                        (setf (cdr (assoc ' direction  connector))  "up")               #|line 273|#
                                                          (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 274|#
                                                              (cond
                                                                (( equal    source_component  nil)                      #|line 275|#
                                                                      (print    (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 276|#
                                                                  )
                                                                (t                                                      #|line 277|#
                                                                      (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))  source_component (cdr (assoc 'source_port  proto_conn)) #|line 278|#))
                                                                        (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me)) (cdr (assoc ' outq  container)) (cdr (assoc 'target_port  proto_conn))  me #|line 279|#))
                                                                          (cdr (assoc '(append    connector )  connectors))
                                                                  )))                                                   #|line 280|#
                                                    )
                                                  (( equal   (cdr (assoc 'dir  proto_conn))  enumThrough)               #|line 281|#
                                                        (setf (cdr (assoc ' direction  connector))  "through")          #|line 282|#
                                                          (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))  me (cdr (assoc 'source_port  proto_conn)) #|line 283|#))
                                                            (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me)) (cdr (assoc ' outq  container)) (cdr (assoc 'target_port  proto_conn))  me #|line 284|#))
                                                              (cdr (assoc '(append    connector )  connectors))
                                                    )))                                                                 #|line 285|#
                                        )                                                                               #|line 286|#
                                        (setf (cdr (assoc ' connections  container))  connectors)                       #|line 287|#
                                          (return-from container_instantiator  container)                               #|line 288|#)))))#|line 289|#
  )#|  The default handler for container components. |#                                                                 #|line 291|#
(defun container_handler (&optional  container  message)
  (declare (ignorable  container  message))                                                                             #|line 292|#
      (route    container #|  from=  |# container  message )
        #|  references to 'self' are replaced by the container during instantiation |#                                  #|line 293|#
          (loop while (any_child_ready    container )
            do                                                                                                          #|line 294|#
                (step_children    container  message )                                                                  #|line 295|#
            )                                                                                                           #|line 296|#
  )#|  Frees the given container and associated data. |#                                                                #|line 298|#
(defun destroy_container (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 299|#
      #| pass |#                                                                                                        #|line 300|##|line 301|#
  )
(defun fifo_is_empty (&optional  fifo)
  (declare (ignorable  fifo))                                                                                           #|line 303|#
      (return-from fifo_is_empty (cdr (assoc '(empty  )  fifo)))                                                        #|line 304|##|line 305|#
  )#|  Routing connection for a container component. The `direction` field has |#                                       #|line 307|##|  no affect on the default message routing system _ it is there for debugging |##|line 308|##|  purposes, or for reading by other tools. |##|line 309|##|line 310|#
(defun Connector (&optional )                                                                                           #|line 311|#
  (list
    (cons 'direction  nil) #|  down, across, up, through |#                                                             #|line 312|#
    (cons 'sender  nil)                                                                                                 #|line 313|#
    (cons 'receiver  nil)                                                                                               #|line 314|#)#|line 315|#)
                                                                                                                        #|line 316|##|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |##|line 317|##|  based on component ID (pointer) and port name. |##|line 318|##|line 319|#
(defun Sender (&optional  name  component  port)                                                                        #|line 320|#
  (list
    (cons 'name  name)                                                                                                  #|line 321|#
    (cons 'component  component) #|  from |#                                                                            #|line 322|#
    (cons 'port  port) #|  from's port |#                                                                               #|line 323|#)#|line 324|#)
                                                                                                                        #|line 325|##|  `Receiver` is a handle to a destination queue, and a `port` name to assign |##|line 326|##|  to incoming messages to this queue. |##|line 327|##|line 328|#
(defun Receiver (&optional  name  queue  port  component)                                                               #|line 329|#
  (list
    (cons 'name  name)                                                                                                  #|line 330|#
    (cons 'queue  queue) #|  queue (input | output) of receiver |#                                                      #|line 331|#
    (cons 'port  port) #|  destination port |#                                                                          #|line 332|#
    (cons 'component  component) #|  to (for bootstrap debug) |#                                                        #|line 333|#)#|line 334|#)
                                                                                                                        #|line 335|##|  Checks if two senders match, by pointer equality and port name matching. |##|line 336|#
(defun sender_eq (&optional  s1  s2)
  (declare (ignorable  s1  s2))                                                                                         #|line 337|#
      (let ((same_components ( equal   (cdr (assoc ' component  s1)) (cdr (assoc ' component  s2)))))                   #|line 338|#
          (let ((same_ports ( equal   (cdr (assoc ' port  s1)) (cdr (assoc ' port  s2)))))                              #|line 339|#
              (return-from sender_eq ( and   same_components  same_ports))                                              #|line 340|#))#|line 341|#
  )#|  Delivers the given message to the receiver of this connector. |#                                                 #|line 343|##|line 344|#
(defun deposit (&optional  parent  conn  message)
  (declare (ignorable  parent  conn  message))                                                                          #|line 345|#
      (let ((new_message (make_message   (cdr (assoc '(cdr (assoc ' port  receiver))  conn)) (cdr (assoc ' datum  message)) #|line 346|#)))
          (push_message    parent (cdr (assoc '(cdr (assoc ' component  receiver))  conn)) (cdr (assoc '(cdr (assoc ' queue  receiver))  conn))  new_message #|line 347|#))#|line 348|#
  )
(defun force_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                                                                                     #|line 350|#
      (let ((tick_msg (make_message    "." (new_datum_tick  )                                                           #|line 351|#)))
          (push_message    parent  eh (cdr (assoc ' inq  eh))  tick_msg                                                 #|line 352|#)
            (return-from force_tick  tick_msg)                                                                          #|line 353|#)#|line 354|#
  )
(defun push_message (&optional  parent  receiver  inq  m)
  (declare (ignorable  parent  receiver  inq  m))                                                                       #|line 356|#
      (cdr (assoc '(put    m                                                                                            #|line 357|#)  inq))
        (cdr (assoc '(cdr (assoc '(put    receiver                                                                      #|line 358|#)  visit_ordering))  parent))#|line 359|#
  )
(defun is_self (&optional  child  container)
  (declare (ignorable  child  container))                                                                               #|line 361|#
      #|  in an earlier version “self“ was denoted as ϕ |#                                                              #|line 362|#
        (return-from is_self ( equal    child  container))                                                              #|line 363|##|line 364|#
  )
(defun step_child (&optional  child  msg)
  (declare (ignorable  child  msg))                                                                                     #|line 366|#
      (let ((before_state (cdr (assoc ' state  child))))                                                                #|line 367|#
          (cdr (assoc '(handler    child  msg                                                                           #|line 368|#)  child))
            (let ((after_state (cdr (assoc ' state  child))))                                                           #|line 369|#
                (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle"))) #|line 370|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle"))) #|line 371|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle"))))#|line 372|#))#|line 373|#
  )
(defun save_message (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 375|#
      (cdr (assoc '(cdr (assoc '(put    msg                                                                             #|line 376|#)  saved_messages))  eh))#|line 377|#
  )
(defun fetch_saved_message_and_clear (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 379|#
      (return-from fetch_saved_message_and_clear (cdr (assoc '(cdr (assoc '(get  )  saved_messages))  eh)))             #|line 380|##|line 381|#
  )
(defun step_children (&optional  container  causingMessage)
  (declare (ignorable  container  causingMessage))                                                                      #|line 383|#
      (setf (cdr (assoc ' state  container))  "idle")                                                                   #|line 384|#
        (loop for child in (list   (cdr (assoc '(cdr (assoc ' queue  visit_ordering))  container)) )
          do                                                                                                            #|line 385|#
              #|  child = container represents self, skip it |#                                                         #|line 386|#
                (cond
                  ((not (is_self    child  container ))                                                                 #|line 387|#
                        (cond
                          ((not (cdr (assoc '(cdr (assoc '(empty  )  inq))  child)))                                    #|line 388|#
                                (let ((msg (cdr (assoc '(cdr (assoc '(get  )  inq))  child))))                          #|line 389|#
                                    (let (( began_long_run  nil))                                                       #|line 390|#
                                        (let (( continued_long_run  nil))                                               #|line 391|#
                                            (let (( ended_long_run  nil))                                               #|line 392|#
                                                (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (step_child    child  msg #|line 393|#))
                                                  (cond
                                                    ( began_long_run                                                    #|line 394|#
                                                          (save_message    child  msg                                   #|line 395|#)
                                                      )
                                                    ( continued_long_run                                                #|line 396|#
                                                          #| pass |#                                                    #|line 397|##|line 398|#
                                                      ))
                                                    (destroy_message    msg )))))                                       #|line 399|#
                            )
                          (t                                                                                            #|line 400|#
                                (cond
                                  ((not (equal  (cdr (assoc ' state  child))  "idle"))                                  #|line 401|#
                                        (let ((msg (force_tick    container  child                                      #|line 402|#)))
                                            (cdr (assoc '(handler    child  msg                                         #|line 403|#)  child))
                                              (destroy_message    msg ))
                                    ))                                                                                  #|line 404|#
                            ))                                                                                          #|line 405|#
                          (cond
                            (( equal   (cdr (assoc ' state  child))  "active")                                          #|line 406|#
                                  #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |##|line 407|#
                                    (setf (cdr (assoc ' state  container))  "active")                                   #|line 408|#
                              ))                                                                                        #|line 409|#
                            (loop while (not (cdr (assoc '(cdr (assoc '(empty  )  outq))  child)))
                              do                                                                                        #|line 410|#
                                  (let ((msg (cdr (assoc '(cdr (assoc '(get  )  outq))  child))))                       #|line 411|#
                                      (route    container  child  msg                                                   #|line 412|#)
                                        (destroy_message    msg ))
                              )
                    ))                                                                                                  #|line 413|#
          )                                                                                                             #|line 414|##|line 415|##|line 416|#
  )
(defun attempt_tick (&optional  parent  eh)
  (declare (ignorable  parent  eh))                                                                                     #|line 418|#
      (cond
        ((not (equal  (cdr (assoc ' state  eh))  "idle"))                                                               #|line 419|#
              (force_tick    parent  eh )                                                                               #|line 420|#
          ))                                                                                                            #|line 421|#
  )
(defun is_tick (&optional  msg)
  (declare (ignorable  msg))                                                                                            #|line 423|#
      (return-from is_tick ( equal    "tick" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg))))                       #|line 424|##|line 425|#
  )#|  Routes a single message to all matching destinations, according to |#                                            #|line 427|##|  the container's connection network. |##|line 428|##|line 429|#
(defun route (&optional  container  from_component  message)
  (declare (ignorable  container  from_component  message))                                                             #|line 430|#
      (let (( was_sent  nil))
          #|  for checking that output went somewhere (at least during bootstrap) |#                                    #|line 431|#
            (let (( fromname  ""))                                                                                      #|line 432|#
                (cond
                  ((is_tick    message )                                                                                #|line 433|#
                        (loop for child in (cdr (assoc ' children  container))
                          do                                                                                            #|line 434|#
                              (attempt_tick    container  child )                                                       #|line 435|#
                          )
                          (setf  was_sent  t)                                                                           #|line 436|#
                    )
                  (t                                                                                                    #|line 437|#
                        (cond
                          ((not (is_self    from_component  container ))                                                #|line 438|#
                                (setf  fromname (cdr (assoc ' name  from_component)))                                   #|line 439|#
                            ))
                          (let ((from_sender (Sender    fromname  from_component (cdr (assoc ' port  message))          #|line 440|#)))#|line 441|#
                              (loop for connector in (cdr (assoc ' connections  container))
                                do                                                                                      #|line 442|#
                                    (cond
                                      ((sender_eq    from_sender (cdr (assoc ' sender  connector)) )                    #|line 443|#
                                            (deposit    container  connector  message                                   #|line 444|#)
                                              (setf  was_sent  t)
                                        ))
                                ))                                                                                      #|line 445|#
                    ))
                  (cond
                    ((not  was_sent)                                                                                    #|line 446|#
                          (print    "\n\n*** Error: ***"                                                                #|line 447|#)
                            (dump_possible_connections    container                                                     #|line 448|#)
                              (print_routing_trace    container                                                         #|line 449|#)
                                (print    "***"                                                                         #|line 450|#)
                                  (print    (concatenate 'string (cdr (assoc ' name  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor..."))))) #|line 451|#)
                                    (print    "***"                                                                     #|line 452|#)
                                      (exit  )                                                                          #|line 453|#
                      ))))                                                                                              #|line 454|#
  )
(defun dump_possible_connections (&optional  container)
  (declare (ignorable  container))                                                                                      #|line 456|#
      (print    (concatenate 'string  "*** possible connections for "  (concatenate 'string (cdr (assoc ' name  container))  ":")) #|line 457|#)
        (loop for connector in (cdr (assoc ' connections  container))
          do                                                                                                            #|line 458|#
              (print    (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  " "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  sender))  connector))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc '(cdr (assoc ' port  sender))  connector))  (concatenate 'string  " -> "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  receiver))  connector))  (concatenate 'string  "." (cdr (assoc '(cdr (assoc ' port  receiver))  connector)))))))))) )#|line 459|#
          )                                                                                                             #|line 460|#
  )
(defun any_child_ready (&optional  container)
  (declare (ignorable  container))                                                                                      #|line 462|#
      (loop for child in (cdr (assoc ' children  container))
        do                                                                                                              #|line 463|#
            (cond
              ((child_is_ready    child )                                                                               #|line 464|#
                    (return-from any_child_ready  t)
                ))                                                                                                      #|line 465|#
        )
        (return-from any_child_ready  nil)                                                                              #|line 466|##|line 467|#
  )
(defun child_is_ready (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 469|#
      (return-from child_is_ready ( or  ( or  ( or  (not (cdr (assoc '(cdr (assoc '(empty  )  outq))  eh))) (not (cdr (assoc '(cdr (assoc '(empty  )  inq))  eh)))) (not (equal  (cdr (assoc ' state  eh))  "idle"))) (any_child_ready    eh )))#|line 470|##|line 471|#
  )
(defun print_routing_trace (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 473|#
      (print   (routing_trace_all    eh )                                                                               #|line 474|#)#|line 475|#
  )
(defun append_routing_descriptor (&optional  container  desc)
  (declare (ignorable  container  desc))                                                                                #|line 477|#
      (cdr (assoc '(cdr (assoc '(put    desc                                                                            #|line 478|#)  routings))  container))#|line 479|#
  )
(defun container_injector (&optional  container  message)
  (declare (ignorable  container  message))                                                                             #|line 481|#
      (container_handler    container  message                                                                          #|line 482|#)#|line 483|#
  )





