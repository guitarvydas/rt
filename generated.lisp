

(defun install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (register_component    reg (Template    "Count"  nil  instantiator )  #|line 2|#) #|line 3|#
  )
(defparameter  counter  0)                                  #|line 5|#
(defparameter  direction  1)                                #|line 6|# #|line 7|#
(defun handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 8|# #|line 9|#
  (cond
    (( equal   (cdr (assoc ' port  msg))  "adv")            #|line 10|#
      (setf  counter (+  counter  direction))               #|line 11|#
      (send_int    eh  ""  counter  msg                     #|line 12|#)
      )
    (( equal   (cdr (assoc ' port  msg))  "rev")            #|line 13|#
      (setf  direction (*  direction  - 1))                 #|line 14|# #|line 15|#
      ))                                                    #|line 16|#
  )
(defun instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 18|#
  (let ((name_with_id (gensymbol    "Count"                 #|line 19|#)))
    (declare (ignorable name_with_id))
    (return-from instantiator (make_leaf    name_with_id  owner  nil  handler  #|line 20|#))) #|line 21|#
  )






#|  Nothing to see here. |#                                 #|line 1|#





