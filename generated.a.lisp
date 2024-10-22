
(declaim (sb-ext:muffle-conditions cl:warning))
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)

(defparameter  counter  0)                                                                                              #|line 1|##|line 2|#
(defparameter  digits (list                                                                                             #|line 3|#  "₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" ))#|line 9|##|line 10|##|line 11|#
(defun gensymbol (&optional  s)                                                                                         #|line 12|##|line 13|#
      (let ((name_with_id  (concatenate 'string  s (funcall  subscripted_digit    counter ))))                          #|line 14|#
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
          Y))                                                                                                           #|line 26|#
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
          (setf (cdr (assoc ' clone  d))  #'(lambda (&optional )(funcall  clone_datum_string    d                       #|line 40|#)))
            (setf (cdr (assoc ' reclaim  d))  #'(lambda (&optional )(funcall  reclaim_datum_string    d                 #|line 41|#)))
              (setf (cdr (assoc ' srepr  d))  #'(lambda (&optional )(funcall  srepr_datum_string    d                   #|line 42|#)))
                (setf (cdr (assoc ' raw  d))  #'(lambda (&optional )(funcall  raw_datum_string    d                     #|line 43|#)))
                  (setf (cdr (assoc ' kind  d))  #'(lambda (&optional ) "string"))                                      #|line 44|#
                    (return-from new_datum_string  d)                                                                   #|line 45|#)#|line 46|#
)
(defun clone_datum_string (&optional  d)                                                                                #|line 48|#
    (let ((d (funcall  new_datum_string   (cdr (assoc ' data  d))                                                       #|line 49|#)))
        (return-from clone_datum_string  d)                                                                             #|line 50|#)#|line 51|#
)
(defun reclaim_datum_string (&optional  src)                                                                            #|line 53|#
    #| pass |#                                                                                                          #|line 54|##|line 55|#
)
(defun srepr_datum_string (&optional  d)                                                                                #|line 57|#
    (return-from srepr_datum_string (cdr (assoc ' data  d)))                                                            #|line 58|##|line 59|#
)
(defun raw_datum_string (&optional  d)                                                                                  #|line 61|#
    (return-from raw_datum_string (funcall  bytearray   (cdr (assoc ' data  d))   "UTF_8"                               #|line 62|#))#|line 63|#
)
(defun new_datum_bang (&optional )                                                                                      #|line 65|#
    (let ((p (funcall  Datum )))                                                                                        #|line 66|#
        (setf (cdr (assoc ' data  p))  t)                                                                               #|line 67|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(funcall  clone_datum_bang    p                         #|line 68|#)))
            (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(funcall  reclaim_datum_bang    p                   #|line 69|#)))
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(funcall  srepr_datum_bang )))                      #|line 70|#
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(funcall  raw_datum_bang )))                        #|line 71|#
                  (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bang"))                                        #|line 72|#
                    (return-from new_datum_bang  p)                                                                     #|line 73|#)#|line 74|#
)
(defun clone_datum_bang (&optional  d)                                                                                  #|line 76|#
    (return-from clone_datum_bang (funcall  new_datum_bang ))                                                           #|line 77|##|line 78|#
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
    (let ((p (funcall  new_datum_bang )))                                                                               #|line 93|#
        (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "tick"))                                                  #|line 94|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(funcall  new_datum_tick )))                            #|line 95|#
            (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(funcall  srepr_datum_tick )))                        #|line 96|#
              (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(funcall  raw_datum_tick )))                          #|line 97|#
                (return-from new_datum_tick  p)                                                                         #|line 98|#)#|line 99|#
)
(defun srepr_datum_tick (&optional )                                                                                    #|line 101|#
    (return-from srepr_datum_tick  ".")                                                                                 #|line 102|##|line 103|#
)
(defun raw_datum_tick (&optional )                                                                                      #|line 105|#
    (return-from raw_datum_tick  nil)                                                                                   #|line 106|##|line 107|#
)
(defun new_datum_bytes (&optional  b)                                                                                   #|line 109|#
    (let ((p (funcall  Datum )))                                                                                        #|line 110|#
        (setf (cdr (assoc ' data  p))  b)                                                                               #|line 111|#
          (setf (cdr (assoc ' clone  p))  clone_datum_bytes)                                                            #|line 112|#
            (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(funcall  reclaim_datum_bytes    p                  #|line 113|#)))
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(funcall  srepr_datum_bytes    b                    #|line 114|#)))
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(funcall  raw_datum_bytes    b                      #|line 115|#)))
                  (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bytes"))                                       #|line 116|#
                    (return-from new_datum_bytes  p)                                                                    #|line 117|#)#|line 118|#
)
(defun clone_datum_bytes (&optional  src)                                                                               #|line 120|#
    (let ((p (funcall  Datum )))                                                                                        #|line 121|#
        (let ((p  src))                                                                                                 #|line 122|#
            (setf (cdr (assoc ' data  p)) (funcall (cdr (assoc ' clone  src)) ))                                        #|line 123|#
              (return-from clone_datum_bytes  p)                                                                        #|line 124|#))#|line 125|#
)
(defun reclaim_datum_bytes (&optional  src)                                                                             #|line 127|#
    #| pass |#                                                                                                          #|line 128|##|line 129|#
)
(defun srepr_datum_bytes (&optional  d)                                                                                 #|line 131|#
    (return-from srepr_datum_bytes (funcall (cdr (assoc '(cdr (assoc ' decode  data))  d))    "UTF_8"                   #|line 132|#))#|line 133|#
)
(defun raw_datum_bytes (&optional  d)                                                                                   #|line 134|#
    (return-from raw_datum_bytes (cdr (assoc ' data  d)))                                                               #|line 135|##|line 136|#
)
(defun new_datum_handle (&optional  h)                                                                                  #|line 138|#
    (return-from new_datum_handle (funcall  new_datum_int    h                                                          #|line 139|#))#|line 140|#
)
(defun new_datum_int (&optional  i)                                                                                     #|line 142|#
    (let ((p (funcall  Datum )))                                                                                        #|line 143|#
        (setf (cdr (assoc ' data  p))  i)                                                                               #|line 144|#
          (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(funcall  clone_int    i                                #|line 145|#)))
            (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(funcall  reclaim_int    i                          #|line 146|#)))
              (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(funcall  srepr_datum_int    i                      #|line 147|#)))
                (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(funcall  raw_datum_int    i                        #|line 148|#)))
                  (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "int"))                                         #|line 149|#
                    (return-from new_datum_int  p)                                                                      #|line 150|#)#|line 151|#
)
(defun clone_int (&optional  i)                                                                                         #|line 153|#
    (let ((p (funcall  new_datum_int    i                                                                               #|line 154|#)))
        (return-from clone_int  p)                                                                                      #|line 155|#)#|line 156|#
)
(defun reclaim_int (&optional  src)                                                                                     #|line 158|#
    #| pass |#                                                                                                          #|line 159|##|line 160|#
)
(defun srepr_datum_int (&optional  i)                                                                                   #|line 162|#
    (return-from srepr_datum_int (funcall  str    i                                                                     #|line 163|#))#|line 164|#
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
    (return-from clone_port (funcall  clone_string    s                                                                 #|line 180|#))#|line 181|#
)#|  Utility for making a `Message`. Used to safely “seed“ messages |#                                                  #|line 183|##|  entering the very top of a network. |##|line 184|#
(defun make_message (&optional  port  datum)                                                                            #|line 185|#
    (let ((p (funcall  clone_string    port                                                                             #|line 186|#)))
        (let ((m (funcall  Message  :port  p :datum (funcall (cdr (assoc ' clone  datum)) )                             #|line 187|#)))
            (return-from make_message  m)                                                                               #|line 188|#))#|line 189|#
)#|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#               #|line 191|#
(defun message_clone (&optional  message)                                                                               #|line 192|#
    (let ((m (funcall  Message  :port (funcall  clone_port   (cdr (assoc ' port  message)) ) :datum (funcall (cdr (assoc '(cdr (assoc ' clone  datum))  message)) ) #|line 193|#)))
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
            (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc ' port  m))  (concatenate 'string  "⦂"  (concatenate 'string (funcall (cdr (assoc '(cdr (assoc ' srepr  datum))  m)) )  "⟫")))))#|line 219|##|line 220|#
        Y))                                                                                                             #|line 221|#
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
    (let ((rdesc (funcall  make_Routing_Descriptor  :action  drSend :component  component :port  port :message  message #|line 248|#)))
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
    (let ((send_desc (funcall  make_Send_Descriptor  :component  sender :port  sender_port :message  msg :cause_port (cdr (assoc ' port  cause_msg)) :cause_message  cause_msg #|line 261|#)))
        (funcall  append_routing_descriptor  :container (cdr (assoc ' owner  sender)) :desc  send_desc                  #|line 262|#))#|line 263|#
)
(defun log_send_string (&optional  sender  sender_port  msg  cause_msg)                                                 #|line 265|#
    (let ((send_desc (funcall  make_Send_Descriptor    sender   sender_port   msg  (cdr (assoc ' port  cause_msg))   cause_msg #|line 266|#)))
        (funcall  append_routing_descriptor  :container (cdr (assoc ' owner  sender)) :desc  send_desc                  #|line 267|#))#|line 268|#
)
(defun fmt_send (&optional  desc  indent)                                                                               #|line 270|#
    (return-from fmt_send  ""                                                                                           #|line 271|#
        #| return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |##|line 272|#)#|line 273|#
)
(defun fmt_send_string (&optional  desc  indent)                                                                        #|line 275|#
    (return-from fmt_send_string (funcall  fmt_send    desc   indent                                                    #|line 276|#))#|line 277|#
)#|  |#                                                                                                                 #|line 279|#
(defun make_Forward_Descriptor (&optional  component  port  message  cause_port  cause_message)                         #|line 280|#
    (let ((rdesc (funcall  make_Routing_Descriptor  :action  drSend :component  component :port  port :message  message #|line 281|#)))
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
    (funcall  print    (concatenate 'string  "*** Error fmt_forward "  desc)                                            #|line 299|#)
      (funcall  quit )                                                                                                  #|line 300|##|line 301|#
)#|  |#                                                                                                                 #|line 303|#
(defun make_Inject_Descriptor (&optional  receiver  port  message)                                                      #|line 304|#
    (let ((rdesc (funcall  make_Routing_Descriptor  :action  drInject :component  receiver :port  port :message  message #|line 305|#)))
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
    (let ((inject_desc (funcall  make_Inject_Descriptor  :receiver  receiver :port  port :message  msg                  #|line 316|#)))
        (funcall  append_routing_descriptor  :container  receiver :desc  inject_desc                                    #|line 317|#))#|line 318|#
)
(defun fmt_inject (&optional  desc  indent)                                                                             #|line 320|#
    #| return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#                    #|line 321|#
      (return-from fmt_inject  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "⟹  "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'component  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'port  desc))  (concatenate 'string  " " (funcall  format_message   (cdr (assoc 'message  desc)) )))))))))#|line 328|##|line 329|#
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
    (let ((rdesc (funcall  make_Down_Descriptor    container   source_port   source_message   target   target_port   target_message #|line 346|#)))
        (funcall  append_routing_descriptor    container   rdesc                                                        #|line 347|#))#|line 348|#
)
(defun fmt_down (&optional  desc  indent)                                                                               #|line 350|#
    #| return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}' |##|line 351|#
      (return-from fmt_down  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  " ↓ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'target  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  " " (funcall  format_message   (cdr (assoc 'target_message  desc)) )))))))))))))#|line 362|##|line 363|#
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
    (let ((rdesc (funcall  make_Up_Descriptor    source   source_port   source_message   container   target_port   target_message #|line 380|#)))
        (funcall  append_routing_descriptor    container   rdesc                                                        #|line 381|#))#|line 382|#
)
(defun fmt_up (&optional  desc  indent)                                                                                 #|line 384|#
    #| return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}' |##|line 385|#
      (return-from fmt_up  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "↑ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'source  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'container_port  desc))  (concatenate 'string  " " (funcall  format_message   (cdr (assoc 'container_message  desc)) )))))))))))))#|line 396|##|line 397|#
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
    (let ((rdesc (funcall  make_Across_Descriptor    container   source   source_port   source_message   target   target_port   target_message #|line 414|#)))
        (funcall  append_routing_descriptor    container   rdesc                                                        #|line 415|#))#|line 416|#
)
(defun fmt_across (&optional  desc  indent)                                                                             #|line 418|#
    #| return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}' |##|line 419|#
      (return-from fmt_across  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "→ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'source  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'target  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  "  " (funcall  format_message   (cdr (assoc 'target_message  desc)) )))))))))))))#|line 430|##|line 431|#
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
    (let ((rdesc (funcall  make_Through_Descriptor    container   source_port   source_message   target_port   message  #|line 447|#)))
        (funcall  append_routing_descriptor    container   rdesc                                                        #|line 448|#))#|line 449|#
)
(defun fmt_through (&optional  desc  indent)                                                                            #|line 451|#
    #| return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}' |##|line 452|#
      (return-from fmt_through  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "⇶ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  " " (funcall  format_message   (cdr (assoc 'message  desc)) )))))))))))))#|line 463|##|line 464|#
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
      ((funcall (cdr (assoc '(cdr (assoc ' empty  outq))  component)) )                                                 #|line 479|#
            (funcall  log_inout_no_output  :container  container :component  component :in_message  in_message )        #|line 480|#
        )
      (t                                                                                                                #|line 481|#
            (funcall  log_inout_recursively  :container  container :component  component :in_message  in_message :out_messages (funcall  list   (cdr (assoc '(cdr (assoc ' queue  outq))  component)) ) )#|line 482|#
        Y))                                                                                                             #|line 483|#
)
(defun log_inout_no_output (&optional  container  component  in_message)                                                #|line 485|#
    (let ((rdesc (funcall  make_InOut_Descriptor  :container  container :component  component :in_message  in_message   #|line 486|#:out_port  nil :out_message  nil #|line 487|#)))
        (funcall  append_routing_descriptor    container   rdesc                                                        #|line 488|#))#|line 489|#
)
(defun log_inout_single (&optional  container  component  in_message  out_message)                                      #|line 491|#
    (let ((rdesc (funcall  make_InOut_Descriptor  :container  container :component  component :in_message  in_message   #|line 492|#:out_port  nil :out_message  out_message #|line 493|#)))
        (funcall  append_routing_descriptor    container   rdesc                                                        #|line 494|#))#|line 495|#
)
(defun log_inout_recursively (&optional  container  component  in_message  (out_messages  nil))                         #|line 497|#
    (cond
      (( equal    nil  out_messages)                                                                                    #|line 498|#
            #| pass |#                                                                                                  #|line 499|#
        )
      (t                                                                                                                #|line 500|#
            (let ((m  (car  out_messages)))                                                                             #|line 501|#
                (let ((rest  (cdr  out_messages)))                                                                      #|line 502|#
                    (funcall  log_inout_single  :container  container :component  component :in_message  in_message :out_message  m #|line 503|#)
                      (funcall  log_inout_recursively  :container  container :component  component :in_message  in_message :out_messages  rest )))#|line 504|#
        Y))                                                                                                             #|line 505|#
)
(defun fmt_inout (&optional  desc  indent)                                                                              #|line 507|#
    (let ((outm (cdr (assoc 'out_message  desc))))                                                                      #|line 508|#
        (cond
          (( equal    nil  outm)                                                                                        #|line 509|#
                (return-from fmt_inout  (concatenate 'string  "\n"  (concatenate 'string  indent  "  ⊥")))              #|line 510|#
            )
          (t                                                                                                            #|line 511|#
                (return-from fmt_inout  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "  ∴ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'component  desc))))  (concatenate 'string  " " (funcall  format_message    outm )))))))#|line 516|##|line 517|#
            Y)))                                                                                                        #|line 518|#
)
(defun log_tick (&optional  container  component  in_message)                                                           #|line 520|#
    #| pass |#                                                                                                          #|line 521|##|line 522|#
)#|  |#                                                                                                                 #|line 524|#
(defun routing_trace_all (&optional  container)                                                                         #|line 525|#
    (let ((indent  ""))                                                                                                 #|line 526|#
        (let ((lis (funcall  list   (cdr (assoc '(cdr (assoc ' queue  routings))  container))                           #|line 527|#)))
            (return-from routing_trace_all (funcall  recursive_routing_trace    container   lis   indent                #|line 528|#))))#|line 529|#
)
(defun recursive_routing_trace (&optional  container  lis  indent)                                                      #|line 531|#
    (cond
      (( equal    nil  lis)                                                                                             #|line 532|#
            (return-from recursive_routing_trace  "")                                                                   #|line 533|#
        )
      (t                                                                                                                #|line 534|#
            (let ((desc (funcall  first    lis                                                                          #|line 535|#)))
                (let ((formatted (funcall (cdr (assoc 'fmt  desc))    desc   indent                                     #|line 536|#)))
                    (return-from recursive_routing_trace (+  formatted (funcall  recursive_routing_trace    container  (funcall  rest    lis )  (+  indent  "  ") )))))#|line 537|#
        Y))                                                                                                             #|line 538|#
)
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                                                                                          #|line 544|#
(defun container_instantiator (&optional  reg  owner  container_name  desc)                                             #|line 545|##|line 546|#
      (let ((container (funcall  make_container    container_name   owner                                               #|line 547|#)))
          (let ((children  nil))                                                                                        #|line 548|#
              (let ((children_by_id  nil))
                  #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#         #|line 549|#
                    #|  collect children |#                                                                             #|line 550|#
                      (loop for child_desc in (cdr (assoc 'children  desc))
                        do                                                                                              #|line 551|#
                            (let ((child_instance (funcall  get_component_instance    reg  (cdr (assoc 'name  child_desc))   container #|line 552|#)))
                                (funcall (cdr (assoc ' append  children))    child_instance                             #|line 553|#)
                                  (setf (nth (cdr (assoc 'id  child_desc))  children_by_id)  child_instance))           #|line 554|#
                        )
                        (setf (cdr (assoc ' children  container))  children)                                            #|line 555|#
                          (let ((me  container))                                                                        #|line 556|##|line 557|#
                                (let ((connectors  nil))                                                                #|line 558|#
                                    (loop for proto_conn in (cdr (assoc 'connections  desc))
                                      do                                                                                #|line 559|#
                                          (let ((source_component  nil))                                                #|line 560|#
                                              (let ((target_component  nil))                                            #|line 561|#
                                                  (let ((connector (funcall  Connector )))                              #|line 562|#
                                                      (cond
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumDown)            #|line 563|#
                                                              #|  JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |##|line 564|#
                                                                (setf (cdr (assoc ' direction  connector))  "down")     #|line 565|#
                                                                  (setf (cdr (assoc ' sender  connector)) (funcall  Sender   (cdr (assoc ' name  me))   me  (cdr (assoc 'source_port  proto_conn)) #|line 566|#))
                                                                    (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 567|#
                                                                        (cond
                                                                          (( equal    target_component  nil)            #|line 568|#
                                                                                (funcall  load_error    (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc 'target  proto_conn))) )#|line 569|#
                                                                            )
                                                                          (t                                            #|line 570|#
                                                                                (setf (cdr (assoc ' receiver  connector)) (funcall  Receiver   (cdr (assoc ' name  target_component))  (cdr (assoc ' inq  target_component))  (cdr (assoc 'target_port  proto_conn))   target_component #|line 571|#))
                                                                                  (funcall (cdr (assoc ' append  connectors))    connector )
                                                                            Y)))                                        #|line 572|#
                                                          )
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumAcross)          #|line 573|#
                                                              (setf (cdr (assoc ' direction  connector))  "across")     #|line 574|#
                                                                (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 575|#
                                                                    (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 576|#
                                                                        (cond
                                                                          (( equal    source_component  nil)            #|line 577|#
                                                                                (funcall  load_error    (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 578|#
                                                                            )
                                                                          (t                                            #|line 579|#
                                                                                (setf (cdr (assoc ' sender  connector)) (funcall  Sender   (cdr (assoc ' name  source_component))   source_component  (cdr (assoc 'source_port  proto_conn)) #|line 580|#))
                                                                                  (cond
                                                                                    (( equal    target_component  nil)  #|line 581|#
                                                                                          (funcall  load_error    (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc ' target  proto_conn))) )#|line 582|#
                                                                                      )
                                                                                    (t                                  #|line 583|#
                                                                                          (setf (cdr (assoc ' receiver  connector)) (funcall  Receiver   (cdr (assoc ' name  target_component))  (cdr (assoc ' inq  target_component))  (cdr (assoc 'target_port  proto_conn))   target_component #|line 584|#))
                                                                                            (funcall (cdr (assoc ' append  connectors))    connector )
                                                                                      Y))
                                                                            Y))))                                       #|line 585|#
                                                          B)
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumUp)              #|line 586|#
                                                              (setf (cdr (assoc ' direction  connector))  "up")         #|line 587|#
                                                                (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 588|#
                                                                    (cond
                                                                      (( equal    source_component  nil)                #|line 589|#
                                                                            (funcall  print    (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 590|#
                                                                        )
                                                                      (t                                                #|line 591|#
                                                                            (setf (cdr (assoc ' sender  connector)) (funcall  Sender   (cdr (assoc ' name  source_component))   source_component  (cdr (assoc 'source_port  proto_conn)) #|line 592|#))
                                                                              (setf (cdr (assoc ' receiver  connector)) (funcall  Receiver   (cdr (assoc ' name  me))  (cdr (assoc ' outq  container))  (cdr (assoc 'target_port  proto_conn))   me #|line 593|#))
                                                                                (funcall (cdr (assoc ' append  connectors))    connector )
                                                                        Y)))                                            #|line 594|#
                                                          B)
                                                        (( equal   (cdr (assoc 'dir  proto_conn))  enumThrough)         #|line 595|#
                                                              (setf (cdr (assoc ' direction  connector))  "through")    #|line 596|#
                                                                (setf (cdr (assoc ' sender  connector)) (funcall  Sender   (cdr (assoc ' name  me))   me  (cdr (assoc 'source_port  proto_conn)) #|line 597|#))
                                                                  (setf (cdr (assoc ' receiver  connector)) (funcall  Receiver   (cdr (assoc ' name  me))  (cdr (assoc ' outq  container))  (cdr (assoc 'target_port  proto_conn))   me #|line 598|#))
                                                                    (funcall (cdr (assoc ' append  connectors))    connector )
                                                          B)))))                                                        #|line 599|#
                                      )                                                                                 #|line 600|#
                                      (setf (cdr (assoc ' connections  container))  connectors)                         #|line 601|#
                                        (return-from container_instantiator  container)                                 #|line 602|#)))))#|line 603|#
)#|  The default handler for container components. |#                                                                   #|line 605|#
(defun container_handler (&optional  container  message)                                                                #|line 606|#
    (funcall  route  :container  container :from_component  container :message  message )
      #|  references to 'self' are replaced by the container during instantiation |#                                    #|line 607|#
        (loop while (funcall  any_child_ready    container )
          do                                                                                                            #|line 608|#
              (funcall  step_children    container   message )                                                          #|line 609|#
          )                                                                                                             #|line 610|#
)#|  Frees the given container and associated data. |#                                                                  #|line 612|#
(defun destroy_container (&optional  eh)                                                                                #|line 613|#
    #| pass |#                                                                                                          #|line 614|##|line 615|#
)
(defun fifo_is_empty (&optional  fifo)                                                                                  #|line 617|#
    (return-from fifo_is_empty (funcall (cdr (assoc ' empty  fifo)) ))                                                  #|line 618|##|line 619|#
)#|  Routing connection for a container component. The `direction` field has |#                                         #|line 621|##|  no affect on the default message routing system _ it is there for debugging |##|line 622|##|  purposes, or for reading by other tools. |##|line 623|##|line 624|#
(defun Connector (&optional )                                                                                           #|line 625|#
  (list
    (cons 'direction  nil) #|  down, across, up, through |#                                                             #|line 626|#
    (cons 'sender  nil)                                                                                                 #|line 627|#
    (cons 'receiver  nil)                                                                                               #|line 628|#)#|line 629|#)
                                                                                                                        #|line 630|##|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |##|line 631|##|  based on component ID (pointer) and port name. |##|line 632|##|line 633|#
(defun Sender (&optional  name  component  port)                                                                        #|line 634|#
  (list
    (cons 'name  name)                                                                                                  #|line 635|#
    (cons 'component  component) #|  from |#                                                                            #|line 636|#
    (cons 'port  port) #|  from's port |#                                                                               #|line 637|#)#|line 638|#)
                                                                                                                        #|line 639|##|  `Receiver` is a handle to a destination queue, and a `port` name to assign |##|line 640|##|  to incoming messages to this queue. |##|line 641|##|line 642|#
(defun Receiver (&optional  name  queue  port  component)                                                               #|line 643|#
  (list
    (cons 'name  name)                                                                                                  #|line 644|#
    (cons 'queue  queue) #|  queue (input | output) of receiver |#                                                      #|line 645|#
    (cons 'port  port) #|  destination port |#                                                                          #|line 646|#
    (cons 'component  component) #|  to (for bootstrap debug) |#                                                        #|line 647|#)#|line 648|#)
                                                                                                                        #|line 649|##|  Checks if two senders match, by pointer equality and port name matching. |##|line 650|#
(defun sender_eq (&optional  s1  s2)                                                                                    #|line 651|#
    (let ((same_components ( equal   (cdr (assoc ' component  s1)) (cdr (assoc ' component  s2)))))                     #|line 652|#
        (let ((same_ports ( equal   (cdr (assoc ' port  s1)) (cdr (assoc ' port  s2)))))                                #|line 653|#
            (return-from sender_eq ( and   same_components  same_ports))                                                #|line 654|#))#|line 655|#
)#|  Delivers the given message to the receiver of this connector. |#                                                   #|line 657|##|line 658|#
(defun deposit (&optional  parent  conn  message)                                                                       #|line 659|#
    (let ((new_message (funcall  make_message  :port (cdr (assoc '(cdr (assoc ' port  receiver))  conn)) :datum (cdr (assoc ' datum  message)) #|line 660|#)))
        (funcall  log_connection    parent   conn   new_message                                                         #|line 661|#)
          (funcall  push_message    parent  (cdr (assoc '(cdr (assoc ' component  receiver))  conn))  (cdr (assoc '(cdr (assoc ' queue  receiver))  conn))   new_message #|line 662|#))#|line 663|#
)
(defun force_tick (&optional  parent  eh)                                                                               #|line 665|#
    (let ((tick_msg (funcall  make_message    "."  (funcall  new_datum_tick )                                           #|line 666|#)))
        (funcall  push_message    parent   eh  (cdr (assoc ' inq  eh))   tick_msg                                       #|line 667|#)
          (return-from force_tick  tick_msg)                                                                            #|line 668|#)#|line 669|#
)
(defun push_message (&optional  parent  receiver  inq  m)                                                               #|line 671|#
    (funcall (cdr (assoc ' put  inq))    m                                                                              #|line 672|#)
      (funcall (cdr (assoc '(cdr (assoc ' put  visit_ordering))  parent))    receiver                                   #|line 673|#)#|line 674|#
)
(defun is_self (&optional  child  container)                                                                            #|line 676|#
    #|  in an earlier version “self“ was denoted as ϕ |#                                                                #|line 677|#
      (return-from is_self ( equal    child  container))                                                                #|line 678|##|line 679|#
)
(defun step_child (&optional  child  msg)                                                                               #|line 681|#
    (let ((before_state (cdr (assoc ' state  child))))                                                                  #|line 682|#
        (funcall (cdr (assoc ' handler  child))    child   msg                                                          #|line 683|#)
          (let ((after_state (cdr (assoc ' state  child))))                                                             #|line 684|#
              (return-from step_child (values undefined undefined))                                                     #|line 687|#))#|line 688|#
)
(defun save_message (&optional  eh  msg)                                                                                #|line 690|#
    (funcall (cdr (assoc '(cdr (assoc ' put  saved_messages))  eh))    msg                                              #|line 691|#)#|line 692|#
)
(defun fetch_saved_message_and_clear (&optional  eh)                                                                    #|line 694|#
    (return-from fetch_saved_message_and_clear (funcall (cdr (assoc '(cdr (assoc ' get  saved_messages))  eh)) ))       #|line 695|##|line 696|#
)
(defun step_children (&optional  container  causingMessage)                                                             #|line 698|#
    (setf (cdr (assoc ' state  container))  "idle")                                                                     #|line 699|#
      (loop for child in (funcall  list   (cdr (assoc '(cdr (assoc ' queue  visit_ordering))  container)) )
        do                                                                                                              #|line 700|#
            #|  child = container represents self, skip it |#                                                           #|line 701|#
              (cond
                ((not (funcall  is_self    child   container ))                                                         #|line 702|#
                      (cond
                        ((not (funcall (cdr (assoc '(cdr (assoc ' empty  inq))  child)) ))                              #|line 703|#
                              (let ((msg (funcall (cdr (assoc '(cdr (assoc ' get  inq))  child)) )))                    #|line 704|#
                                  (multiple-value-setq ( began_long_run  continued_long_run  ended_long_run) (funcall  step_child    child   msg #|line 705|#))
                                    (cond
                                      ( began_long_run                                                                  #|line 706|#
                                            (funcall  save_message    child   msg )                                     #|line 707|#
                                        )
                                      ( continued_long_run                                                              #|line 708|#
                                            #| pass |#                                                                  #|line 709|#
                                        B)
                                      ( ended_long_run                                                                  #|line 710|#
                                            (funcall  log_inout  :container  container :component  child :in_message (funcall  fetch_saved_message_and_clear    child ) )#|line 711|#
                                        B)
                                      (t                                                                                #|line 712|#
                                            (funcall  log_inout  :container  container :component  child :in_message  msg )#|line 713|#
                                        Y))
                                      (funcall  destroy_message    msg ))                                               #|line 714|#
                          )
                        (t                                                                                              #|line 715|#
                              (cond
                                ((not (equal  (cdr (assoc ' state  child))  "idle"))                                    #|line 716|#
                                      (let ((msg (funcall  force_tick    container   child                              #|line 717|#)))
                                          (funcall (cdr (assoc ' handler  child))    child   msg                        #|line 718|#)
                                            (funcall  log_tick  :container  container :component  child :in_message  msg #|line 719|#)
                                              (funcall  destroy_message    msg ))
                                  ))                                                                                    #|line 720|#
                          Y))                                                                                           #|line 721|#
                        (cond
                          (( equal   (cdr (assoc ' state  child))  "active")                                            #|line 722|#
                                #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |##|line 723|#
                                  (setf (cdr (assoc ' state  container))  "active")                                     #|line 724|#
                            ))                                                                                          #|line 725|#
                          (loop while (not (funcall (cdr (assoc '(cdr (assoc ' empty  outq))  child)) ))
                            do                                                                                          #|line 726|#
                                (let ((msg (funcall (cdr (assoc '(cdr (assoc ' get  outq))  child)) )))                 #|line 727|#
                                    (funcall  route    container   child   msg                                          #|line 728|#)
                                      (funcall  destroy_message    msg ))
                            )
                  ))                                                                                                    #|line 729|#
        )                                                                                                               #|line 730|##|line 731|##|line 732|#
)
(defun attempt_tick (&optional  parent  eh)                                                                             #|line 734|#
    (cond
      ((not (equal  (cdr (assoc ' state  eh))  "idle"))                                                                 #|line 735|#
            (funcall  force_tick    parent   eh )                                                                       #|line 736|#
        ))                                                                                                              #|line 737|#
)
(defun is_tick (&optional  msg)                                                                                         #|line 739|#
    (return-from is_tick ( equal    "tick" (funcall (cdr (assoc '(cdr (assoc ' kind  datum))  msg)) )))                 #|line 740|##|line 741|#
)#|  Routes a single message to all matching destinations, according to |#                                              #|line 743|##|  the container's connection network. |##|line 744|##|line 745|#
(defun route (&optional  container  from_component  message)                                                            #|line 746|#
    (let (( was_sent  nil))
        #|  for checking that output went somewhere (at least during bootstrap) |#                                      #|line 747|#
          (let (( fromname  ""))                                                                                        #|line 748|#
              (cond
                ((funcall  is_tick    message )                                                                         #|line 749|#
                      (loop for child in (cdr (assoc ' children  container))
                        do                                                                                              #|line 750|#
                            (funcall  attempt_tick    container   child   message )                                     #|line 751|#
                        )
                        (setf  was_sent  t)                                                                             #|line 752|#
                  )
                (t                                                                                                      #|line 753|#
                      (cond
                        ((not (funcall  is_self    from_component   container ))                                        #|line 754|#
                              (setf  fromname (cdr (assoc ' name  from_component)))                                     #|line 755|#
                          ))
                        (let ((from_sender (funcall  Sender  :name  fromname :component  from_component :port (cdr (assoc ' port  message)) #|line 756|#)))#|line 757|#
                            (loop for connector in (cdr (assoc ' connections  container))
                              do                                                                                        #|line 758|#
                                  (cond
                                    ((funcall  sender_eq    from_sender  (cdr (assoc ' sender  connector)) )            #|line 759|#
                                          (funcall  deposit    container   connector   message                          #|line 760|#)
                                            (setf  was_sent  t)
                                      ))
                              ))                                                                                        #|line 761|#
                  Y))
                (cond
                  ((not  was_sent)                                                                                      #|line 762|#
                        (funcall  print    "\n\n*** Error: ***"                                                         #|line 763|#)
                          (funcall  dump_possible_connections    container                                              #|line 764|#)
                            (funcall  print_routing_trace    container                                                  #|line 765|#)
                              (funcall  print    "***"                                                                  #|line 766|#)
                                (funcall  print    (concatenate 'string (cdr (assoc ' name  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor..."))))) #|line 767|#)
                                  (funcall  print    "***"                                                              #|line 768|#)
                                    (funcall  exit )                                                                    #|line 769|#
                    ))))                                                                                                #|line 770|#
)
(defun dump_possible_connections (&optional  container)                                                                 #|line 772|#
    (funcall  print    (concatenate 'string  "*** possible connections for "  (concatenate 'string (cdr (assoc ' name  container))  ":")) #|line 773|#)
      (loop for connector in (cdr (assoc ' connections  container))
        do                                                                                                              #|line 774|#
            (funcall  print    (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  " "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  sender))  connector))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc '(cdr (assoc ' port  sender))  connector))  (concatenate 'string  " -> "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  receiver))  connector))  (concatenate 'string  "." (cdr (assoc '(cdr (assoc ' port  receiver))  connector)))))))))) )#|line 775|#
        )                                                                                                               #|line 776|#
)
(defun any_child_ready (&optional  container)                                                                           #|line 778|#
    (loop for child in (cdr (assoc ' children  container))
      do                                                                                                                #|line 779|#
          (cond
            ((funcall  child_is_ready    child )                                                                        #|line 780|#
                  (return-from any_child_ready  t)
              ))                                                                                                        #|line 781|#
      )
      (return-from any_child_ready  nil)                                                                                #|line 782|##|line 783|#
)
(defun child_is_ready (&optional  eh)                                                                                   #|line 785|#
    (return-from child_is_ready ( or  ( or  ( or  (not (funcall (cdr (assoc '(cdr (assoc ' empty  outq))  eh)) )) (not (funcall (cdr (assoc '(cdr (assoc ' empty  inq))  eh)) ))) (not (equal  (cdr (assoc ' state  eh))  "idle"))) (funcall  any_child_ready    eh )))#|line 786|##|line 787|#
)
(defun print_routing_trace (&optional  eh)                                                                              #|line 789|#
    (funcall  print   (funcall  routing_trace_all    eh )                                                               #|line 790|#)#|line 791|#
)
(defun append_routing_descriptor (&optional  container  desc)                                                           #|line 793|#
    (funcall (cdr (assoc '(cdr (assoc ' put  routings))  container))    desc                                            #|line 794|#)#|line 795|#
)
(defun log_connection (&optional  container  connector  message)                                                        #|line 797|#
    (cond
      (( equal    "down" (cdr (assoc ' direction  connector)))                                                          #|line 798|#
            (funcall  log_down  :container  container                                                                   #|line 799|#:source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) #|line 800|#:source_message  nil #|line 801|#:target (cdr (assoc '(cdr (assoc ' component  receiver))  connector)) #|line 802|#:target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) #|line 803|#:target_message  message )#|line 804|#
        )
      (( equal    "up" (cdr (assoc ' direction  connector)))                                                            #|line 805|#
            (funcall  log_up  :source (cdr (assoc '(cdr (assoc ' component  sender))  connector)) :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) :source_message  nil :container  container :target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) #|line 806|#:target_message  message )#|line 807|#
        B)
      (( equal    "across" (cdr (assoc ' direction  connector)))                                                        #|line 808|#
            (funcall  log_across  :container  container                                                                 #|line 809|#:source (cdr (assoc '(cdr (assoc ' component  sender))  connector)) :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) :source_message  nil #|line 810|#:target (cdr (assoc '(cdr (assoc ' component  receiver))  connector)) :target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) :target_message  message )#|line 811|#
        B)
      (( equal    "through" (cdr (assoc ' direction  connector)))                                                       #|line 812|#
            (funcall  log_through  :container  container :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) :source_message  nil #|line 813|#:target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) :message  message )#|line 814|#
        B)
      (t                                                                                                                #|line 815|#
            (funcall  print    (concatenate 'string  "*** FATAL error: in log_connection /"  (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  "/ /"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "/ /"  (concatenate 'string (funcall (cdr (assoc '(cdr (assoc ' srepr  datum))  message)) )  "/")))))) #|line 816|#)
              (funcall  exit )                                                                                          #|line 817|#
        Y))                                                                                                             #|line 818|#
)
(defun container_injector (&optional  container  message)                                                               #|line 820|#
    (funcall  log_inject  :receiver  container :port (cdr (assoc ' port  message)) :msg  message                        #|line 821|#)
      (funcall  container_handler    container   message                                                                #|line 822|#)#|line 823|#
)




