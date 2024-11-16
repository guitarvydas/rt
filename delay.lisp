

(defun delay_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Delay"  nil  #'delay_instantiator )  #|line 2|#) #|line 3|#
  )
(defun Delay_Info (&optional )                              #|line 5|#
  (list
    (cons (quote counter)  0)                               #|line 6|#
    (cons (quote saved_message)  nil)                       #|line 7|#) #|line 8|#)
                                                            #|line 9|#
(defun delay_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 10|#
  (let ((name_with_id (funcall (quote gensymbol)   "delay"  #|line 11|#)))
    (declare (ignorable name_with_id))
    (let ((info (funcall (quote Delay_Info) )))
      (declare (ignorable info))                            #|line 12|#
      (return-from delay_instantiator (funcall (quote make_leaf)   name_with_id  owner  info  #'delay_handler  #|line 13|#)))) #|line 14|#
  )
(defparameter  DELAYDELAY  50000)                           #|line 16|# #|line 17|#
(defun first_time (&optional  m)
  (declare (ignorable  m))                                  #|line 18|#
  (return-from first_time (not (funcall (quote is_tick)   m  #|line 19|#))) #|line 20|#
  )
(defun delay_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 22|#
  (let ((info (cdr (assoc (quote  instance_data)  eh))))
    (declare (ignorable info))                              #|line 23|#
    (cond
      ((funcall (quote first_time)   msg )                  #|line 24|#
        (setf (cdr (assoc (quote  saved_message)  info))  msg) #|line 25|#
        (funcall (quote set_active)   eh )
        #|  tell engine to keep running this component with ;ticks'  |# #|line 26|# #|line 27|#
        ))                                                  #|line 28|#
    (let ((count (cdr (assoc (quote  counter)  info))))
      (declare (ignorable count))                           #|line 29|#
      (let (( next (+  count  1)))
        (declare (ignorable  next))                         #|line 30|#
        (cond
          (( >=  (cdr (assoc (quote  counter)  info))  DELAYDELAY) #|line 31|#
            (funcall (quote set_idle)   eh )
            #|  tell engine that we're finally done  |#     #|line 32|#
            (funcall (quote forward)   eh  "" (cdr (assoc (quote  saved_message)  info))  #|line 33|#)
            (setf  next  0)                                 #|line 34|# #|line 35|#
            ))
        (setf (cdr (assoc (quote  counter)  info))  next)   #|line 36|#))) #|line 37|#
  )




