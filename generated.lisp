
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)

(defparameter  counter  0)                                                                                              #|line 1|#
#|line 2|#

(defparameter  digits (list                                                                                             #|line 3|#
			"₀"  "₁"  "₂"  "₃"  "₄"  "₅"  "₆"  "₇"  "₈"  "₉"  "₁₀"  "₁₁"  "₁₂"  "₁₃"  "₁₄"  "₁₅"  "₁₆"  "₁₇"  "₁₈"  "₁₉"  "₂₀"  "₂₁"  "₂₂"  "₂₃"  "₂₄"  "₂₅"  "₂₆"  "₂₇"  "₂₈"  "₂₉" ))#|line 9|#
#|line 10|#
#|line 11|#

(defun gensymbol (&optional  s)                                                                                         #|line 12|#
  #|line 13|#

  (let ((name_with_id  (concatenate 'string  s (subscripted_digit    counter ))))                                   #|line 14|#

    (setf  counter (+  counter  1))                                                                               #|line 15|#

    (return-from gensymbol  name_with_id)                                                                       #|line 16|#
    )                                                                                                             #|line 17|#

  )
(defun subscripted_digit (&optional  n)                                                                                 #|line 19|#
  #|line 20|#

  (cond
    (( and  ( >=   n  0) ( <=   n  29))                                                                             #|line 21|#

      (return-from subscripted_digit (nth  n  digits))                                                          #|line 22|#

      )
    (t                                                                                                              #|line 23|#

      (return-from subscripted_digit  (concatenate 'string  "₊"  n))                                            #|line 24|#
      #|line 25|#

      ))                                                                                                            #|line 26|#

  )
(defun Datum (&optional )                                                                                               #|line 28|#

  (list
    (cons 'data  nil)                                                                                                   #|line 29|#

    (cons 'clone  nil)                                                                                                  #|line 30|#

    (cons 'reclaim  nil)                                                                                                #|line 31|#

    (cons 'srepr  nil)                                                                                                  #|line 32|#

    (cons 'kind  nil)                                                                                                   #|line 33|#

    (cons 'raw  nil)                                                                                                    #|line 34|#
    )                                                                                                                   #|line 35|#
  )
#|line 36|#

(defun new_datum_string (&optional  s)                                                                                  #|line 37|#

  (let ((d  (Datum)))                                                                                                 #|line 38|#

    (setf (cdr (assoc ' data  d))  s)                                                                               #|line 39|#

    (setf (cdr (assoc ' clone  d))  #'(lambda (&optional )(clone_datum_string    d                                #|line 40|#
							    )))
    (setf (cdr (assoc ' reclaim  d))  #'(lambda (&optional )(reclaim_datum_string    d                          #|line 41|#
							      )))
    (setf (cdr (assoc ' srepr  d))  #'(lambda (&optional )(srepr_datum_string    d                            #|line 42|#
							    )))
    (setf (cdr (assoc ' raw  d))  #'(lambda (&optional )(raw_datum_string    d                              #|line 43|#
							  )))
    (setf (cdr (assoc ' kind  d))  #'(lambda (&optional ) "string"))                                      #|line 44|#

    (return-from new_datum_string  d)                                                                   #|line 45|#
    )                                                                                                     #|line 46|#

  )
(defun clone_datum_string (&optional  d)                                                                                #|line 48|#

  (let ((d (new_datum_string   (cdr (assoc ' data  d))                                                                #|line 49|#
	     )))
    (return-from clone_datum_string  d)                                                                             #|line 50|#
    )                                                                                                                 #|line 51|#

  )
(defun reclaim_datum_string (&optional  src)                                                                            #|line 53|#

  #| pass |#                                                                                                          #|line 54|#
  #|line 55|#

  )
(defun srepr_datum_string (&optional  d)                                                                                #|line 57|#

  (return-from srepr_datum_string (cdr (assoc ' data  d)))                                                            #|line 58|#
  #|line 59|#

  )
(defun raw_datum_string (&optional  d)                                                                                  #|line 61|#

  (return-from raw_datum_string (bytearray   (cdr (assoc ' data  d))   "UTF_8"                                        #|line 62|#
				  ))                                                                                                                #|line 63|#

  )
(defun new_datum_bang (&optional )                                                                                      #|line 65|#

  (let ((p (Datum )))                                                                                                 #|line 66|#

    (setf (cdr (assoc ' data  p))  t)                                                                               #|line 67|#

    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_datum_bang    p                                  #|line 68|#
							    )))
    (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bang    p                            #|line 69|#
							      )))
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bang )))                               #|line 70|#

    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bang )))                                 #|line 71|#

    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bang"))                                        #|line 72|#

    (return-from new_datum_bang  p)                                                                     #|line 73|#
    )                                                                                                     #|line 74|#

  )
(defun clone_datum_bang (&optional  d)                                                                                  #|line 76|#

  (return-from clone_datum_bang (new_datum_bang ))                                                                    #|line 77|#
  #|line 78|#

  )
(defun reclaim_datum_bang (&optional  d)                                                                                #|line 80|#

  #| pass |#                                                                                                          #|line 81|#
  #|line 82|#

  )
(defun srepr_datum_bang (&optional )                                                                                    #|line 84|#

  (return-from srepr_datum_bang  "!")                                                                                 #|line 85|#
  #|line 86|#

  )
(defun raw_datum_bang (&optional )                                                                                      #|line 88|#

  (return-from raw_datum_bang  nil)                                                                                   #|line 89|#
  #|line 90|#

  )
(defun new_datum_tick (&optional )                                                                                      #|line 92|#

  (let ((p (new_datum_bang )))                                                                                        #|line 93|#

    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "tick"))                                                  #|line 94|#

    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(new_datum_tick )))                                     #|line 95|#

    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_tick )))                                 #|line 96|#

    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_tick )))                                   #|line 97|#

    (return-from new_datum_tick  p)                                                                         #|line 98|#
    )                                                                                                         #|line 99|#

  )
(defun srepr_datum_tick (&optional )                                                                                    #|line 101|#

  (return-from srepr_datum_tick  ".")                                                                                 #|line 102|#
  #|line 103|#

  )
(defun raw_datum_tick (&optional )                                                                                      #|line 105|#

  (return-from raw_datum_tick  nil)                                                                                   #|line 106|#
  #|line 107|#

  )
(defun new_datum_bytes (&optional  b)                                                                                   #|line 109|#

  (let ((p (Datum )))                                                                                                 #|line 110|#

    (setf (cdr (assoc ' data  p))  b)                                                                               #|line 111|#

    (setf (cdr (assoc ' clone  p))  clone_datum_bytes)                                                            #|line 112|#

    (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_datum_bytes    p                           #|line 113|#
							      )))
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_bytes    b                             #|line 114|#
							    )))
    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_bytes    b                               #|line 115|#
							  )))
    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "bytes"))                                       #|line 116|#

    (return-from new_datum_bytes  p)                                                                    #|line 117|#
    )                                                                                                     #|line 118|#

  )
(defun clone_datum_bytes (&optional  src)                                                                               #|line 120|#

  (let ((p (Datum )))                                                                                                 #|line 121|#

    (let ((p  src))                                                                                                 #|line 122|#

      (setf (cdr (assoc ' data  p)) (cdr (assoc '(clone )  src)))                                                 #|line 123|#

      (return-from clone_datum_bytes  p)                                                                        #|line 124|#
      ))                                                                                                          #|line 125|#

  )
(defun reclaim_datum_bytes (&optional  src)                                                                             #|line 127|#

  #| pass |#                                                                                                          #|line 128|#
  #|line 129|#

  )
(defun srepr_datum_bytes (&optional  d)                                                                                 #|line 131|#

  (return-from srepr_datum_bytes (cdr (assoc '(cdr (assoc '(decode    "UTF_8"                                         #|line 132|#
							     )  data))  d)))                                                                                                   #|line 133|#

  )
(defun raw_datum_bytes (&optional  d)                                                                                   #|line 134|#

  (return-from raw_datum_bytes (cdr (assoc ' data  d)))                                                               #|line 135|#
  #|line 136|#

  )
(defun new_datum_handle (&optional  h)                                                                                  #|line 138|#

  (return-from new_datum_handle (new_datum_int    h                                                                   #|line 139|#
				  ))                                                                                                                #|line 140|#

  )
(defun new_datum_int (&optional  i)                                                                                     #|line 142|#

  (let ((p (Datum )))                                                                                                 #|line 143|#

    (setf (cdr (assoc ' data  p))  i)                                                                               #|line 144|#

    (setf (cdr (assoc ' clone  p))  #'(lambda (&optional )(clone_int    i                                         #|line 145|#
							    )))
    (setf (cdr (assoc ' reclaim  p))  #'(lambda (&optional )(reclaim_int    i                                   #|line 146|#
							      )))
    (setf (cdr (assoc ' srepr  p))  #'(lambda (&optional )(srepr_datum_int    i                               #|line 147|#
							    )))
    (setf (cdr (assoc ' raw  p))  #'(lambda (&optional )(raw_datum_int    i                                 #|line 148|#
							  )))
    (setf (cdr (assoc ' kind  p))  #'(lambda (&optional ) "int"))                                         #|line 149|#

    (return-from new_datum_int  p)                                                                      #|line 150|#
    )                                                                                                     #|line 151|#

  )
(defun clone_int (&optional  i)                                                                                         #|line 153|#

  (let ((p (new_datum_int    i                                                                                        #|line 154|#
	     )))
    (return-from clone_int  p)                                                                                      #|line 155|#
    )                                                                                                                 #|line 156|#

  )
(defun reclaim_int (&optional  src)                                                                                     #|line 158|#

  #| pass |#                                                                                                          #|line 159|#
  #|line 160|#

  )
(defun srepr_datum_int (&optional  i)                                                                                   #|line 162|#

  (return-from srepr_datum_int (str    i                                                                              #|line 163|#
				 ))                                                                                                                #|line 164|#

  )
(defun raw_datum_int (&optional  i)                                                                                     #|line 166|#

  (return-from raw_datum_int  i)                                                                                      #|line 167|#
  #|line 168|#

  )#|  Message passed to a leaf component. |#                                                                             #|line 170|#
#|  |#                                                                                                                  #|line 171|#
#|  `port` refers to the name of the incoming or outgoing port of this component. |#                                    #|line 172|#
#|  `datum` is the data attached to this message. |#                                                                    #|line 173|#

(defun Message (&optional  port  datum)                                                                                 #|line 174|#

  (list
    (cons 'port  port)                                                                                                  #|line 175|#

    (cons 'datum  datum)                                                                                                #|line 176|#
    )                                                                                                                   #|line 177|#
  )
#|line 178|#

(defun clone_port (&optional  s)                                                                                        #|line 179|#

  (return-from clone_port (clone_string    s                                                                          #|line 180|#
			    ))                                                                                                                #|line 181|#

  )#|  Utility for making a `Message`. Used to safely “seed“ messages |#                                                  #|line 183|#
#|  entering the very top of a network. |#                                                                              #|line 184|#

(defun make_message (&optional  port  datum)                                                                            #|line 185|#

  (let ((p (clone_string    port                                                                                      #|line 186|#
	     )))
    (let ((m (Message  :port  p :datum (cdr (assoc '(clone )  datum))                                               #|line 187|#
               )))
      (return-from make_message  m)                                                                               #|line 188|#
      ))                                                                                                            #|line 189|#

  )#|  Clones a message. Primarily used internally for “fanning out“ a message to multiple destinations. |#               #|line 191|#

(defun message_clone (&optional  message)                                                                               #|line 192|#

  (let ((m (Message  :port (clone_port   (cdr (assoc ' port  message)) ) :datum (cdr (assoc '(cdr (assoc '(clone )  datum))  message)) #|line 193|#
	     )))
    (return-from message_clone  m)                                                                                  #|line 194|#
    )                                                                                                                 #|line 195|#

  )#|  Frees a message. |#                                                                                                #|line 197|#

(defun destroy_message (&optional  msg)                                                                                 #|line 198|#

  #|  during debug, dont destroy any message, since we want to trace messages, thus, we need to persist ancestor messages |##|line 199|#

  #| pass |#                                                                                                        #|line 200|#
  #|line 201|#

  )
(defun destroy_datum (&optional  msg)                                                                                   #|line 203|#

  #| pass |#                                                                                                          #|line 204|#
  #|line 205|#

  )
(defun destroy_port (&optional  msg)                                                                                    #|line 207|#

  #| pass |#                                                                                                          #|line 208|#
  #|line 209|#

  )#|  |#                                                                                                                 #|line 211|#

(defun format_message (&optional  m)                                                                                    #|line 212|#

  (cond
    (( equal    m  nil)                                                                                               #|line 213|#

      (return-from format_message  "ϕ")                                                                           #|line 214|#

      )
    (t                                                                                                                #|line 215|#

      (return-from format_message  (concatenate 'string  "⟪"  (concatenate 'string (cdr (assoc ' port  m))  (concatenate 'string  "⦂"  (concatenate 'string (cdr (assoc '(cdr (assoc '(srepr )  datum))  m))  "⟫")))))#|line 219|#
      #|line 220|#

      ))                                                                                                              #|line 221|#

  )#|  dynamic routing descriptors |#                                                                                     #|line 223|#
#|line 224|#

(defparameter  drInject  "inject")
(defparameter  drSend  "send")
(defparameter  drInOut  "inout")
(defparameter  drForward  "forward")
(defparameter  drDown  "down")
(defparameter  drUp  "up")
(defparameter  drAcross  "across")
(defparameter  drThrough  "through")                                                                                    #|line 233|#
#|  See “class_free programming“ starting at 45:01 of https://www.youtube.com/watch?v=XFTOG895C7c |#                    #|line 234|#
#|line 235|#
#|line 236|#

(defun make_Routing_Descriptor (&optional  action  component  port  message)                                            #|line 237|#

  (return-from make_Routing_Descriptor
    (let ((_dict (make-hash-table :test 'equal)))                                                                     #|line 238|#

      (setf (gethash "action" _dict)  action)
      (setf (gethash "component" _dict)  component)
      (setf (gethash "port" _dict)  port)
      (setf (gethash "message" _dict)  message)                                                                       #|line 242|#

      _dict))                                                                                                         #|line 243|#
  #|line 244|#

  )#|  |#                                                                                                                 #|line 246|#

(defun make_Send_Descriptor (&optional  component  port  message  cause_port  cause_message)                            #|line 247|#

  (let ((rdesc (make_Routing_Descriptor  :action  drSend :component  component :port  port :message  message          #|line 248|#
		 )))
    (return-from make_Send_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                 #|line 249|#

        (setf (gethash "action" _dict)  drSend)
        (setf (gethash "component" _dict) (cdr (assoc 'component  rdesc)))
        (setf (gethash "port" _dict) (cdr (assoc 'port  rdesc)))
        (setf (gethash "message" _dict) (cdr (assoc 'message  rdesc)))
        (setf (gethash "cause_port" _dict)  cause_port)
        (setf (gethash "cause_message" _dict)  cause_message)
        (setf (gethash "fmt" _dict)  fmt_send)                                                                      #|line 256|#

        _dict))                                                                                                     #|line 257|#
    )                                                                                                                 #|line 258|#

  )
(defun log_send (&optional  sender  sender_port  msg  cause_msg)                                                        #|line 260|#

  (let ((send_desc (make_Send_Descriptor  :component  sender :port  sender_port :message  msg :cause_port (cdr (assoc ' port  cause_msg)) :cause_message  cause_msg #|line 261|#
		     )))
    (append_routing_descriptor  :container (cdr (assoc ' owner  sender)) :desc  send_desc                           #|line 262|#
      ))                                                                                                              #|line 263|#

  )
(defun log_send_string (&optional  sender  sender_port  msg  cause_msg)                                                 #|line 265|#

  (let ((send_desc (make_Send_Descriptor    sender   sender_port   msg  (cdr (assoc ' port  cause_msg))   cause_msg   #|line 266|#
		     )))
    (append_routing_descriptor  :container (cdr (assoc ' owner  sender)) :desc  send_desc                           #|line 267|#
      ))                                                                                                              #|line 268|#

  )
(defun fmt_send (&optional  desc  indent)                                                                               #|line 270|#

  (return-from fmt_send  ""                                                                                           #|line 271|#

    #| return f;\n{indent}⋯ {desc@component.name}.“{desc@cause_port}“ ∴ {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |##|line 272|#
    )                                                                                                                 #|line 273|#

  )
(defun fmt_send_string (&optional  desc  indent)                                                                        #|line 275|#

  (return-from fmt_send_string (fmt_send    desc   indent                                                             #|line 276|#
				 ))                                                                                                                #|line 277|#

  )#|  |#                                                                                                                 #|line 279|#

(defun make_Forward_Descriptor (&optional  component  port  message  cause_port  cause_message)                         #|line 280|#

  (let ((rdesc (make_Routing_Descriptor  :action  drSend :component  component :port  port :message  message          #|line 281|#
		 )))
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

          _dict))                                                                                                 #|line 291|#
      ))                                                                                                            #|line 292|#

  )
(defun log_forward (&optional  sender  sender_port  msg  cause_msg)                                                     #|line 294|#

  #| pass |#
  #|  when needed, it is too frequent to bother logging |#                                                          #|line 295|#
  #|line 296|#

  )
(defun fmt_forward (&optional  desc)                                                                                    #|line 298|#

  (print    (concatenate 'string  "*** Error fmt_forward "  desc)                                                     #|line 299|#
    )
  (quit )                                                                                                           #|line 300|#
  #|line 301|#

  )#|  |#                                                                                                                 #|line 303|#

(defun make_Inject_Descriptor (&optional  receiver  port  message)                                                      #|line 304|#

  (let ((rdesc (make_Routing_Descriptor  :action  drInject :component  receiver :port  port :message  message         #|line 305|#
		 )))
    (return-from make_Inject_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                 #|line 306|#

        (setf (gethash "action" _dict)  drInject)
        (setf (gethash "component" _dict) (cdr (assoc 'component  rdesc)))
        (setf (gethash "port" _dict) (cdr (assoc 'port  rdesc)))
        (setf (gethash "message" _dict) (cdr (assoc 'message  rdesc)))
        (setf (gethash "fmt" _dict)  fmt_inject)                                                                    #|line 311|#

        _dict))                                                                                                     #|line 312|#
    )                                                                                                                 #|line 313|#

  )
(defun log_inject (&optional  receiver  port  msg)                                                                      #|line 315|#

  (let ((inject_desc (make_Inject_Descriptor  :receiver  receiver :port  port :message  msg                           #|line 316|#
		       )))
    (append_routing_descriptor  :container  receiver :desc  inject_desc                                             #|line 317|#
      ))                                                                                                              #|line 318|#

  )
(defun fmt_inject (&optional  desc  indent)                                                                             #|line 320|#

  #| return f'\n{indent}⟹  {desc@component.name}.“{desc@port}“ {format_message (desc@message)}' |#                    #|line 321|#

  (return-from fmt_inject  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "⟹  "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'component  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'message  desc)) )))))))))#|line 328|#
  #|line 329|#

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

      _dict))                                                                                                         #|line 342|#
  #|line 343|#

  )
(defun log_down (&optional  container  source_port  source_message  target  target_port  target_message)                #|line 345|#

  (let ((rdesc (make_Down_Descriptor    container   source_port   source_message   target   target_port   target_message #|line 346|#
		 )))
    (append_routing_descriptor    container   rdesc                                                                 #|line 347|#
      ))                                                                                                              #|line 348|#

  )
(defun fmt_down (&optional  desc  indent)                                                                               #|line 350|#

  #| return f'\n{indent}↓ {desc@container.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“ {format_message (desc@target_message)}' |##|line 351|#

  (return-from fmt_down  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  " ↓ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'target  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'target_message  desc)) )))))))))))))#|line 362|#
  #|line 363|#

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

      _dict))                                                                                                         #|line 376|#
  #|line 377|#

  )
(defun log_up (&optional  source  source_port  source_message  container  target_port  target_message)                  #|line 379|#

  (let ((rdesc (make_Up_Descriptor    source   source_port   source_message   container   target_port   target_message #|line 380|#
		 )))
    (append_routing_descriptor    container   rdesc                                                                 #|line 381|#
      ))                                                                                                              #|line 382|#

  )
(defun fmt_up (&optional  desc  indent)                                                                                 #|line 384|#

  #| return f'\n{indent}↑ {desc@source.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@container_port}“ {format_message (desc@container_message)}' |##|line 385|#

  (return-from fmt_up  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "↑ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'source  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'container_port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'container_message  desc)) )))))))))))))#|line 396|#
  #|line 397|#

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

      _dict))                                                                                                         #|line 410|#
  #|line 411|#

  )
(defun log_across (&optional  container  source  source_port  source_message  target  target_port  target_message)      #|line 413|#

  (let ((rdesc (make_Across_Descriptor    container   source   source_port   source_message   target   target_port   target_message #|line 414|#
		 )))
    (append_routing_descriptor    container   rdesc                                                                 #|line 415|#
      ))                                                                                                              #|line 416|#

  )
(defun fmt_across (&optional  desc  indent)                                                                             #|line 418|#

  #| return f'\n{indent}→ {desc@source.name}.“{desc@source_port}“ ➔ {desc@target.name}.“{desc@target_port}“  {format_message (desc@target_message)}' |##|line 419|#

  (return-from fmt_across  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "→ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'source  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'target  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  "  " (format_message   (cdr (assoc 'target_message  desc)) )))))))))))))#|line 430|#
  #|line 431|#

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

      _dict))                                                                                                         #|line 443|#
  #|line 444|#

  )
(defun log_through (&optional  container  source_port  source_message  target_port  message)                            #|line 446|#

  (let ((rdesc (make_Through_Descriptor    container   source_port   source_message   target_port   message           #|line 447|#
		 )))
    (append_routing_descriptor    container   rdesc                                                                 #|line 448|#
      ))                                                                                                              #|line 449|#

  )
(defun fmt_through (&optional  desc  indent)                                                                            #|line 451|#

  #| return f'\n{indent}⇶ {desc @container.name}.“{desc@source_port}“ ➔ {desc@container.name}.“{desc@target_port}“ {format_message (desc@message)}' |##|line 452|#

  (return-from fmt_through  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "⇶ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'source_port  desc))  (concatenate 'string  " ➔ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'container  desc))))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc 'target_port  desc))  (concatenate 'string  " " (format_message   (cdr (assoc 'message  desc)) )))))))))))))#|line 463|#
  #|line 464|#

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

      _dict))                                                                                                         #|line 475|#
  #|line 476|#

  )
(defun log_inout (&optional  container  component  in_message)                                                          #|line 478|#

  (cond
    ((cdr (assoc '(cdr (assoc '(empty )  outq))  component))                                                          #|line 479|#

      (log_inout_no_output  :container  container :component  component :in_message  in_message )                 #|line 480|#

      )
    (t                                                                                                                #|line 481|#

      (log_inout_recursively  :container  container :component  component :in_message  in_message :out_messages (list   (cdr (assoc '(cdr (assoc ' queue  outq))  component)) ) )#|line 482|#

      ))                                                                                                              #|line 483|#

  )
(defun log_inout_no_output (&optional  container  component  in_message)                                                #|line 485|#

  (let ((rdesc (make_InOut_Descriptor  :container  container :component  component :in_message  in_message            #|line 486|#
		 :out_port  nil :out_message  nil                                                                                    #|line 487|#
		 )))
    (append_routing_descriptor    container   rdesc                                                                 #|line 488|#
      ))                                                                                                              #|line 489|#

  )
(defun log_inout_single (&optional  container  component  in_message  out_message)                                      #|line 491|#

  (let ((rdesc (make_InOut_Descriptor  :container  container :component  component :in_message  in_message            #|line 492|#
		 :out_port  nil :out_message  out_message                                                                            #|line 493|#
		 )))
    (append_routing_descriptor    container   rdesc                                                                 #|line 494|#
      ))                                                                                                              #|line 495|#

  )
(defun log_inout_recursively (&optional  container  component  in_message  :out_messages  nil)                          #|line 497|#

  (cond
    (( equal    nil  out_messages)                                                                                    #|line 498|#

      #| pass |#                                                                                                  #|line 499|#

      )
    (t                                                                                                                #|line 500|#

      (let ((m  (car  out_messages)))                                                                             #|line 501|#

        (let ((rest  (cdr  out_messages)))                                                                      #|line 502|#

          (log_inout_single  :container  container :component  component :in_message  in_message :out_message  m #|line 503|#
            )
          (log_inout_recursively  :container  container :component  component :in_message  in_message :out_messages  rest )))#|line 504|#

      ))                                                                                                              #|line 505|#

  )
(defun fmt_inout (&optional  desc  indent)                                                                              #|line 507|#

  (let ((outm (cdr (assoc 'out_message  desc))))                                                                      #|line 508|#

    (cond
      (( equal    nil  outm)                                                                                        #|line 509|#

        (return-from fmt_inout  (concatenate 'string  "\n"  (concatenate 'string  indent  "  ⊥")))              #|line 510|#

        )
      (t                                                                                                            #|line 511|#

        (return-from fmt_inout  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "  ∴ "  (concatenate 'string (cdr (assoc ' name (cdr (assoc 'component  desc))))  (concatenate 'string  " " (format_message    outm )))))))#|line 516|#
        #|line 517|#

        )))                                                                                                         #|line 518|#

  )
(defun log_tick (&optional  container  component  in_message)                                                           #|line 520|#

  #| pass |#                                                                                                          #|line 521|#
  #|line 522|#

  )#|  |#                                                                                                                 #|line 524|#

(defun routing_trace_all (&optional  container)                                                                         #|line 525|#

  (let ((indent  ""))                                                                                                 #|line 526|#

    (let ((lis (list   (cdr (assoc '(cdr (assoc ' queue  routings))  container))                                    #|line 527|#
		 )))
      (return-from routing_trace_all (recursive_routing_trace    container   lis   indent                         #|line 528|#
				       ))))                                                                                                      #|line 529|#

  )
(defun recursive_routing_trace (&optional  container  lis  indent)                                                      #|line 531|#

  (cond
    (( equal    nil  lis)                                                                                             #|line 532|#

      (return-from recursive_routing_trace  "")                                                                   #|line 533|#

      )
    (t                                                                                                                #|line 534|#

      (let ((desc (first    lis                                                                                   #|line 535|#
		    )))
        (let ((formatted (funcall (cdr (assoc 'fmt  desc))    desc   indent                                     #|line 536|#
			   )))
          (return-from recursive_routing_trace (+  formatted (recursive_routing_trace    container  (rest    lis )  (+  indent  "  ") )))))#|line 537|#

      ))                                                                                                              #|line 538|#

  )
(defparameter  enumDown  0)
(defparameter  enumAcross  1)
(defparameter  enumUp  2)
(defparameter  enumThrough  3)                                                                                          #|line 544|#

(defun container_instantiator (&optional  reg  owner  container_name  desc)                                             #|line 545|#
  #|line 546|#

  (let ((container (make_container    container_name   owner                                                        #|line 547|#
		     )))
    (let ((children  nil))                                                                                        #|line 548|#

      (let ((children_by_id  nil))
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#         #|line 549|#

        #|  collect children |#                                                                             #|line 550|#

        (loop for child_desc in (cdr (assoc 'children  desc))
          do                                                                                              #|line 551|#

          (let ((child_instance (get_component_instance    reg  (cdr (assoc 'name  child_desc))   container #|line 552|#
				  )))
            (cdr (assoc '(append    child_instance                                                  #|line 553|#
                           )  children))
            (setf (nth (cdr (assoc 'id  child_desc))  children_by_id)  child_instance))           #|line 554|#

          )
        (setf (cdr (assoc ' children  container))  children)                                            #|line 555|#

        (let ((me  container))                                                                        #|line 556|#
          #|line 557|#

          (let ((connectors  nil))                                                                #|line 558|#

            (loop for proto_conn in (cdr (assoc 'connections  desc))
              do                                                                                #|line 559|#

              (let ((source_component  nil))                                                #|line 560|#

                (let ((target_component  nil))                                            #|line 561|#

                  (let ((connector (Connector )))                                       #|line 562|#

                    (cond
                      (( equal   (cdr (assoc 'dir  proto_conn))  enumDown)            #|line 563|#

                        #|  JSON: {'dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |##|line 564|#

                        (setf (cdr (assoc ' direction  connector))  "down")     #|line 565|#

                        (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))   me  (cdr (assoc 'source_port  proto_conn)) #|line 566|#
                                                                  ))
                        (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 567|#

                          (cond
                            (( equal    target_component  nil)            #|line 568|#

                              (load_error    (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc 'target  proto_conn))) )#|line 569|#

                              )
                            (t                                            #|line 570|#

                              (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component))  (cdr (assoc ' inq  target_component))  (cdr (assoc 'target_port  proto_conn))   target_component #|line 571|#
                                                                          ))
                              (cdr (assoc '(append    connector )  connectors))
                              )))                                         #|line 572|#

                        )
                      (( equal   (cdr (assoc 'dir  proto_conn))  enumAcross)          #|line 573|#

                        (setf (cdr (assoc ' direction  connector))  "across")     #|line 574|#

                        (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 575|#

                          (let ((target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))#|line 576|#

                            (cond
                              (( equal    source_component  nil)            #|line 577|#

                                (load_error    (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 578|#

                                )
                              (t                                            #|line 579|#

                                (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))   source_component  (cdr (assoc 'source_port  proto_conn)) #|line 580|#
                                                                          ))
                                (cond
                                  (( equal    target_component  nil)  #|line 581|#

                                    (load_error    (concatenate 'string  "internal error: .Across connection target not ok " (cdr (assoc ' target  proto_conn))) )#|line 582|#

                                    )
                                  (t                                  #|line 583|#

                                    (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  target_component))  (cdr (assoc ' inq  target_component))  (cdr (assoc 'target_port  proto_conn))   target_component #|line 584|#
                                                                                ))
                                    (cdr (assoc '(append    connector )  connectors))
                                    ))
                                ))))                                        #|line 585|#

                        )
                      (( equal   (cdr (assoc 'dir  proto_conn))  enumUp)              #|line 586|#

                        (setf (cdr (assoc ' direction  connector))  "up")         #|line 587|#

                        (let ((source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))#|line 588|#

                          (cond
                            (( equal    source_component  nil)                #|line 589|#

                              (print    (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc 'source  proto_conn))) )#|line 590|#

                              )
                            (t                                                #|line 591|#

                              (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  source_component))   source_component  (cdr (assoc 'source_port  proto_conn)) #|line 592|#
                                                                        ))
                              (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me))  (cdr (assoc ' outq  container))  (cdr (assoc 'target_port  proto_conn))   me #|line 593|#
                                                                          ))
                              (cdr (assoc '(append    connector )  connectors))
                              )))                                             #|line 594|#

                        )
                      (( equal   (cdr (assoc 'dir  proto_conn))  enumThrough)         #|line 595|#

                        (setf (cdr (assoc ' direction  connector))  "through")    #|line 596|#

                        (setf (cdr (assoc ' sender  connector)) (Sender   (cdr (assoc ' name  me))   me  (cdr (assoc 'source_port  proto_conn)) #|line 597|#
                                                                  ))
                        (setf (cdr (assoc ' receiver  connector)) (Receiver   (cdr (assoc ' name  me))  (cdr (assoc ' outq  container))  (cdr (assoc 'target_port  proto_conn))   me #|line 598|#
                                                                    ))
                        (cdr (assoc '(append    connector )  connectors))
                        )))))                                                         #|line 599|#

              )                                                                                 #|line 600|#

            (setf (cdr (assoc ' connections  container))  connectors)                         #|line 601|#

            (return-from container_instantiator  container)                                 #|line 602|#
            )))))                                                                             #|line 603|#

  )#|  The default handler for container components. |#                                                                   #|line 605|#

(defun container_handler (&optional  container  message)                                                                #|line 606|#

  (route  :container  container :from_component  container :message  message )
  #|  references to 'self' are replaced by the container during instantiation |#                                    #|line 607|#

  (loop while (any_child_ready    container )
    do                                                                                                            #|line 608|#

    (step_children    container   message )                                                                   #|line 609|#

    )                                                                                                             #|line 610|#

  )#|  Frees the given container and associated data. |#                                                                  #|line 612|#

(defun destroy_container (&optional  eh)                                                                                #|line 613|#

  #| pass |#                                                                                                          #|line 614|#
  #|line 615|#

  )
(defun fifo_is_empty (&optional  fifo)                                                                                  #|line 617|#

  (return-from fifo_is_empty (cdr (assoc '(empty )  fifo)))                                                           #|line 618|#
  #|line 619|#

  )#|  Routing connection for a container component. The `direction` field has |#                                         #|line 621|#
#|  no affect on the default message routing system _ it is there for debugging |#                                      #|line 622|#
#|  purposes, or for reading by other tools. |#                                                                         #|line 623|#
#|line 624|#

(defun Connector (&optional )                                                                                           #|line 625|#

  (list
    (cons 'direction  nil) #|  down, across, up, through |#                                                             #|line 626|#

    (cons 'sender  nil)                                                                                                 #|line 627|#

    (cons 'receiver  nil)                                                                                               #|line 628|#
    )                                                                                                                   #|line 629|#
  )
#|line 630|#
#|  `Sender` is used to “pattern match“ which `Receiver` a message should go to, |#                                     #|line 631|#
#|  based on component ID (pointer) and port name. |#                                                                   #|line 632|#
#|line 633|#

(defun Sender (&optional  name  component  port)                                                                        #|line 634|#

  (list
    (cons 'name  name)                                                                                                  #|line 635|#

    (cons 'component  component) #|  from |#                                                                            #|line 636|#

    (cons 'port  port) #|  from's port |#                                                                               #|line 637|#
    )                                                                                                                   #|line 638|#
  )
#|line 639|#
#|  `Receiver` is a handle to a destination queue, and a `port` name to assign |#                                       #|line 640|#
#|  to incoming messages to this queue. |#                                                                              #|line 641|#
#|line 642|#

(defun Receiver (&optional  name  queue  port  component)                                                               #|line 643|#

  (list
    (cons 'name  name)                                                                                                  #|line 644|#

    (cons 'queue  queue) #|  queue (input | output) of receiver |#                                                      #|line 645|#

    (cons 'port  port) #|  destination port |#                                                                          #|line 646|#

    (cons 'component  component) #|  to (for bootstrap debug) |#                                                        #|line 647|#
    )                                                                                                                   #|line 648|#
  )
#|line 649|#
#|  Checks if two senders match, by pointer equality and port name matching. |#                                         #|line 650|#

(defun sender_eq (&optional  s1  s2)                                                                                    #|line 651|#

  (let ((same_components ( equal   (cdr (assoc ' component  s1)) (cdr (assoc ' component  s2)))))                     #|line 652|#

    (let ((same_ports ( equal   (cdr (assoc ' port  s1)) (cdr (assoc ' port  s2)))))                                #|line 653|#

      (return-from sender_eq ( and   same_components  same_ports))                                                #|line 654|#
      ))                                                                                                            #|line 655|#

  )#|  Delivers the given message to the receiver of this connector. |#                                                   #|line 657|#
#|line 658|#

(defun deposit (&optional  parent  conn  message)                                                                       #|line 659|#

  (let ((new_message (make_message  :port (cdr (assoc '(cdr (assoc ' port  receiver))  conn)) :datum (cdr (assoc ' datum  message)) #|line 660|#
		       )))
    (log_connection    parent   conn   new_message                                                                  #|line 661|#
      )
    (push_message    parent  (cdr (assoc '(cdr (assoc ' component  receiver))  conn))  (cdr (assoc '(cdr (assoc ' queue  receiver))  conn))   new_message #|line 662|#
      ))                                                                                                            #|line 663|#

  )
(defun force_tick (&optional  parent  eh)                                                                               #|line 665|#

  (let ((tick_msg (make_message    "."  (new_datum_tick )                                                             #|line 666|#
		    )))
    (push_message    parent   eh  (cdr (assoc ' inq  eh))   tick_msg                                                #|line 667|#
      )
    (return-from force_tick  tick_msg)                                                                            #|line 668|#
    )                                                                                                               #|line 669|#

  )
(defun push_message (&optional  parent  receiver  inq  m)                                                               #|line 671|#

  (cdr (assoc '(put    m                                                                                              #|line 672|#
		 )  inq))
  (cdr (assoc '(cdr (assoc '(put    receiver                                                                        #|line 673|#
			      )  visit_ordering))  parent))                                                                                     #|line 674|#

  )
(defun is_self (&optional  child  container)                                                                            #|line 676|#

  #|  in an earlier version “self“ was denoted as ϕ |#                                                                #|line 677|#

  (return-from is_self ( equal    child  container))                                                                #|line 678|#
  #|line 679|#

  )
(defun step_child (&optional  child  msg)                                                                               #|line 681|#

  (let ((before_state (cdr (assoc ' state  child))))                                                                  #|line 682|#

    (cdr (assoc '(handler    child   msg                                                                            #|line 683|#
		   )  child))
    (let ((after_state (cdr (assoc ' state  child))))                                                             #|line 684|#

      (return-from step_child (values undefined undefined))                                                     #|line 687|#
      ))                                                                                                          #|line 688|#

  )
(defun save_message (&optional  eh  msg)                                                                                #|line 690|#

  (cdr (assoc '(cdr (assoc '(put    msg                                                                               #|line 691|#
			      )  saved_messages))  eh))                                                                                           #|line 692|#

  )
(defun fetch_saved_message_and_clear (&optional  eh)                                                                    #|line 694|#

  (return-from fetch_saved_message_and_clear (cdr (assoc '(cdr (assoc '(get )  saved_messages))  eh)))                #|line 695|#
  #|line 696|#

  )
(defun step_children (&optional  container  causingMessage)                                                             #|line 698|#

  (setf (cdr (assoc ' state  container))  "idle")                                                                     #|line 699|#

  (loop for child in (list   (cdr (assoc '(cdr (assoc ' queue  visit_ordering))  container)) )
    do                                                                                                              #|line 700|#

    #|  child = container represents self, skip it |#                                                           #|line 701|#

    (cond
      ((not (is_self    child   container ))                                                                  #|line 702|#

        (cond
          ((not (cdr (assoc '(cdr (assoc '(empty )  inq))  child)))                                       #|line 703|#

            (let ((msg (cdr (assoc '(cdr (assoc '(get )  inq))  child))))                             #|line 704|#

              (loop while (step_child    child   msg                                                #|line 705|#
                            )
                doundefined)
              (cond
                ( began_long_run                                                                  #|line 706|#

                  (save_message    child   msg )                                              #|line 707|#

                  )
                ( continued_long_run                                                              #|line 708|#

                  #| pass |#                                                                  #|line 709|#

                  )
                ( ended_long_run                                                                  #|line 710|#

                  (log_inout  :container  container :component  child :in_message (fetch_saved_message_and_clear    child ) )#|line 711|#

                  )
                (t                                                                                #|line 712|#

                  (log_inout  :container  container :component  child :in_message  msg )      #|line 713|#

                  ))
              (destroy_message    msg ))                                                        #|line 714|#

            )
          (t                                                                                              #|line 715|#

            (cond
              ((not (equal  (cdr (assoc ' state  child))  "idle")                                     #|line 716|#

                 (let ((msg (force_tick    container   child                                       #|line 717|#
                              )))
                   (cdr (assoc '(handler    child   msg                                          #|line 718|#
                                  )  child))
                   (log_tick  :container  container :component  child :in_message  msg         #|line 719|#
                     )
                   (destroy_message    msg ))
                 ))                                                                                    #|line 720|#

              ))                                                                                            #|line 721|#

          (cond
            (( equal   (cdr (assoc ' state  child))  "active")                                            #|line 722|#

              #|  if child remains active, then the container must remain active and must propagate “ticks“ to child |##|line 723|#

              (setf (cdr (assoc ' state  container))  "active")                                     #|line 724|#

              ))                                                                                          #|line 725|#

          (loop while (not (cdr (assoc '(cdr (assoc '(empty )  outq))  child)))
            do                                                                                          #|line 726|#

            (let ((msg (cdr (assoc '(cdr (assoc '(get )  outq))  child))))                          #|line 727|#

              (route    container   child   msg                                                   #|line 728|#
                )
              (destroy_message    msg ))
            )
          ))                                                                                                    #|line 729|#

      )                                                                                                               #|line 730|#
    #|line 731|#
    #|line 732|#

    )
  (defun attempt_tick (&optional  parent  eh)                                                                             #|line 734|#

    (cond
      ((not (equal  (cdr (assoc ' state  eh))  "idle")                                                                  #|line 735|#

         (force_tick    parent   eh )                                                                                #|line 736|#

         ))                                                                                                              #|line 737|#

      )
    (defun is_tick (&optional  msg)                                                                                         #|line 739|#

      (return-from is_tick ( equal    "tick" (cdr (assoc '(cdr (assoc '(kind )  datum))  msg))))                          #|line 740|#
      #|line 741|#

      )#|  Routes a single message to all matching destinations, according to |#                                              #|line 743|#
    #|  the container's connection network. |#                                                                              #|line 744|#
    #|line 745|#

    (defun route (&optional  container  from_component  message)                                                            #|line 746|#

      (let (( was_sent  nil))
        #|  for checking that output went somewhere (at least during bootstrap) |#                                      #|line 747|#

        (let (( fromname  ""))                                                                                        #|line 748|#

          (cond
            ((is_tick    message )                                                                                  #|line 749|#

              (loop for child in (cdr (assoc ' children  container))
                do                                                                                              #|line 750|#

                (attempt_tick    container   child   message )                                              #|line 751|#

                )
              (setf  was_sent  t)                                                                             #|line 752|#

              )
            (t                                                                                                      #|line 753|#

              (cond
                ((not (is_self    from_component   container ))                                                 #|line 754|#

                  (setf  fromname (cdr (assoc ' name  from_component)))                                     #|line 755|#

                  ))
              (let ((from_sender (Sender  :name  fromname :component  from_component :port (cdr (assoc ' port  message)) #|line 756|#
				   )))                                                                                             #|line 757|#

                (loop for connector in (cdr (assoc ' connections  container))
                  do                                                                                        #|line 758|#

                  (cond
                    ((sender_eq    from_sender  (cdr (assoc ' sender  connector)) )                     #|line 759|#

                      (deposit    container   connector   message                                   #|line 760|#
                        )
                      (setf  was_sent  t)
                      ))
                  ))                                                                                        #|line 761|#

              ))
          (cond
            ((not  was_sent)                                                                                      #|line 762|#

              (print    "\n\n*** Error: ***"                                                                  #|line 763|#
                )
              (dump_possible_connections    container                                                       #|line 764|#
                )
              (print_routing_trace    container                                                           #|line 765|#
                )
              (print    "***"                                                                           #|line 766|#
                )
              (print    (concatenate 'string (cdr (assoc ' name  container))  (concatenate 'string  ": message '"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "' from "  (concatenate 'string  fromname  " dropped on floor..."))))) #|line 767|#
                )
              (print    "***"                                                                       #|line 768|#
                )
              (exit )                                                                             #|line 769|#

              ))))                                                                                                #|line 770|#

      )
    (defun dump_possible_connections (&optional  container)                                                                 #|line 772|#

      (print    (concatenate 'string  "*** possible connections for "  (concatenate 'string (cdr (assoc ' name  container))  ":")) #|line 773|#
	)
      (loop for connector in (cdr (assoc ' connections  container))
        do                                                                                                              #|line 774|#

        (print    (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  " "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  sender))  connector))  (concatenate 'string  "."  (concatenate 'string (cdr (assoc '(cdr (assoc ' port  sender))  connector))  (concatenate 'string  " -> "  (concatenate 'string (cdr (assoc '(cdr (assoc ' name  receiver))  connector))  (concatenate 'string  "." (cdr (assoc '(cdr (assoc ' port  receiver))  connector)))))))))) )#|line 775|#

        )                                                                                                               #|line 776|#

      )
    (defun any_child_ready (&optional  container)                                                                           #|line 778|#

      (loop for child in (cdr (assoc ' children  container))
	do                                                                                                                #|line 779|#

        (cond
          ((child_is_ready    child )                                                                                 #|line 780|#

            (return-from any_child_ready  t)
            ))                                                                                                        #|line 781|#

	)
      (return-from any_child_ready  nil)                                                                                #|line 782|#
      #|line 783|#

      )
    (defun child_is_ready (&optional  eh)                                                                                   #|line 785|#

      (return-from child_is_ready ( or  ( or  ( or  (not (cdr (assoc '(cdr (assoc '(empty )  outq))  eh))) (not (cdr (assoc '(cdr (assoc '(empty )  inq))  eh)))) (not (equal  (cdr (assoc ' state  eh))  "idle")) (any_child_ready    eh )))#|line 786|#
        #|line 787|#

	)
      (defun print_routing_trace (&optional  eh)                                                                              #|line 789|#

	(print   (routing_trace_all    eh )                                                                                 #|line 790|#
	  )                                                                                                                   #|line 791|#

	)
      (defun append_routing_descriptor (&optional  container  desc)                                                           #|line 793|#

	(cdr (assoc '(cdr (assoc '(put    desc                                                                              #|line 794|#
				    )  routings))  container))                                                                                          #|line 795|#

	)
      (defun log_connection (&optional  container  connector  message)                                                        #|line 797|#

	(cond
	  (( equal    "down" (cdr (assoc ' direction  connector)))                                                          #|line 798|#

            (log_down  :container  container                                                                            #|line 799|#
              :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector))                                         #|line 800|#
              :source_message  nil                                                                                        #|line 801|#
              :target (cdr (assoc '(cdr (assoc ' component  receiver))  connector))                                       #|line 802|#
              :target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector))                                       #|line 803|#
              :target_message  message )                                                                                  #|line 804|#

            )
	  (( equal    "up" (cdr (assoc ' direction  connector)))                                                            #|line 805|#

            (log_up  :source (cdr (assoc '(cdr (assoc ' component  sender))  connector)) :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) :source_message  nil :container  container :target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) #|line 806|#
              :target_message  message )                                                                                  #|line 807|#

            )
	  (( equal    "across" (cdr (assoc ' direction  connector)))                                                        #|line 808|#

            (log_across  :container  container                                                                          #|line 809|#
              :source (cdr (assoc '(cdr (assoc ' component  sender))  connector)) :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) :source_message  nil #|line 810|#
              :target (cdr (assoc '(cdr (assoc ' component  receiver))  connector)) :target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) :target_message  message )#|line 811|#

            )
	  (( equal    "through" (cdr (assoc ' direction  connector)))                                                       #|line 812|#

            (log_through  :container  container :source_port (cdr (assoc '(cdr (assoc ' port  sender))  connector)) :source_message  nil #|line 813|#
              :target_port (cdr (assoc '(cdr (assoc ' port  receiver))  connector)) :message  message )                   #|line 814|#

            )
	  (t                                                                                                                #|line 815|#

            (print    (concatenate 'string  "*** FATAL error: in log_connection /"  (concatenate 'string (cdr (assoc ' direction  connector))  (concatenate 'string  "/ /"  (concatenate 'string (cdr (assoc ' port  message))  (concatenate 'string  "/ /"  (concatenate 'string (cdr (assoc '(cdr (assoc '(srepr )  datum))  message))  "/")))))) #|line 816|#
              )
            (exit )                                                                                                   #|line 817|#

            ))                                                                                                              #|line 818|#

	)
      (defun container_injector (&optional  container  message)                                                               #|line 820|#

	(log_inject  :receiver  container :port (cdr (assoc ' port  message)) :msg  message                                 #|line 821|#
	  )
	(container_handler    container   message                                                                         #|line 822|#
	  )                                                                                                                 #|line 823|#

	)





      (load "~/quicklisp/setup.lisp")
      (ql:quickload :cl-json)
      #|line 4|#
      #|line 5|#

      (defun Component_Registry (&optional )                                                                                  #|line 6|#

	(list
	  (cons 'templates  nil)                                                                                              #|line 7|#
	  )                                                                                                                   #|line 8|#
	)
      #|line 9|#

      (defun Template (&optional  name  template_data  instantiator)                                                          #|line 10|#

	(list
	  (cons 'name  name)                                                                                                  #|line 11|#

	  (cons 'template_data  template_data)                                                                                #|line 12|#

	  (cons 'instantiator  instantiator)                                                                                  #|line 13|#
	  )                                                                                                                   #|line 14|#
	)
      #|line 15|#

      (defun read_and_convert_json_file (&optional  filename)                                                                 #|line 16|#

	;; read json from a named file and convert it into internal form (a tree of routings)
	;; return the routings from the function or print an error message and return nil
	(handler-bind ((error #'(lambda (condition) nil)))
	  (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
            (json:decode-json json-stream)))
        #|line 17|#
        #|line 18|#

	)
      (defun json2internal (&optional  container_xml)                                                                         #|line 20|#

	(let ((fname (cdr (assoc '(cdr (assoc '(basename    container_xml                                                   #|line 21|#
						 )  path))  os))))
          (let ((routings (read_and_convert_json_file    fname                                                            #|line 22|#
			    )))
            (return-from json2internal  routings)                                                                       #|line 23|#
            ))                                                                                                            #|line 24|#

	)
      (defun delete_decls (&optional  d)                                                                                      #|line 26|#

	#| pass |#                                                                                                          #|line 27|#
        #|line 28|#

	)
      (defun make_component_registry (&optional )                                                                             #|line 30|#

	(return-from make_component_registry (Component_Registry ))                                                         #|line 31|#
        #|line 32|#

	)
      (defun register_component (&optional  reg  template  :ok_to_overwrite  nil)                                             #|line 34|#

	(let ((name (mangle_name   (cdr (assoc ' name  template))                                                           #|line 35|#
		      )))
          (cond
            (( and  ( in   name (cdr (assoc ' templates  reg))) (not  ok_to_overwrite))                                   #|line 36|#

              (load_error    (concatenate 'string  "Component "  (concatenate 'string (cdr (assoc ' name  template))  " already declared")) )#|line 37|#

              ))
          (setf (cdr (assoc '(nth  name  templates)  reg))  template)                                                   #|line 38|#

          (return-from register_component  reg)                                                                       #|line 39|#
          )                                                                                                             #|line 40|#

	)
      (defun register_multiple_components (&optional  reg  templates)                                                         #|line 42|#

	(loop for template in  templates
	  do                                                                                                                #|line 43|#

          (register_component    reg   template )                                                                       #|line 44|#

	  )                                                                                                                 #|line 45|#

	)
      (defun get_component_instance (&optional  reg  full_name  owner)                                                        #|line 47|#

	(let ((template_name (mangle_name    full_name                                                                      #|line 48|#
			       )))
          (cond
            (( in   template_name (cdr (assoc ' templates  reg)))                                                         #|line 49|#

              (let ((template (cdr (assoc '(nth  template_name  templates)  reg))))                                   #|line 50|#

                (cond
                  (( equal    template  nil)                                                                        #|line 51|#

                    (load_error    (concatenate 'string  "Registry Error: Can;t find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 52|#
                      )
                    (return-from get_component_instance  nil)                                                 #|line 53|#

                    )
                  (t                                                                                                #|line 54|#

                    (let ((owner_name  ""))                                                                     #|line 55|#

                      (let ((instance_name  template_name))                                                   #|line 56|#

                        (cond
                          ((not (equal   nil  owner)                                                        #|line 57|#

                             (let ((owner_name (cdr (assoc ' name  owner))))                             #|line 58|#

                               (let ((instance_name  (concatenate 'string  owner_name  (concatenate 'string  "."  template_name))))))#|line 59|#

                             )
                            (t                                                                                #|line 60|#

                              (let ((instance_name  template_name)))                                      #|line 61|#

                              ))
                          (let ((instance (cdr (assoc '(instantiator    reg   owner   instance_name  (cdr (assoc ' template_data  template)) #|line 62|#
							 )  template))))
                            (setf (cdr (assoc ' depth  instance)) (calculate_depth    instance            #|line 63|#
								    ))
                            (return-from get_component_instance  instance))))
                      )))                                                                                             #|line 64|#

		)
              (t                                                                                                            #|line 65|#

                (load_error    (concatenate 'string  "Registry Error: Can't find component "  (concatenate 'string  template_name  " (does it need to be declared in components_to_include_in_project?")) #|line 66|#
                  )
                (return-from get_component_instance  nil)                                                             #|line 67|#

		)))                                                                                                         #|line 68|#

	  )
	(defun calculate_depth (&optional  eh)                                                                                  #|line 69|#

	  (cond
	    (( equal   (cdr (assoc ' owner  eh))  nil)                                                                        #|line 70|#

              (return-from calculate_depth  0)                                                                            #|line 71|#

              )
	    (t                                                                                                                #|line 72|#

              (return-from calculate_depth (+  1 (calculate_depth   (cdr (assoc ' owner  eh)) )))                         #|line 73|#

              ))                                                                                                              #|line 74|#

	  )
	(defun dump_registry (&optional  reg)                                                                                   #|line 76|#

	  (print )                                                                                                            #|line 77|#

	  (print    "*** PALETTE ***"                                                                                       #|line 78|#
	    )
          (loop for c in (cdr (assoc ' templates  reg))
            do                                                                                                            #|line 79|#

            (print   (cdr (assoc ' name  c)) )                                                                        #|line 80|#

            )
          (print    "***************"                                                                                   #|line 81|#
            )
          (print )                                                                                                    #|line 82|#
          #|line 83|#

	  )
	(defun print_stats (&optional  reg)                                                                                     #|line 85|#

	  (print    (concatenate 'string  "registry statistics: " (cdr (assoc ' stats  reg)))                                 #|line 86|#
	    )                                                                                                                   #|line 87|#

	  )
	(defun mangle_name (&optional  s)                                                                                       #|line 89|#

	  #|  trim name to remove code from Container component names _ deferred until later (or never) |#                    #|line 90|#

	  (return-from mangle_name  s)                                                                                      #|line 91|#
          #|line 92|#

	  )
	(defun generate_shell_components (&optional  reg  container_list)                                                       #|line 95|#

	  #|  [ |#                                                                                                            #|line 96|#

	  #|      {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 97|#

          #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |#                        #|line 98|#

          #|  ] |#                                                                                                      #|line 99|#

          (cond
            ((not (equal   nil  container_list)                                                                       #|line 100|#

               (loop for diagram in  container_list
                 do                                                                                                #|line 101|#

                 #|  loop through every component in the diagram and look for names that start with “$“ |#     #|line 102|#

                 #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |##|line 103|#

                 (loop for child_descriptor in (cdr (assoc 'children  diagram))
                   do                                                                                      #|line 104|#

                   (cond
                     ((first_char_is   (cdr (assoc 'name  child_descriptor))   "$" )                   #|line 105|#

                       (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 106|#

                         (let ((cmd (cdr (assoc '(strip )  (subseq  name 1)))))                  #|line 107|#

                           (let ((generated_leaf (Template  :name  name :instantiator  shell_out_instantiate :template_data  cmd #|line 108|#
                                                   )))
                             (register_component    reg   generated_leaf ))))                #|line 109|#

                       )
                     ((first_char_is   (cdr (assoc 'name  child_descriptor))   "'" )                   #|line 110|#

                       (let ((name (cdr (assoc 'name  child_descriptor))))                         #|line 111|#

                         (let ((s  (subseq  name 1)))                                            #|line 112|#

                           (let ((generated_leaf (Template  :name  name :instantiator  string_constant_instantiate :template_data  s #|line 113|#
                                                   )))
                             (register_component    reg   generated_leaf :ok_to_overwrite  t ))))
                       ))
                   )
                 )                                                                                                 #|line 114|#

               ))                                                                                                      #|line 115|#

	    )
	  (defun first_char (&optional  s)                                                                                        #|line 117|#

	    (return-from first_char  (car  s))                                                                                  #|line 118|#
            #|line 119|#

	    )
	  (defun first_char_is (&optional  s  c)                                                                                  #|line 121|#

	    (return-from first_char_is ( equal    c (first_char    s                                                            #|line 122|#
						      )))                                                                                                               #|line 123|#

	    )#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 125|#
	  #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |##|line 126|#

	  (defun run_command (&optional  eh  cmd  s)                                                                              #|line 127|#

	    (let ((ret (cdr (assoc '(run    cmd :capture_output  t :input  s :encoding  "UTF_8"                                 #|line 128|#
				      )  subprocess))))
              (cond
		((not ( equal   (cdr (assoc ' returncode  ret))  0))                                                          #|line 129|#

                  (cond
                    ((not (equal  (cdr (assoc ' stderr  ret))  nil)                                                       #|line 130|#

                       (return-from run_command (values undefined undefined))                                          #|line 131|#

                       )
                      (t                                                                                                    #|line 132|#

                        (return-from run_command (values undefined undefined))
			))                                                                                                  #|line 133|#

		    )
		  (t                                                                                                            #|line 134|#

                    (return-from run_command (values undefined undefined))                                                  #|line 135|#

		    )))                                                                                                         #|line 136|#

	      )#|  Data for an asyncronous component _ effectively, a function with input |#                                          #|line 138|#
	    #|  and output queues of messages. |#                                                                                   #|line 139|#
	    #|  |#                                                                                                                  #|line 140|#
	    #|  Components can either be a user_supplied function (“lea“), or a “container“ |#                                      #|line 141|#
	    #|  that routes messages to child components according to a list of connections |#                                      #|line 142|#
	    #|  that serve as a message routing table. |#                                                                           #|line 143|#
	    #|  |#                                                                                                                  #|line 144|#
	    #|  Child components themselves can be leaves or other containers. |#                                                   #|line 145|#
	    #|  |#                                                                                                                  #|line 146|#
	    #|  `handler` invokes the code that is attached to this component. |#                                                   #|line 147|#
	    #|  |#                                                                                                                  #|line 148|#
	    #|  `instance_data` is a pointer to instance data that the `leaf_handler` |#                                            #|line 149|#
	    #|  function may want whenever it is invoked again. |#                                                                  #|line 150|#
	    #|  |#                                                                                                                  #|line 151|#
            #|line 152|#
            #|line 155|#
            #|line 156|#
	    #|  Eh_States :: enum { idle, active } |#                                                                               #|line 157|#

	    (defun Eh (&optional )                                                                                                  #|line 158|#

	      (list
		(cons 'name  "")                                                                                                    #|line 159|#

		(cons 'inq (cdr (assoc '(Queue )  queue)))                                                                          #|line 160|#

		(cons 'outq (cdr (assoc '(Queue )  queue)))                                                                         #|line 161|#

		(cons 'owner  nil)                                                                                                  #|line 162|#

		(cons 'saved_messages (cdr (assoc '(LifoQueue )  queue))) #|  stack of saved message(s) |#                          #|line 163|#

		(cons 'inject  injector_NIY)                                                                                        #|line 164|#

		(cons 'children  nil)                                                                                               #|line 165|#

		(cons 'visit_ordering (cdr (assoc '(Queue )  queue)))                                                               #|line 166|#

		(cons 'connections  nil)                                                                                            #|line 167|#

		(cons 'routings (cdr (assoc '(Queue )  queue)))                                                                     #|line 168|#

		(cons 'handler  nil)                                                                                                #|line 169|#

		(cons 'instance_data  nil)                                                                                          #|line 170|#

		(cons 'state  "idle")                                                                                               #|line 171|#
		#|  bootstrap debugging |#                                                                                          #|line 172|#

		(cons 'kind  nil) #|  enum { container, leaf, } |#                                                                  #|line 173|#

		(cons 'trace  nil) #|  set '⊤' if logging is enabled and if this component should be traced, (⊥ means silence, no tracing for this component) |##|line 174|#

		(cons 'depth  0) #|  hierarchical depth of component, 0=top, 1=1st child of top, 2=1st child of 1st child of top, etc. |##|line 175|#
		)                                                                                                                   #|line 176|#
	      )
            #|line 177|#
	    #|  Creates a component that acts as a container. It is the same as a `Eh` instance |#                                  #|line 178|#
	    #|  whose handler function is `container_handler`. |#                                                                   #|line 179|#

	    (defun make_container (&optional  name  owner)                                                                          #|line 180|#

	      (let ((eh (Eh )))                                                                                                   #|line 181|#

		(setf (cdr (assoc ' name  eh))  name)                                                                           #|line 182|#

		(setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 183|#

		(setf (cdr (assoc ' handler  eh))  container_handler)                                                       #|line 184|#

		(setf (cdr (assoc ' inject  eh))  container_injector)                                                     #|line 185|#

                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 186|#

                (setf (cdr (assoc ' kind  eh))  "container")                                                          #|line 187|#

                (return-from make_container  eh)                                                                    #|line 188|#
                )                                                                                                     #|line 189|#

	      )#|  Creates a new leaf component out of a handler function, and a data parameter |#                                    #|line 191|#
	    #|  that will be passed back to your handler when called. |#                                                            #|line 192|#
            #|line 193|#

	    (defun make_leaf (&optional  name  owner  instance_data  handler)                                                       #|line 194|#

	      (let ((eh (Eh )))                                                                                                   #|line 195|#

		(setf (cdr (assoc ' name  eh))  (concatenate 'string (cdr (assoc ' name  owner))  (concatenate 'string  "."  name)))#|line 196|#

		(setf (cdr (assoc ' owner  eh))  owner)                                                                       #|line 197|#

		(setf (cdr (assoc ' handler  eh))  handler)                                                                 #|line 198|#

		(setf (cdr (assoc ' instance_data  eh))  instance_data)                                                   #|line 199|#

                (setf (cdr (assoc ' state  eh))  "idle")                                                                #|line 200|#

                (setf (cdr (assoc ' kind  eh))  "leaf")                                                               #|line 201|#

                (return-from make_leaf  eh)                                                                         #|line 202|#
                )                                                                                                     #|line 203|#

	      )#|  Sends a message on the given `port` with `data`, placing it on the output |#                                       #|line 205|#
	    #|  of the given component. |#                                                                                          #|line 206|#
            #|line 207|#

	    (defun send (&optional  eh  port  datum  causingMessage)                                                                #|line 208|#

	      (let ((msg (make_message    port   datum                                                                            #|line 209|#
			   )))
		(log_send  :sender  eh :sender_port  port :msg  msg :cause_msg  causingMessage                                  #|line 210|#
		  )
		(put_output    eh   msg                                                                                       #|line 211|#
		  ))                                                                                                            #|line 212|#

	      )
	    (defun send_string (&optional  eh  port  s  causingMessage)                                                             #|line 214|#

	      (let ((datum (new_datum_string    s                                                                                 #|line 215|#
			     )))
		(let ((msg (make_message  :port  port :datum  datum                                                             #|line 216|#
			     )))
		  (log_send_string  :sender  eh :sender_port  port :msg  msg :cause_msg  causingMessage                       #|line 217|#
		    )
		  (put_output    eh   msg                                                                                   #|line 218|#
		    )))                                                                                                       #|line 219|#

	      )
	    (defun forward (&optional  eh  port  msg)                                                                               #|line 221|#

	      (let ((fwdmsg (make_message    port  (cdr (assoc ' datum  msg))                                                     #|line 222|#
			      )))
		(log_forward  :sender  eh :sender_port  port :msg  msg :cause_msg  msg                                          #|line 223|#
		  )
		(put_output    eh   msg                                                                                       #|line 224|#
		  ))                                                                                                            #|line 225|#

	      )
	    (defun inject (&optional  eh  msg)                                                                                      #|line 227|#

	      (cdr (assoc '(inject    eh   msg                                                                                    #|line 228|#
			     )  eh))                                                                                                             #|line 229|#

	      )#|  Returns a list of all output messages on a container. |#                                                           #|line 231|#
	    #|  For testing / debugging purposes. |#                                                                                #|line 232|#
            #|line 233|#

	    (defun output_list (&optional  eh)                                                                                      #|line 234|#

	      (return-from output_list (cdr (assoc ' outq  eh)))                                                                  #|line 235|#
              #|line 236|#

	      )#|  Utility for printing an array of messages. |#                                                                      #|line 238|#

	    (defun print_output_list (&optional  eh)                                                                                #|line 239|#

	      (loop for m in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
		do                                                                                                                #|line 240|#

		(print   (format_message    m ) )                                                                             #|line 241|#

		)                                                                                                                 #|line 242|#

	      )
	    (defun spaces (&optional  n)                                                                                            #|line 244|#

	      (let (( s  ""))                                                                                                     #|line 245|#

		(loop for i in (loop for n from 0 below  n by 1 collect n)
		  do                                                                                                            #|line 246|#

		  (setf  s (+  s  " "))                                                                                     #|line 247|#

		  )
		(return-from spaces  s)                                                                                       #|line 248|#
		)                                                                                                               #|line 249|#

	      )
	    (defun set_active (&optional  eh)                                                                                       #|line 251|#

	      (setf (cdr (assoc ' state  eh))  "active")                                                                          #|line 252|#
              #|line 253|#

	      )
	    (defun set_idle (&optional  eh)                                                                                         #|line 255|#

	      (setf (cdr (assoc ' state  eh))  "idle")                                                                            #|line 256|#
              #|line 257|#

	      )#|  Utility for printing a specific output message. |#                                                                 #|line 259|#
            #|line 260|#

	    (defun fetch_first_output (&optional  eh  port)                                                                         #|line 261|#

	      (loop for msg in (list   (cdr (assoc '(cdr (assoc ' queue  outq))  eh)) )
		do                                                                                                                #|line 262|#

		(cond
		  (( equal   (cdr (assoc ' port  msg))  port)                                                                 #|line 263|#

                    (return-from fetch_first_output (cdr (assoc ' datum  msg)))
		    ))                                                                                                        #|line 264|#

		)
	      (return-from fetch_first_output  nil)                                                                             #|line 265|#
              #|line 266|#

	      )
	    (defun print_specific_output (&optional  eh  :port  ""  :stderr  nil)                                                   #|line 268|#

	      (let (( datum (fetch_first_output    eh   port                                                                      #|line 269|#
			      )))
		(let (( outf  nil))                                                                                             #|line 270|#

		  (cond
		    ((not (equal   datum  nil)                                                                                #|line 271|#

                       (cond
			 ( stderr
                           #|  I don't remember why I found it useful to print to stderr during bootstrapping, so I've left it in... |##|line 272|#

                           (setf  outf (cdr (assoc ' stderr  sys)))                                                  #|line 273|#

                           )
			 (t                                                                                                #|line 274|#

                           (setf  outf (cdr (assoc ' stdout  sys)))                                                    #|line 275|#

                           ))
                       (print   (cdr (assoc '(srepr )  datum)) :file  outf )                                             #|line 276|#

                       ))))                                                                                                    #|line 277|#

		)
	      (defun put_output (&optional  eh  msg)                                                                                  #|line 279|#

		(cdr (assoc '(cdr (assoc '(put    msg                                                                               #|line 280|#
					    )  outq))  eh))                                                                                                     #|line 281|#

		)
	      (defun injector_NIY (&optional  eh  msg)                                                                                #|line 283|#

		#|  print (f'Injector not implemented for this component “{eh.name}“ kind ∷ {eh.kind} port ∷ “{msg.port}“') |#      #|line 284|#

		(print    (concatenate 'string  "Injector not implemented for this component "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  " kind ∷ "  (concatenate 'string (cdr (assoc ' kind  eh))  (concatenate 'string  ",  port ∷ " (cdr (assoc ' port  msg))))))) #|line 289|#
		  )
		(exit )                                                                                                         #|line 290|#
                #|line 291|#

		)                                                                                                                       #|line 297|#

	      (defparameter  root_project  "")                                                                                        #|line 298|#

	      (defparameter  root_0D  "")                                                                                             #|line 299|#
              #|line 300|#

	      (defun set_environment (&optional  rproject  r0D)                                                                       #|line 301|#
                #|line 302|#
                #|line 303|#

		(setf  root_project  rproject)                                                                                  #|line 304|#

		(setf  root_0D  r0D)                                                                                          #|line 305|#
                #|line 306|#

		)
	      (defun probe_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 308|#

		(let ((name_with_id (gensymbol    "?"                                                                               #|line 309|#
				      )))
		  (return-from probe_instantiate (make_leaf  :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 310|#
						   )))                                                                                                           #|line 311|#

		)
	      (defun probeA_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 312|#

		(let ((name_with_id (gensymbol    "?A"                                                                              #|line 313|#
				      )))
		  (return-from probeA_instantiate (make_leaf  :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 314|#
						    )))                                                                                                           #|line 315|#

		)
	      (defun probeB_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 317|#

		(let ((name_with_id (gensymbol    "?B"                                                                              #|line 318|#
				      )))
		  (return-from probeB_instantiate (make_leaf  :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 319|#
						    )))                                                                                                           #|line 320|#

		)
	      (defun probeC_instantiate (&optional  reg  owner  name  template_data)                                                  #|line 322|#

		(let ((name_with_id (gensymbol    "?C"                                                                              #|line 323|#
				      )))
		  (return-from probeC_instantiate (make_leaf  :name  name_with_id :owner  owner :instance_data  nil :handler  probe_handler #|line 324|#
						    )))                                                                                                           #|line 325|#

		)
	      (defun probe_handler (&optional  eh  msg)                                                                               #|line 327|#

		(let ((s (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))))                                                       #|line 328|#

		  (print    (concatenate 'string  "... probe "  (concatenate 'string (cdr (assoc ' name  eh))  (concatenate 'string  ": "  s))) :file (cdr (assoc ' stderr  sys)) #|line 329|#
		    ))                                                                                                              #|line 330|#

		)
	      (defun trash_instantiate (&optional  reg  owner  name  template_data)                                                   #|line 332|#

		(let ((name_with_id (gensymbol    "trash"                                                                           #|line 333|#
				      )))
		  (return-from trash_instantiate (make_leaf  :name  name_with_id :owner  owner :instance_data  nil :handler  trash_handler #|line 334|#
						   )))                                                                                                           #|line 335|#

		)
	      (defun trash_handler (&optional  eh  msg)                                                                               #|line 337|#

		#|  to appease dumped_on_floor checker |#                                                                           #|line 338|#

		#| pass |#                                                                                                        #|line 339|#
                #|line 340|#

		)
	      (defun TwoMessages (&optional  first  second)                                                                           #|line 341|#

		(list
		  (cons 'first  first)                                                                                                #|line 342|#

		  (cons 'second  second)                                                                                              #|line 343|#
		  )                                                                                                                   #|line 344|#
		)
              #|line 345|#
	      #|  Deracer_States :: enum { idle, waitingForFirst, waitingForSecond } |#                                               #|line 346|#

	      (defun Deracer_Instance_Data (&optional  state  buffer)                                                                 #|line 347|#

		(list
		  (cons 'state  state)                                                                                                #|line 348|#

		  (cons 'buffer  buffer)                                                                                              #|line 349|#
		  )                                                                                                                   #|line 350|#
		)
              #|line 351|#

	      (defun reclaim_Buffers_from_heap (&optional  inst)                                                                      #|line 352|#

		#| pass |#                                                                                                          #|line 353|#
                #|line 354|#

		)
	      (defun deracer_instantiate (&optional  reg  owner  name  template_data)                                                 #|line 356|#

		(let ((name_with_id (gensymbol    "deracer"                                                                         #|line 357|#
				      )))
		  (let ((inst (Deracer_Instance_Data    "idle"  (TwoMessages    nil   nil )                                       #|line 358|#
				)))
		    (setf (cdr (assoc ' state  inst))  "idle")                                                                  #|line 359|#

		    (let ((eh (make_leaf  :name  name_with_id :owner  owner :instance_data  inst :handler  deracer_handler    #|line 360|#
				)))
                      (return-from deracer_instantiate  eh)                                                                 #|line 361|#
                      )))                                                                                                     #|line 362|#

		)
	      (defun send_first_then_second (&optional  eh  inst)                                                                     #|line 364|#

		(forward    eh   "1"  (cdr (assoc '(cdr (assoc ' first  buffer))  inst))                                            #|line 365|#
		  )
		(forward    eh   "2"  (cdr (assoc '(cdr (assoc ' second  buffer))  inst))                                         #|line 366|#
		  )
		(reclaim_Buffers_from_heap    inst                                                                              #|line 367|#
		  )                                                                                                               #|line 368|#

		)
	      (defun deracer_handler (&optional  eh  msg)                                                                             #|line 370|#

		(setf  inst (cdr (assoc ' instance_data  eh)))                                                                      #|line 371|#

		(cond
		  (( equal   (cdr (assoc ' state  inst))  "idle")                                                                 #|line 372|#

		    (cond
                      (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 373|#

			(setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 374|#

                        (setf (cdr (assoc ' state  inst))  "waitingForSecond")                                          #|line 375|#

			)
                      (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 376|#

			(setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 377|#

                        (setf (cdr (assoc ' state  inst))  "waitingForFirst")                                           #|line 378|#

			)
                      (t                                                                                                      #|line 379|#

			(runtime_error    (concatenate 'string  "bad msg.port (case A) for deracer " (cdr (assoc ' port  msg))) )
			))                                                                                                    #|line 380|#

		    )
		  (( equal   (cdr (assoc ' state  inst))  "waitingForFirst")                                                      #|line 381|#

		    (cond
                      (( equal    "1" (cdr (assoc ' port  msg)))                                                              #|line 382|#

			(setf (cdr (assoc '(cdr (assoc ' first  buffer))  inst))  msg)                                    #|line 383|#

                        (send_first_then_second    eh   inst                                                            #|line 384|#
                          )
                        (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 385|#

			)
                      (t                                                                                                      #|line 386|#

			(runtime_error    (concatenate 'string  "bad msg.port (case B) for deracer " (cdr (assoc ' port  msg))) )
			))                                                                                                    #|line 387|#

		    )
		  (( equal   (cdr (assoc ' state  inst))  "waitingForSecond")                                                     #|line 388|#

		    (cond
                      (( equal    "2" (cdr (assoc ' port  msg)))                                                              #|line 389|#

			(setf (cdr (assoc '(cdr (assoc ' second  buffer))  inst))  msg)                                   #|line 390|#

                        (send_first_then_second    eh   inst                                                            #|line 391|#
                          )
                        (setf (cdr (assoc ' state  inst))  "idle")                                                    #|line 392|#

			)
                      (t                                                                                                      #|line 393|#

			(runtime_error    (concatenate 'string  "bad msg.port (case C) for deracer " (cdr (assoc ' port  msg))) )
			))                                                                                                    #|line 394|#

		    )
		  (t                                                                                                              #|line 395|#

		    (runtime_error    "bad state for deracer {eh.state}" )                                                    #|line 396|#

		    ))                                                                                                            #|line 397|#

		)
	      (defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)                                #|line 399|#

		(let ((name_with_id (gensymbol    "Low Level Read Text File"                                                        #|line 400|#
				      )))
		  (return-from low_level_read_text_file_instantiate (make_leaf    name_with_id   owner   nil   low_level_read_text_file_handler #|line 401|#
								      )))                                                                                                           #|line 402|#

		)
	      (defun low_level_read_text_file_handler (&optional  eh  msg)                                                            #|line 404|#

		(let ((fname (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))))                                                   #|line 405|#

		  ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
		  ;; given eh and msg if needed
		  (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
		    (with-open-file (stream fname)
		      (let ((contents (make-string (file-length stream))))
			(read-sequence contents stream)
			(send_string eh "" contents))))
                  #|line 406|#
		  )                                                                                                                 #|line 407|#

		)
	      (defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)                                     #|line 409|#

		(let ((name_with_id (gensymbol    "Ensure String Datum"                                                             #|line 410|#
				      )))
		  (return-from ensure_string_datum_instantiate (make_leaf    name_with_id   owner   nil   ensure_string_datum_handler #|line 411|#
								 )))                                                                                                           #|line 412|#

		)
	      (defun ensure_string_datum_handler (&optional  eh  msg)                                                                 #|line 414|#

		(cond
		  (( equal    "string" (cdr (assoc '(cdr (assoc '(kind )  datum))  msg)))                                           #|line 415|#

		    (forward    eh   ""   msg )                                                                                 #|line 416|#

		    )
		  (t                                                                                                                #|line 417|#

		    (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (cdr (assoc ' datum  msg)))))#|line 418|#

                      (send_string    eh   "✗"   emsg   msg ))                                                                #|line 419|#

		    ))                                                                                                              #|line 420|#

		)
	      (defun Syncfilewrite_Data (&optional )                                                                                  #|line 422|#

		(list
		  (cons 'filename  "")                                                                                                #|line 423|#
		  )                                                                                                                   #|line 424|#
		)
              #|line 425|#
	      #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |#                                      #|line 426|#

	      (defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)                                           #|line 427|#

		(let ((name_with_id (gensymbol    "syncfilewrite"                                                                   #|line 428|#
				      )))
		  (let ((inst (Syncfilewrite_Data )))                                                                             #|line 429|#

		    (return-from syncfilewrite_instantiate (make_leaf    name_with_id   owner   inst   syncfilewrite_handler    #|line 430|#
							     ))))                                                                                                      #|line 431|#

		)
	      (defun syncfilewrite_handler (&optional  eh  msg)                                                                       #|line 433|#

		(let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 434|#

		  (cond
		    (( equal    "filename" (cdr (assoc ' port  msg)))                                                             #|line 435|#

                      (setf (cdr (assoc ' filename  inst)) (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg)))                #|line 436|#

		      )
		    (( equal    "input" (cdr (assoc ' port  msg)))                                                                #|line 437|#

                      (let ((contents (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))))                                    #|line 438|#

			(let (( f (open   (cdr (assoc ' filename  inst))   "w"                                              #|line 439|#
				    )))
                          (cond
                            ((not (equal   f  nil)                                                                        #|line 440|#

                               (cdr (assoc '(write   (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))                #|line 441|#
					      )  f))
                               (cdr (assoc '(close )  f))                                                            #|line 442|#

                               (send    eh   "done"  (new_datum_bang )   msg )                                     #|line 443|#

                               )
                              (t                                                                                            #|line 444|#

                                (send_string    eh   "✗"   (concatenate 'string  "open error on file " (cdr (assoc ' filename  inst)))   msg )
				))))                                                                                        #|line 445|#

			)))                                                                                                         #|line 446|#

		  )
		(defun StringConcat_Instance_Data (&optional )                                                                          #|line 448|#

		  (list
		    (cons 'buffer1  nil)                                                                                                #|line 449|#

		    (cons 'buffer2  nil)                                                                                                #|line 450|#

		    (cons 'count  0)                                                                                                    #|line 451|#
		    )                                                                                                                   #|line 452|#
		  )
                #|line 453|#

		(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)                                            #|line 454|#

		  (let ((name_with_id (gensymbol    "stringconcat"                                                                    #|line 455|#
					)))
		    (let ((instp (StringConcat_Instance_Data )))                                                                    #|line 456|#

		      (return-from stringconcat_instantiate (make_leaf    name_with_id   owner   instp   stringconcat_handler     #|line 457|#
							      ))))                                                                                                      #|line 458|#

		  )
		(defun stringconcat_handler (&optional  eh  msg)                                                                        #|line 460|#

		  (let (( inst (cdr (assoc ' instance_data  eh))))                                                                    #|line 461|#

		    (cond
		      (( equal    "1" (cdr (assoc ' port  msg)))                                                                    #|line 462|#

			(setf (cdr (assoc ' buffer1  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))  #|line 463|#
							      ))
			(setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 464|#

			(maybe_stringconcat    eh   inst   msg )                                                            #|line 465|#

			)
		      (( equal    "2" (cdr (assoc ' port  msg)))                                                                    #|line 466|#

			(setf (cdr (assoc ' buffer2  inst)) (clone_string   (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))  #|line 467|#
							      ))
			(setf (cdr (assoc ' count  inst)) (+ (cdr (assoc ' count  inst))  1))                                 #|line 468|#

			(maybe_stringconcat    eh   inst   msg )                                                            #|line 469|#

			)
		      (t                                                                                                            #|line 470|#

			(runtime_error    (concatenate 'string  "bad msg.port for stringconcat: " (cdr (assoc ' port  msg)))    #|line 471|#
			  )                                                                                                       #|line 472|#

			)))                                                                                                         #|line 473|#

		  )
		(defun maybe_stringconcat (&optional  eh  inst  msg)                                                                    #|line 475|#

		  (cond
		    (( and  ( equal    0 (len   (cdr (assoc ' buffer1  inst)) )) ( equal    0 (len   (cdr (assoc ' buffer2  inst)) )))#|line 476|#

		      (runtime_error    "something is wrong in stringconcat, both strings are 0 length" )                         #|line 477|#

		      ))
		  (cond
		    (( >=  (cdr (assoc ' count  inst))  2)                                                                          #|line 478|#

		      (let (( concatenated_string  ""))                                                                         #|line 479|#

			(cond
			  (( equal    0 (len   (cdr (assoc ' buffer1  inst)) ))                                               #|line 480|#

                            (setf  concatenated_string (cdr (assoc ' buffer2  inst)))                                     #|line 481|#

			    )
			  (( equal    0 (len   (cdr (assoc ' buffer2  inst)) ))                                               #|line 482|#

                            (setf  concatenated_string (cdr (assoc ' buffer1  inst)))                                     #|line 483|#

			    )
			  (t                                                                                                  #|line 484|#

                            (setf  concatenated_string (+ (cdr (assoc ' buffer1  inst)) (cdr (assoc ' buffer2  inst))))   #|line 485|#

			    ))
			(send_string    eh   ""   concatenated_string   msg                                                 #|line 486|#
			  )
			(setf (cdr (assoc ' buffer1  inst))  nil)                                                         #|line 487|#

                        (setf (cdr (assoc ' buffer2  inst))  nil)                                                       #|line 488|#

                        (setf (cdr (assoc ' count  inst))  0))                                                        #|line 489|#

		      ))                                                                                                            #|line 490|#

		  )#|  |#                                                                                                                 #|line 492|#
                #|line 493|#
		#|  this needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |##|line 494|#

		(defun shell_out_instantiate (&optional  reg  owner  name  template_data)                                               #|line 495|#

		  (let ((name_with_id (gensymbol    "shell_out"                                                                       #|line 496|#
					)))
		    (let ((cmd (cdr (assoc '(split    template_data                                                                 #|line 497|#
					      )  shlex))))
		      (return-from shell_out_instantiate (make_leaf    name_with_id   owner   cmd   shell_out_handler             #|line 498|#
							   ))))                                                                                                      #|line 499|#

		  )
		(defun shell_out_handler (&optional  eh  msg)                                                                           #|line 501|#

		  (let ((cmd (cdr (assoc ' instance_data  eh))))                                                                      #|line 502|#

		    (let ((s (cdr (assoc '(cdr (assoc '(srepr )  datum))  msg))))                                                   #|line 503|#

		      (loop while (run_command    eh   cmd   s                                                                    #|line 504|#
				    )
			doundefined)
		      (cond
			((not (equal   stderr  nil)                                                                             #|line 505|#

			   (send_string    eh   "✗"   stderr   msg )                                                         #|line 506|#

			   )
			  (t                                                                                                      #|line 507|#

			    (send_string    eh   ""   stdout   msg )                                                          #|line 508|#

			    ))))                                                                                                  #|line 509|#

		    )
		  (defun string_constant_instantiate (&optional  reg  owner  name  template_data)                                         #|line 511|#
                    #|line 512|#
                    #|line 513|#

		    (let ((name_with_id (gensymbol    "strconst"                                                                    #|line 514|#
					  )))
		      (let (( s  template_data))                                                                                  #|line 515|#

			(cond
			  ((not (equal   root_project  "")                                                                      #|line 516|#

                             (setf  s (cdr (assoc '(sub    "_00_"   root_project   s )  re)))                                #|line 517|#

			     ))
			  (cond
			    ((not (equal   root_0D  "")                                                                         #|line 518|#

                               (setf  s (cdr (assoc '(sub    "_0D_"   root_0D   s )  re)))                                   #|line 519|#

			       ))
			    (return-from string_constant_instantiate (make_leaf    name_with_id   owner   s   string_constant_handler #|line 520|#
								       ))))                                                                                              #|line 521|#

			)
		      (defun string_constant_handler (&optional  eh  msg)                                                                     #|line 523|#

			(let ((s (cdr (assoc ' instance_data  eh))))                                                                        #|line 524|#

			  (send_string    eh   ""   s   msg                                                                               #|line 525|#
			    ))                                                                                                              #|line 526|#

			)
		      (defun string_make_persistent (&optional  s)                                                                            #|line 528|#

			#|  this is here for non_GC languages like Odin, it is a no_op for GC languages like Python |#                      #|line 529|#

			(return-from string_make_persistent  s)                                                                           #|line 530|#
                        #|line 531|#

			)
		      (defun string_clone (&optional  s)                                                                                      #|line 533|#

			(return-from string_clone  s)                                                                                       #|line 534|#
                        #|line 535|#

			)                                                                                                                       #|line 538|#
		      #|  usage: app ${_00_} ${_0D_} arg main diagram_filename1 diagram_filename2 ... |#                                      #|line 539|#
		      #|  where ${_00_} is the root directory for the project |#                                                              #|line 540|#
		      #|  where ${_0D_} is the root directory for 0D (e.g. 0D/odin or 0D/python) |#                                           #|line 541|#
                      #|line 542|#
                      #|line 543|#
                      #|line 544|#

		      (defun initialize_component_palette (&optional  root_project  root_0D  diagram_source_files)                            #|line 545|#

			(let ((reg (make_component_registry )))                                                                             #|line 546|#

			  (loop for diagram_source in  diagram_source_files
			    do                                                                                                            #|line 547|#

			    (let ((all_containers_within_single_file (json2internal    diagram_source                                 #|line 548|#
								       )))
			      (generate_shell_components    reg   all_containers_within_single_file                                 #|line 549|#
				)
			      (loop for container in  all_containers_within_single_file
				do                                                                                                #|line 550|#

				(register_component    reg  (Template  :name (cdr (assoc 'name  container)) :template_data  container :instantiator  container_instantiator ) )
				))                                                                                                #|line 551|#

			    )
			  (initialize_stock_components    reg                                                                           #|line 552|#
			    )
			  (return-from initialize_component_palette  reg)                                                             #|line 553|#
			  )                                                                                                             #|line 554|#

			)
		      (defun print_error_maybe (&optional  main_container)                                                                    #|line 556|#

			(let ((error_port  "✗"))                                                                                            #|line 557|#

			  (let ((err (fetch_first_output    main_container   error_port                                                   #|line 558|#
				       )))
			    (cond
			      (( and  (not (equal   err  nil) ( <   0 (len   (trimws   (cdr (assoc '(srepr )  err)) ) )))               #|line 559|#

				 (print    "___ !!! ERRORS !!! ___"                                                                  #|line 560|#
				   )
				 (print_specific_output    main_container   error_port   nil )                                     #|line 561|#

				 ))))                                                                                                    #|line 562|#

			  )#|  debugging helpers |#                                                                                               #|line 564|#
                        #|line 565|#

			(defun dump_outputs (&optional  main_container)                                                                         #|line 566|#

			  (print )                                                                                                            #|line 567|#

			  (print    "___ Outputs ___"                                                                                       #|line 568|#
			    )
			  (print_output_list    main_container                                                                            #|line 569|#
			    )                                                                                                               #|line 570|#

			  )
			(defun trace_outputs (&optional  main_container)                                                                        #|line 572|#

			  (print )                                                                                                            #|line 573|#

			  (print    "___ Message Traces ___"                                                                                #|line 574|#
			    )
			  (print_routing_trace    main_container                                                                          #|line 575|#
			    )                                                                                                               #|line 576|#

			  )
			(defun dump_hierarchy (&optional  main_container)                                                                       #|line 578|#

			  (print )                                                                                                            #|line 579|#

			  (print    (concatenate 'string  "___ Hierarchy ___" (build_hierarchy    main_container ))                         #|line 580|#
			    )                                                                                                                 #|line 581|#

			  )
			(defun build_hierarchy (&optional  c)                                                                                   #|line 583|#

			  (let (( s  ""))                                                                                                     #|line 584|#

			    (loop for child in (cdr (assoc ' children  c))
			      do                                                                                                            #|line 585|#

			      (setf  s  (concatenate 'string  s (build_hierarchy    child )))                                           #|line 586|#

			      )
			    (let (( indent  ""))                                                                                          #|line 587|#

			      (loop for i in (loop for n from 0 below (cdr (assoc ' depth  c)) by 1 collect n)
				do                                                                                                      #|line 588|#

				(setf  indent (+  indent  "  "))                                                                    #|line 589|#

				)
			      (return-from build_hierarchy  (concatenate 'string  "\n"  (concatenate 'string  indent  (concatenate 'string  "("  (concatenate 'string (cdr (assoc ' name  c))  (concatenate 'string  s  ")"))))))#|line 590|#
			      ))                                                                                                        #|line 591|#

			  )
			(defun dump_connections (&optional  c)                                                                                  #|line 593|#

			  (print )                                                                                                            #|line 594|#

			  (print    "___ connections ___"                                                                                   #|line 595|#
			    )
			  (dump_possible_connections    c                                                                                 #|line 596|#
			    )
			  (loop for child in (cdr (assoc ' children  c))
			    do                                                                                                          #|line 597|#

			    (print )                                                                                                #|line 598|#

			    (dump_possible_connections    child )                                                                 #|line 599|#

			    )                                                                                                           #|line 600|#

			  )
			(defun trimws (&optional  s)                                                                                            #|line 602|#

			  #|  remove whitespace from front and back of string |#                                                              #|line 603|#

			  (return-from trimws (cdr (assoc '(strip )  s)))                                                                   #|line 604|#
                          #|line 605|#

			  )
			(defun clone_string (&optional  s)                                                                                      #|line 607|#

			  (return-from clone_string  s                                                                                        #|line 608|#
                            #|line 609|#
			    )                                                                                                               #|line 610|#

			  )
			(defparameter  load_errors  nil)                                                                                        #|line 611|#

			(defparameter  runtime_errors  nil)                                                                                     #|line 612|#
                        #|line 613|#

			(defun load_error (&optional  s)                                                                                        #|line 614|#
                          #|line 615|#

			  (print    s                                                                                                       #|line 616|#
			    )
			  (quit )                                                                                                         #|line 617|#

			  (setf  load_errors  t)                                                                                        #|line 618|#
                          #|line 619|#

			  )
			(defun runtime_error (&optional  s)                                                                                     #|line 621|#
                          #|line 622|#

			  (print    s                                                                                                       #|line 623|#
			    )
			  (quit )                                                                                                         #|line 624|#

			  (setf  runtime_errors  t)                                                                                     #|line 625|#
                          #|line 626|#

			  )
			(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)                                            #|line 628|#

			  (let ((instance_name (gensymbol    "fakepipe"                                                                       #|line 629|#
						 )))
			    (return-from fakepipename_instantiate (make_leaf    instance_name   owner   nil   fakepipename_handler          #|line 630|#
								    )))                                                                                                           #|line 631|#

			  )
			(defparameter  rand  0)                                                                                                 #|line 633|#
                        #|line 634|#

			(defun fakepipename_handler (&optional  eh  msg)                                                                        #|line 635|#
                          #|line 636|#

			  (setf  rand (+  rand  1))
			  #|  not very random, but good enough _ 'rand' must be unique within a single run |#                             #|line 637|#

			  (send_string    eh   ""   (concatenate 'string  "/tmp/fakepipe"  rand)   msg                                  #|line 638|#
			    )                                                                                                             #|line 639|#

			  )                                                                                                                       #|line 641|#
			#|  all of the the built_in leaves are listed here |#                                                                   #|line 642|#
			#|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |##|line 643|#
                        #|line 644|#
                        #|line 645|#

			(defun initialize_stock_components (&optional  reg)                                                                     #|line 646|#

			  (register_component    reg  (Template    "1then2"   nil   deracer_instantiate )                                     #|line 647|#
			    )
			  (register_component    reg  (Template    "?"   nil   probe_instantiate )                                          #|line 648|#
			    )
			  (register_component    reg  (Template    "?A"   nil   probeA_instantiate )                                      #|line 649|#
			    )
			  (register_component    reg  (Template    "?B"   nil   probeB_instantiate )                                    #|line 650|#
			    )
			  (register_component    reg  (Template    "?C"   nil   probeC_instantiate )                                  #|line 651|#
			    )
			  (register_component    reg  (Template    "trash"   nil   trash_instantiate )                              #|line 652|#
			    )                                                                                                         #|line 653|#

			  (register_component    reg  (Template    "Low Level Read Text File"   nil   low_level_read_text_file_instantiate ) #|line 654|#
			    )
			  (register_component    reg  (Template    "Ensure String Datum"   nil   ensure_string_datum_instantiate ) #|line 655|#
			    )                                                                                                     #|line 656|#

			  (register_component    reg  (Template    "syncfilewrite"   nil   syncfilewrite_instantiate )        #|line 657|#
			    )
			  (register_component    reg  (Template    "stringconcat"   nil   stringconcat_instantiate )        #|line 658|#
			    )
                          #|  for fakepipe |#                                                                             #|line 659|#

                          (register_component    reg  (Template    "fakepipename"   nil   fakepipename_instantiate )    #|line 660|#
                            )                                                                                             #|line 661|#

			  )                                                                                                                       #|line 663|#

			(defun initialize (&optional )                                                                                          #|line 664|#

			  (let ((root_of_project  (nth  1 argv)))                                                                             #|line 665|#

			    (let ((root_of_0D  (nth  2 argv)))                                                                              #|line 666|#

			      (let ((arg  (nth  3 argv)))                                                                                 #|line 667|#

				(let ((main_container_name  (nth  4 argv)))                                                             #|line 668|#

				  (let ((diagram_names  (nthcdr  5 (argv))))                                                          #|line 669|#

				    (let ((palette (initialize_component_palette    root_project   root_0D   diagram_names          #|line 670|#
						     )))
				      (return-from initialize (values undefined undefined))                                       #|line 671|#
				      ))))))                                                                                        #|line 672|#

			  )
			(defun start (&optional  palette  env  :show_hierarchy  False  :show_connections  False  :show_traces  False  :show_all_outputs  False)#|line 674|#

			  (let ((root_of_project (nth  0  env)))                                                                              #|line 675|#

			    (let ((root_of_0D (nth  1  env)))                                                                               #|line 676|#

			      (let ((main_container_name (nth  2  env)))                                                                  #|line 677|#

				(let ((diagram_names (nth  3  env)))                                                                    #|line 678|#

				  (let ((arg (nth  4  env)))                                                                          #|line 679|#

				    (set_environment    root_of_project   root_of_0D                                                #|line 680|#
				      )
				    #|  get entrypoint container |#                                                               #|line 681|#

				    (setf  main_container (get_component_instance    palette   main_container_name :owner  nil  #|line 682|#
							    ))
				    (cond
                                      (( equal    nil  main_container)                                                        #|line 683|#

					(load_error    (concatenate 'string  "Couldn't find container with page name "  (concatenate 'string  main_container_name  (concatenate 'string  " in files "  (concatenate 'string  diagram_source_files  "(check tab names, or disable compression?)")))) #|line 687|#
					  )                                                                                 #|line 688|#

					))
                                    (cond
                                      ( show_hierarchy                                                                      #|line 689|#

                                        (dump_hierarchy    main_container                                               #|line 690|#
                                          )                                                                               #|line 691|#

					))
                                    (cond
                                      ( show_connections                                                                  #|line 692|#

                                        (dump_connections    main_container                                           #|line 693|#
                                          )                                                                             #|line 694|#

					))
                                    (cond
                                      ((not  load_errors)                                                               #|line 695|#

                                        (setf  arg (new_datum_string    arg                                         #|line 696|#
						     ))
                                        (setf  msg (make_message    ""   arg                                      #|line 697|#
						     ))
                                        (inject    main_container   msg                                         #|line 698|#
                                          )
                                        (cond
                                          ( show_all_outputs                                                  #|line 699|#

                                            (dump_outputs    main_container                               #|line 700|#
                                              )
                                            )
                                          (t                                                                  #|line 701|#

                                            (print_error_maybe    main_container                          #|line 702|#
                                              )
                                            (print_specific_output    main_container :port  "" :stderr  False #|line 703|#
                                              )
                                            (cond
                                              ( show_traces                                           #|line 704|#

                                                (print    "--- routing traces ---"                #|line 705|#
                                                  )
                                                (print   (routing_trace_all    main_container ) #|line 706|#
                                                  )                                               #|line 707|#

                                                ))                                                    #|line 708|#

                                            ))
                                        (cond
                                          ( show_all_outputs                                                #|line 709|#

                                            (print    "--- done ---"                                    #|line 710|#
                                              )                                                           #|line 711|#

                                            ))                                                              #|line 712|#

                                        )))))))                                                                         #|line 713|#

			  )                                                                                                                       #|line 715|#
                        #|line 716|#
			#|  utility functions  |#                                                                                               #|line 717|#

			(defun send_int (&optional  eh  port  i  causing_message)                                                               #|line 718|#

			  (let ((datum (new_datum_int    i                                                                                    #|line 719|#
					 )))
			    (send    eh   port   datum   causing_message                                                                    #|line 720|#
			      ))                                                                                                              #|line 721|#

			  )
			(defun send_bang (&optional  eh  port  causing_message)                                                                 #|line 723|#

			  (let ((datum (new_datum_bang )))                                                                                    #|line 724|#

			    (send    eh   port   datum   causing_message                                                                    #|line 725|#
			      ))                                                                                                              #|line 726|#

			  )




