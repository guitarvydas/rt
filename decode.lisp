

(defun decode_install (&optional  reg)
  (declare (ignorable  reg))                                #|line 1|#
  (funcall (quote register_component)   reg (funcall (quote Template)   "Decode"  nil  #'decode_instantiator )  #|line 2|#) #|line 3|#
  )
(defparameter  decode_digits (list   "0"  "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9" )) #|line 5|#
(defun decode_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 6|# #|line 7|#
  (let (( i (parse-integer (funcall (slot-value (slot-value  msg 'datum) 'srepr) )) #|line 8|#))
    (declare (ignorable  i))
    (cond
      (( and  ( >=   i  0) ( <=   i  9))                    #|line 9|#
        (funcall (quote send_string)   eh (nth  i  decode_digits) (nth  i  decode_digits)  msg  #|line 10|#) #|line 11|#
        ))
    (funcall (quote send_bang)   eh  "done"  msg            #|line 12|#)) #|line 13|#
  )
(defun decode_instantiator (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 15|#
  (let ((name_with_id (funcall (quote gensymbol)   "Decode"  #|line 16|#)))
    (declare (ignorable name_with_id))
    (return-from decode_instantiator (funcall (quote make_leaf)   name_with_id  owner  nil  #'decode_handler  #|line 17|#)))
  )





