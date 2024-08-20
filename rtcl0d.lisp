

(defparameter counter 0)
(defparameter digits (list  "₀" "₁" "₂" "₃" "₄" "₅" "₆" "₇" "₈" "₉" "₁₀" "₁₁" "₁₂" "₁₃" "₁₄" "₁₅" "₁₆" "₁₇" "₁₈" "₁₉" "₂₀" "₂₁" "₂₂" "₂₃" "₂₄" "₂₅" "₂₆" "₂₇" "₂₈" "₂₉"))
(defun gensym (s)
  (progn
    (let (name_with_id f"{s}{subscripted_digit (counter)}")
      (inc counter 1)
      
      (return-from gensym name_with_id))))
(defun subscripted_digit (n)
  (progn
    (cond 
      ( ( <=  ( and  ( >=  n 0) n) 29) 
        (progn
          
          (return-from subscripted_digit (aref digits n))))
      (t 
        (progn
          
          (return-from subscripted_digit f"₊{n}"))))))
(defun new-Datum ()
  (list
    (cons 'data  nil)
    (cons 'clone  nil)
    (cons 'reclaim  nil)
    (cons 'srepr  nil)
    (cons 'kind  nil)
    (cons 'raw  nil)))

(defun new_datum_string (s)
  (progn
    (let (d (fresh-Datum))
      (let ((slot-value 'data d) s)
        (let ((slot-value 'clone d) #'(lambda  (clone_datum_string  d)))
          (let ((slot-value 'reclaim d) #'(lambda  (reclaim_datum_string  d)))
            (let ((slot-value 'srepr d) #'(lambda  (srepr_datum_string  d)))
              (let ((slot-value 'raw d) #'(lambda  (raw_datum_string  d)))
                (let ((slot-value 'kind d) #'(lambda  "string"))
                  
                  (return-from new_datum_string d))))))))))
(defun clone_datum_string (d)
  (progn
    (let (d (new_datum_string  (slot-value 'data d)))
      
      (return-from clone_datum_string d))))
(defun reclaim_datum_string (src)
  (progn
    pass))
(defun srepr_datum_string (d)
  (progn
    
    (return-from srepr_datum_string (slot-value 'data d))))
(defun raw_datum_string (d)
  (progn
    
    (return-from raw_datum_string (bytearray  (slot-value 'data d)  'UTF_8'))))
(defun new_datum_bang ()
  (progn
    (let (p (Datum ))
      (let ((slot-value 'data p)  t)
        (let ((slot-value 'clone p) #'(lambda  (clone_datum_bang  p)))
          (let ((slot-value 'reclaim p) #'(lambda  (reclaim_datum_bang  p)))
            (let ((slot-value 'srepr p) #'(lambda  (srepr_datum_bang )))
              (let ((slot-value 'raw p) #'(lambda  (raw_datum_bang )))
                (let ((slot-value 'kind p) #'(lambda  "bang"))
                  
                  (return-from new_datum_bang p))))))))))
(defun clone_datum_bang (d)
  (progn
    
    (return-from clone_datum_bang (new_datum_bang ))))
(defun reclaim_datum_bang (d)
  (progn
    pass))
(defun srepr_datum_bang ()
  (progn
    
    (return-from srepr_datum_bang "!")))
(defun raw_datum_bang ()
  (progn
    
    (return-from raw_datum_bang  nil)))
(defun new_datum_tick ()
  (progn
    (let (p (new_datum_bang ))
      (let ((slot-value 'kind p) #'(lambda  "tick"))
        (let ((slot-value 'clone p) #'(lambda  (new_datum_tick )))
          (let ((slot-value 'srepr p) #'(lambda  (srepr_datum_tick )))
            (let ((slot-value 'raw p) #'(lambda  (raw_datum_tick )))
              
              (return-from new_datum_tick p))))))))
(defun srepr_datum_tick ()
  (progn
    
    (return-from srepr_datum_tick ".")))
(defun raw_datum_tick ()
  (progn
    
    (return-from raw_datum_tick  nil)))
(defun new_datum_bytes (b)
  (progn
    (let (p (Datum ))
      (let ((slot-value 'data p) b)
        (let ((slot-value 'clone p) clone_datum_bytes)
          (let ((slot-value 'reclaim p) #'(lambda  (reclaim_datum_bytes  p)))
            (let ((slot-value 'srepr p) #'(lambda  (srepr_datum_bytes  b)))
              (let ((slot-value 'raw p) #'(lambda  (raw_datum_bytes  b)))
                (let ((slot-value 'kind p) #'(lambda  "bytes"))
                  
                  (return-from new_datum_bytes p))))))))))
(defun clone_datum_bytes (src)
  (progn
    (let (p (Datum ))
      (let (p src)
        (let ((slot-value 'data p) (slot-value '(clone ) src))
          
          (return-from clone_datum_bytes p))))))
(defun reclaim_datum_bytes (src)
  (progn
    pass))
(defun srepr_datum_bytes (d)
  (progn
    
    (return-from srepr_datum_bytes (slot-value '(slot-value '(decode  'utf_8') data) d))))
(defun raw_datum_bytes (d)
  (progn
    
    (return-from raw_datum_bytes (slot-value 'data d))))
(defun new_datum_handle (h)
  (progn
    
    (return-from new_datum_handle (new_datum_int  h))))
(defun new_datum_int (i)
  (progn
    (let (p (Datum ))
      (let ((slot-value 'data p) i)
        (let ((slot-value 'clone p) #'(lambda  (clone_int  i)))
          (let ((slot-value 'reclaim p) #'(lambda  (reclaim_int  i)))
            (let ((slot-value 'srepr p) #'(lambda  (srepr_datum_int  i)))
              (let ((slot-value 'raw p) #'(lambda  (raw_datum_int  i)))
                (let ((slot-value 'kind p) #'(lambda  "int"))
                  
                  (return-from new_datum_int p))))))))))
(defun clone_int (i)
  (progn
    (let (p (Datum ))
      (let (p (new_datum_int  i))
        
        (return-from clone_int p)))))
(defun reclaim_int (src)
  (progn
    pass))
(defun srepr_datum_int (i)
  (progn
    
    (return-from srepr_datum_int (str  i))))
(defun raw_datum_int (i)
  (progn
    
    (return-from raw_datum_int i)))
(defun new-Message (port datum)
  (list
    (cons 'port port)
    (cons 'datum datum)))

(defun clone_port (s)
  (progn
    
    (return-from clone_port (clone_string  s))))
(defun make_message (port datum)
  (progn
    (let (p (clone_string  port))
      (let (m (Message  p  (slot-value '(clone ) datum)))
        
        (return-from make_message m)))))
(defun message_clone (message)
  (progn
    (let (m (Message  (clone_port  (slot-value 'port message))  (slot-value '(slot-value '(clone ) datum) message)))
      
      (return-from message_clone m))))
(defun destroy_message (msg)
  (progn
    pass))
(defun destroy_datum (msg)
  (progn
    pass))
(defun destroy_port (msg)
  (progn
    pass))
(defun format_message (m)
  (progn
    (cond 
      (( equal  m  nil) 
        (progn
          
          (return-from format_message "ϕ")))
      (t 
        (progn
          
          (return-from format_message f'⟪"{m.port}"⦂"{m.datum.srepr ()}"⟫'))))))
(defparameter drInject "inject")
(defparameter drSend "send")
(defparameter drInOut "inout")
(defparameter drForward "forward")
(defparameter drDown "down")
(defparameter drUp "up")
(defparameter drAcross "across")
(defparameter drThrough "through")
(defun make_Routing_Descriptor (action= nil component= nil port= nil message= nil)
  (progn
    
    (return-from make_Routing_Descriptor (fresh-hash (list  ("action" . action) ("component" . component) ("port" . port) ("message" . message))))))
(defun make_Send_Descriptor (component= nil port= nil message= nil cause_port= nil cause_message= nil)
  (progn
    (let (rdesc (make_Routing_Descriptor  drSend  component  port  message))
      
      (return-from make_Send_Descriptor (fresh-hash (list  ("action" . drSend) ("component" . (gethash 'component rdesc)) ("port" . (gethash 'port rdesc)) ("message" . (gethash 'message rdesc)) ("cause_port" . cause_port) ("cause_message" . cause_message) ("fmt" . fmt_send)))))))
(defun log_send (sender sender_port msg cause_msg)
  (progn
    (let (send_desc (make_Send_Descriptor  sender  sender_port  msg  (slot-value 'port cause_msg)  cause_msg))
      (append_routing_descriptor  (slot-value 'owner sender)  send_desc))))
(defun log_send_string (sender sender_port msg cause_msg)
  (progn
    (let (send_desc (make_Send_Descriptor  sender  sender_port  msg  (slot-value 'port cause_msg)  cause_msg))
      (append_routing_descriptor  (slot-value 'owner sender)  send_desc))))
(defun fmt_send (desc indent)
  (progn
    
    (return-from fmt_send "")))
(defun fmt_send_string (desc indent)
  (progn
    
    (return-from fmt_send_string (fmt_send  desc  indent))))
(defun make_Forward_Descriptor (component= nil port= nil message= nil cause_port= nil cause_message= nil)
  (progn
    (let (rdesc (make_Routing_Descriptor  drSend  component  port  message))
      (let (fmt_forward #'(lambda (desc) ''))
        
        (return-from make_Forward_Descriptor (fresh-hash (list  ("action" . drForward) ("component" . (gethash 'component rdesc)) ("port" . (gethash 'port rdesc)) ("message" . (gethash 'message rdesc)) ("cause_port" . cause_port) ("cause_message" . cause_message) ("fmt" . fmt_forward))))))))
(defun log_forward (sender sender_port msg cause_msg)
  (progn
    pass))
(defun fmt_forward (desc)
  (progn
    (print  f"*** Error fmt_forward {desc}")
    (quit )))
(defun make_Inject_Descriptor (receiver= nil port= nil message= nil)
  (progn
    (let (rdesc (make_Routing_Descriptor  drInject  receiver  port  message))
      
      (return-from make_Inject_Descriptor (fresh-hash (list  ("action" . drInject) ("component" . (gethash 'component rdesc)) ("port" . (gethash 'port rdesc)) ("message" . (gethash 'message rdesc)) ("fmt" . fmt_inject)))))))
(defun log_inject (receiver port msg)
  (progn
    (let (inject_desc (make_Inject_Descriptor  receiver  port  msg))
      (append_routing_descriptor  receiver  inject_desc))))
(defun fmt_inject (desc indent)
  (progn
    
    (return-from fmt_inject f'\n{indent}⟹  {desc@component.name}."{desc@port}" {format_message (desc@message)}')))
(defun make_Down_Descriptor (container= nil source_port= nil source_message= nil target= nil target_port= nil target_message= nil)
  (progn
    
    (return-from make_Down_Descriptor (fresh-hash (list  ("action" . drDown) ("container" . container) ("source_port" . source_port) ("source_message" . source_message) ("target" . target) ("target_port" . target_port) ("target_message" . target_message) ("fmt" . fmt_down))))))
(defun log_down (container= nil source_port= nil source_message= nil target= nil target_port= nil target_message= nil)
  (progn
    (let (rdesc (make_Down_Descriptor  container  source_port  source_message  target  target_port  target_message))
      (append_routing_descriptor  container  rdesc))))
(defun fmt_down (desc indent)
  (progn
    
    (return-from fmt_down f'\n{indent}↓ {desc@container.name}."{desc@source_port}" ➔ {desc@target.name}."{desc@target_port}" {format_message (desc@target_message)}')))
(defun make_Up_Descriptor (source= nil source_port= nil source_message= nil container= nil container_port= nil container_message= nil)
  (progn
    
    (return-from make_Up_Descriptor (fresh-hash (list  ("action" . drUp) ("source" . source) ("source_port" . source_port) ("source_message" . source_message) ("container" . container) ("container_port" . container_port) ("container_message" . container_message) ("fmt" . fmt_up))))))
(defun log_up (source= nil source_port= nil source_message= nil container= nil target_port= nil target_message= nil)
  (progn
    (let (rdesc (make_Up_Descriptor  source  source_port  source_message  container  target_port  target_message))
      (append_routing_descriptor  container  rdesc))))
(defun fmt_up (desc indent)
  (progn
    
    (return-from fmt_up f'\n{indent}↑ {desc@source.name}."{desc@source_port}" ➔ {desc@container.name}."{desc@container_port}" {format_message (desc@container_message)}')))
(defun make_Across_Descriptor (container= nil source= nil source_port= nil source_message= nil target= nil target_port= nil target_message= nil)
  (progn
    
    (return-from make_Across_Descriptor (fresh-hash (list  ("action" . drAcross) ("container" . container) ("source" . source) ("source_port" . source_port) ("source_message" . source_message) ("target" . target) ("target_port" . target_port) ("target_message" . target_message) ("fmt" . fmt_across))))))
(defun log_across (container= nil source= nil source_port= nil source_message= nil target= nil target_port= nil target_message= nil)
  (progn
    (let (rdesc (make_Across_Descriptor  container  source  source_port  source_message  target  target_port  target_message))
      (append_routing_descriptor  container  rdesc))))
(defun fmt_across (desc indent)
  (progn
    
    (return-from fmt_across f'\n{indent}→ {desc@source.name}."{desc@source_port}" ➔ {desc@target.name}."{desc@target_port}"  {format_message (desc@target_message)}')))
(defun make_Through_Descriptor (container= nil source_port= nil source_message= nil target_port= nil message= nil)
  (progn
    
    (return-from make_Through_Descriptor (fresh-hash (list  ("action" . drThrough) ("container" . container) ("source_port" . source_port) ("source_message" . source_message) ("target_port" . target_port) ("message" . message) ("fmt" . fmt_through))))))
(defun log_through (container= nil source_port= nil source_message= nil target_port= nil message= nil)
  (progn
    (let (rdesc (make_Through_Descriptor  container  source_port  source_message  target_port  message))
      (append_routing_descriptor  container  rdesc))))
(defun fmt_through (desc indent)
  (progn
    
    (return-from fmt_through f'\n{indent}⇶ {desc @container.name}."{desc@source_port}" ➔ {desc@container.name}."{desc@target_port}" {format_message (desc@message)}')))
(defun make_InOut_Descriptor (container= nil component= nil in_message= nil out_port= nil out_message= nil)
  (progn
    
    (return-from make_InOut_Descriptor (fresh-hash (list  ("action" . drInOut) ("container" . container) ("component" . component) ("in_message" . in_message) ("out_message" . out_message) ("fmt" . fmt_inout))))))
(defun log_inout (container= nil component= nil in_message= nil)
  (progn
    (cond 
      ((slot-value '(slot-value '(empty ) outq) component) 
        (progn
          (log_inout_no_output  container  component  in_message)))
      (t 
        (progn
          (log_inout_recursively  container  component  in_message  (list  (slot-value '(slot-value 'queue outq) component))))))))
(defun log_inout_no_output (container= nil component= nil in_message= nil)
  (progn
    (let (rdesc (make_InOut_Descriptor  container  component  in_message))
      (append_routing_descriptor  container  rdesc))))
(defun log_inout_single (container= nil component= nil in_message= nil out_message= nil)
  (progn
    (let (rdesc (make_InOut_Descriptor  container  component  in_message  out_message))
      (append_routing_descriptor  container  rdesc))))
(defun log_inout_recursively (container= nil component= nil in_message= nil out_messages= nil)
  (progn
    (cond 
      (( equal   nil out_messages) 
        (progn
          pass))
      (t 
        (progn
          (let (m (car out_messages))
            (let (rest (cdr out_messages))
              (log_inout_single  container  component  in_message  m)
              (log_inout_recursively  container  component  in_message  rest))))))))
(defun fmt_inout (desc indent)
  (progn
    (let (outm (gethash 'out_message desc))
      (cond 
        (( equal   nil outm) 
          (progn
            
            (return-from fmt_inout f'\n{indent}  ⊥')))
        (t 
          (progn
            
            (return-from fmt_inout f'\n{indent}  ∴ {desc@component.name} {format_message (outm)}')))))))
(defun log_tick (container= nil component= nil in_message= nil)
  (progn
    pass))
(defun routing_trace_all (container)
  (progn
    (let (indent "")
      (let (lis (list  (slot-value '(slot-value 'queue routings) container)))
        
        (return-from routing_trace_all (recursive_routing_trace  container  lis  indent))))))
(defun recursive_routing_trace (container lis indent)
  (progn
    (cond 
      (( equal   nil lis) 
        (progn
          
          (return-from recursive_routing_trace '')))
      (t 
        (progn
          (let (desc (first  lis))
            (let (formatted ((gethash 'fmt desc)  desc  indent))
              
              (return-from recursive_routing_trace (+ formatted (recursive_routing_trace  container  (rest  lis)  (+ indent '  ')))))))))))
(defconstant enumDown 0)
(defconstant enumAcross 1)
(defconstant enumUp 2)
(defconstant enumThrough 3)
(defun container_instantiator (reg owner container_name desc)
  (progn
    (let (container (make_container  container_name  owner))
      (let (children  nil)
        (let (children_by_id (make-hash-table :test :equal))
          for child_desc in (gethash 'children desc):
          (progn
            (let (child_instance (get_component_instance  reg  (gethash 'name child_desc)  container))
              (slot-value '(append  child_instance) children)
              (let ((aref children_by_id (gethash 'id child_desc)) child_instance))))
          (let ((slot-value 'children container) children)
            (let (me container)
              (let (connectors  nil)
                for proto_conn in (gethash 'connections desc):
                (progn
                  (let (source_component  nil)
                    (let (target_component  nil)
                      (let (connector (Connector ))
                        (cond 
                          (( equal  (gethash 'dir proto_conn) enumDown) 
                            (progn
                              (let ((slot-value 'direction connector) "down")
                                (let ((slot-value 'sender connector) (Sender  (slot-value 'name me)  me  (gethash 'source_port proto_conn)))
                                  (let (target_component (aref children_by_id (gethash 'id (gethash 'target proto_conn))))
                                    (cond 
                                      ( ( equal  target_component  nil) 
                                        (progn
                                          (load_error  f"internal error: .Down connection target internal error {proto_conn@target}")))
                                      (t 
                                        (progn
                                          (let ((slot-value 'receiver connector) (Receiver  (slot-value 'name target_component)  (slot-value 'inq target_component)  (gethash 'target_port proto_conn)  target_component))
                                            (slot-value '(append  connector) connectors))))))))))
                          (( equal  (gethash 'dir proto_conn) enumAcross) 
                            (progn
                              (let ((slot-value 'direction connector) "across")
                                (let (source_component (aref children_by_id (gethash 'id (gethash 'source proto_conn))))
                                  (let (target_component (aref children_by_id (gethash 'id (gethash 'target proto_conn))))
                                    (cond 
                                      (( equal  source_component  nil) 
                                        (progn
                                          (load_error  f"internal error: .Across connection source not ok {proto_conn@source}")))
                                      (t 
                                        (progn
                                          (let ((slot-value 'sender connector) (Sender  (slot-value 'name source_component)  source_component  (gethash 'source_port proto_conn)))
                                            (cond 
                                              (( equal  target_component  nil) 
                                                (progn
                                                  (load_error  f"internal error: .Across connection target not ok {proto_conn.target}")))
                                              (t 
                                                (progn
                                                  (let ((slot-value 'receiver connector) (Receiver  (slot-value 'name target_component)  (slot-value 'inq target_component)  (gethash 'target_port proto_conn)  target_component))
                                                    (slot-value '(append  connector) connectors))))))))))))))
                          (( equal  (gethash 'dir proto_conn) enumUp) 
                            (progn
                              (let ((slot-value 'direction connector) "up")
                                (let (source_component (aref children_by_id (gethash 'id (gethash 'source proto_conn))))
                                  (cond 
                                    (( equal  source_component  nil) 
                                      (progn
                                        (print  f"internal error: .Up connection source not ok {proto_conn@source}")))
                                    (t 
                                      (progn
                                        (let ((slot-value 'sender connector) (Sender  (slot-value 'name source_component)  source_component  (gethash 'source_port proto_conn)))
                                          (let ((slot-value 'receiver connector) (Receiver  (slot-value 'name me)  (slot-value 'outq container)  (gethash 'target_port proto_conn)  me))
                                            (slot-value '(append  connector) connectors))))))))))
                          (( equal  (gethash 'dir proto_conn) enumThrough) 
                            (progn
                              (let ((slot-value 'direction connector) "through")
                                (let ((slot-value 'sender connector) (Sender  (slot-value 'name me)  me  (gethash 'source_port proto_conn)))
                                  (let ((slot-value 'receiver connector) (Receiver  (slot-value 'name me)  (slot-value 'outq container)  (gethash 'target_port proto_conn)  me))
                                    (slot-value '(append  connector) connectors)))))))))))
                (let ((slot-value 'connections container) connectors)
                  
                  (return-from container_instantiator container))))))))))
(defun container_handler (container message)
  (progn
    (route  container  container  message)
    while (any_child_ready  container):
    (progn
      (step_children  container  message))))
(defun destroy_container (eh)
  (progn
    pass))
(defun fifo_is_empty (fifo)
  (progn
    
    (return-from fifo_is_empty (slot-value '(empty ) fifo))))
(defun new-Connector ()
  (list
    (cons 'direction  nil)
    (cons 'sender  nil)
    (cons 'receiver  nil)))

(defun new-Sender (name component port)
  (list
    (cons 'name name)
    (cons 'component component)
    (cons 'port port)))

(defun new-Receiver (name queue port component)
  (list
    (cons 'name name)
    (cons 'queue queue)
    (cons 'port port)
    (cons 'component component)))

(defun sender_eq (s1 s2)
  (progn
    (let (same_components  ( equal  (slot-value 'component s1) (slot-value 'component s2)))
      (let (same_ports  ( equal  (slot-value 'port s1) (slot-value 'port s2)))
        
        (return-from sender_eq ( and  same_components same_ports))))))
(defun deposit (parent conn message)
  (progn
    (let (new_message (make_message  (slot-value '(slot-value 'port receiver) conn)  (slot-value 'datum message)))
      (log_connection  parent  conn  new_message)
      (push_message  parent  (slot-value '(slot-value 'component receiver) conn)  (slot-value '(slot-value 'queue receiver) conn)  new_message))))
(defun force_tick (parent eh)
  (progn
    (let (tick_msg (make_message  "."  (new_datum_tick )))
      (push_message  parent  eh  (slot-value 'inq eh)  tick_msg)
      
      (return-from force_tick tick_msg))))
(defun push_message (parent receiver inq m)
  (progn
    (slot-value '(put  m) inq)
    (slot-value '(slot-value '(put  receiver) visit_ordering) parent)))
(defun is_self (child container)
  (progn
    
    (return-from is_self ( equal  child container))))
(defun step_child (child msg)
  (progn
    (let (before_state (slot-value 'state child))
      (slot-value '(handler  child  msg) child)
      (let (after_state (slot-value 'state child))
        
        (return-from step_child (values (not (equal ( and  ( equal  before_state "idle") after_state) "idle"))  (not (equal ( and  (not (equal before_state "idle")) after_state) "idle")) ( equal  ( and  (not (equal before_state "idle")) after_state) "idle")))))))
(defun save_message (eh msg)
  (progn
    (slot-value '(slot-value '(put  msg) saved_messages) eh)))
(defun fetch_saved_message_and_clear (eh)
  (progn
    
    (return-from fetch_saved_message_and_clear (slot-value '(slot-value '(get ) saved_messages) eh))))
(defun step_children (container causingMessage)
  (progn
    (let ((slot-value 'state container) "idle")
      for child in (list  (slot-value '(slot-value 'queue visit_ordering) container)):
      (progn
        (cond 
          ( (not  (is_self  child  container)) 
            (progn
              (cond 
                ( (not  (slot-value '(slot-value '(empty ) inq) child)) 
                  (progn
                    (let (msg (slot-value '(slot-value '(get ) inq) child))
                      (multiple-value-bind (began_long_run , continued_long_run, ended_long_run)
                        (step_child  child  msg)
                        (cond 
                          (began_long_run 
                            (progn
                              (save_message  child  msg)))
                          (continued_long_run 
                            (progn
                              pass))
                          (ended_long_run 
                            (progn
                              (log_inout  container  child  (fetch_saved_message_and_clear  child))))
                          (t 
                            (progn
                              (log_inout  container  child  msg))))
                        (destroy_message  msg)))))
                (t 
                  (progn
                    (cond 
                      ( (not (equal (slot-value 'state child) "idle")) 
                        (progn
                          (let (msg (force_tick  container  child))
                            (slot-value '(handler  child  msg) child)
                            (log_tick  container  child  msg)
                            (destroy_message  msg))))))))
              (cond 
                ( ( equal  (slot-value 'state child) "active") 
                  (progn
                    (let ((slot-value 'state container) "active")))))
              while  (not  (slot-value '(slot-value '(empty ) outq) child)):
              (progn
                (let (msg (slot-value '(slot-value '(get ) outq) child))
                  (route  container  child  msg)
                  (destroy_message  msg))))))))))
(defun attempt_tick (parent eh)
  (progn
    (cond 
      ((not (equal (slot-value 'state eh) "idle")) 
        (progn
          (force_tick  parent  eh))))))
(defun is_tick (msg)
  (progn
    
    (return-from is_tick ( equal  "tick" (slot-value '(slot-value '(kind ) datum) msg)))))
(defun route (container from_component message)
  (progn
    (let (was_sent  nil)
      (cond 
        ((is_tick  message) 
          (progn
            for child in (slot-value 'children container):
            (progn
              (attempt_tick  container  child  message))
            (let (was_sent  t))))
        (t 
          (progn
            (let (fromname "")
              (cond 
                ( (not  (is_self  from_component  container)) 
                  (progn
                    (let (fromname (slot-value 'name from_component))))))
              (let (from_sender (Sender  fromname  from_component  (slot-value 'port message)))
                for connector in (slot-value 'connections container):
                (progn
                  (cond 
                    ((sender_eq  from_sender  (slot-value 'sender connector)) 
                      (progn
                        (deposit  container  connector  message)
                        (let (was_sent  t)))))))))))
      (cond 
        ((not  was_sent) 
          (progn
            (print  "\n\n*** Error: ***")
            (dump_possible_connections  container)
            (print_routing_trace  container)
            (print  "***")
            (print  f"{container.name}: message '{message.port}' from {fromname} dropped on floor...")
            (print  "***")
            (exit )))))))
(defun dump_possible_connections (container)
  (progn
    (print  f"*** possible connections for {container.name}:")
    for connector in (slot-value 'connections container):
    (progn
      (print  f"{connector.direction} {connector.sender.name}.{connector.sender.port} -> {connector.receiver.name}.{connector.receiver.port}"))))
(defun any_child_ready (container)
  (progn
    for child in (slot-value 'children container):
    (progn
      (cond 
        ((child_is_ready  child) 
          (progn
            
            (return-from any_child_ready  t)))))
    
    (return-from any_child_ready  nil)))
(defun child_is_ready (eh)
  (progn
    
    (return-from child_is_ready ( or  ( or  ( or   (not  (slot-value '(slot-value '(empty ) outq) eh))  (not  (slot-value '(slot-value '(empty ) inq) eh)))  (not (equal (slot-value 'state eh) "idle")))  (any_child_ready  eh)))))
(defun print_routing_trace (eh)
  (progn
    (print  (routing_trace_all  eh))))
(defun append_routing_descriptor (container desc)
  (progn
    (slot-value '(slot-value '(put  desc) routings) container)))
(defun log_connection (container connector message)
  (progn
    (cond 
      (( equal  "down" (slot-value 'direction connector)) 
        (progn
          (log_down  container  (slot-value '(slot-value 'port sender) connector)  (slot-value '(slot-value 'component receiver) connector)  (slot-value '(slot-value 'port receiver) connector)  message)))
      (( equal  "up" (slot-value 'direction connector)) 
        (progn
          (log_up  (slot-value '(slot-value 'component sender) connector)  (slot-value '(slot-value 'port sender) connector)  container  (slot-value '(slot-value 'port receiver) connector)  message)))
      (( equal  "across" (slot-value 'direction connector)) 
        (progn
          (log_across  container  (slot-value '(slot-value 'component sender) connector)  (slot-value '(slot-value 'port sender) connector)  (slot-value '(slot-value 'component receiver) connector)  (slot-value '(slot-value 'port receiver) connector)  message)))
      (( equal  "through" (slot-value 'direction connector)) 
        (progn
          (log_through  container  (slot-value '(slot-value 'port sender) connector)   nil  (slot-value '(slot-value 'port receiver) connector)  message)))
      (t 
        (progn
          (print  f"*** FATAL error: in log_connection /{connector.direction}/ /{message.port}/ /{message.datum.srepr ()}/")
          (exit ))))))
(defun container_injector (container message)
  (progn
    (log_inject  container  (slot-value 'port message)  message)
    (container_handler  container  message)))
import os
import json
import sys
(defun new-Component_Registry ()
  (list
    (cons 'templates (make-hash-table :test :equal))))

(defun new-Template (name template_data instantiator)
  (list
    (cons 'name name)
    (cons 'template_data template_data)
    (cons 'instantiator instantiator)))

(defun read_and_convert_json_file (filename)
  (progn
    try:
    
    (progn
      (let (fil (open  filename  'r'))
        (let (json_data (slot-value '(read ) fil))
          (let (routings (slot-value '(loads  json_data) json))
            (slot-value '(close ) fil)
            
            (return-from read_and_convert_json_file routings)))))except FileNotFoundError:
    (progn
      (print  f"File not found: {filename}")
      
      (return-from read_and_convert_json_file  nil))except (slot-value 'JSONDecodeError json) as e:
    (progn
      (print  f"Error decoding JSON in file: {e}")
      
      (return-from read_and_convert_json_file  nil))))
(defun json2internal (container_xml)
  (progn
    (let (fname (slot-value '(slot-value '(basename  container_xml) path) os))
      (let (routings (read_and_convert_json_file  fname))
        
        (return-from json2internal routings)))))
(defun delete_decls (d)
  (progn
    pass))
(defun make_component_registry ()
  (progn
    
    (return-from make_component_registry (Component_Registry ))))
(defun register_component (reg template ok_to_overwrite= nil)
  (progn
    (let (name (mangle_name  (slot-value 'name template)))
      (cond 
        (( and  ( in  name (slot-value 'templates reg)) (not ok_to_overwrite)) 
          (progn
            (load_error  f"Component {template.name} already declared"))))
      (let ((slot-value '(aref templates name) reg) template)
        
        (return-from register_component reg)))))
(defun register_multiple_components (reg templates)
  (progn
    for template in templates:
    (progn
      (register_component  reg  template))))
(defun get_component_instance (reg full_name owner)
  (progn
    (let (template_name (mangle_name  full_name))
      (cond 
        (( in  template_name (slot-value 'templates reg)) 
          (progn
            (let (template (slot-value '(aref templates template_name) reg))
              (cond 
                ( ( equal  template  nil) 
                  (progn
                    (load_error  f"Registry Error: Can't find component {template_name} (does it need to be declared in components_to_include_in_project?")
                      
                      (return-from get_component_instance  nil)))
                  (t 
                    (progn
                      (let (owner_name "")
                        (let (instance_name f"{template_name}")
                          (cond 
                            ((not (equal  nil owner)) 
                              (progn
                                (let (owner_name (slot-value 'name owner))
                                  (let (instance_name f"{owner_name}.{template_name}")))))
                            (t 
                              (progn
                                (let (instance_name f"{template_name}")))))
                          (let (instance (slot-value '(instantiator  reg  owner  instance_name  (slot-value 'template_data template)) template))
                            (let ((slot-value 'depth instance) (calculate_depth  instance))
                              
                              (return-from get_component_instance instance)))))))))))
          (t 
            (progn
              (load_error  f"Registry Error: Can't find component {template_name} (does it need to be declared in components_to_include_in_project?")
                
                (return-from get_component_instance  nil)))))))
    (defun calculate_depth (eh)
      (progn
        (cond 
          (( equal  (slot-value 'owner eh)  nil) 
            (progn
              
              (return-from calculate_depth 0)))
          (t 
            (progn
              
              (return-from calculate_depth (+ 1 (calculate_depth  (slot-value 'owner eh)))))))))
    (defun dump_registry (reg)
      (progn
        (print )
        (print  "*** PALETTE ***")
        for c in (slot-value 'templates reg):
        (progn
          (print  (slot-value 'name c)))
        (print  "***************")
        (print )))
    (defun print_stats (reg)
      (progn
        (print  f"registry statistics: {reg.stats}")))
    (defun mangle_name (s)
      (progn
        
        (return-from mangle_name s)))
    import subprocess
    (defun generate_shell_components (reg container_list)
      (progn
        (cond 
          ((not (equal  nil container_list)) 
            (progn
              for diagram in container_list:
              (progn
                for child_descriptor in (gethash 'children diagram):
                (progn
                  (cond 
                    ((first_char_is  (gethash 'name child_descriptor)  "$") 
                      (progn
                        (let (name (gethash 'name child_descriptor))
                          (let (cmd (slot-value '(strip ) (subseq name 1)))
                            (let (generated_leaf (Template  name  shell_out_instantiate  cmd))
                              (register_component  reg  generated_leaf))))))
                    ((first_char_is  (gethash 'name child_descriptor)  "'") 
                      (progn
                        (let (name (gethash 'name child_descriptor))
                          (let (s (subseq name 1))
                            (let (generated_leaf (Template  name  string_constant_instantiate  s))
                              (register_component  reg  generated_leaf   t))))))))))))))
    (defun first_char (s)
      (progn
        
        (return-from first_char (car s))))
    (defun first_char_is (s c)
      (progn
        
        (return-from first_char_is ( equal  c (first_char  s)))))
    (defun run_command (eh cmd s)
      (progn
        (let (ret (slot-value '(run  cmd   t  s  'utf_8') subprocess))
          (cond 
            ((not  ( equal  (slot-value 'returncode ret) 0)) 
              (progn
                (cond 
                  ((not (equal (slot-value 'stderr ret)  nil)) 
                    (progn
                      
                      (return-from run_command (values ""  (slot-value 'stderr ret)))))
                  (t 
                    (progn
                      
                      (return-from run_command (values ""  f"error in shell_out {ret.returncode}")))))))
            (t 
              (progn
                
                (return-from run_command (values (slot-value 'stdout ret)   nil))))))))
    import queue
    import sys
    (defun new-Eh ()
      (list
        (cons 'name "")
        (cons 'inq (slot-value '(Queue ) queue))
        (cons 'outq (slot-value '(Queue ) queue))
        (cons 'owner  nil)
        (cons 'saved_messages (slot-value '(LifoQueue ) queue))
        (cons 'inject injector_NIY)
        (cons 'children  nil)
        (cons 'visit_ordering (slot-value '(Queue ) queue))
        (cons 'connections  nil)
        (cons 'routings (slot-value '(Queue ) queue))
        (cons 'handler  nil)
        (cons 'instance_data  nil)
        (cons 'state "idle")
        (cons 'kind  nil)
        (cons 'trace  nil)
        (cons 'depth 0)))
    
    (defun make_container (name owner)
      (progn
        (let (eh (Eh ))
          (let ((slot-value 'name eh) name)
            (let ((slot-value 'owner eh) owner)
              (let ((slot-value 'handler eh) container_handler)
                (let ((slot-value 'inject eh) container_injector)
                  (let ((slot-value 'state eh) "idle")
                    (let ((slot-value 'kind eh) "container")
                      
                      (return-from make_container eh))))))))))
    (defun make_leaf (name owner instance_data handler)
      (progn
        (let (eh (Eh ))
          (let ((slot-value 'name eh) f"{owner.name}.{name}")
            (let ((slot-value 'owner eh) owner)
              (let ((slot-value 'handler eh) handler)
                (let ((slot-value 'instance_data eh) instance_data)
                  (let ((slot-value 'state eh) "idle")
                    (let ((slot-value 'kind eh) "leaf")
                      
                      (return-from make_leaf eh))))))))))
    (defun send (eh port datum causingMessage)
      (progn
        (let (msg (make_message  port  datum))
          (log_send  eh  port  msg  causingMessage)
          (put_output  eh  msg))))
    (defun send_string (eh port s causingMessage)
      (progn
        (let (datum (new_datum_string  s))
          (let (msg (make_message  port  datum))
            (log_send_string  eh  port  msg  causingMessage)
            (put_output  eh  msg)))))
    (defun forward (eh port msg)
      (progn
        (let (fwdmsg (make_message  port  (slot-value 'datum msg)))
          (log_forward  eh  port  msg  msg)
          (put_output  eh  msg))))
    (defun inject (eh msg)
      (progn
        (slot-value '(inject  eh  msg) eh)))
    (defun output_list (eh)
      (progn
        
        (return-from output_list (slot-value 'outq eh))))
    (defun print_output_list (eh)
      (progn
        for m in (list  (slot-value '(slot-value 'queue outq) eh)):
        (progn
          (print  (format_message  m)))))
    (defun spaces (n)
      (progn
        (let (s "")
          for i in (loop for n from 0 below n by 1 collect n):
          (progn
            (let (s (+ s " "))))
          
          (return-from spaces s))))
    (defun set_active (eh)
      (progn
        (let ((slot-value 'state eh) "active"))))
    (defun set_idle (eh)
      (progn
        (let ((slot-value 'state eh) "idle"))))
    (defun fetch_first_output (eh port)
      (progn
        for msg in (list  (slot-value '(slot-value 'queue outq) eh)):
        (progn
          (cond 
            ( ( equal  (slot-value 'port msg) port) 
              (progn
                
                (return-from fetch_first_output (slot-value 'datum msg))))))
        
        (return-from fetch_first_output  nil)))
    (defun print_specific_output (eh port="" stderr= nil)
      (progn
        (let (datum (fetch_first_output  eh  port))
          (cond 
            ((not (equal datum  nil)) 
              (progn
                (cond 
                  (stderr 
                    (progn
                      (let (outf (slot-value 'stderr sys)))))
                  (t 
                    (progn
                      (let (outf (slot-value 'stdout sys))))))
                (print  (slot-value '(srepr ) datum)  outf)))))))
    (defun put_output (eh msg)
      (progn
        (slot-value '(slot-value '(put  msg) outq) eh)))
    (defun injector_NIY (eh msg)
      (progn
        (print  f'Injector not implemented for this component "{eh.name}" kind={eh.kind} port="{msg.port}"')
        (exit )))
    import sys
    import re
    import subprocess
    import shlex
    (defparameter root_project "")
    (defparameter root_0D "")
    (defun set_environment (rproject r0D)
      (progn
        (let (root_project rproject)
          (let (root_0D r0D)))))
    (defun probe_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "?"))
          
          (return-from probe_instantiate (make_leaf  name_with_id  owner   nil  probe_handler)))))
    (defun probeA_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "?A"))
          
          (return-from probeA_instantiate (make_leaf  name_with_id  owner   nil  probe_handler)))))
    (defun probeB_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "?B"))
          
          (return-from probeB_instantiate (make_leaf  name_with_id  owner   nil  probe_handler)))))
    (defun probeC_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "?C"))
          
          (return-from probeC_instantiate (make_leaf  name_with_id  owner   nil  probe_handler)))))
    (defun probe_handler (eh msg)
      (progn
        (let (s (slot-value '(slot-value '(srepr ) datum) msg))
          (print  f"... probe {eh.name}: {s}"  (slot-value 'stderr sys)))))
    (defun trash_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "trash"))
          
          (return-from trash_instantiate (make_leaf  name_with_id  owner   nil  trash_handler)))))
    (defun trash_handler (eh msg)
      (progn
        pass))
    (defun new-TwoMessages (first second)
      (list
        (cons 'first first)
        (cons 'second second)))
    
    (defun new-Deracer_Instance_Data (state buffer)
      (list
        (cons 'state state)
        (cons 'buffer buffer)))
    
    (defun reclaim_Buffers_from_heap (inst)
      (progn
        pass))
    (defun deracer_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "deracer"))
          (let (inst (Deracer_Instance_Data  "idle"  (TwoMessages   nil   nil)))
            (let ((slot-value 'state inst) "idle")
              (let (eh (make_leaf  name_with_id  owner  inst  deracer_handler))
                
                (return-from deracer_instantiate eh)))))))
    (defun send_first_then_second (eh inst)
      (progn
        (forward  eh  "1"  (slot-value '(slot-value 'first buffer) inst))
        (forward  eh  "2"  (slot-value '(slot-value 'second buffer) inst))
        (reclaim_Buffers_from_heap  inst)))
    (defun deracer_handler (eh msg)
      (progn
        (let (inst (slot-value 'instance_data eh))
          (cond 
            (( equal  (slot-value 'state inst) "idle") 
              (progn
                (cond 
                  (( equal  "1" (slot-value 'port msg)) 
                    (progn
                      (let ((slot-value '(slot-value 'first buffer) inst) msg)
                        (let ((slot-value 'state inst) "waitingForSecond")))))
                  (( equal  "2" (slot-value 'port msg)) 
                    (progn
                      (let ((slot-value '(slot-value 'second buffer) inst) msg)
                        (let ((slot-value 'state inst) "waitingForFirst")))))
                  (t 
                    (progn
                      (runtime_error  f"bad msg.port (case A) for deracer {msg.port}"))))))
            (( equal  (slot-value 'state inst) "waitingForFirst") 
              (progn
                (cond 
                  (( equal  "1" (slot-value 'port msg)) 
                    (progn
                      (let ((slot-value '(slot-value 'first buffer) inst) msg)
                        (send_first_then_second  eh  inst)
                        (let ((slot-value 'state inst) "idle")))))
                  (t 
                    (progn
                      (runtime_error  f"bad msg.port (case B) for deracer {msg.port}"))))))
            (( equal  (slot-value 'state inst) "waitingForSecond") 
              (progn
                (cond 
                  (( equal  "2" (slot-value 'port msg)) 
                    (progn
                      (let ((slot-value '(slot-value 'second buffer) inst) msg)
                        (send_first_then_second  eh  inst)
                        (let ((slot-value 'state inst) "idle")))))
                  (t 
                    (progn
                      (runtime_error  f"bad msg.port (case C) for deracer {msg.port}"))))))
            (t 
              (progn
                (runtime_error  "bad state for deracer {eh.state}")))))))
    (defun low_level_read_text_file_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "Low Level Read Text File"))
          
          (return-from low_level_read_text_file_instantiate (make_leaf  name_with_id  owner   nil  low_level_read_text_file_handler)))))
    (defun low_level_read_text_file_handler (eh msg)
      (progn
        (let (fname (slot-value '(slot-value '(srepr ) datum) msg))
          try:
          
          (progn
            (let (f (open  fname))))except Exception as e:
          (progn
            (let (f  nil)))
          (cond 
            ((not (equal f  nil)) 
              (progn
                (let (data (slot-value '(read ) f))
                  (cond 
                    ((not (equal data  nil)) 
                      (progn
                        (send_string  eh  ""  data  msg)))
                    (t 
                      (progn
                        (let (emsg f"read error on file {fname}")
                          (send_string  eh  "✗"  emsg  msg)))))
                  (slot-value '(close ) f))))
            (t 
              (progn
                (let (emsg f"open error on file {fname}")
                  (send_string  eh  "✗"  emsg  msg))))))))
    (defun ensure_string_datum_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "Ensure String Datum"))
          
          (return-from ensure_string_datum_instantiate (make_leaf  name_with_id  owner   nil  ensure_string_datum_handler)))))
    (defun ensure_string_datum_handler (eh msg)
      (progn
        (cond 
          (( equal  "string" (slot-value '(slot-value '(kind ) datum) msg)) 
            (progn
              (forward  eh  ""  msg)))
          (t 
            (progn
              (let (emsg f"*** ensure: type error (expected a string datum) but got {msg.datum}")
                (send_string  eh  "✗"  emsg  msg)))))))
    (defun new-Syncfilewrite_Data ()
      (list
        (cons 'filename "")))
    
    (defun syncfilewrite_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "syncfilewrite"))
          (let (inst (Syncfilewrite_Data ))
            
            (return-from syncfilewrite_instantiate (make_leaf  name_with_id  owner  inst  syncfilewrite_handler))))))
    (defun syncfilewrite_handler (eh msg)
      (progn
        (let (inst (slot-value 'instance_data eh))
          (cond 
            (( equal  "filename" (slot-value 'port msg)) 
              (progn
                (let ((slot-value 'filename inst) (slot-value '(slot-value '(srepr ) datum) msg)))))
            (( equal  "input" (slot-value 'port msg)) 
              (progn
                (let (contents (slot-value '(slot-value '(srepr ) datum) msg))
                  (let (f (open  (slot-value 'filename inst)  "w"))
                    (cond 
                      ((not (equal f  nil)) 
                        (progn
                          (slot-value '(write  (slot-value '(slot-value '(srepr ) datum) msg)) f)
                          (slot-value '(close ) f)
                          (send  eh  "done"  (new_datum_bang )  msg)))
                      (t 
                        (progn
                          (send_string  eh  "✗"  f"open error on file {inst.filename}"  msg))))))))))))
    (defun new-StringConcat_Instance_Data ()
      (list
        (cons 'buffer1  nil)
        (cons 'buffer2  nil)
        (cons 'count 0)))
    
    (defun stringconcat_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "stringconcat"))
          (let (instp (StringConcat_Instance_Data ))
            
            (return-from stringconcat_instantiate (make_leaf  name_with_id  owner  instp  stringconcat_handler))))))
    (defun stringconcat_handler (eh msg)
      (progn
        (let (inst (slot-value 'instance_data eh))
          (cond 
            (( equal  "1" (slot-value 'port msg)) 
              (progn
                (let ((slot-value 'buffer1 inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (inc (slot-value 'count inst) 1)
                  (maybe_stringconcat  eh  inst  msg))))
            (( equal  "2" (slot-value 'port msg)) 
              (progn
                (let ((slot-value 'buffer2 inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (inc (slot-value 'count inst) 1)
                  (maybe_stringconcat  eh  inst  msg))))
            (t 
              (progn
                (runtime_error  f"bad msg.port for stringconcat: {msg.port}")))))))
    (defun maybe_stringconcat (eh inst msg)
      (progn
        (cond 
          (( and   ( equal  0 (len  (slot-value 'buffer1 inst)))  ( equal  0 (len  (slot-value 'buffer2 inst)))) 
            (progn
              (runtime_error  "something is wrong in stringconcat, both strings are 0 length"))))
        (cond 
          (( >=  (slot-value 'count inst) 2) 
            (progn
              (let (concatenated_string "")
                (cond 
                  (( equal  0 (len  (slot-value 'buffer1 inst))) 
                    (progn
                      (let (concatenated_string (slot-value 'buffer2 inst)))))
                  (( equal  0 (len  (slot-value 'buffer2 inst))) 
                    (progn
                      (let (concatenated_string (slot-value 'buffer1 inst)))))
                  (t 
                    (progn
                      (let (concatenated_string (+ (slot-value 'buffer1 inst) (slot-value 'buffer2 inst)))))))
                (send_string  eh  ""  concatenated_string  msg)
                (let ((slot-value 'buffer1 inst)  nil)
                  (let ((slot-value 'buffer2 inst)  nil)
                    (let ((slot-value 'count inst) 0))))))))))
    (defun shell_out_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "shell_out"))
          (let (cmd (slot-value '(split  template_data) shlex))
            
            (return-from shell_out_instantiate (make_leaf  name_with_id  owner  cmd  shell_out_handler))))))
    (defun shell_out_handler (eh msg)
      (progn
        (let (cmd (slot-value 'instance_data eh))
          (let (s (slot-value '(slot-value '(srepr ) datum) msg))
            (multiple-value-bind (stdout , stderr)
              (run_command  eh  cmd  s)
              (cond 
                ((not (equal stderr  nil)) 
                  (progn
                    (send_string  eh  "✗"  stderr  msg)))
                (t 
                  (progn
                    (send_string  eh  ""  stdout  msg)))))))))
    (defun string_constant_instantiate (reg owner name template_data)
      (progn
        (let (name_with_id (gensym  "strconst"))
          (let (s template_data)
            (cond 
              ((not (equal root_project "")) 
                (progn
                  (let (s (slot-value '(sub  "_00_"  root_project  s) re))))))
            (cond 
              ((not (equal root_0D "")) 
                (progn
                  (let (s (slot-value '(sub  "_0D_"  root_0D  s) re))))))
            
            (return-from string_constant_instantiate (make_leaf  name_with_id  owner  s  string_constant_handler))))))
    (defun string_constant_handler (eh msg)
      (progn
        (let (s (slot-value 'instance_data eh))
          (send_string  eh  ""  s  msg))))
    (defun string_make_persistent (s)
      (progn
        
        (return-from string_make_persistent s)))
    (defun string_clone (s)
      (progn
        
        (return-from string_clone s)))
    import sys
    (defun parse_command_line_args ()
      (progn
        (cond 
          ( ( <  (len  (slot-value 'argv sys))  (+ 5 1)) 
            (progn
              (load_error  "usage: ${_00_} ${_0D_} app <arg> <main tab name> <diagram file name 1> ...")
              
              (return-from parse_command_line_args  nil)))
          (t 
            (progn
              (let (root_project (nth *argv* 1))
                (let (root_0D (nth *argv* 2))
                  (let (arg (nth *argv* 3))
                    (let (main_container_name (nth *argv* 4))
                      (let (diagram_source_files (nthcdr *argv* 5))
                        
                        (return-from parse_command_line_args (values root_project  root_0D arg main_container_name diagram_source_files))))))))))))
    (defun initialize_component_palette (root_project root_0D diagram_source_files project_specific_components_subroutine)
      (progn
        (let (reg (make_component_registry ))
          for diagram_source in diagram_source_files:
          (progn
            (let (all_containers_within_single_file (json2internal  diagram_source))
              (generate_shell_components  reg  all_containers_within_single_file)
              for container in all_containers_within_single_file:
              (progn
                (register_component  reg  (Template  (aref container 'name')  container  container_instantiator)))))
          (initialize_stock_components  reg)
          (project_specific_components_subroutine  root_project  root_0D  reg)
          
          (return-from initialize_component_palette reg))))
    (defun print_error_maybe (main_container)
      (progn
        (let (error_port "✗")
          (let (err (fetch_first_output  main_container  error_port))
            (cond 
              (( and   (not (equal err  nil))  ( <  0 (len  (trimws  (slot-value '(srepr ) err))))) 
                (progn
                  (print  "___ !!! ERRORS !!! ___")
                  (print_specific_output  main_container  error_port   nil))))))))
    (defun dump_outputs (main_container)
      (progn
        (print )
        (print  "___ Outputs ___")
        (print_output_list  main_container)))
    (defun trace_outputs (main_container)
      (progn
        (print )
        (print  "___ Message Traces ___")
        (print_routing_trace  main_container)))
    (defun dump_hierarchy (main_container)
      (progn
        (print )
        (print  f"___ Hierarchy ___{(build_hierarchy (main_container))}")))
    (defun build_hierarchy (c)
      (progn
        (let (s "")
          for child in (slot-value 'children c):
          (progn
            (let (s f"{s}{build_hierarchy (child)}")))
          (let (indent "")
            for i in (loop for n from 0 below (slot-value 'depth c) by 1 collect n):
            (progn
              (let (indent (+ indent "  "))))
            
            (return-from build_hierarchy f"\n{indent}({c.name}{s})")))))
    (defun dump_connections (c)
      (progn
        (print )
        (print  f"___ connections ___")
        (dump_possible_connections  c)
        for child in (slot-value 'children c):
        (progn
          (print )
          (dump_possible_connections  child))))
    (defun trimws (s)
      (progn
        
        (return-from trimws (slot-value '(strip ) s))))
    (defun clone_string (s)
      (progn
        
        (return-from clone_string s)))
    (defparameter load_errors  nil)
    (defparameter runtime_errors  nil)
    (defun load_error (s)
      (progn
        (print  s)
        (quit )
        (let (load_errors  t))))
    (defun runtime_error (s)
      (progn
        (print  s)
        (quit )
        (let (runtime_errors  t))))
    (defun fakepipename_instantiate (reg owner name template_data)
      (progn
        (let (instance_name (gensym  "fakepipe"))
          
          (return-from fakepipename_instantiate (make_leaf  instance_name  owner   nil  fakepipename_handler)))))
    (defparameter rand 0)
    (defun fakepipename_handler (eh msg)
      (progn
        (inc rand 1)
        (send_string  eh  ""  f"/tmp/fakepipe{rand}"  msg)))
    (defun new-OhmJS_Instance_Data ()
      (list
        (cons 'pathname_0D_  nil)
        (cons 'grammar_name  nil)
        (cons 'grammar_filename  nil)
        (cons 'semantics_filename  nil)
        (cons 's  nil)))
    
    (defun ohmjs_instantiate (reg owner name template_data)
      (progn
        (let (instance_name (gensym  "OhmJS"))
          (let (inst (OhmJS_Instance_Data ))
            
            (return-from ohmjs_instantiate (make_leaf  instance_name  owner  inst  ohmjs_handle))))))
    (defun ohmjs_maybe (eh inst causingMsg)
      (progn
        (cond 
          ((not (equal ( and  (not (equal ( and  (not (equal ( and  (not (equal ( and  (not (equal  nil (slot-value 'pathname_0D_ inst)))  nil) (slot-value 'grammar_name inst)))  nil) (slot-value 'grammar_filename inst)))  nil) (slot-value 'semantics_filename inst)))  nil) (slot-value 's inst))) 
            (progn
              (let (cmd (list  f"{inst.pathname_0D_}/std/ohmjs.js" f"{inst.grammar_name}" f"{inst.grammar_filename}" f"{inst.semantics_filename}"))
                (multiple-value-bind (captured_output , err)
                  (run_command  eh  cmd  (slot-value 's inst))
                  (cond 
                    (( equal  err  nil) 
                      (progn
                        (let (err "")))))
                  (let (errstring (trimws  err))
                    (cond 
                      (( equal  (len  errstring) 0) 
                        (progn
                          (send_string  eh  ""  (trimws  captured_output)  causingMsg)))
                      (t 
                        (progn
                          (send_string  eh  "✗"  errstring  causingMsg))))
                    (let ((slot-value 'pathname_0D_ inst)  nil)
                      (let ((slot-value 'grammar_name inst)  nil)
                        (let ((slot-value 'grammar_filename inst)  nil)
                          (let ((slot-value 'semantics_filename inst)  nil)
                            (let ((slot-value 's inst)  nil))))))))))))))
    (defun ohmjs_handle (eh msg)
      (progn
        (let (inst (slot-value 'instance_data eh))
          (cond 
            (( equal  (slot-value 'port msg) "0D path") 
              (progn
                (let ((slot-value 'pathname_0D_ inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (ohmjs_maybe  eh  inst  msg))))
            (( equal  (slot-value 'port msg) "grammar name") 
              (progn
                (let ((slot-value 'grammar_name inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (ohmjs_maybe  eh  inst  msg))))
            (( equal  (slot-value 'port msg) "grammar") 
              (progn
                (let ((slot-value 'grammar_filename inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (ohmjs_maybe  eh  inst  msg))))
            (( equal  (slot-value 'port msg) "semantics") 
              (progn
                (let ((slot-value 'semantics_filename inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (ohmjs_maybe  eh  inst  msg))))
            (( equal  (slot-value 'port msg) "input") 
              (progn
                (let ((slot-value 's inst) (clone_string  (slot-value '(slot-value '(srepr ) datum) msg)))
                  (ohmjs_maybe  eh  inst  msg))))
            (t 
              (progn
                (let (emsg f"!!! ERROR: OhmJS got an illegal message port {msg.port}")
                  (send_string  eh  "✗"  emsg  msg))))))))
    (defun initialize_stock_components (reg)
      (progn
        (register_component  reg  (Template  "1then2"   nil  deracer_instantiate))
        (register_component  reg  (Template  "?"   nil  probe_instantiate))
        (register_component  reg  (Template  "?A"   nil  probeA_instantiate))
        (register_component  reg  (Template  "?B"   nil  probeB_instantiate))
        (register_component  reg  (Template  "?C"   nil  probeC_instantiate))
        (register_component  reg  (Template  "trash"   nil  trash_instantiate))
        (register_component  reg  (Template  "Low Level Read Text File"   nil  low_level_read_text_file_instantiate))
        (register_component  reg  (Template  "Ensure String Datum"   nil  ensure_string_datum_instantiate))
        (register_component  reg  (Template  "syncfilewrite"   nil  syncfilewrite_instantiate))
        (register_component  reg  (Template  "stringconcat"   nil  stringconcat_instantiate))
        (register_component  reg  (Template  "fakepipename"   nil  fakepipename_instantiate))
        (register_component  reg  (Template  "OhmJS"   nil  ohmjs_instantiate))))
    (defun run (pregistry root_project root_0D arg main_container_name diagram_source_files injectfn show_hierarchy= t show_connections= t show_traces= t show_all_outputs= t)
      (progn
        (set_environment  root_project  root_0D)
        (let (main_container (get_component_instance  pregistry  main_container_name   nil))
          (cond 
            (( equal   nil main_container) 
              (progn
                (load_error  f"Couldn't find container with page name {main_container_name} in files {diagram_source_files} (check tab names, or disable compression?)"))))
          (cond 
            (show_hierarchy 
              (progn
                (dump_hierarchy  main_container))))
          (cond 
            (show_connections 
              (progn
                (dump_connections  main_container))))
          (cond 
            ((not load_errors) 
              (progn
                (injectfn  root_project  root_0D  arg  main_container))))
          (cond 
            (show_all_outputs 
              (progn
                (dump_outputs  main_container)))
            (t 
              (progn
                (print_error_maybe  main_container)
                (print_specific_output  main_container  ""   nil))))
          (cond 
            (show_traces 
              (progn
                (print  "___ routing traces ___")
                (print  (routing_trace_all  main_container)))))
          (cond 
            (show_all_outputs 
              (progn
                (print  "___ done ___")))))))
    
    

