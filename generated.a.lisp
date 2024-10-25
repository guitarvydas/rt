
(ql:quickload :cl-json)

(defparameter  counter  0)                                                                                              #|line 1|##|line 2|#
(defparameter  digits (list                                                                                             #|line 3|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" ))#|line 9|##|line 10|##|line 11|#
(defun gensymbol (&optional  s)                                                                                         #|line 12|##|line 13|#
      (let ((name_with_id  (concatenate 'string  s (subscripted_digit    counter ))))                                   #|line 14|#
          (setf  counter (+  counter  1))                                                                               #|line 15|#
            (return-from gensymbol  name_with_id)                                                                       #|line 16|#)#|line 17|#
)
(defun subscripted_digit (&optional  n)                                                                                 #|line 19|##|line 20|#
      (cond
        (( and  ( >=   n  0) ( <=   n  29))                                                                             #|line 21|#
              (return-from subscripted_digit (nth  n  digits))                                                          #|line 22|#
          )
        (t                                                                                                              #|line 23|#
              (return-from subscripted_digit  (concatenate 'string  "₊"  n))                                            #|line 24|##|line 25|#
          ))                                                                                                            #|line 26|#
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
(defun new_datum_string (&optional  s)                                                                                  #|line 37|#
    (let ((d  (Datum)))                                                                                                 #|line 38|#
        (setf (cdr (assoc ' data  d))  s)                                                                               #|line 39|#
          (setf (cdr (assoc ' clone  d))  #'(lambda (&optional )(clone_datum_string    d                                #|line 40|#)))
            (setf (cdr (assoc ' reclaim  d))  #'(lambda (&optional )(reclaim_datum_string    d                          #|line 41|#)))
              (setf (cdr (assoc ' srepr  d))  #'(lambda (&optional )(srepr_datum_string    d                            #|line 42|#)))
                (setf (cdr (assoc ' raw  d))  #'(lambda (&optional )(raw_datum_string    d                              #|line 43|#)))
                  (setf (cdr (assoc ' kind  d))  #'(lambda (&optional ) "string"))                                      #|line 44|#
                    (return-from new_datum_string  d)                                                                   #|line 45|#)#|line 46|#
)
(defun clone_datum_string (&optional  d)                                                                                #|line 48|#
    (let ((d (new_datum_string   (cdr (assoc ' data  d))                                                                #|line 49|#)))
        (return-from clone_datum_string  d)                                                                             #|line 50|#)#|line 51|#
)
(defun reclaim_datum_string (&optional  src)                                                                            #|line 53|#
    #| pass |#                                                                                                          #|line 54|##|line 55|#
)
(defun srepr_datum_string (&optional  d)                                                                                #|line 57|#
    (return-from srepr_datum_string (cdr (assoc ' data  d)))                                                            #|line 58|##|line 59|#
)
(defun raw_datum_string (&optional  d)                                                                                  #|line 61|#
    (return-from raw_datum_string (bytearray   (cdr (assoc ' data  d))  "UTF_8"                                         #|line 62|#))#|line 63|#
)
(defun new_datum_bang (&optional )                                                                                      #|line 65|#
    (let ((p (Datum  )))                                                                                                #|line 66|#
        (setf (cdr (assoc ' data  p))  t)                                                                               #|line 67|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bang    p                                  #|line 68|#)))
            (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bang    p                            #|line 69|#)))
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bang  )))                              #|line 70|#
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bang  )))                                #|line 71|#
                  (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bang"))                                        #|line 72|#
                    (return-from new_datum_bang  p)                                                                     #|line 73|#)#|line 74|#
)
(defun clone_datum_bang (&optional  d)                                                                                  #|line 76|#
    (return-from clone_datum_bang (new_datum_bang  ))                                                                   #|line 77|##|line 78|#
)
(defun reclaim_datum_bang (&optional  d)                                                                                #|line 80|#
    #| pass |#                                                                                                          #|line 81|##|line 82|#
)
(defun srepr_datum_bang (&optional )                                                                                    #|line 84|#
    (return-from srepr_datum_bang  "!")                                                                                 #|line 85|##|line 86|#
)
(defun raw_datum_bang (&optional )                                                                                      #|line 88|#
    (return-from raw_datum_bang  nil)                                                                                   #|line 89|##|line 90|#
)
(defun new_datum_tick (&optional )                                                                                      #|line 92|#
    (let ((p (new_datum_bang  )))                                                                                       #|line 93|#
        (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "tick"))                                                  #|line 94|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(new_datum_tick  )))                                    #|line 95|#
            (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_tick  )))                                #|line 96|#
              (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_tick  )))                                  #|line 97|#
                (return-from new_datum_tick  p)                                                                         #|line 98|#)#|line 99|#
)
(defun srepr_datum_tick (&optional )                                                                                    #|line 101|#
    (return-from srepr_datum_tick  ".")                                                                                 #|line 102|##|line 103|#
)
(defun raw_datum_tick (&optional )                                                                                      #|line 105|#
    (return-from raw_datum_tick  nil)                                                                                   #|line 106|##|line 107|#
)
(defun new_datum_bytes (&optional  b)                                                                                   #|line 109|#
    (let ((p (Datum  )))                                                                                                #|line 110|#
        (setf (cdr (assoc ' data  p))  b)                                                                               #|line 111|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bytes    p                                 #|line 112|#)))
            (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bytes    p                           #|line 113|#)))
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bytes    b                             #|line 114|#)))
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bytes    b                               #|line 115|#)))
                  (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bytes"))                                       #|line 116|#
                    (return-from new_datum_bytes  p)                                                                    #|line 117|#)#|line 118|#
)
(defun clone_datum_bytes (&optional  src)                                                                               #|line 120|#
    (let ((p (Datum  )))                                                                                                #|line 121|#
        (let ((p  src))                                                                                                 #|line 122|#
            (setf (cdr (assoc ' data  p)) (cdr (assoc '(clone  )  src)))                                                #|line 123|#
              (return-from clone_datum_bytes  p)                                                                        #|line 124|#))#|line 125|#
)
(defun reclaim_datum_bytes (&optional  src)                                                                             #|line 127|#
    #| pass |#                                                                                                          #|line 128|##|line 129|#
)
(defun srepr_datum_bytes (&optional  d)                                                                                 #|line 131|#
    (return-from srepr_datum_bytes (cdr (assoc '(cdr (assoc '(decode    "UTF_8"                                         #|line 132|#)  data))  d)))#|line 133|#
)
(defun raw_datum_bytes (&optional  d)                                                                                   #|line 134|#
    (return-from raw_datum_bytes (cdr (assoc ' data  d)))                                                               #|line 135|##|line 136|#
)
(defun new_datum_handle (&optional  h)                                                                                  #|line 138|#
    (return-from new_datum_handle (new_datum_int    h                                                                   #|line 139|#))#|line 140|#
)
(defun new_datum_int (&optional  i)                                                                                     #|line 142|#
    (let ((p (Datum  )))                                                                                                #|line 143|#
        (setf (cdr (assoc ' data  p))  i)                                                                               #|line 144|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_int    i                                         #|line 145|#)))
            (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_int    i                                   #|line 146|#)))
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_int    i                               #|line 147|#)))
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_int    i                                 #|line 148|#)))
                  (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "int"))                                         #|line 149|#
                    (return-from new_datum_int  p)                                                                      #|line 150|#)#|line 151|#
)
(defun clone_int (&optional  i)                                                                                         #|line 153|#
    (let ((p (new_datum_int    i                                                                                        #|line 154|#)))
        (return-from clone_int  p)                                                                                      #|line 155|#)#|line 156|#
)
(defun reclaim_int (&optional  src)                                                                                     #|line 158|#
    #| pass |#                                                                                                          #|line 159|##|line 160|#
)
(defun srepr_datum_int (&optional  i)                                                                                   #|line 162|#
    (return-from srepr_datum_int (str    i                                                                              #|line 163|#))#|line 164|#
)
(defun raw_datum_int (&optional  i)                                                                                     #|line 166|#
    (return-from raw_datum_int  i)                                                                                      #|line 167|##|line 168|#
)#|  Message passed to a leaf component. |#                                                                             #|line 170|##|  |##|line 171|##|  `port` refers to the name of the incoming or outgoing port of this component. |##|line 172|##|  `datum` is the data attached to this message. |##|line 173|#
(defun Message (&optional  port  datum)                                                                                 #|line 174|#
  (list
    (cons 'port  port)                                                                                                  #|line 175|#
    (cons 'datum  datum)                                                                                                #|line 176|#)#|line 177|#)
                                                                                                                        #|line 178|#
(defun clone_port (&optional  s)                                                                                        #|line 179|#
    (return-from clone_port (clone_string    s                                                                          #|line 180|#))#|line 181|#
)#|  Utility for making a `Message`. Used to safely “seed“ messages |#                                                  #|line 183|##|  entering the very top of a network. |##|line 184|#
(defun make_message (&optional  port  datum)                                                                            #|line 185|#
    (let ((p (clone_string    port                                                                                      #|line 186|#)))
        (let ((m (Message    p (cdr (assoc '(clone  )  datum))                                                          #|line 187|#)))
            (return-from make_message  m)                                                                               #|line 188|#))#|line 189|#
)#|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#               #|line 191|#
(defun message_clone (&optional  message)                                                                               #|line 192|#
    (let ((m (Message   (clone_port   (cdr (assoc ' port  message)) ) (cdr (assoc '(cdr (assoc '(clone  )  datum))  message)) #|line 193|#)))
        (return-from message_clone  m)                                                                                  #|line 194|#)#|line 195|#
)#|  Frees a message. |#                                                                                                #|line 197|#
(defun destroy_message (&optional  msg)                                                                                 #|line 198|#
    #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |##|line 199|#
      #| pass |#                                                                                                        #|line 200|##|line 201|#
)
(defun destroy_datum (&optional  msg)                                                                                   #|line 203|#
    #| pass |#                                                                                                          #|line 204|##|line 205|#
)
(defun destroy_port (&optional  msg)                                                                                    #|line 207|#
    #| pass |#                                                                                                          #|line 208|##|line 209|#
)#|  |#                                                                                                                 #|line 211|#
(defun format_message (&optional  m)                                                                                    #|line 212|#
    (cond
      (( equal    m  nil)                                                                                               #|line 213|#
            (return-from format_message  "ϕ")                                                                           #|line 214|#
        )
      (t                                                                                                                #|line 215|#
            (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc ' port  m))  (concatenate 'string  "⦂"  (concatenate 'string (cdr (assoc '(cdr (assoc '(srepr  )  datum))  m))  "⟫")))))#|line 219|##|line 220|#
        ))                                                                                                              #|line 221|#
)#|  dynamic routing descriptors |#                                                                                     #|line 223|##|line 224|#
(defparameter  drInject  "inject")
(defparameter  drSend  "send")
(defparameter  drInOut  "inout")
(defparameter  drForward  "forward")
(defparameter  drDown  "down")
(defparameter  drUp  "up")
(defparameter  drAcross  "across")
(defparameter  drThrough  "through")                                                                                    #|line 233|##|  See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c |##|line 234|##|line 235|##|line 236|#
(defun make_Routing_Descriptor (&optional  action  component  port  message)                                            #|line 237|#
    (return-from make_Routing_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 238|#
        (setf (gethash "action" _dict)  action)
        (setf (gethash "component" _dict)  component)
        (setf (gethash "port" _dict)  port)
        (setf (gethash "message" _dict)  message)                                                                       #|line 242|#
        _dict))                                                                                                         #|line 243|##|line 244|#
)#|  |#                                                                                                                 #|line 246|#
(defun make_Send_Descriptor (&optional  component  port  message  cause_port  cause_message)                            #|line 247|#
    (let ((rdesc (make_Routing_Descriptor    drSend  component  port  message                                           #|line 248|#)))
        (return-from make_Send_Descriptor
          (let ((_dict (make-hash-table :test 'equal)))                                                                 #|line 249|#
            (setf (gethash "action" _dict)  drSend)
            (setf (gethash "component" _dict) (cdr (assoc 'component  rdesc)))
            (setf (gethash "port" _dict) (cdr (assoc 'port  rdesc)))
            (setf (gethash "message" _dict) (cdr (assoc 'message  rdesc)))
            (setf (gethash "cause_port" _dict)  cause_port)
            (setf (gethash "cause_message" _dict)  cause_message)
            (setf (gethash "fmt" _dict)  fmt_send)                                                                      #|line 256|#
            _dict))                                                                                                     #|line 257|#)#|line 258|#
)
(defun log_send (&optional  sender  sender_port  msg  cause_msg)                                                        #|line 260|#
    (let ((send_desc (make_Send_Descriptor    sender  sender_port  msg (cdr (assoc ' port  cause_msg))  cause_msg       #|line 261|#)))
        (append_routing_descriptor   (cdr (assoc ' owner  sender))  send_desc                                           #|line 262|#))#|line 263|#
)
(defun log_send_string (&optional  sender  sender_port  msg  cause_msg)                                                 #|line 265|#
    (let ((send_desc (make_Send_Descriptor    sender  sender_port  msg (cdr (assoc ' port  cause_msg))  cause_msg       #|line 266|#)))
        (append_routing_descriptor   (cdr (assoc ' owner  sender))  send_desc                                           #|line 267|#))#|line 268|#
)
(defun fmt_send (&optional  desc  indent)                                                                               #|line 270|#
    (return-from fmt_send  ""                                                                                           #|line 271|#
        #| return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |##|line 272|#)#|line 273|#
)
(defun fmt_send_string (&optional  desc  indent)                                                                        #|line 275|#
    (return-from fmt_send_string (fmt_send    desc  indent                                                              #|line 276|#))#|line 277|#
)#|  |#                                                                                                                 #|line 279|#
(defun make_Forward_Descriptor (&optional  component  port  message  cause_port  cause_message)                         #|line 280|#
    (let ((rdesc (make_Routing_Descriptor    drSend  component  port  message                                           #|line 281|#)))
        (let ((fmt_forward  #'(lambda (&optional  desc) "")))                                                           #|line 282|#
            (return-from make_Forward_Descriptor
              (let ((_dict (make-hash-table :test 'equal)))                                                             #|line 283|#
                (setf (gethash "action" _dict)  drForward)
                (setf (gethash "component" _dict) (cdr (assoc 'component  rdesc)))
                (setf (gethash "port" _dict) (cdr (assoc 'port  rdesc)))
                (setf (gethash "message" _dict) (cdr (assoc 'message  rdesc)))
                (setf (gethash "cause_port" _dict)  cause_port)
                (setf (gethash "cause_message" _dict)  cause_message)
                (setf (gethash "fmt" _dict)  fmt_forward)                                                               #|line 290|#
                _dict))                                                                                                 #|line 291|#))#|line 292|#
)
(defun log_forward (&optional  sender  sender_port  msg  cause_msg)                                                     #|line 294|#
    #| pass |#
      #|  when needed, it is too frequent to bother logging |#                                                          #|line 295|##|line 296|#
)
(defun fmt_forward (&optional  desc)                                                                                    #|line 298|#
    (print    (concatenate 'string  "*** Error fmt_forward "  desc)                                                     #|line 299|#)
      (quit  )                                                                                                          #|line 300|##|line 301|#
)#|  |#                                                                                                                 #|line 303|#
(defun make_Inject_Descriptor (&optional  receiver  port  message)                                                      #|line 304|#
    (let ((rdesc (make_Routing_Descriptor    drInject  receiver  port  message                                          #|line 305|#)))
        (return-from make_Inject_Descriptor
          (let ((_dict (make-hash-table :test 'equal)))                                                                 #|line 306|#
            (setf (gethash "action" _dict)  drInject)
            (setf (gethash "component" _dict) (cdr (assoc 'component  rdesc)))
            (setf (gethash "port" _dict) (cdr (assoc 'port  rdesc)))
            (setf (gethash "message" _dict) (cdr (assoc 'message  rdesc)))
            (setf (gethash "fmt" _dict)  fmt_inject)                                                                    #|line 311|#
            _dict))                                                                                                     #|line 312|#)#|line 313|#
)
(defun log_inject (&optional  receiver  port  msg)                                                                      #|line 315|#
    (let ((inject_desc (make_Inject_Descriptor    receiver  port  msg                                                   #|line 316|#)))
        (append_routing_descriptor    receiver  inject_desc                                                             #|line 317|#))#|line 318|#
)
(defun fmt_inject (&optional  desc  indent)                                                                             #|line 320|#
    #| return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#                    #|line 321|#
      (return-from fmt_inject  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "⟹  "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'component  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'message  desc)) )))))))))#|line 328|##|line 329|#
)#|  |#                                                                                                                 #|line 331|#
(defun make_Down_Descriptor (&optional  container  source_port  source_message  target  target_port  target_message)    #|line 332|#
    (return-from make_Down_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 333|#
        (setf (gethash "action" _dict)  drDown)
        (setf (gethash "container" _dict)  container)
        (setf (gethash "source_port" _dict)  source_port)
        (setf (gethash "source_message" _dict)  source_message)
        (setf (gethash "target" _dict)  target)
        (setf (gethash "target_port" _dict)  target_port)
        (setf (gethash "target_message" _dict)  target_message)
        (setf (gethash "fmt" _dict)  fmt_down)                                                                          #|line 341|#
        _dict))                                                                                                         #|line 342|##|line 343|#
)
(defun log_down (&optional  container  source_port  source_message  target  target_port  target_message)                #|line 345|#
    (let ((rdesc (make_Down_Descriptor    container  source_port  source_message  target  target_port  target_message   #|line 346|#)))
        (append_routing_descriptor    container  rdesc                                                                  #|line 347|#))#|line 348|#
)
(defun fmt_down (&optional  desc  indent)                                                                               #|line 350|#
    #| return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}' |##|line 351|#
      (return-from fmt_down  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  " ↓ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'target  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'target_message  desc)) )))))))))))))#|line 362|##|line 363|#
)#|  |#                                                                                                                 #|line 365|#
(defun make_Up_Descriptor (&optional  source  source_port  source_message  container  container_port  container_message)#|line 366|#
    (return-from make_Up_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 367|#
        (setf (gethash "action" _dict)  drUp)
        (setf (gethash "source" _dict)  source)
        (setf (gethash "source_port" _dict)  source_port)
        (setf (gethash "source_message" _dict)  source_message)
        (setf (gethash "container" _dict)  container)
        (setf (gethash "container_port" _dict)  container_port)
        (setf (gethash "container_message" _dict)  container_message)
        (setf (gethash "fmt" _dict)  fmt_up)                                                                            #|line 375|#
        _dict))                                                                                                         #|line 376|##|line 377|#
)
(defun log_up (&optional  source  source_port  source_message  container  target_port  target_message)                  #|line 379|#
    (let ((rdesc (make_Up_Descriptor    source  source_port  source_message  container  target_port  target_message     #|line 380|#)))
        (append_routing_descriptor    container  rdesc                                                                  #|line 381|#))#|line 382|#
)
(defun fmt_up (&optional  desc  indent)                                                                                 #|line 384|#
    #| return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}' |##|line 385|#
      (return-from fmt_up  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "↑ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'source  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'container_port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'container_message  desc)) )))))))))))))#|line 396|##|line 397|#
)
(defun make_Across_Descriptor (&optional  container  source  source_port  source_message  target  target_port  target_message)#|line 399|#
    (return-from make_Across_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 400|#
        (setf (gethash "action" _dict)  drAcross)
        (setf (gethash "container" _dict)  container)
        (setf (gethash "source" _dict)  source)
        (setf (gethash "source_port" _dict)  source_port)
        (setf (gethash "source_message" _dict)  source_message)
        (setf (gethash "target" _dict)  target)
        (setf (gethash "target_port" _dict)  target_port)
        (setf (gethash "target_message" _dict)  target_message)
        (setf (gethash "fmt" _dict)  fmt_across)                                                                        #|line 409|#
        _dict))                                                                                                         #|line 410|##|line 411|#
)
(defun log_across (&optional  container  source  source_port  source_message  target  target_port  target_message)      #|line 413|#
    (let ((rdesc (make_Across_Descriptor    container  source  source_port  source_message  target  target_port  target_message #|line 414|#)))
        (append_routing_descriptor    container  rdesc                                                                  #|line 415|#))#|line 416|#
)
(defun fmt_across (&optional  desc  indent)                                                                             #|line 418|#
    #| return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}' |##|line 419|#
      (return-from fmt_across  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "→ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'source  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'target  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  "  " (format_message   (cdr (assoc 'target_message  desc)) )))))))))))))#|line 430|##|line 431|#
)#|  |#                                                                                                                 #|line 433|#
(defun make_Through_Descriptor (&optional  container  source_port  source_message  target_port  message)                #|line 434|#
    (return-from make_Through_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 435|#
        (setf (gethash "action" _dict)  drThrough)
        (setf (gethash "container" _dict)  container)
        (setf (gethash "source_port" _dict)  source_port)
        (setf (gethash "source_message" _dict)  source_message)
        (setf (gethash "target_port" _dict)  target_port)
        (setf (gethash "message" _dict)  message)
        (setf (gethash "fmt" _dict)  fmt_through)                                                                       #|line 442|#
        _dict))                                                                                                         #|line 443|##|line 444|#
)
(defun log_through (&optional  container  source_port  source_message  target_port  message)                            #|line 446|#
    (let ((rdesc (make_Through_Descriptor    container  source_port  source_message  target_port  message               #|line 447|#)))
        (append_routing_descriptor    container  rdesc                                                                  #|line 448|#))#|line 449|#
)
(defun fmt_through (&optional  desc  indent)                                                                            #|line 451|#
    #| return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}' |##|line 452|#
      (return-from fmt_through  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "⇶ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'message  desc)) )))))))))))))#|line 463|##|line 464|#
)#|  |#                                                                                                                 #|line 466|#
(defun make_InOut_Descriptor (&optional  container  component  in_message  out_port  out_message)                       #|line 467|#
    (return-from make_InOut_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 468|#
        (setf (gethash "action" _dict)  drInOut)
        (setf (gethash "container" _dict)  container)
        (setf (gethash "component" _dict)  component)
        (setf (gethash "in_message" _dict)  in_message)
        (setf (gethash "out_message" _dict)  out_message)
        (setf (gethash "fmt" _dict)  fmt_inout)                                                                         #|line 474|#
        _dict))                                                                                                         #|line 475|##|line 476|#
)
(defun log_inout (&optional  container  component  in_message)                                                          #|line 478|#
    (cond
      ((cdr (assoc '(cdr (assoc '(empty  )  outq))  component))                                                         #|line 479|#
            (log_inout_no_output    container  component  in_message )                                                  #|line 480|#
        )
      (t                                                                                                                #|line 481|#
            (log_inout_recursively    container  component  in_message (list   (cdr (assoc '(cdr (assoc ' queue  outq))  component)) ) )#|line 482|#
        ))                                                                                                              #|line 483|#
)
(defun log_inout_no_output (&optional  container  component  in_message)                                                #|line 485|#
    (let ((rdesc (make_InOut_Descriptor    container  component  in_message  nil  nil                                   #|line 486|#)))
        (append_routing_descriptor    container  rdesc                                                                  #|line 487|#))#|line 488|#
)
(defun log_inout_single (&optional  container  component  in_message  out_message)                                      #|line 490|#
    (let ((rdesc (make_InOut_Descriptor    container  component  in_message  nil  out_message                           #|line 491|#)))
        (append_routing_descriptor    container  rdesc                                                                  #|line 492|#))#|line 493|#
)
(defun log_inout_recursively (&optional  container  component  in_message  out_messages)                                #|line 495|#
    (cond
      (( equal    nil  out_messages)                                                                                    #|line 496|#
            #| pass |#                                                                                                  #|line 497|#
        )
      (t                                                                                                                #|line 498|#
            (let ((m  (car  out_messages)))                                                                             #|line 499|#
                (let ((rest  (cdr  out_messages)))                                                                      #|line 500|#
                    (log_inout_single    container  component  in_message  m                                            #|line 501|#)
                      (log_inout_recursively    container  component  in_message  rest )))                              #|line 502|#
        ))                                                                                                              #|line 503|#
)
(defun fmt_inout (&optional  desc  indent)                                                                              #|line 505|#
    (let ((outm (cdr (assoc 'out_message  desc))))                                                                      #|line 506|#
        (cond
          (( equal    nil  outm)                                                                                        #|line 507|#
                (return-from fmt_inout  (concatenate 'string  "\n"  (concatenate 'string  indent  "  ⊥")))              #|line 508|#
            )
          (t                                                                                                            #|line 509|#
                (return-from fmt_inout  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "  ∴ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'component  desc))))  (concatenate 'string  " " (format_message    outm )))))))#|line 514|##|line 515|#
            )))                                                                                                         #|line 516|#
)
(defun log_tick (&optional  container  component  in_message)                                                           #|line 518|#
    #| pass |#                                                                                                          #|line 519|##|line 520|#
)#|  |#                                                                                                                 #|line 522|#
(defun routing_trace_all (&optional  container)                                                                         #|line 523|#
    (let ((indent  ""))                                                                                                 #|line 524|#
        (let ((lis (list   (cdr (assoc '(cdr (assoc ' queue  routings))  container))                                    #|line 525|#)))
            (return-from routing_trace_all (recursive_routing_trace    container  lis  indent                           #|line 526|#))))#|line 527|#
)
(defun recursive_routing_trace (&optional  container  lis  indent)                                                      #|line 529|#
    (cond
      (( equal    nil  lis)                                                                                             #|line 530|#
            (return-from recursive_routing_trace  "")                                                                   #|line 531|#
        )
      (t                                                                                                                #|line 532|#
            (let ((desc (first    lis                                                                                   #|line 533|#)))
                (let ((formatted (funcall (cdr (assoc 'fmt  desc))   desc  indent                                       #|line 534|#)))
                    (return-from recursive_routing_trace (+  formatted (recursive_routing_trace    container (rest    lis ) (+  indent  "  ") )))))#|line 535|#
        ))                                                                                                              #|line 536|#
)
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                                                                                          #|line 542|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)                                             #|line 543|##|line 544|#
      (let ((container (make_container    container_name  owner                                                         #|line 545|#)))
          (let ((children  nil))                                                                                        #|line 546|#
              (let ((children_by_id  nil))
                  #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#         #|line 547|#
                    #|  collect children |#                                                                             #|line 548|#
                      (loop for child_desc in (cdr (assoc 'children  desc))
                        do                                                                                              #|line 549|#
                            (let ((child_instance (get_component_instance    reg (cdr (assoc 'name  child_desc))  container #|line 550|#)))
                                (cdr (assoc '(append    child_instance                                                  #|line 551|#)  children))
                                  (setf (nth (cdr (assoc 'id  child_desc))  children_by_id)  child_instance))           #|line 552|#
                        )
                        (setf (cdr (assoc ' children  container))  children)                                            #|line 553|#
                          (let ((me  container))                                                                        #|line 554|##|line 555|#
                                (let ((connectors  nil))                                                                #|line 556|#
                                    (loop for proto_conn in (cdr (assoc 'connections  desc))
                                      do                                                                                #|line 557|#
                                          (let ((source_component  nil))                                                #|line 558|#
                                              (let ((target_component  nil))                                            #|line 559|#
                                                  (let ((connector (Connector  )))                                      #|line 560|#
                                                      (cond
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumDown)            #|line 561|#
                                                              #|  JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |##|line 562|#
                                                                (setf (cdr (assoc ' direction  connector))  "down")     #|line 563|#
                                                                  (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))  me (cdr (assoc 'source_port  proto_conn)) #|line 564|#))
                                                                    (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 565|#
                                                                        (cond
                                                                          (( equal    target_component  nil)            #|line 566|#
                                                                                (load_error    (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc 'target  proto_conn))) )#|line 567|#
                                                                            )
                                                                          (t                                            #|line 568|#
                                                                                (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component)) (cdr (assoc ' inq  target_component)) (cdr (assoc 'target_port  proto_conn))  target_component #|line 569|#))
                                                                                  (cdr (assoc '(append    connector )  connectors))
                                                                            )))                                         #|line 570|#
                                                          )
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumAcross)          #|line 571|#
                                                              (setf (cdr (assoc ' direction  connector))  "across")     #|line 572|#
                                                                (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 573|#
                                                                    (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 574|#
                                                                        (cond
                                                                          (( equal    source_component  nil)            #|line 575|#
                                                                                (load_error    (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 576|#
                                                                            )
                                                                          (t                                            #|line 577|#
                                                                                (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))  source_component (cdr (assoc 'source_port  proto_conn)) #|line 578|#))
                                                                                  (cond
                                                                                    (( equal    target_component  nil)  #|line 579|#
                                                                                          (load_error    (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc ' target  proto_conn))) )#|line 580|#
                                                                                      )
                                                                                    (t                                  #|line 581|#
                                                                                          (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component)) (cdr (assoc ' inq  target_component)) (cdr (assoc 'target_port  proto_conn))  target_component #|line 582|#))
                                                                                            (cdr (assoc '(append    connector )  connectors))
                                                                                      ))
                                                                            ))))                                        #|line 583|#
                                                          )
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumUp)              #|line 584|#
                                                              (setf (cdr (assoc ' direction  connector))  "up")         #|line 585|#
                                                                (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 586|#
                                                                    (cond
                                                                      (( equal    source_component  nil)                #|line 587|#
                                                                            (print    (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 588|#
                                                                        )
                                                                      (t                                                #|line 589|#
                                                                            (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))  source_component (cdr (assoc 'source_port  proto_conn)) #|line 590|#))
                                                                              (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me)) (cdr (assoc ' outq  container)) (cdr (assoc 'target_port  proto_conn))  me #|line 591|#))
                                                                                (cdr (assoc '(append    connector )  connectors))
                                                                        )))                                             #|line 592|#
                                                          )
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumThrough)         #|line 593|#
                                                              (setf (cdr (assoc ' direction  connector))  "through")    #|line 594|#
                                                                (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))  me (cdr (assoc 'source_port  proto_conn)) #|line 595|#))
                                                                  (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me)) (cdr (assoc ' outq  container)) (cdr (assoc 'target_port  proto_conn))  me #|line 596|#))
                                                                    (cdr (assoc '(append    connector )  connectors))
                                                          )))))                                                         #|line 597|#
                                      )                                                                                 #|line 598|#
                                      (setf (cdr (assoc ' connections  container))  connectors)                         #|line 599|#
                                        (return-from container_instantiator  container)                                 #|line 600|#)))))#|line 601|#
)#|  The default handler for container components. |#                                                                   #|line 603|#
(defun container_handler (&optional  container  message)                                                                #|line 604|#
    (route    container #|  from=  |# container  message )
      #|  references to 'self' are replaced by the container during instantiation |#                                    #|line 605|#
        (loop while (any_child_ready    container )
          do                                                                                                            #|line 606|#
              (step_children    container  message )                                                                    #|line 607|#
          )                                                                                                             #|line 608|#
)#|  Frees the given container and associated data. |#                                                                  #|line 610|#
(defun destroy_container (&optional  eh)                                                                                #|line 611|#
    #| pass |#                                                                                                          #|line 612|##|line 613|#
)
(defun fifo_is_empty (&optional  fifo)                                                                                  #|line 615|#
    (return-from fifo_is_empty (cdr (assoc '(empty  )  fifo)))                                                          #|line 616|##|line 617|#
)#|  Routing connection for a container component. The `direction` field has |#                                         #|line 619|##|  no affect on the default message routing system _ it is there for debugging |##|line 620|##|  purposes, or for reading by other tools. |##|line 621|##|line 622|#
(defun Connector (&optional )                                                                                           #|line 623|#
  (list
    (cons 'direction  nil) #|  down, across, up, through |#                                                             #|line 624|#
    (cons 'sender  nil)                                                                                                 #|line 625|#
    (cons 'receiver  nil)                                                                                               #|line 626|#)#|line 627|#)
                                                                                                                        #|line 628|##|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |##|line 629|##|  based on component ID (pointer) and port name. |##|line 630|##|line 631|#
(defun Sender (&optional  name  component  port)                                                                        #|line 632|#
  (list
    (cons 'name  name)                                                                                                  #|line 633|#
    (cons 'component  component) #|  from |#                                                                            #|line 634|#
    (cons 'port  port) #|  from's port |#                                                                               #|line 635|#)#|line 636|#)
                                                                                                                        #|line 637|##|  `Receiver` is a handle to a destination queue, and a `port` name to assign |##|line 638|##|  to incoming messages to this queue. |##|line 639|##|line 640|#
(defun Receiver (&optional  name  queue  port  component)                                                               #|line 641|#
  (list
    (cons 'name  name)                                                                                                  #|line 642|#
    (cons 'queue  queue) #|  queue (input | output) of receiver |#                                                      #|line 643|#
    (cons 'port  port) #|  destination port |#                                                                          #|line 644|#
    (cons 'component  component) #|  to (for bootstrap debug) |#                                                        #|line 645|#)#|line 646|#)
                                                                                                                        #|line 647|##|  Checks if two senders match, by pointer equality and port name matching. |##|line 648|#
(defun sender_eq (&optional  s1  s2)                                                                                    #|line 649|#
    (let ((same_components ( equal   (cdr (assoc ' component  s1)) (cdr (assoc ' component  s2)))))                     #|line 650|#
        (let ((same_ports ( equal   (cdr (assoc ' port  s1)) (cdr (assoc ' port  s2)))))                                #|line 651|#
            (return-from sender_eq ( and   same_components  same_ports))                                                #|line 652|#))#|line 653|#
)#|  Delivers the given message to the receiver of this connector. |#                                                   #|line 655|##|line 656|#
(defun deposit (&optional  parent  conn  message)                                                                       #|line 657|#
    (let ((new_message (make_message   (cdr (assoc '(cdr (assoc ' port  receiver))  conn)) (cdr (assoc ' datum  message)) #|line 658|#)))
        (log_connection    parent  conn  new_message                                                                    #|line 659|#)
          (push_message    parent (cdr (assoc '(cdr (assoc ' component  receiver))  conn)) (cdr (assoc '(cdr (assoc ' queue  receiver))  conn))  new_message #|line 660|#))#|line 661|#
)
(defun force_tick (&optional  parent  eh)                                                                               #|line 663|#
    (let ((tick_msg (make_message    "." (new_datum_tick  )                                                             #|line 664|#)))
        (push_message    parent  eh (cdr (assoc ' inq  eh))  tick_msg                                                   #|line 665|#)
          (return-from force_tick  tick_msg)                                                                            #|line 666|#)#|line 667|#
)
(defun push_message (&optional  parent  receiver  inq  m)                                                               #|line 669|#
    (cdr (assoc '(put    m                                                                                              #|line 670|#)  inq))
      (cdr (assoc '(cdr (assoc '(put    receiver                                                                        #|line 671|#)  visit_ordering))  parent))#|line 672|#
)
(defun is_self (&optional  child  container)                                                                            #|line 674|#
    #|  in an earlier version “self“ was denoted as ϕ |#                                                                #|line 675|#
      (return-from is_self ( equal    child  container))                                                                #|line 676|##|line 677|#
)
(defun step_child (&optional  child  msg)                                                                               #|line 679|#
    (let ((before_state (cdr (assoc ' state  child))))                                                                  #|line 680|#
        (cdr (assoc '(handler    child  msg                                                                             #|line 681|#)  child))
          (let ((after_state (cdr (assoc ' state  child))))                                                             #|line 682|#
              (return-from step_child (values ( and  ( equal    before_state  "idle") (not (equal   after_state  "idle"))) #|line 683|#( and  (not (equal   before_state  "idle")) (not (equal   after_state  "idle"))) #|line 684|#( and  (not (equal   before_state  "idle")) ( equal    after_state  "idle"))))#|line 685|#))#|line 686|#
)
(defun save_message (&optional  eh  msg)                                                                                #|line 688|#
    (cdr (assoc '(cdr (assoc '(put    msg                                                                               #|line 689|#)  saved_messages))  eh))#|line 690|#
)
(defun fetch_saved_message_and_clear (&optional  eh)                                                                    #|line 692|#
    (return-from fetch_saved_message_and_clear (cdr (assoc '(cdr (assoc '(get  )  saved_messages))  eh)))               #|line 693|##|line 694|#
)
(defun step_children (&optional  container  causingMessage)                                                             #|line 696|#
    (setf (cdr (assoc ' state  container))  "idle")                                                                     #|line 697|#
      (loop for child in (list   (cdr (assoc '(cdr (assoc ' queue  visit_ordering))  container)) )
        do                                                                                                              #|line 698|#
            #|  child = container represents self, skip it |#                                                           #|line 699|#
              (cond
                ((not (is_self    child  container ))                                                                   #|line 700|#
                      (cond
                        ((not (cdr (assoc '(cdr (assoc '(empty  )  inq))  child)))                                      #|line 701|#
                              (let ((msg (cdr (assoc '(cdr (assoc '(get  )  inq))  child))))                            #|line 702|#
                                  (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (step_child    child  msg #|line 703|#))
                                    (cond
                                      ( began_long_run                                                                  #|line 704|#
                                            (save_message    child  msg )                                               #|line 705|#
                                        )
                                      ( continued_long_run                                                              #|line 706|#
                                            #| pass |#                                                                  #|line 707|#
                                        )
                                      ( ended_long_run                                                                  #|line 708|#
                                            (log_inout    container  child (fetch_saved_message_and_clear    child ) )  #|line 709|#
                                        )
                                      (t                                                                                #|line 710|#
                                            (log_inout    container  child  msg )                                       #|line 711|#
                                        ))
                                      (destroy_message    msg ))                                                        #|line 712|#
                          )
                        (t                                                                                              #|line 713|#
                              (cond
                                ((not (equal  (cdr (assoc ' state  child))  "idle"))                                    #|line 714|#
                                      (let ((msg (force_tick    container  child                                        #|line 715|#)))
                                          (cdr (assoc '(handler    child  msg                                           #|line 716|#)  child))
                                            (log_tick    container  child  msg                                          #|line 717|#)
                                              (destroy_message    msg ))
                                  ))                                                                                    #|line 718|#
                          ))                                                                                            #|line 719|#
                        (cond
                          (( equal   (cdr (assoc ' state  child))  "active")                                            #|line 720|#
                                #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |##|line 721|#
                                  (setf (cdr (assoc ' state  container))  "active")                                     #|line 722|#
                            ))                                                                                          #|line 723|#
                          (loop while (not (cdr (assoc '(cdr (assoc '(empty  )  outq))  child)))
                            do                                                                                          #|line 724|#
                                (let ((msg (cdr (assoc '(cdr (assoc '(get  )  outq))  child))))                         #|line 725|#
                                    (route    container  child  msg                                                     #|line 726|#)
                                      (destroy_message    msg ))
                            )
                  ))                                                                                                    #|line 727|#
        )                                                                                                               #|line 728|##|line 729|##|line 730|#
)
(defun attempt_tick (&optional  parent  eh)                                                                             #|line 732|#
    (cond
      ((not (equal  (cdr (assoc ' state  eh))  "idle"))                                                                 #|line 733|#
            (force_tick    parent  eh )                                                                                 #|line 734|#
        ))                                                                                                              #|line 735|#
)
(defun is_tick (&optional  msg)                                                                                         #|line 737|#
    (return-from is_tick ( equal    "tick" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg))))                         #|line 738|##|line 739|#
)#|  Routes a single message to all matching destinations, according to |#                                              #|line 741|##|  the container's connection network. |##|line 742|##|line 743|#
(defun route (&optional  container  from_component  message)                                                            #|line 744|#
    (let (( was_sent  nil))
        #|  for checking that output went somewhere (at least during bootstrap) |#                                      #|line 745|#
          (let (( fromname  ""))                                                                                        #|line 746|#
              (cond
                ((is_tick    message )                                                                                  #|line 747|#
                      (loop for child in (cdr (assoc ' children  container))
                        do                                                                                              #|line 748|#
                            (attempt_tick    container  child  message )                                                #|line 749|#
                        )
                        (setf  was_sent  t)                                                                             #|line 750|#
                  )
                (t                                                                                                      #|line 751|#
                      (cond
                        ((not (is_self    from_component  container ))                                                  #|line 752|#
                              (setf  fromname (cdr (assoc ' name  from_component)))                                     #|line 753|#
                          ))
                        (let ((from_sender (Sender    fromname  from_component (cdr (assoc ' port  message))            #|line 754|#)))#|line 755|#
                            (loop for connector in (cdr (assoc ' connections  container))
                              do                                                                                        #|line 756|#
                                  (cond
                                    ((sender_eq    from_sender (cdr (assoc ' sender  connector)) )                      #|line 757|#
                                          (deposit    container  connector  message                                     #|line 758|#)
                                            (setf  was_sent  t)
                                      ))
                              ))                                                                                        #|line 759|#
                  ))
                (cond
                  ((not  was_sent)                                                                                      #|line 760|#
                        (print    "\n\n*** Error: ***"                                                                  #|line 761|#)
                          (dump_possible_connections    container                                                       #|line 762|#)
                            (print_routing_trace    container                                                           #|line 763|#)
                              (print    "***"                                                                           #|line 764|#)
                                (print    (concatenate 'string (cdr (assoc ' name  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor..."))))) #|line 765|#)
                                  (print    "***"                                                                       #|line 766|#)
                                    (exit  )                                                                            #|line 767|#
                    ))))                                                                                                #|line 768|#
)
(defun dump_possible_connections (&optional  container)                                                                 #|line 770|#
    (print    (concatenate 'string  "*** possible connections for "  (concatenate 'string (cdr (assoc ' name  container))  ":")) #|line 771|#)
      (loop for connector in (cdr (assoc ' connections  container))
        do                                                                                                              #|line 772|#
            (print    (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  " "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  sender))  connector))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc '(cdr (assoc ' port  sender))  connector))  (concatenate 'string  " -> "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  receiver))  connector))  (concatenate 'string  "." (cdr (assoc '(cdr (assoc ' port  receiver))  connector)))))))))) )#|line 773|#
        )                                                                                                               #|line 774|#
)
(defun any_child_ready (&optional  container)                                                                           #|line 776|#
    (loop for child in (cdr (assoc ' children  container))
      do                                                                                                                #|line 777|#
          (cond
            ((child_is_ready    child )                                                                                 #|line 778|#
                  (return-from any_child_ready  t)
              ))                                                                                                        #|line 779|#
      )
      (return-from any_child_ready  nil)                                                                                #|line 780|##|line 781|#
)
(defun child_is_ready (&optional  eh)                                                                                   #|line 783|#
    (return-from child_is_ready ( or  ( or  ( or  (not (cdr (assoc '(cdr (assoc '(empty  )  outq))  eh))) (not (cdr (assoc '(cdr (assoc '(empty  )  inq))  eh)))) (not (equal  (cdr (assoc ' state  eh))  "idle"))) (any_child_ready    eh )))#|line 784|##|line 785|#
)
(defun print_routing_trace (&optional  eh)                                                                              #|line 787|#
    (print   (routing_trace_all    eh )                                                                                 #|line 788|#)#|line 789|#
)
(defun append_routing_descriptor (&optional  container  desc)                                                           #|line 791|#
    (cdr (assoc '(cdr (assoc '(put    desc                                                                              #|line 792|#)  routings))  container))#|line 793|#
)
(defun log_connection (&optional  container  connector  message)                                                        #|line 795|#
    (cond
      (( equal    "down" (cdr (assoc ' direction  connector)))                                                          #|line 796|#
            (log_down    container                                                                                      #|line 797|##|  source port =  |#(cdr (assoc '(cdr (assoc ' port  sender))  connector)) #|line 798|##|  source message =  |# nil #|line 799|##|  target =  |#(cdr (assoc '(cdr (assoc ' component  receiver))  connector)) #|line 800|##|  target port =  |#(cdr (assoc '(cdr (assoc ' port  receiver))  connector)) #|line 801|##|  target message =  |# message )#|line 802|#
        )
      (( equal    "up" (cdr (assoc ' direction  connector)))                                                            #|line 803|#
            (log_up   (cdr (assoc '(cdr (assoc ' component  sender))  connector)) (cdr (assoc '(cdr (assoc ' port  sender))  connector))  nil  container (cdr (assoc '(cdr (assoc ' port  receiver))  connector))  message )#|line 804|#
        )
      (( equal    "across" (cdr (assoc ' direction  connector)))                                                        #|line 805|#
            (log_across    container                                                                                    #|line 806|#(cdr (assoc '(cdr (assoc ' component  sender))  connector)) (cdr (assoc '(cdr (assoc ' port  sender))  connector))  nil #|line 807|#(cdr (assoc '(cdr (assoc ' component  receiver))  connector)) (cdr (assoc '(cdr (assoc ' port  receiver))  connector))  message )#|line 808|#
        )
      (( equal    "through" (cdr (assoc ' direction  connector)))                                                       #|line 809|#
            (log_through    container (cdr (assoc '(cdr (assoc ' port  sender))  connector))  nil                       #|line 810|#(cdr (assoc '(cdr (assoc ' port  receiver))  connector))  message )#|line 811|#
        )
      (t                                                                                                                #|line 812|#
            (print    (concatenate 'string  "*** FATAL error: in log_connection /"  (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  "/ /"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "/ /"  (concatenate 'string (cdr (assoc '(cdr (assoc '(srepr  )  datum))  message))  "/")))))) #|line 813|#)
              (exit  )                                                                                                  #|line 814|#
        ))                                                                                                              #|line 815|#
)
(defun container_injector (&optional  container  message)                                                               #|line 817|#
    (log_inject    container (cdr (assoc ' port  message))  message                                                     #|line 818|#)
      (container_handler    container  message                                                                          #|line 819|#)#|line 820|#
)





