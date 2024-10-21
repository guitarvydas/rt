
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)

(defun make_Send_Descriptor (&optional  component  port  message  cause_port  cause_message)                            #|line 1|#

  (let ((rdesc (make_Routing_Descriptor  :action  drSend :component  component :port  port :message  message          #|line 2|#
		 )))
    (return-from make_Send_Descriptor
      (let ((_dict (make-hash-table :test 'equal)))                                                                 #|line 3|#
        (setf (gethash "action" _dict)  drSend) (setf (gethash "component" _dict) (cdr (assoc 'component  rdesc)) (setf (gethash "port" _dict) (cdr (assoc 'port  rdesc)) (setf (gethash "message" _dict) (cdr (assoc 'message  rdesc)) (setf (gethash "cause_port" _dict)  cause_port) (setf (gethash "cause_message" _dict)  cause_message) (setf (gethash "fmt" _dict)  fmt_send) #|line 10|#

																					    _dict))                                                                                                     #|line 11|#
						  )                                                                                                                 #|line 12|#

	)





      (load "~/quicklisp/setup.lisp")
      (ql:quickload :cl-json)
      #|  Nothing to see here. |#                                                                                             #|line 1|#





