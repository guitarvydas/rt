
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






(ql:quickload :cl-json)
                                                                                                                        #|line 4|##|line 5|#
(defun Component_Registry (&optional )                                                                                  #|line 6|#
  (list
    (cons 'templates  nil)                                                                                              #|line 7|#)#|line 8|#)
                                                                                                                        #|line 9|#
(defun Template (&optional  name  template_data  instantiator)                                                          #|line 10|#
  (list
    (cons 'name  name)                                                                                                  #|line 11|#
    (cons 'template_data  template_data)                                                                                #|line 12|#
    (cons 'instantiator  instantiator)                                                                                  #|line 13|#)#|line 14|#)
                                                                                                                        #|line 15|#
(defun read_and_convert_json_file (&optional  filename)
  (declare (ignorable  filename))                                                                                       #|line 16|#
      ;; read json from a named file and convert it into internal form (a tree of routings)
      ;; return the routings from the function or raise an error
      (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
        (json:decode-json json-stream))
                                                                                                                        #|line 17|##|line 18|#
  )
(defun json2internal (&optional  container_xml)
  (declare (ignorable  container_xml))                                                                                  #|line 20|#
      (let ((fname (cdr (assoc '(cdr (assoc '(basename    container_xml                                                 #|line 21|#)  path))  os))))
          (let ((routings (read_and_convert_json_file    fname                                                          #|line 22|#)))
              (return-from json2internal  routings)                                                                     #|line 23|#))#|line 24|#
  )
(defun delete_decls (&optional  d)
  (declare (ignorable  d))                                                                                              #|line 26|#
      #| pass |#                                                                                                        #|line 27|##|line 28|#
  )
(defun make_component_registry (&optional )
  (declare (ignorable ))                                                                                                #|line 30|#
      (return-from make_component_registry (Component_Registry  ))                                                      #|line 31|##|line 32|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
      (return-from register_component (abstracted_register_component    reg  template  nil ))                           #|line 34|#
  )
(defun register_component_allow_overwriting (&optional  reg  template)
  (declare (ignorable  reg  template))
      (return-from register_component_allow_overwriting (abstracted_register_component    reg  template  t ))           #|line 35|#
  )
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)
  (declare (ignorable  reg  template  ok_to_overwrite))                                                                 #|line 37|#
      (let ((name (mangle_name   (cdr (assoc ' name  template))                                                         #|line 38|#)))
          (cond
            (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                 #|line 39|#
                  (load_error    (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 40|#
              ))
            (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                 #|line 41|#
              (return-from abstracted_register_component  reg)                                                          #|line 42|#)#|line 43|#
  )
(defun register_multiple_components (&optional  reg  templates)
  (declare (ignorable  reg  templates))                                                                                 #|line 45|#
      (loop for template in  templates
        do                                                                                                              #|line 46|#
            (register_component    reg  template )                                                                      #|line 47|#
        )                                                                                                               #|line 48|#
  )
(defun get_component_instance (&optional  reg  full_name  owner)
  (declare (ignorable  reg  full_name  owner))                                                                          #|line 50|#
      (let ((template_name (mangle_name    full_name                                                                    #|line 51|#)))
          (cond
            (( in   template_name (cdr (assoc ' templates  reg)))                                                       #|line 52|#
                  (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))                                 #|line 53|#
                      (cond
                        (( equal    template  nil)                                                                      #|line 54|#
                              (load_error    (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 55|#)
                                (return-from get_component_instance  nil)                                               #|line 56|#
                          )
                        (t                                                                                              #|line 57|#
                              (let ((owner_name  ""))                                                                   #|line 58|#
                                  (let ((instance_name  template_name))                                                 #|line 59|#
                                      (cond
                                        ((not (equal   nil  owner))                                                     #|line 60|#
                                              (setf  owner_name (cdr (assoc ' name  owner)))                            #|line 61|#
                                                (setf  instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name)))#|line 62|#
                                          )
                                        (t                                                                              #|line 63|#
                                              (setf  instance_name  template_name)                                      #|line 64|#
                                          ))
                                        (let ((instance (cdr (assoc '(instantiator    reg  owner  instance_name (cdr (assoc ' template_data  template)) #|line 65|#)  template))))
                                            (setf (cdr (assoc ' depth  instance)) (calculate_depth    instance          #|line 66|#))
                                              (return-from get_component_instance  instance))))
                          )))                                                                                           #|line 67|#
              )
            (t                                                                                                          #|line 68|#
                  (load_error    (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 69|#)
                    (return-from get_component_instance  nil)                                                           #|line 70|#
              )))                                                                                                       #|line 71|#
  )
(defun calculate_depth (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 72|#
      (cond
        (( equal   (cdr (assoc ' owner  eh))  nil)                                                                      #|line 73|#
              (return-from calculate_depth  0)                                                                          #|line 74|#
          )
        (t                                                                                                              #|line 75|#
              (return-from calculate_depth (+  1 (calculate_depth   (cdr (assoc ' owner  eh)) )))                       #|line 76|#
          ))                                                                                                            #|line 77|#
  )
(defun dump_registry (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 79|#
      (nl  )                                                                                                            #|line 80|#
        (print    "*** PALETTE ***"                                                                                     #|line 81|#)
          (loop for c in (cdr (assoc ' templates  reg))
            do                                                                                                          #|line 82|#
                (print   (cdr (assoc ' name  c)) )                                                                      #|line 83|#
            )
            (print    "***************"                                                                                 #|line 84|#)
              (nl  )                                                                                                    #|line 85|##|line 86|#
  )
(defun print_stats (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 88|#
      (print    (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg)))                               #|line 89|#)#|line 90|#
  )
(defun mangle_name (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 92|#
      #|  trim name to remove code from Container component names _ deferred until later (or never) |#                  #|line 93|#
        (return-from mangle_name  s)                                                                                    #|line 94|##|line 95|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                                                                            #|line 98|#
      #|  [ |#                                                                                                          #|line 99|#
        #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 100|#
          #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                      #|line 101|#
            #|  ] |#                                                                                                    #|line 102|#
              (cond
                ((not (equal   nil  container_list))                                                                    #|line 103|#
                      (loop for diagram in  container_list
                        do                                                                                              #|line 104|#
                            #|  loop through every component in the diagram and look for names that start with “$“ |#   #|line 105|#
                              #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 106|#
                                (loop for child_descriptor in (cdr (assoc 'children  diagram))
                                  do                                                                                    #|line 107|#
                                      (cond
                                        ((first_char_is   (cdr (assoc 'name  child_descriptor))  "$" )                  #|line 108|#
                                              (let ((name (cdr (assoc 'name  child_descriptor))))                       #|line 109|#
                                                  (let ((cmd (cdr (assoc '(strip  )  (subseq  name 1)))))               #|line 110|#
                                                      (let ((generated_leaf (Template    name  shell_out_instantiate  cmd #|line 111|#)))
                                                          (register_component    reg  generated_leaf                    #|line 112|#))))
                                          )
                                        ((first_char_is   (cdr (assoc 'name  child_descriptor))  "'" )                  #|line 113|#
                                              (let ((name (cdr (assoc 'name  child_descriptor))))                       #|line 114|#
                                                  (let ((s  (subseq  name 1)))                                          #|line 115|#
                                                      (let ((generated_leaf (Template    name  string_constant_instantiate  s #|line 116|#)))
                                                          (register_component_allow_overwriting    reg  generated_leaf  #|line 117|#))))#|line 118|#
                                          ))                                                                            #|line 119|#
                                  )                                                                                     #|line 120|#
                        )                                                                                               #|line 121|#
                  ))                                                                                                    #|line 122|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 124|#
      (return-from first_char  (car  s))                                                                                #|line 125|##|line 126|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                                                                                           #|line 128|#
      (return-from first_char_is ( equal    c (first_char    s                                                          #|line 129|#)))#|line 130|#
  )#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 132|##|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 133|#
(defun run_command (&optional  eh  cmd  s)
  (declare (ignorable  eh  cmd  s))                                                                                     #|line 134|#
      #|  capture_output ∷ ⊤ |#                                                                                         #|line 135|#
        (let ((ret (cdr (assoc '(run    cmd  s  "UTF_8"                                                                 #|line 136|#)  subprocess))))
            (cond
              ((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                      #|line 137|#
                    (cond
                      ((not (equal  (cdr (assoc ' stderr  ret))  nil))                                                  #|line 138|#
                            (return-from run_command (values  "" (cdr (assoc ' stderr  ret))))                          #|line 139|#
                        )
                      (t                                                                                                #|line 140|#
                            (return-from run_command (values  ""  (concatenate 'string  "error in shell_out " (cdr (assoc ' returncode  ret)))))
                        ))                                                                                              #|line 141|#
                )
              (t                                                                                                        #|line 142|#
                    (return-from run_command (values (cdr (assoc ' stdout  ret))  nil))                                 #|line 143|#
                )))                                                                                                     #|line 144|#
  )#|  Data for an asyncronous component _ effectively, a function with input |#                                        #|line 146|##|  and output queues of messages. |##|line 147|##|  |##|line 148|##|  Components can either be a user_supplied function (“lea“), or a “container“ |##|line 149|##|  that routes messages to child components according to a list of connections |##|line 150|##|  that serve as a message routing table. |##|line 151|##|  |##|line 152|##|  Child components themselves can be leaves or other containers. |##|line 153|##|  |##|line 154|##|  `handler` invokes the code that is attached to this component. |##|line 155|##|  |##|line 156|##|  `instance_data` is a pointer to instance data that the `leaf_handler` |##|line 157|##|  function may want whenever it is invoked again. |##|line 158|##|  |##|line 159|##|line 160|##|line 163|##|line 164|##|  Eh_States :: enum { idle, active } |##|line 165|#
(defun Eh (&optional )                                                                                                  #|line 166|#
  (list
    (cons 'name  "")                                                                                                    #|line 167|#
    (cons 'inq (cdr (assoc '(Queue  )  queue)))                                                                         #|line 168|#
    (cons 'outq (cdr (assoc '(Queue  )  queue)))                                                                        #|line 169|#
    (cons 'owner  nil)                                                                                                  #|line 170|#
    (cons 'saved_messages (cdr (assoc '(LifoQueue  )  queue))) #|  stack of saved message(s) |#                         #|line 171|#
    (cons 'inject  injector_NIY)                                                                                        #|line 172|#
    (cons 'children  nil)                                                                                               #|line 173|#
    (cons 'visit_ordering (cdr (assoc '(Queue  )  queue)))                                                              #|line 174|#
    (cons 'connections  nil)                                                                                            #|line 175|#
    (cons 'routings (cdr (assoc '(Queue  )  queue)))                                                                    #|line 176|#
    (cons 'handler  nil)                                                                                                #|line 177|#
    (cons 'instance_data  nil)                                                                                          #|line 178|#
    (cons 'state  "idle")                                                                                               #|line 179|##|  bootstrap debugging |##|line 180|#
    (cons 'kind  nil) #|  enum { container, leaf, } |#                                                                  #|line 181|#
    (cons 'trace  nil) #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |##|line 182|#
    (cons 'depth  0) #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |##|line 183|#)#|line 184|#)
                                                                                                                        #|line 185|##|  Creates a component that acts as a container. It is the same as a `Eh` instance |##|line 186|##|  whose handler function is `container_handler`. |##|line 187|#
(defun make_container (&optional  name  owner)
  (declare (ignorable  name  owner))                                                                                    #|line 188|#
      (let ((eh (Eh  )))                                                                                                #|line 189|#
          (setf (cdr (assoc ' name  eh))  name)                                                                         #|line 190|#
            (setf (cdr (assoc ' owner  eh))  owner)                                                                     #|line 191|#
              (setf (cdr (assoc ' handler  eh))  container_handler)                                                     #|line 192|#
                (setf (cdr (assoc ' inject  eh))  container_injector)                                                   #|line 193|#
                  (setf (cdr (assoc ' state  eh))  "idle")                                                              #|line 194|#
                    (setf (cdr (assoc ' kind  eh))  "container")                                                        #|line 195|#
                      (return-from make_container  eh)                                                                  #|line 196|#)#|line 197|#
  )#|  Creates a new leaf component out of a handler function, and a data parameter |#                                  #|line 199|##|  that will be passed back to your handler when called. |##|line 200|##|line 201|#
(defun make_leaf (&optional  name  owner  instance_data  handler)
  (declare (ignorable  name  owner  instance_data  handler))                                                            #|line 202|#
      (let ((eh (Eh  )))                                                                                                #|line 203|#
          (setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)))#|line 204|#
            (setf (cdr (assoc ' owner  eh))  owner)                                                                     #|line 205|#
              (setf (cdr (assoc ' handler  eh))  handler)                                                               #|line 206|#
                (setf (cdr (assoc ' instance_data  eh))  instance_data)                                                 #|line 207|#
                  (setf (cdr (assoc ' state  eh))  "idle")                                                              #|line 208|#
                    (setf (cdr (assoc ' kind  eh))  "leaf")                                                             #|line 209|#
                      (return-from make_leaf  eh)                                                                       #|line 210|#)#|line 211|#
  )#|  Sends a message on the given `port` with `data`, placing it on the output |#                                     #|line 213|##|  of the given component. |##|line 214|##|line 215|#
(defun send (&optional  eh  port  datum  causingMessage)
  (declare (ignorable  eh  port  datum  causingMessage))                                                                #|line 216|#
      (let ((msg (make_message    port  datum                                                                           #|line 217|#)))
          (put_output    eh  msg                                                                                        #|line 218|#))#|line 219|#
  )
(defun send_string (&optional  eh  port  s  causingMessage)
  (declare (ignorable  eh  port  s  causingMessage))                                                                    #|line 221|#
      (let ((datum (new_datum_string    s                                                                               #|line 222|#)))
          (let ((msg (make_message    port  datum                                                                       #|line 223|#)))
              (put_output    eh  msg                                                                                    #|line 224|#)))#|line 225|#
  )
(defun forward (&optional  eh  port  msg)
  (declare (ignorable  eh  port  msg))                                                                                  #|line 227|#
      (let ((fwdmsg (make_message    port (cdr (assoc ' datum  msg))                                                    #|line 228|#)))
          (put_output    eh  msg                                                                                        #|line 229|#))#|line 230|#
  )
(defun inject (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 232|#
      (cdr (assoc '(inject    eh  msg                                                                                   #|line 233|#)  eh))#|line 234|#
  )#|  Returns a list of all output messages on a container. |#                                                         #|line 236|##|  For testing / debugging purposes. |##|line 237|##|line 238|#
(defun output_list (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 239|#
      (return-from output_list (cdr (assoc ' outq  eh)))                                                                #|line 240|##|line 241|#
  )#|  Utility for printing an array of messages. |#                                                                    #|line 243|#
(defun print_output_list (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 244|#
      (loop for m in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
        do                                                                                                              #|line 245|#
            (print   (format_message    m ) )                                                                           #|line 246|#
        )                                                                                                               #|line 247|#
  )
(defun spaces (&optional  n)
  (declare (ignorable  n))                                                                                              #|line 249|#
      (let (( s  ""))                                                                                                   #|line 250|#
          (loop for i in (loop for n from 0 below  n by 1 collect n)
            do                                                                                                          #|line 251|#
                (setf  s (+  s  " "))                                                                                   #|line 252|#
            )
            (return-from spaces  s)                                                                                     #|line 253|#)#|line 254|#
  )
(defun set_active (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 256|#
      (setf (cdr (assoc ' state  eh))  "active")                                                                        #|line 257|##|line 258|#
  )
(defun set_idle (&optional  eh)
  (declare (ignorable  eh))                                                                                             #|line 260|#
      (setf (cdr (assoc ' state  eh))  "idle")                                                                          #|line 261|##|line 262|#
  )#|  Utility for printing a specific output message. |#                                                               #|line 264|##|line 265|#
(defun fetch_first_output (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 266|#
      (loop for msg in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
        do                                                                                                              #|line 267|#
            (cond
              (( equal   (cdr (assoc ' port  msg))  port)                                                               #|line 268|#
                    (return-from fetch_first_output (cdr (assoc ' datum  msg)))
                ))                                                                                                      #|line 269|#
        )
        (return-from fetch_first_output  nil)                                                                           #|line 270|##|line 271|#
  )
(defun print_specific_output (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 273|#
      #|  port ∷ “” |#                                                                                                  #|line 274|#
        (let (( datum (fetch_first_output    eh  port                                                                   #|line 275|#)))
            (let (( outf  nil))                                                                                         #|line 276|#
                (cond
                  ((not (equal   datum  nil))                                                                           #|line 277|#
                        (setf  outf (cdr (assoc ' stdout  sys)))                                                        #|line 278|#
                          (print   (cdr (assoc '(srepr  )  datum))  outf )                                              #|line 279|#
                    ))))                                                                                                #|line 280|#
  )
(defun print_specific_output_to_stderr (&optional  eh  port)
  (declare (ignorable  eh  port))                                                                                       #|line 281|#
      #|  port ∷ “” |#                                                                                                  #|line 282|#
        (let (( datum (fetch_first_output    eh  port                                                                   #|line 283|#)))
            (let (( outf  nil))                                                                                         #|line 284|#
                (cond
                  ((not (equal   datum  nil))                                                                           #|line 285|#
                        #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |##|line 286|#
                          (setf  outf (cdr (assoc ' stderr  sys)))                                                      #|line 287|#
                            (print   (cdr (assoc '(srepr  )  datum))  outf )                                            #|line 288|#
                    ))))                                                                                                #|line 289|#
  )
(defun put_output (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 291|#
      (cdr (assoc '(cdr (assoc '(put    msg                                                                             #|line 292|#)  outq))  eh))#|line 293|#
  )
(defun injector_NIY (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 295|#
      #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#    #|line 296|#
        (print    (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))) #|line 301|#)
          (exit  )                                                                                                      #|line 302|##|line 303|#
  )                                                                                                                     #|line 309|#
(defparameter  root_project  "")                                                                                        #|line 310|#
(defparameter  root_0D  "")                                                                                             #|line 311|##|line 312|#
(defun set_environment (&optional  rproject  r0D)
  (declare (ignorable  rproject  r0D))                                                                                  #|line 313|##|line 314|##|line 315|#
          (setf  root_project  rproject)                                                                                #|line 316|#
            (setf  root_0D  r0D)                                                                                        #|line 317|##|line 318|#
  )
(defun probe_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 320|#
      (let ((name_with_id (gensymbol    "?"                                                                             #|line 321|#)))
          (return-from probe_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                          #|line 322|#)))#|line 323|#
  )
(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 324|#
      (let ((name_with_id (gensymbol    "?A"                                                                            #|line 325|#)))
          (return-from probeA_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                         #|line 326|#)))#|line 327|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 329|#
      (let ((name_with_id (gensymbol    "?B"                                                                            #|line 330|#)))
          (return-from probeB_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                         #|line 331|#)))#|line 332|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 334|#
      (let ((name_with_id (gensymbol    "?C"                                                                            #|line 335|#)))
          (return-from probeC_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                         #|line 336|#)))#|line 337|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 339|#
      (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                    #|line 340|#
          (print    (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))) (cdr (assoc ' stderr  sys)) #|line 341|#))#|line 342|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 344|#
      (let ((name_with_id (gensymbol    "trash"                                                                         #|line 345|#)))
          (return-from trash_instantiate (make_leaf    name_with_id  owner  nil  trash_handler                          #|line 346|#)))#|line 347|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 349|#
      #|  to appease dumped_on_floor checker |#                                                                         #|line 350|#
        #| pass |#                                                                                                      #|line 351|##|line 352|#
  )
(defun TwoMessages (&optional  first  second)                                                                           #|line 353|#
  (list
    (cons 'first  first)                                                                                                #|line 354|#
    (cons 'second  second)                                                                                              #|line 355|#)#|line 356|#)
                                                                                                                        #|line 357|##|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |##|line 358|#
(defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 359|#
  (list
    (cons 'state  state)                                                                                                #|line 360|#
    (cons 'buffer  buffer)                                                                                              #|line 361|#)#|line 362|#)
                                                                                                                        #|line 363|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                                                                                           #|line 364|#
      #| pass |#                                                                                                        #|line 365|##|line 366|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 368|#
      (let ((name_with_id (gensymbol    "deracer"                                                                       #|line 369|#)))
          (let ((inst (Deracer_Instance_Data    "idle" (TwoMessages    nil  nil )                                       #|line 370|#)))
              (setf (cdr (assoc ' state  inst))  "idle")                                                                #|line 371|#
                (let ((eh (make_leaf    name_with_id  owner  inst  deracer_handler                                      #|line 372|#)))
                    (return-from deracer_instantiate  eh)                                                               #|line 373|#)))#|line 374|#
  )
(defun send_first_then_second (&optional  eh  inst)
  (declare (ignorable  eh  inst))                                                                                       #|line 376|#
      (forward    eh  "1" (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                            #|line 377|#)
        (forward    eh  "2" (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                         #|line 378|#)
          (reclaim_Buffers_from_heap    inst                                                                            #|line 379|#)#|line 380|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 382|#
      (let (( inst (cdr (assoc ' instance_data  eh))))                                                                  #|line 383|#
          (cond
            (( equal   (cdr (assoc ' state  inst))  "idle")                                                             #|line 384|#
                  (cond
                    (( equal    "1" (cdr (assoc ' port  msg)))                                                          #|line 385|#
                          (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                #|line 386|#
                            (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                      #|line 387|#
                      )
                    (( equal    "2" (cdr (assoc ' port  msg)))                                                          #|line 388|#
                          (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                               #|line 389|#
                            (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                       #|line 390|#
                      )
                    (t                                                                                                  #|line 391|#
                          (runtime_error    (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
                      ))                                                                                                #|line 392|#
              )
            (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                  #|line 393|#
                  (cond
                    (( equal    "1" (cdr (assoc ' port  msg)))                                                          #|line 394|#
                          (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                #|line 395|#
                            (send_first_then_second    eh  inst                                                         #|line 396|#)
                              (setf (cdr (assoc ' state  inst))  "idle")                                                #|line 397|#
                      )
                    (t                                                                                                  #|line 398|#
                          (runtime_error    (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
                      ))                                                                                                #|line 399|#
              )
            (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                 #|line 400|#
                  (cond
                    (( equal    "2" (cdr (assoc ' port  msg)))                                                          #|line 401|#
                          (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                               #|line 402|#
                            (send_first_then_second    eh  inst                                                         #|line 403|#)
                              (setf (cdr (assoc ' state  inst))  "idle")                                                #|line 404|#
                      )
                    (t                                                                                                  #|line 405|#
                          (runtime_error    (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
                      ))                                                                                                #|line 406|#
              )
            (t                                                                                                          #|line 407|#
                  (runtime_error    "bad state for deracer {eh.state}" )                                                #|line 408|#
              )))                                                                                                       #|line 409|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 411|#
      (let ((name_with_id (gensymbol    "Low Level Read Text File"                                                      #|line 412|#)))
          (return-from low_level_read_text_file_instantiate (make_leaf    name_with_id  owner  nil  low_level_read_text_file_handler #|line 413|#)))#|line 414|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 416|#
      (let ((fname (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                #|line 417|#
          ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
          ;; given eh and msg if needed
          (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
            (with-open-file (stream fname)
              (let ((contents (make-string (file-length stream))))
                (read-sequence contents stream)
                (send_string eh "" contents))))
                                                                                                                        #|line 418|#)#|line 419|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 421|#
      (let ((name_with_id (gensymbol    "Ensure String Datum"                                                           #|line 422|#)))
          (return-from ensure_string_datum_instantiate (make_leaf    name_with_id  owner  nil  ensure_string_datum_handler #|line 423|#)))#|line 424|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 426|#
      (cond
        (( equal    "string" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg)))                                        #|line 427|#
              (forward    eh  ""  msg )                                                                                 #|line 428|#
          )
        (t                                                                                                              #|line 429|#
              (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))))#|line 430|#
                  (send_string    eh  "✗"  emsg  msg ))                                                                 #|line 431|#
          ))                                                                                                            #|line 432|#
  )
(defun Syncfilewrite_Data (&optional )                                                                                  #|line 434|#
  (list
    (cons 'filename  "")                                                                                                #|line 435|#)#|line 436|#)
                                                                                                                        #|line 437|##|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |##|line 438|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 439|#
      (let ((name_with_id (gensymbol    "syncfilewrite"                                                                 #|line 440|#)))
          (let ((inst (Syncfilewrite_Data  )))                                                                          #|line 441|#
              (return-from syncfilewrite_instantiate (make_leaf    name_with_id  owner  inst  syncfilewrite_handler     #|line 442|#))))#|line 443|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 445|#
      (let (( inst (cdr (assoc ' instance_data  eh))))                                                                  #|line 446|#
          (cond
            (( equal    "filename" (cdr (assoc ' port  msg)))                                                           #|line 447|#
                  (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)))             #|line 448|#
              )
            (( equal    "input" (cdr (assoc ' port  msg)))                                                              #|line 449|#
                  (let ((contents (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                 #|line 450|#
                      (let (( f (open   (cdr (assoc ' filename  inst))  "w"                                             #|line 451|#)))
                          (cond
                            ((not (equal   f  nil))                                                                     #|line 452|#
                                  (cdr (assoc '(write   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))             #|line 453|#)  f))
                                    (cdr (assoc '(close  )  f))                                                         #|line 454|#
                                      (send    eh  "done" (new_datum_bang  )  msg )                                     #|line 455|#
                              )
                            (t                                                                                          #|line 456|#
                                  (send_string    eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))  msg )
                              ))))                                                                                      #|line 457|#
              )))                                                                                                       #|line 458|#
  )
(defun StringConcat_Instance_Data (&optional )                                                                          #|line 460|#
  (list
    (cons 'buffer1  nil)                                                                                                #|line 461|#
    (cons 'buffer2  nil)                                                                                                #|line 462|#
    (cons 'count  0)                                                                                                    #|line 463|#)#|line 464|#)
                                                                                                                        #|line 465|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 466|#
      (let ((name_with_id (gensymbol    "stringconcat"                                                                  #|line 467|#)))
          (let ((instp (StringConcat_Instance_Data  )))                                                                 #|line 468|#
              (return-from stringconcat_instantiate (make_leaf    name_with_id  owner  instp  stringconcat_handler      #|line 469|#))))#|line 470|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 472|#
      (let (( inst (cdr (assoc ' instance_data  eh))))                                                                  #|line 473|#
          (cond
            (( equal    "1" (cdr (assoc ' port  msg)))                                                                  #|line 474|#
                  (setf (cdr (assoc ' buffer1  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 475|#))
                    (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                               #|line 476|#
                      (maybe_stringconcat    eh  inst  msg )                                                            #|line 477|#
              )
            (( equal    "2" (cdr (assoc ' port  msg)))                                                                  #|line 478|#
                  (setf (cdr (assoc ' buffer2  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 479|#))
                    (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                               #|line 480|#
                      (maybe_stringconcat    eh  inst  msg )                                                            #|line 481|#
              )
            (t                                                                                                          #|line 482|#
                  (runtime_error    (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))  #|line 483|#)#|line 484|#
              )))                                                                                                       #|line 485|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                                                                                  #|line 487|#
      (cond
        (( and  ( equal    0 (len   (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len   (cdr (assoc ' buffer2  inst)) )))#|line 488|#
              (runtime_error    "something is wrong in stringconcat, both strings are 0 length" )                       #|line 489|#
          ))
        (cond
          (( >=  (cdr (assoc ' count  inst))  2)                                                                        #|line 490|#
                (let (( concatenated_string  ""))                                                                       #|line 491|#
                    (cond
                      (( equal    0 (len   (cdr (assoc ' buffer1  inst)) ))                                             #|line 492|#
                            (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                   #|line 493|#
                        )
                      (( equal    0 (len   (cdr (assoc ' buffer2  inst)) ))                                             #|line 494|#
                            (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                   #|line 495|#
                        )
                      (t                                                                                                #|line 496|#
                            (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst)))) #|line 497|#
                        ))
                      (send_string    eh  ""  concatenated_string  msg                                                  #|line 498|#)
                        (setf (cdr (assoc ' buffer1  inst))  nil)                                                       #|line 499|#
                          (setf (cdr (assoc ' buffer2  inst))  nil)                                                     #|line 500|#
                            (setf (cdr (assoc ' count  inst))  0))                                                      #|line 501|#
            ))                                                                                                          #|line 502|#
  )#|  |#                                                                                                               #|line 504|##|line 505|##|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 506|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 507|#
      (let ((name_with_id (gensymbol    "shell_out"                                                                     #|line 508|#)))
          (let ((cmd (cdr (assoc '(split    template_data                                                               #|line 509|#)  shlex))))
              (return-from shell_out_instantiate (make_leaf    name_with_id  owner  cmd  shell_out_handler              #|line 510|#))))#|line 511|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 513|#
      (let ((cmd (cdr (assoc ' instance_data  eh))))                                                                    #|line 514|#
          (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                #|line 515|#
              (multiple-value-setq ( stdout  stderr) (run_command    eh  cmd  s                                         #|line 516|#))
                (cond
                  ((not (equal   stderr  nil))                                                                          #|line 517|#
                        (send_string    eh  "✗"  stderr  msg )                                                          #|line 518|#
                    )
                  (t                                                                                                    #|line 519|#
                        (send_string    eh  ""  stdout  msg )                                                           #|line 520|#
                    ))))                                                                                                #|line 521|#
  )
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 523|##|line 524|##|line 525|#
          (let ((name_with_id (gensymbol    "strconst"                                                                  #|line 526|#)))
              (let (( s  template_data))                                                                                #|line 527|#
                  (cond
                    ((not (equal   root_project  ""))                                                                   #|line 528|#
                          (setf  s (cdr (assoc '(sub    "_00_"  root_project  s )  re)))                                #|line 529|#
                      ))
                    (cond
                      ((not (equal   root_0D  ""))                                                                      #|line 530|#
                            (setf  s (cdr (assoc '(sub    "_0D_"  root_0D  s )  re)))                                   #|line 531|#
                        ))
                      (return-from string_constant_instantiate (make_leaf    name_with_id  owner  s  string_constant_handler #|line 532|#))))#|line 533|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 535|#
      (let ((s (cdr (assoc ' instance_data  eh))))                                                                      #|line 536|#
          (send_string    eh  ""  s  msg                                                                                #|line 537|#))#|line 538|#
  )
(defun string_make_persistent (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 540|#
      #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                    #|line 541|#
        (return-from string_make_persistent  s)                                                                         #|line 542|##|line 543|#
  )
(defun string_clone (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 545|#
      (return-from string_clone  s)                                                                                     #|line 546|##|line 547|#
  )                                                                                                                     #|line 550|##|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |##|line 551|##|  where ${_00_} is the root directory for the project |##|line 552|##|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |##|line 553|##|line 554|##|line 555|##|line 556|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)
  (declare (ignorable  root_project  root_0D  diagram_source_files))                                                    #|line 557|#
      (let ((reg (make_component_registry  )))                                                                          #|line 558|#
          (loop for diagram_source in  diagram_source_files
            do                                                                                                          #|line 559|#
                (let ((all_containers_within_single_file (json2internal    diagram_source                               #|line 560|#)))
                    (generate_shell_components    reg  all_containers_within_single_file                                #|line 561|#)
                      (loop for container in  all_containers_within_single_file
                        do                                                                                              #|line 562|#
                            (register_component    reg (Template   (cdr (assoc 'name  container)) #|  template_data =  |# container #|  instantiator =  |# container_instantiator ) )
                        ))                                                                                              #|line 563|#
            )
            (initialize_stock_components    reg                                                                         #|line 564|#)
              (return-from initialize_component_palette  reg)                                                           #|line 565|#)#|line 566|#
  )
(defun print_error_maybe (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 568|#
      (let ((error_port  "✗"))                                                                                          #|line 569|#
          (let ((err (fetch_first_output    main_container  error_port                                                  #|line 570|#)))
              (cond
                (( and  (not (equal   err  nil)) ( <   0 (len   (trimws   (cdr (assoc '(srepr  )  err)) ) )))           #|line 571|#
                      (print    "___ !!! ERRORS !!! ___"                                                                #|line 572|#)
                        (print_specific_output    main_container  error_port  nil )                                     #|line 573|#
                  ))))                                                                                                  #|line 574|#
  )#|  debugging helpers |#                                                                                             #|line 576|##|line 577|#
(defun nl (&optional )
  (declare (ignorable ))                                                                                                #|line 578|#
      (print    ""                                                                                                      #|line 579|#)#|line 580|#
  )
(defun dump_outputs (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 582|#
      (nl  )                                                                                                            #|line 583|#
        (print    "___ Outputs ___"                                                                                     #|line 584|#)
          (print_output_list    main_container                                                                          #|line 585|#)#|line 586|#
  )
(defun trace_outputs (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 588|#
      (nl  )                                                                                                            #|line 589|#
        (print    "___ Message Traces ___"                                                                              #|line 590|#)
          (print_routing_trace    main_container                                                                        #|line 591|#)#|line 592|#
  )
(defun dump_hierarchy (&optional  main_container)
  (declare (ignorable  main_container))                                                                                 #|line 594|#
      (nl  )                                                                                                            #|line 595|#
        (print    (concatenate 'string  "___ Hierarchy ___" (build_hierarchy    main_container ))                       #|line 596|#)#|line 597|#
  )
(defun build_hierarchy (&optional  c)
  (declare (ignorable  c))                                                                                              #|line 599|#
      (let (( s  ""))                                                                                                   #|line 600|#
          (loop for child in (cdr (assoc ' children  c))
            do                                                                                                          #|line 601|#
                (setf  s  (concatenate 'string  s (build_hierarchy    child )))                                         #|line 602|#
            )
            (let (( indent  ""))                                                                                        #|line 603|#
                (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
                  do                                                                                                    #|line 604|#
                      (setf  indent (+  indent  "  "))                                                                  #|line 605|#
                  )
                  (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")"))))))#|line 606|#))#|line 607|#
  )
(defun dump_connections (&optional  c)
  (declare (ignorable  c))                                                                                              #|line 609|#
      (nl  )                                                                                                            #|line 610|#
        (print    "___ connections ___"                                                                                 #|line 611|#)
          (dump_possible_connections    c                                                                               #|line 612|#)
            (loop for child in (cdr (assoc ' children  c))
              do                                                                                                        #|line 613|#
                  (nl  )                                                                                                #|line 614|#
                    (dump_possible_connections    child )                                                               #|line 615|#
              )                                                                                                         #|line 616|#
  )
(defun trimws (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 618|#
      #|  remove whitespace from front and back of string |#                                                            #|line 619|#
        (return-from trimws (cdr (assoc '(strip  )  s)))                                                                #|line 620|##|line 621|#
  )
(defun clone_string (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 623|#
      (return-from clone_string  s                                                                                      #|line 624|##|line 625|#)#|line 626|#
  )
(defparameter  load_errors  nil)                                                                                        #|line 627|#
(defparameter  runtime_errors  nil)                                                                                     #|line 628|##|line 629|#
(defun load_error (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 630|##|line 631|#
        (print    s                                                                                                     #|line 632|#)
          (quit  )                                                                                                      #|line 633|#
            (setf  load_errors  t)                                                                                      #|line 634|##|line 635|#
  )
(defun runtime_error (&optional  s)
  (declare (ignorable  s))                                                                                              #|line 637|##|line 638|#
        (print    s                                                                                                     #|line 639|#)
          (quit  )                                                                                                      #|line 640|#
            (setf  runtime_errors  t)                                                                                   #|line 641|##|line 642|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))                                                                #|line 644|#
      (let ((instance_name (gensymbol    "fakepipe"                                                                     #|line 645|#)))
          (return-from fakepipename_instantiate (make_leaf    instance_name  owner  nil  fakepipename_handler           #|line 646|#)))#|line 647|#
  )
(defparameter  rand  0)                                                                                                 #|line 649|##|line 650|#
(defun fakepipename_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                                                                                        #|line 651|##|line 652|#
        (setf  rand (+  rand  1))
          #|  not very random, but good enough _ 'rand' must be unique within a single run |#                           #|line 653|#
            (send_string    eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg                                   #|line 654|#)#|line 655|#
  )                                                                                                                     #|line 657|##|  all of the the built_in leaves are listed here |##|line 658|##|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 659|##|line 660|##|line 661|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                                                                            #|line 662|#
      (register_component    reg (Template    "1then2"  nil  deracer_instantiate )                                      #|line 663|#)
        (register_component    reg (Template    "?"  nil  probe_instantiate )                                           #|line 664|#)
          (register_component    reg (Template    "?A"  nil  probeA_instantiate )                                       #|line 665|#)
            (register_component    reg (Template    "?B"  nil  probeB_instantiate )                                     #|line 666|#)
              (register_component    reg (Template    "?C"  nil  probeC_instantiate )                                   #|line 667|#)
                (register_component    reg (Template    "trash"  nil  trash_instantiate )                               #|line 668|#)#|line 669|#
                  (register_component    reg (Template    "Low Level Read Text File"  nil  low_level_read_text_file_instantiate ) #|line 670|#)
                    (register_component    reg (Template    "Ensure String Datum"  nil  ensure_string_datum_instantiate ) #|line 671|#)#|line 672|#
                      (register_component    reg (Template    "syncfilewrite"  nil  syncfilewrite_instantiate )         #|line 673|#)
                        (register_component    reg (Template    "stringconcat"  nil  stringconcat_instantiate )         #|line 674|#)
                          #|  for fakepipe |#                                                                           #|line 675|#
                            (register_component    reg (Template    "fakepipename"  nil  fakepipename_instantiate )     #|line 676|#)#|line 677|#
  )
(defun argv (&optional )
  (declare (ignorable ))                                                                                                #|line 679|#
      (error 'NIY)
                                                                                                                        #|line 680|##|line 681|#
  )
(defun initialize (&optional )
  (declare (ignorable ))                                                                                                #|line 683|#
      (let ((root_of_project  (nth  1 argv)))                                                                           #|line 684|#
          (let ((root_of_0D  (nth  2 argv)))                                                                            #|line 685|#
              (let ((arg  (nth  3 argv)))                                                                               #|line 686|#
                  (let ((main_container_name  (nth  4 argv)))                                                           #|line 687|#
                      (let ((diagram_names  (nthcdr  5 (argv))))                                                        #|line 688|#
                          (let ((palette (initialize_component_palette    root_project  root_0D  diagram_names          #|line 689|#)))
                              (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg )))#|line 690|#))))))#|line 691|#
  )
(defun start (&optional  palette  env)
  (declare (ignorable  palette  env))
      (start_with_debug    palette  env  nil  nil  nil  nil )                                                           #|line 693|#
  )
(defun start_with_debug (&optional  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs)
  (declare (ignorable  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs))                  #|line 694|#
      #|  show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥ |#                                    #|line 695|#
        (let ((root_of_project (nth  0  env)))                                                                          #|line 696|#
            (let ((root_of_0D (nth  1  env)))                                                                           #|line 697|#
                (let ((main_container_name (nth  2  env)))                                                              #|line 698|#
                    (let ((diagram_names (nth  3  env)))                                                                #|line 699|#
                        (let ((arg (nth  4  env)))                                                                      #|line 700|#
                            (set_environment    root_of_project  root_of_0D                                             #|line 701|#)
                              #|  get entrypoint container |#                                                           #|line 702|#
                                (let (( main_container (get_component_instance    palette  main_container_name  nil     #|line 703|#)))
                                    (cond
                                      (( equal    nil  main_container)                                                  #|line 704|#
                                            (load_error    (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)")))) #|line 708|#)#|line 709|#
                                        ))
                                      (cond
                                        ( show_hierarchy                                                                #|line 710|#
                                              (dump_hierarchy    main_container                                         #|line 711|#)#|line 712|#
                                          ))
                                        (cond
                                          ( show_connections                                                            #|line 713|#
                                                (dump_connections    main_container                                     #|line 714|#)#|line 715|#
                                            ))
                                          (cond
                                            ((not  load_errors)                                                         #|line 716|#
                                                  (let (( arg (new_datum_string    arg                                  #|line 717|#)))
                                                      (let (( msg (make_message    ""  arg                              #|line 718|#)))
                                                          (inject    main_container  msg                                #|line 719|#)
                                                            (cond
                                                              ( show_all_outputs                                        #|line 720|#
                                                                    (dump_outputs    main_container                     #|line 721|#)
                                                                )
                                                              (t                                                        #|line 722|#
                                                                    (print_error_maybe    main_container                #|line 723|#)
                                                                      (print_specific_output    main_container  ""      #|line 724|#)
                                                                        (cond
                                                                          ( show_traces                                 #|line 725|#
                                                                                (print    "--- routing traces ---"      #|line 726|#)
                                                                                  (print   (routing_trace_all    main_container ) #|line 727|#)#|line 728|#
                                                                            ))                                          #|line 729|#
                                                                ))
                                                              (cond
                                                                ( show_all_outputs                                      #|line 730|#
                                                                      (print    "--- done ---"                          #|line 731|#)#|line 732|#
                                                                  ))))                                                  #|line 733|#
                                              ))))))))                                                                  #|line 734|#
  )                                                                                                                     #|line 736|##|line 737|##|  utility functions  |##|line 738|#
(defun send_int (&optional  eh  port  i  causing_message)
  (declare (ignorable  eh  port  i  causing_message))                                                                   #|line 739|#
      (let ((datum (new_datum_int    i                                                                                  #|line 740|#)))
          (send    eh  port  datum  causing_message                                                                     #|line 741|#))#|line 742|#
  )
(defun send_bang (&optional  eh  port  causing_message)
  (declare (ignorable  eh  port  causing_message))                                                                      #|line 744|#
      (let ((datum (new_datum_bang  )))                                                                                 #|line 745|#
          (send    eh  port  datum  causing_message                                                                     #|line 746|#))#|line 747|#
  )





