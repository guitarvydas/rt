
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
(defun read_and_convert_json_file (&optional  filename)                                                                 #|line 16|#
    ;; read json from a named file and convert it into internal form (a tree of routings)
    ;; return the routings from the function or print an error message and return nil
    (handler-bind ((error #'(lambda (condition) nil)))
      (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
        (json:decode-json json-stream)))
                                                                                                                        #|line 17|##|line 18|#
)
(defun json2internal (&optional  container_xml)                                                                         #|line 20|#
    (let ((fname (cdr (assoc '(cdr (assoc '(basename    container_xml                                                   #|line 21|#)  path))  os))))
        (let ((routings (read_and_convert_json_file    fname                                                            #|line 22|#)))
            (return-from json2internal  routings)                                                                       #|line 23|#))#|line 24|#
)
(defun delete_decls (&optional  d)                                                                                      #|line 26|#
    #| pass |#                                                                                                          #|line 27|##|line 28|#
)
(defun make_component_registry (&optional )                                                                             #|line 30|#
    (return-from make_component_registry (Component_Registry  ))                                                        #|line 31|##|line 32|#
)
(defun register_component (&optional  reg  template)
    (return-from register_component (abstracted_register_component    reg  template  nil ))                             #|line 34|#
)
(defun register_component_allow_overwriting (&optional  reg  template)
    (return-from register_component_allow_overwriting (abstracted_register_component    reg  template  t ))             #|line 35|#
)
(defun abstracted_register_component (&optional  reg  template  ok_to_overwrite)                                        #|line 37|#
    (let ((name (mangle_name   (cdr (assoc ' name  template))                                                           #|line 38|#)))
        (cond
          (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                   #|line 39|#
                (load_error    (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 40|#
            ))
          (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                   #|line 41|#
            (return-from abstracted_register_component  reg)                                                            #|line 42|#)#|line 43|#
)
(defun register_multiple_components (&optional  reg  templates)                                                         #|line 45|#
    (loop for template in  templates
      do                                                                                                                #|line 46|#
          (register_component    reg  template )                                                                        #|line 47|#
      )                                                                                                                 #|line 48|#
)
(defun get_component_instance (&optional  reg  full_name  owner)                                                        #|line 50|#
    (let ((template_name (mangle_name    full_name                                                                      #|line 51|#)))
        (cond
          (( in   template_name (cdr (assoc ' templates  reg)))                                                         #|line 52|#
                (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))                                   #|line 53|#
                    (cond
                      (( equal    template  nil)                                                                        #|line 54|#
                            (load_error    (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 55|#)
                              (return-from get_component_instance  nil)                                                 #|line 56|#
                        )
                      (t                                                                                                #|line 57|#
                            (let ((owner_name  ""))                                                                     #|line 58|#
                                (let ((instance_name  template_name))                                                   #|line 59|#
                                    (cond
                                      ((not (equal   nil  owner))                                                       #|line 60|#
                                            (let ((owner_name (cdr (assoc ' name  owner))))                             #|line 61|#
                                                (let ((instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))))))#|line 62|#
                                        )
                                      (t                                                                                #|line 63|#
                                            (let ((instance_name  template_name)))                                      #|line 64|#
                                        ))
                                      (let ((instance (cdr (assoc '(instantiator    reg  owner  instance_name (cdr (assoc ' template_data  template)) #|line 65|#)  template))))
                                          (setf (cdr (assoc ' depth  instance)) (calculate_depth    instance            #|line 66|#))
                                            (return-from get_component_instance  instance))))
                        )))                                                                                             #|line 67|#
            )
          (t                                                                                                            #|line 68|#
                (load_error    (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 69|#)
                  (return-from get_component_instance  nil)                                                             #|line 70|#
            )))                                                                                                         #|line 71|#
)
(defun calculate_depth (&optional  eh)                                                                                  #|line 72|#
    (cond
      (( equal   (cdr (assoc ' owner  eh))  nil)                                                                        #|line 73|#
            (return-from calculate_depth  0)                                                                            #|line 74|#
        )
      (t                                                                                                                #|line 75|#
            (return-from calculate_depth (+  1 (calculate_depth   (cdr (assoc ' owner  eh)) )))                         #|line 76|#
        ))                                                                                                              #|line 77|#
)
(defun dump_registry (&optional  reg)                                                                                   #|line 79|#
    (print  )                                                                                                           #|line 80|#
      (print    "*** PALETTE ***"                                                                                       #|line 81|#)
        (loop for c in (cdr (assoc ' templates  reg))
          do                                                                                                            #|line 82|#
              (print   (cdr (assoc ' name  c)) )                                                                        #|line 83|#
          )
          (print    "***************"                                                                                   #|line 84|#)
            (print  )                                                                                                   #|line 85|##|line 86|#
)
(defun print_stats (&optional  reg)                                                                                     #|line 88|#
    (print    (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg)))                                 #|line 89|#)#|line 90|#
)
(defun mangle_name (&optional  s)                                                                                       #|line 92|#
    #|  trim name to remove code from Container component names _ deferred until later (or never) |#                    #|line 93|#
      (return-from mangle_name  s)                                                                                      #|line 94|##|line 95|#
)
(defun generate_shell_components (&optional  reg  container_list)                                                       #|line 98|#
    #|  [ |#                                                                                                            #|line 99|#
      #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 100|#
        #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                        #|line 101|#
          #|  ] |#                                                                                                      #|line 102|#
            (cond
              ((not (equal   nil  container_list))                                                                      #|line 103|#
                    (loop for diagram in  container_list
                      do                                                                                                #|line 104|#
                          #|  loop through every component in the diagram and look for names that start with “$“ |#     #|line 105|#
                            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 106|#
                              (loop for child_descriptor in (cdr (assoc 'children  diagram))
                                do                                                                                      #|line 107|#
                                    (cond
                                      ((first_char_is   (cdr (assoc 'name  child_descriptor))  "$" )                    #|line 108|#
                                            (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 109|#
                                                (let ((cmd (cdr (assoc '(strip  )  (subseq  name 1)))))                 #|line 110|#
                                                    (let ((generated_leaf (Template    name  shell_out_instantiate  cmd #|line 111|#)))
                                                        (register_component    reg  generated_leaf                      #|line 112|#))))
                                        )
                                      ((first_char_is   (cdr (assoc 'name  child_descriptor))  "'" )                    #|line 113|#
                                            (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 114|#
                                                (let ((s  (subseq  name 1)))                                            #|line 115|#
                                                    (let ((generated_leaf (Template    name  string_constant_instantiate  s #|line 116|#)))
                                                        (register_component_allow_overwriting    reg  generated_leaf    #|line 117|#))))#|line 118|#
                                        ))                                                                              #|line 119|#
                                )                                                                                       #|line 120|#
                      )                                                                                                 #|line 121|#
                ))                                                                                                      #|line 122|#
)
(defun first_char (&optional  s)                                                                                        #|line 124|#
    (return-from first_char  (car  s))                                                                                  #|line 125|##|line 126|#
)
(defun first_char_is (&optional  s  c)                                                                                  #|line 128|#
    (return-from first_char_is ( equal    c (first_char    s                                                            #|line 129|#)))#|line 130|#
)#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 132|##|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 133|#
(defun run_command (&optional  eh  cmd  s)                                                                              #|line 134|#
    #|  capture_output ∷ ⊤ |#                                                                                           #|line 135|#
      (let ((ret (cdr (assoc '(run    cmd  s  "UTF_8"                                                                   #|line 136|#)  subprocess))))
          (cond
            ((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                        #|line 137|#
                  (cond
                    ((not (equal  (cdr (assoc ' stderr  ret))  nil))                                                    #|line 138|#
                          (return-from run_command (values  "" (cdr (assoc ' stderr  ret))))                            #|line 139|#
                      )
                    (t                                                                                                  #|line 140|#
                          (return-from run_command (values  ""  (concatenate 'string  "error in shell_out " (cdr (assoc ' returncode  ret)))))
                      ))                                                                                                #|line 141|#
              )
            (t                                                                                                          #|line 142|#
                  (return-from run_command (values (cdr (assoc ' stdout  ret))  nil))                                   #|line 143|#
              )))                                                                                                       #|line 144|#
)#|  Data for an asyncronous component _ effectively, a function with input |#                                          #|line 146|##|  and output queues of messages. |##|line 147|##|  |##|line 148|##|  Components can either be a user_supplied function (“lea“), or a “container“ |##|line 149|##|  that routes messages to child components according to a list of connections |##|line 150|##|  that serve as a message routing table. |##|line 151|##|  |##|line 152|##|  Child components themselves can be leaves or other containers. |##|line 153|##|  |##|line 154|##|  `handler` invokes the code that is attached to this component. |##|line 155|##|  |##|line 156|##|  `instance_data` is a pointer to instance data that the `leaf_handler` |##|line 157|##|  function may want whenever it is invoked again. |##|line 158|##|  |##|line 159|##|line 160|##|line 163|##|line 164|##|  Eh_States :: enum { idle, active } |##|line 165|#
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
(defun make_container (&optional  name  owner)                                                                          #|line 188|#
    (let ((eh (Eh  )))                                                                                                  #|line 189|#
        (setf (cdr (assoc ' name  eh))  name)                                                                           #|line 190|#
          (setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 191|#
            (setf (cdr (assoc ' handler  eh))  container_handler)                                                       #|line 192|#
              (setf (cdr (assoc ' inject  eh))  container_injector)                                                     #|line 193|#
                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 194|#
                  (setf (cdr (assoc ' kind  eh))  "container")                                                          #|line 195|#
                    (return-from make_container  eh)                                                                    #|line 196|#)#|line 197|#
)#|  Creates a new leaf component out of a handler function, and a data parameter |#                                    #|line 199|##|  that will be passed back to your handler when called. |##|line 200|##|line 201|#
(defun make_leaf (&optional  name  owner  instance_data  handler)                                                       #|line 202|#
    (let ((eh (Eh  )))                                                                                                  #|line 203|#
        (setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)))#|line 204|#
          (setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 205|#
            (setf (cdr (assoc ' handler  eh))  handler)                                                                 #|line 206|#
              (setf (cdr (assoc ' instance_data  eh))  instance_data)                                                   #|line 207|#
                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 208|#
                  (setf (cdr (assoc ' kind  eh))  "leaf")                                                               #|line 209|#
                    (return-from make_leaf  eh)                                                                         #|line 210|#)#|line 211|#
)#|  Sends a message on the given `port` with `data`, placing it on the output |#                                       #|line 213|##|  of the given component. |##|line 214|##|line 215|#
(defun send (&optional  eh  port  datum  causingMessage)                                                                #|line 216|#
    (let ((msg (make_message    port  datum                                                                             #|line 217|#)))
        (log_send    eh  port  msg  causingMessage                                                                      #|line 218|#)
          (put_output    eh  msg                                                                                        #|line 219|#))#|line 220|#
)
(defun send_string (&optional  eh  port  s  causingMessage)                                                             #|line 222|#
    (let ((datum (new_datum_string    s                                                                                 #|line 223|#)))
        (let ((msg (make_message    port  datum                                                                         #|line 224|#)))
            (log_send_string    eh  port  msg  causingMessage                                                           #|line 225|#)
              (put_output    eh  msg                                                                                    #|line 226|#)))#|line 227|#
)
(defun forward (&optional  eh  port  msg)                                                                               #|line 229|#
    (let ((fwdmsg (make_message    port (cdr (assoc ' datum  msg))                                                      #|line 230|#)))
        (log_forward    eh  port  msg  msg                                                                              #|line 231|#)
          (put_output    eh  msg                                                                                        #|line 232|#))#|line 233|#
)
(defun inject (&optional  eh  msg)                                                                                      #|line 235|#
    (cdr (assoc '(inject    eh  msg                                                                                     #|line 236|#)  eh))#|line 237|#
)#|  Returns a list of all output messages on a container. |#                                                           #|line 239|##|  For testing / debugging purposes. |##|line 240|##|line 241|#
(defun output_list (&optional  eh)                                                                                      #|line 242|#
    (return-from output_list (cdr (assoc ' outq  eh)))                                                                  #|line 243|##|line 244|#
)#|  Utility for printing an array of messages. |#                                                                      #|line 246|#
(defun print_output_list (&optional  eh)                                                                                #|line 247|#
    (loop for m in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
      do                                                                                                                #|line 248|#
          (print   (format_message    m ) )                                                                             #|line 249|#
      )                                                                                                                 #|line 250|#
)
(defun spaces (&optional  n)                                                                                            #|line 252|#
    (let (( s  ""))                                                                                                     #|line 253|#
        (loop for i in (loop for n from 0 below  n by 1 collect n)
          do                                                                                                            #|line 254|#
              (setf  s (+  s  " "))                                                                                     #|line 255|#
          )
          (return-from spaces  s)                                                                                       #|line 256|#)#|line 257|#
)
(defun set_active (&optional  eh)                                                                                       #|line 259|#
    (setf (cdr (assoc ' state  eh))  "active")                                                                          #|line 260|##|line 261|#
)
(defun set_idle (&optional  eh)                                                                                         #|line 263|#
    (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 264|##|line 265|#
)#|  Utility for printing a specific output message. |#                                                                 #|line 267|##|line 268|#
(defun fetch_first_output (&optional  eh  port)                                                                         #|line 269|#
    (loop for msg in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
      do                                                                                                                #|line 270|#
          (cond
            (( equal   (cdr (assoc ' port  msg))  port)                                                                 #|line 271|#
                  (return-from fetch_first_output (cdr (assoc ' datum  msg)))
              ))                                                                                                        #|line 272|#
      )
      (return-from fetch_first_output  nil)                                                                             #|line 273|##|line 274|#
)
(defun print_specific_output (&optional  eh  port)                                                                      #|line 276|#
    #|  port ∷ “” |#                                                                                                    #|line 277|#
      (let (( datum (fetch_first_output    eh  port                                                                     #|line 278|#)))
          (let (( outf  nil))                                                                                           #|line 279|#
              (cond
                ((not (equal   datum  nil))                                                                             #|line 280|#
                      (setf  outf (cdr (assoc ' stdout  sys)))                                                          #|line 281|#
                        (print   (cdr (assoc '(srepr  )  datum))  outf )                                                #|line 282|#
                  ))))                                                                                                  #|line 283|#
)
(defun print_specific_output_to_stderr (&optional  eh  port)                                                            #|line 284|#
    #|  port ∷ “” |#                                                                                                    #|line 285|#
      (let (( datum (fetch_first_output    eh  port                                                                     #|line 286|#)))
          (let (( outf  nil))                                                                                           #|line 287|#
              (cond
                ((not (equal   datum  nil))                                                                             #|line 288|#
                      #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |##|line 289|#
                        (setf  outf (cdr (assoc ' stderr  sys)))                                                        #|line 290|#
                          (print   (cdr (assoc '(srepr  )  datum))  outf )                                              #|line 291|#
                  ))))                                                                                                  #|line 292|#
)
(defun put_output (&optional  eh  msg)                                                                                  #|line 294|#
    (cdr (assoc '(cdr (assoc '(put    msg                                                                               #|line 295|#)  outq))  eh))#|line 296|#
)
(defun injector_NIY (&optional  eh  msg)                                                                                #|line 298|#
    #|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#      #|line 299|#
      (print    (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))) #|line 304|#)
        (exit  )                                                                                                        #|line 305|##|line 306|#
)                                                                                                                       #|line 312|#
(defparameter  root_project  "")                                                                                        #|line 313|#
(defparameter  root_0D  "")                                                                                             #|line 314|##|line 315|#
(defun set_environment (&optional  rproject  r0D)                                                                       #|line 316|##|line 317|##|line 318|#
        (setf  root_project  rproject)                                                                                  #|line 319|#
          (setf  root_0D  r0D)                                                                                          #|line 320|##|line 321|#
)
(defun probe_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 323|#
    (let ((name_with_id (gensymbol    "?"                                                                               #|line 324|#)))
        (return-from probe_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                            #|line 325|#)))#|line 326|#
)
(defun probeA_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 327|#
    (let ((name_with_id (gensymbol    "?A"                                                                              #|line 328|#)))
        (return-from probeA_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                           #|line 329|#)))#|line 330|#
)
(defun probeB_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 332|#
    (let ((name_with_id (gensymbol    "?B"                                                                              #|line 333|#)))
        (return-from probeB_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                           #|line 334|#)))#|line 335|#
)
(defun probeC_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 337|#
    (let ((name_with_id (gensymbol    "?C"                                                                              #|line 338|#)))
        (return-from probeC_instantiate (make_leaf    name_with_id  owner  nil  probe_handler                           #|line 339|#)))#|line 340|#
)
(defun probe_handler (&optional  eh  msg)                                                                               #|line 342|#
    (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                      #|line 343|#
        (print    (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))) (cdr (assoc ' stderr  sys)) #|line 344|#))#|line 345|#
)
(defun trash_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 347|#
    (let ((name_with_id (gensymbol    "trash"                                                                           #|line 348|#)))
        (return-from trash_instantiate (make_leaf    name_with_id  owner  nil  trash_handler                            #|line 349|#)))#|line 350|#
)
(defun trash_handler (&optional  eh  msg)                                                                               #|line 352|#
    #|  to appease dumped_on_floor checker |#                                                                           #|line 353|#
      #| pass |#                                                                                                        #|line 354|##|line 355|#
)
(defun TwoMessages (&optional  first  second)                                                                           #|line 356|#
  (list
    (cons 'first  first)                                                                                                #|line 357|#
    (cons 'second  second)                                                                                              #|line 358|#)#|line 359|#)
                                                                                                                        #|line 360|##|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |##|line 361|#
(defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 362|#
  (list
    (cons 'state  state)                                                                                                #|line 363|#
    (cons 'buffer  buffer)                                                                                              #|line 364|#)#|line 365|#)
                                                                                                                        #|line 366|#
(defun reclaim_Buffers_from_heap (&optional  inst)                                                                      #|line 367|#
    #| pass |#                                                                                                          #|line 368|##|line 369|#
)
(defun deracer_instantiate (&optional  reg  owner  name  template_data)                                                 #|line 371|#
    (let ((name_with_id (gensymbol    "deracer"                                                                         #|line 372|#)))
        (let ((inst (Deracer_Instance_Data    "idle" (TwoMessages    nil  nil )                                         #|line 373|#)))
            (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 374|#
              (let ((eh (make_leaf    name_with_id  owner  inst  deracer_handler                                        #|line 375|#)))
                  (return-from deracer_instantiate  eh)                                                                 #|line 376|#)))#|line 377|#
)
(defun send_first_then_second (&optional  eh  inst)                                                                     #|line 379|#
    (forward    eh  "1" (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                              #|line 380|#)
      (forward    eh  "2" (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                           #|line 381|#)
        (reclaim_Buffers_from_heap    inst                                                                              #|line 382|#)#|line 383|#
)
(defun deracer_handler (&optional  eh  msg)                                                                             #|line 385|#
    (setf  inst (cdr (assoc ' instance_data  eh)))                                                                      #|line 386|#
      (cond
        (( equal   (cdr (assoc ' state  inst))  "idle")                                                                 #|line 387|#
              (cond
                (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 388|#
                      (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 389|#
                        (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                          #|line 390|#
                  )
                (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 391|#
                      (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 392|#
                        (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                           #|line 393|#
                  )
                (t                                                                                                      #|line 394|#
                      (runtime_error    (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 395|#
          )
        (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                      #|line 396|#
              (cond
                (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 397|#
                      (setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 398|#
                        (send_first_then_second    eh  inst                                                             #|line 399|#)
                          (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 400|#
                  )
                (t                                                                                                      #|line 401|#
                      (runtime_error    (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 402|#
          )
        (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                     #|line 403|#
              (cond
                (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 404|#
                      (setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 405|#
                        (send_first_then_second    eh  inst                                                             #|line 406|#)
                          (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 407|#
                  )
                (t                                                                                                      #|line 408|#
                      (runtime_error    (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
                  ))                                                                                                    #|line 409|#
          )
        (t                                                                                                              #|line 410|#
              (runtime_error    "bad state for deracer {eh.state}" )                                                    #|line 411|#
          ))                                                                                                            #|line 412|#
)
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)                                #|line 414|#
    (let ((name_with_id (gensymbol    "Low Level Read Text File"                                                        #|line 415|#)))
        (return-from low_level_read_text_file_instantiate (make_leaf    name_with_id  owner  nil  low_level_read_text_file_handler #|line 416|#)))#|line 417|#
)
(defun low_level_read_text_file_handler (&optional  eh  msg)                                                            #|line 419|#
    (let ((fname (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                  #|line 420|#
        ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
        ;; given eh and msg if needed
        (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
          (with-open-file (stream fname)
            (let ((contents (make-string (file-length stream))))
              (read-sequence contents stream)
              (send_string eh "" contents))))
                                                                                                                        #|line 421|#)#|line 422|#
)
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)                                     #|line 424|#
    (let ((name_with_id (gensymbol    "Ensure String Datum"                                                             #|line 425|#)))
        (return-from ensure_string_datum_instantiate (make_leaf    name_with_id  owner  nil  ensure_string_datum_handler #|line 426|#)))#|line 427|#
)
(defun ensure_string_datum_handler (&optional  eh  msg)                                                                 #|line 429|#
    (cond
      (( equal    "string" (cdr (assoc '(cdr (assoc '(kind  )  datum))  msg)))                                          #|line 430|#
            (forward    eh  ""  msg )                                                                                   #|line 431|#
        )
      (t                                                                                                                #|line 432|#
            (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))))#|line 433|#
                (send_string    eh  "✗"  emsg  msg ))                                                                   #|line 434|#
        ))                                                                                                              #|line 435|#
)
(defun Syncfilewrite_Data (&optional )                                                                                  #|line 437|#
  (list
    (cons 'filename  "")                                                                                                #|line 438|#)#|line 439|#)
                                                                                                                        #|line 440|##|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |##|line 441|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)                                           #|line 442|#
    (let ((name_with_id (gensymbol    "syncfilewrite"                                                                   #|line 443|#)))
        (let ((inst (Syncfilewrite_Data  )))                                                                            #|line 444|#
            (return-from syncfilewrite_instantiate (make_leaf    name_with_id  owner  inst  syncfilewrite_handler       #|line 445|#))))#|line 446|#
)
(defun syncfilewrite_handler (&optional  eh  msg)                                                                       #|line 448|#
    (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 449|#
        (cond
          (( equal    "filename" (cdr (assoc ' port  msg)))                                                             #|line 450|#
                (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)))               #|line 451|#
            )
          (( equal    "input" (cdr (assoc ' port  msg)))                                                                #|line 452|#
                (let ((contents (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                   #|line 453|#
                    (let (( f (open   (cdr (assoc ' filename  inst))  "w"                                               #|line 454|#)))
                        (cond
                          ((not (equal   f  nil))                                                                       #|line 455|#
                                (cdr (assoc '(write   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))               #|line 456|#)  f))
                                  (cdr (assoc '(close  )  f))                                                           #|line 457|#
                                    (send    eh  "done" (new_datum_bang  )  msg )                                       #|line 458|#
                            )
                          (t                                                                                            #|line 459|#
                                (send_string    eh  "✗"  (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))  msg )
                            ))))                                                                                        #|line 460|#
            )))                                                                                                         #|line 461|#
)
(defun StringConcat_Instance_Data (&optional )                                                                          #|line 463|#
  (list
    (cons 'buffer1  nil)                                                                                                #|line 464|#
    (cons 'buffer2  nil)                                                                                                #|line 465|#
    (cons 'count  0)                                                                                                    #|line 466|#)#|line 467|#)
                                                                                                                        #|line 468|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)                                            #|line 469|#
    (let ((name_with_id (gensymbol    "stringconcat"                                                                    #|line 470|#)))
        (let ((instp (StringConcat_Instance_Data  )))                                                                   #|line 471|#
            (return-from stringconcat_instantiate (make_leaf    name_with_id  owner  instp  stringconcat_handler        #|line 472|#))))#|line 473|#
)
(defun stringconcat_handler (&optional  eh  msg)                                                                        #|line 475|#
    (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 476|#
        (cond
          (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 477|#
                (setf (cdr (assoc ' buffer1  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 478|#))
                  (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 479|#
                    (maybe_stringconcat    eh  inst  msg )                                                              #|line 480|#
            )
          (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 481|#
                (setf (cdr (assoc ' buffer2  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg)) #|line 482|#))
                  (setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 483|#
                    (maybe_stringconcat    eh  inst  msg )                                                              #|line 484|#
            )
          (t                                                                                                            #|line 485|#
                (runtime_error    (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))    #|line 486|#)#|line 487|#
            )))                                                                                                         #|line 488|#
)
(defun maybe_stringconcat (&optional  eh  inst  msg)                                                                    #|line 490|#
    (cond
      (( and  ( equal    0 (len   (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len   (cdr (assoc ' buffer2  inst)) )))#|line 491|#
            (runtime_error    "something is wrong in stringconcat, both strings are 0 length" )                         #|line 492|#
        ))
      (cond
        (( >=  (cdr (assoc ' count  inst))  2)                                                                          #|line 493|#
              (let (( concatenated_string  ""))                                                                         #|line 494|#
                  (cond
                    (( equal    0 (len   (cdr (assoc ' buffer1  inst)) ))                                               #|line 495|#
                          (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                     #|line 496|#
                      )
                    (( equal    0 (len   (cdr (assoc ' buffer2  inst)) ))                                               #|line 497|#
                          (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                     #|line 498|#
                      )
                    (t                                                                                                  #|line 499|#
                          (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst))))   #|line 500|#
                      ))
                    (send_string    eh  ""  concatenated_string  msg                                                    #|line 501|#)
                      (setf (cdr (assoc ' buffer1  inst))  nil)                                                         #|line 502|#
                        (setf (cdr (assoc ' buffer2  inst))  nil)                                                       #|line 503|#
                          (setf (cdr (assoc ' count  inst))  0))                                                        #|line 504|#
          ))                                                                                                            #|line 505|#
)#|  |#                                                                                                                 #|line 507|##|line 508|##|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 509|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)                                               #|line 510|#
    (let ((name_with_id (gensymbol    "shell_out"                                                                       #|line 511|#)))
        (let ((cmd (cdr (assoc '(split    template_data                                                                 #|line 512|#)  shlex))))
            (return-from shell_out_instantiate (make_leaf    name_with_id  owner  cmd  shell_out_handler                #|line 513|#))))#|line 514|#
)
(defun shell_out_handler (&optional  eh  msg)                                                                           #|line 516|#
    (let ((cmd (cdr (assoc ' instance_data  eh))))                                                                      #|line 517|#
        (let ((s (cdr (assoc '(cdr (assoc '(srepr  )  datum))  msg))))                                                  #|line 518|#
            (multiple-value-setq ( stdout  stderr) (run_command    eh  cmd  s                                           #|line 519|#))
              (cond
                ((not (equal   stderr  nil))                                                                            #|line 520|#
                      (send_string    eh  "✗"  stderr  msg )                                                            #|line 521|#
                  )
                (t                                                                                                      #|line 522|#
                      (send_string    eh  ""  stdout  msg )                                                             #|line 523|#
                  ))))                                                                                                  #|line 524|#
)
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)                                         #|line 526|##|line 527|##|line 528|#
        (let ((name_with_id (gensymbol    "strconst"                                                                    #|line 529|#)))
            (let (( s  template_data))                                                                                  #|line 530|#
                (cond
                  ((not (equal   root_project  ""))                                                                     #|line 531|#
                        (setf  s (cdr (assoc '(sub    "_00_"  root_project  s )  re)))                                  #|line 532|#
                    ))
                  (cond
                    ((not (equal   root_0D  ""))                                                                        #|line 533|#
                          (setf  s (cdr (assoc '(sub    "_0D_"  root_0D  s )  re)))                                     #|line 534|#
                      ))
                    (return-from string_constant_instantiate (make_leaf    name_with_id  owner  s  string_constant_handler #|line 535|#))))#|line 536|#
)
(defun string_constant_handler (&optional  eh  msg)                                                                     #|line 538|#
    (let ((s (cdr (assoc ' instance_data  eh))))                                                                        #|line 539|#
        (send_string    eh  ""  s  msg                                                                                  #|line 540|#))#|line 541|#
)
(defun string_make_persistent (&optional  s)                                                                            #|line 543|#
    #|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                      #|line 544|#
      (return-from string_make_persistent  s)                                                                           #|line 545|##|line 546|#
)
(defun string_clone (&optional  s)                                                                                      #|line 548|#
    (return-from string_clone  s)                                                                                       #|line 549|##|line 550|#
)                                                                                                                       #|line 553|##|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |##|line 554|##|  where ${_00_} is the root directory for the project |##|line 555|##|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |##|line 556|##|line 557|##|line 558|##|line 559|#
(defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)                            #|line 560|#
    (let ((reg (make_component_registry  )))                                                                            #|line 561|#
        (loop for diagram_source in  diagram_source_files
          do                                                                                                            #|line 562|#
              (let ((all_containers_within_single_file (json2internal    diagram_source                                 #|line 563|#)))
                  (generate_shell_components    reg  all_containers_within_single_file                                  #|line 564|#)
                    (loop for container in  all_containers_within_single_file
                      do                                                                                                #|line 565|#
                          (register_component    reg (Template   (cdr (assoc 'name  container)) #|  template_data =  |# container #|  instantiator =  |# container_instantiator ) )
                      ))                                                                                                #|line 566|#
          )
          (initialize_stock_components    reg                                                                           #|line 567|#)
            (return-from initialize_component_palette  reg)                                                             #|line 568|#)#|line 569|#
)
(defun print_error_maybe (&optional  main_container)                                                                    #|line 571|#
    (let ((error_port  "✗"))                                                                                            #|line 572|#
        (let ((err (fetch_first_output    main_container  error_port                                                    #|line 573|#)))
            (cond
              (( and  (not (equal   err  nil)) ( <   0 (len   (trimws   (cdr (assoc '(srepr  )  err)) ) )))             #|line 574|#
                    (print    "___ !!! ERRORS !!! ___"                                                                  #|line 575|#)
                      (print_specific_output    main_container  error_port  nil )                                       #|line 576|#
                ))))                                                                                                    #|line 577|#
)#|  debugging helpers |#                                                                                               #|line 579|##|line 580|#
(defun dump_outputs (&optional  main_container)                                                                         #|line 581|#
    (print  )                                                                                                           #|line 582|#
      (print    "___ Outputs ___"                                                                                       #|line 583|#)
        (print_output_list    main_container                                                                            #|line 584|#)#|line 585|#
)
(defun trace_outputs (&optional  main_container)                                                                        #|line 587|#
    (print  )                                                                                                           #|line 588|#
      (print    "___ Message Traces ___"                                                                                #|line 589|#)
        (print_routing_trace    main_container                                                                          #|line 590|#)#|line 591|#
)
(defun dump_hierarchy (&optional  main_container)                                                                       #|line 593|#
    (print  )                                                                                                           #|line 594|#
      (print    (concatenate 'string  "___ Hierarchy ___" (build_hierarchy    main_container ))                         #|line 595|#)#|line 596|#
)
(defun build_hierarchy (&optional  c)                                                                                   #|line 598|#
    (let (( s  ""))                                                                                                     #|line 599|#
        (loop for child in (cdr (assoc ' children  c))
          do                                                                                                            #|line 600|#
              (setf  s  (concatenate 'string  s (build_hierarchy    child )))                                           #|line 601|#
          )
          (let (( indent  ""))                                                                                          #|line 602|#
              (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
                do                                                                                                      #|line 603|#
                    (setf  indent (+  indent  "  "))                                                                    #|line 604|#
                )
                (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")"))))))#|line 605|#))#|line 606|#
)
(defun dump_connections (&optional  c)                                                                                  #|line 608|#
    (print  )                                                                                                           #|line 609|#
      (print    "___ connections ___"                                                                                   #|line 610|#)
        (dump_possible_connections    c                                                                                 #|line 611|#)
          (loop for child in (cdr (assoc ' children  c))
            do                                                                                                          #|line 612|#
                (print  )                                                                                               #|line 613|#
                  (dump_possible_connections    child )                                                                 #|line 614|#
            )                                                                                                           #|line 615|#
)
(defun trimws (&optional  s)                                                                                            #|line 617|#
    #|  remove whitespace from front and back of string |#                                                              #|line 618|#
      (return-from trimws (cdr (assoc '(strip  )  s)))                                                                  #|line 619|##|line 620|#
)
(defun clone_string (&optional  s)                                                                                      #|line 622|#
    (return-from clone_string  s                                                                                        #|line 623|##|line 624|#)#|line 625|#
)
(defparameter  load_errors  nil)                                                                                        #|line 626|#
(defparameter  runtime_errors  nil)                                                                                     #|line 627|##|line 628|#
(defun load_error (&optional  s)                                                                                        #|line 629|##|line 630|#
      (print    s                                                                                                       #|line 631|#)
        (quit  )                                                                                                        #|line 632|#
          (setf  load_errors  t)                                                                                        #|line 633|##|line 634|#
)
(defun runtime_error (&optional  s)                                                                                     #|line 636|##|line 637|#
      (print    s                                                                                                       #|line 638|#)
        (quit  )                                                                                                        #|line 639|#
          (setf  runtime_errors  t)                                                                                     #|line 640|##|line 641|#
)
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)                                            #|line 643|#
    (let ((instance_name (gensymbol    "fakepipe"                                                                       #|line 644|#)))
        (return-from fakepipename_instantiate (make_leaf    instance_name  owner  nil  fakepipename_handler             #|line 645|#)))#|line 646|#
)
(defparameter  rand  0)                                                                                                 #|line 648|##|line 649|#
(defun fakepipename_handler (&optional  eh  msg)                                                                        #|line 650|##|line 651|#
      (setf  rand (+  rand  1))
        #|  not very random, but good enough _ 'rand' must be unique within a single run |#                             #|line 652|#
          (send_string    eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  msg                                     #|line 653|#)#|line 654|#
)                                                                                                                       #|line 656|##|  all of the the built_in leaves are listed here |##|line 657|##|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 658|##|line 659|##|line 660|#
(defun initialize_stock_components (&optional  reg)                                                                     #|line 661|#
    (register_component    reg (Template    "1then2"  nil  deracer_instantiate )                                        #|line 662|#)
      (register_component    reg (Template    "?"  nil  probe_instantiate )                                             #|line 663|#)
        (register_component    reg (Template    "?A"  nil  probeA_instantiate )                                         #|line 664|#)
          (register_component    reg (Template    "?B"  nil  probeB_instantiate )                                       #|line 665|#)
            (register_component    reg (Template    "?C"  nil  probeC_instantiate )                                     #|line 666|#)
              (register_component    reg (Template    "trash"  nil  trash_instantiate )                                 #|line 667|#)#|line 668|#
                (register_component    reg (Template    "Low Level Read Text File"  nil  low_level_read_text_file_instantiate ) #|line 669|#)
                  (register_component    reg (Template    "Ensure String Datum"  nil  ensure_string_datum_instantiate ) #|line 670|#)#|line 671|#
                    (register_component    reg (Template    "syncfilewrite"  nil  syncfilewrite_instantiate )           #|line 672|#)
                      (register_component    reg (Template    "stringconcat"  nil  stringconcat_instantiate )           #|line 673|#)
                        #|  for fakepipe |#                                                                             #|line 674|#
                          (register_component    reg (Template    "fakepipename"  nil  fakepipename_instantiate )       #|line 675|#)#|line 676|#
)                                                                                                                       #|line 678|#
(defun initialize (&optional )                                                                                          #|line 679|#
    (let ((root_of_project  (nth  1 argv)))                                                                             #|line 680|#
        (let ((root_of_0D  (nth  2 argv)))                                                                              #|line 681|#
            (let ((arg  (nth  3 argv)))                                                                                 #|line 682|#
                (let ((main_container_name  (nth  4 argv)))                                                             #|line 683|#
                    (let ((diagram_names  (nthcdr  5 (argv))))                                                          #|line 684|#
                        (let ((palette (initialize_component_palette    root_project  root_0D  diagram_names            #|line 685|#)))
                            (return-from initialize (values  palette (list   root_of_project  root_of_0D  main_container_name  diagram_names  arg )))#|line 686|#))))))#|line 687|#
)
(defun start (&optional  palette  env)
    (start_with_debug    palette  env  nil  nil  nil  nil )                                                             #|line 689|#
)
(defun start_with_debug (&optional  palette  env  show_hierarchy  show_connections  show_traces  show_all_outputs)      #|line 690|#
    #|  show_hierarchy∷⊥, show_connections∷⊥, show_traces∷⊥, show_all_outputs∷⊥ |#                                      #|line 691|#
      (let ((root_of_project (nth  0  env)))                                                                            #|line 692|#
          (let ((root_of_0D (nth  1  env)))                                                                             #|line 693|#
              (let ((main_container_name (nth  2  env)))                                                                #|line 694|#
                  (let ((diagram_names (nth  3  env)))                                                                  #|line 695|#
                      (let ((arg (nth  4  env)))                                                                        #|line 696|#
                          (set_environment    root_of_project  root_of_0D                                               #|line 697|#)
                            #|  get entrypoint container |#                                                             #|line 698|#
                              (let (( main_container (get_component_instance    palette  main_container_name  nil       #|line 699|#)))
                                  (cond
                                    (( equal    nil  main_container)                                                    #|line 700|#
                                          (load_error    (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_names  "(check tab names, or disable compression?)")))) #|line 704|#)#|line 705|#
                                      ))
                                    (cond
                                      ( show_hierarchy                                                                  #|line 706|#
                                            (dump_hierarchy    main_container                                           #|line 707|#)#|line 708|#
                                        ))
                                      (cond
                                        ( show_connections                                                              #|line 709|#
                                              (dump_connections    main_container                                       #|line 710|#)#|line 711|#
                                          ))
                                        (cond
                                          ((not  load_errors)                                                           #|line 712|#
                                                (let (( arg (new_datum_string    arg                                    #|line 713|#)))
                                                    (let (( msg (make_message    ""  arg                                #|line 714|#)))
                                                        (inject    main_container  msg                                  #|line 715|#)
                                                          (cond
                                                            ( show_all_outputs                                          #|line 716|#
                                                                  (dump_outputs    main_container                       #|line 717|#)
                                                              )
                                                            (t                                                          #|line 718|#
                                                                  (print_error_maybe    main_container                  #|line 719|#)
                                                                    (print_specific_output    main_container  ""        #|line 720|#)
                                                                      (cond
                                                                        ( show_traces                                   #|line 721|#
                                                                              (print    "--- routing traces ---"        #|line 722|#)
                                                                                (print   (routing_trace_all    main_container ) #|line 723|#)#|line 724|#
                                                                          ))                                            #|line 725|#
                                                              ))
                                                            (cond
                                                              ( show_all_outputs                                        #|line 726|#
                                                                    (print    "--- done ---"                            #|line 727|#)#|line 728|#
                                                                ))))                                                    #|line 729|#
                                            ))))))))                                                                    #|line 730|#
)                                                                                                                       #|line 732|##|line 733|##|  utility functions  |##|line 734|#
(defun send_int (&optional  eh  port  i  causing_message)                                                               #|line 735|#
    (let ((datum (new_datum_int    i                                                                                    #|line 736|#)))
        (send    eh  port  datum  causing_message                                                                       #|line 737|#))#|line 738|#
)
(defun send_bang (&optional  eh  port  causing_message)                                                                 #|line 740|#
    (let ((datum (new_datum_bang  )))                                                                                   #|line 741|#
        (send    eh  port  datum  causing_message                                                                       #|line 742|#))#|line 743|#
)





