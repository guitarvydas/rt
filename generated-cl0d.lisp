

(defun container_instantiator (&optional  reg owner container_name desc)
  (let (( container (make_container   container_name  owner)))
    (let (( children nil))
      (let (( children_by_id bil))
        
        #|  not strictly necessary, but, we can remove 1 runtime lookup by “compiling it out“ here |#
        
        #|  collect children |#
        (loop for child_desc in (cdr (assoc 'children  desc))
          do
            (let (( child_instance (get_component_instance   reg (cdr (assoc 'name  child_desc))  container)))
              (funcall2 (fieldf 'append  children)   child_instance)
              (let (((nth (cdr (assoc 'id  child_desc))  children_by_id)  child_instance)))))
        (setf (fieldf 'children  container)  children)
        (let (( me  container))
          (let (( connectors nil))
            (loop for proto_conn in (cdr (assoc 'connections  desc))
              do
                (let (( source_component  nil))
                  (let (( target_component  nil))
                    (let (( connector (Connector )))
                      (cond 
                        (( equal   (cdr (assoc 'dir  proto_conn))  enumDown)
                            
                            #|  JSON: {;dir': 0, 'source': {'name': '', 'id': 0}, 'source_port': '', 'target': {'name': 'Echo', 'id': 12}, 'target_port': ''}, |#
                            (setf (fieldf 'direction  connector)  "down")
                            (setf (fieldf 'sender  connector) (Sender  (fieldf 'name  me)  me (cdr (assoc 'source_port  proto_conn))))
                            (let (( target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))
                              (cond 
                                (( equal    target_component  nil)
                                    (load_error   (concatenate 'string  "internal error: .Down connection target internal error " (cdr (assoc 'target  proto_conn)))) )
                                (t
                                    (setf (fieldf 'receiver  connector) (Receiver  (fieldf 'name  target_component) (fieldf 'inq  target_component) (cdr (assoc 'target_port  proto_conn))  target_component))
                                    (funcall2 (fieldf 'append  connectors)   connector) ))))
                        (( equal   (cdr (assoc 'dir  proto_conn))  enumAcross)
                            (setf (fieldf 'direction  connector)  "across")
                            (let (( source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))
                              (let (( target_component (nth (cdr (assoc 'id (cdr (assoc 'target  proto_conn))))  children_by_id)))
                                (cond 
                                  (( equal    source_component  nil)
                                      (load_error   (concatenate 'string  "internal error: .Across connection source not ok " (cdr (assoc 'source  proto_conn)))) )
                                  (t
                                      (setf (fieldf 'sender  connector) (Sender  (fieldf 'name  source_component)  source_component (cdr (assoc 'source_port  proto_conn))))
                                      (cond 
                                        (( equal    target_component  nil)
                                            (load_error   (concatenate 'string  "internal error: .Across connection target not ok " (fieldf 'target  proto_conn))) )
                                        (t
                                            (setf (fieldf 'receiver  connector) (Receiver  (fieldf 'name  target_component) (fieldf 'inq  target_component) (cdr (assoc 'target_port  proto_conn))  target_component))
                                            (funcall2 (fieldf 'append  connectors)   connector) )))))))
                        (( equal   (cdr (assoc 'dir  proto_conn))  enumUp)
                            (setf (fieldf 'direction  connector)  "up")
                            (let (( source_component (nth (cdr (assoc 'id (cdr (assoc 'source  proto_conn))))  children_by_id)))
                              (cond 
                                (( equal    source_component  nil)
                                    (print   (concatenate 'string  "internal error: .Up connection source not ok " (cdr (assoc 'source  proto_conn)))) )
                                (t
                                    (setf (fieldf 'sender  connector) (Sender  (fieldf 'name  source_component)  source_component (cdr (assoc 'source_port  proto_conn))))
                                    (setf (fieldf 'receiver  connector) (Receiver  (fieldf 'name  me) (fieldf 'outq  container) (cdr (assoc 'target_port  proto_conn))  me))
                                    (funcall2 (fieldf 'append  connectors)   connector) ))))
                        (( equal   (cdr (assoc 'dir  proto_conn))  enumThrough)
                            (setf (fieldf 'direction  connector)  "through")
                            (setf (fieldf 'sender  connector) (Sender  (fieldf 'name  me)  me (cdr (assoc 'source_port  proto_conn))))
                            (setf (fieldf 'receiver  connector) (Receiver  (fieldf 'name  me) (fieldf 'outq  container) (cdr (assoc 'target_port  proto_conn))  me))
                            (funcall2 (fieldf 'append  connectors)   connector) ))))))
            (setf (fieldf 'connections  container)  connectors)
            (return-from container_instantiator  container)))))))




