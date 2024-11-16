

(defun install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "@"  nil  instantiator )  #|line 2|#) #|line 3|#
  )
(defun instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 5|#
  (let ((name_with_id (funcall (quote gensymbol)   "@"      #|line 6|#)))
    (declare (ignorable name_with_id))
    (return-from instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  handler  #|line 7|#))) #|line 8|#
  )
(defun handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 10|#
  (setf  s (cdr (assoc (quote(cdr (assoc (quote(funcall (quote srepr) ))  datum)))  msg))) #|line 11|#
  (setf  i (funcall (quote int)   s                         #|line 12|#))
  (loop while ( >   i  0)
    do
      (progn                                                #|line 13|#
        (setf  s  (concatenate 'string  " "  s)             #|line 14|#)
        (setf  i (-  i  1))                                 #|line 15|# #|line 16|#
        ))
    (funcall (quote print)   s                              #|line 17|#) #|line 18|#
    )






#|  Nothing to see here. |#                                 #|line 1|#





