

(defun probeA_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 1|#
  (let ((name_with_id (funcall (quote gensymbol)   "?A"     #|line 2|#)))
    (declare (ignorable name_with_id))
    (return-from probeA_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 3|#))) #|line 4|#
  )
(defun probeB_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 6|#
  (let ((name_with_id (funcall (quote gensymbol)   "?B"     #|line 7|#)))
    (declare (ignorable name_with_id))
    (return-from probeB_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 8|#))) #|line 9|#
  )
(defun probeC_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 11|#
  (let ((name_with_id (funcall (quote gensymbol)   "?C"     #|line 12|#)))
    (declare (ignorable name_with_id))
    (return-from probeC_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'probe_handler  #|line 13|#))) #|line 14|#
  )
(defun probe_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 16|#
  (let ((s (slot-value (slot-value  msg 'datum) 'v)))
    (declare (ignorable s))                                 #|line 17|#
    (format *error-output* "~a~%"  (concatenate 'string  "... probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "  s)))) #|line 18|#) #|line 19|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 21|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 22|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 23|#))) #|line 24|#
  )
(defun trash_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 26|#
  #|  to appease dumped_on_floor checker |#                 #|line 27|#
  #| pass |#                                                #|line 28|# #|line 29|#
  )
(defclass TwoMessages ()                                    #|line 30|#
  (
    (firstmsg :accessor firstmsg :initarg :firstmsg :initform  nil)  #|line 31|#
    (secondmsg :accessor secondmsg :initarg :secondmsg :initform  nil)  #|line 32|#)) #|line 33|#

                                                            #|line 34|# #|  Deracer_States :: enum { idle, waitingForFirstmsg, waitingForSecondmsg } |# #|line 35|#
(defclass Deracer_Instance_Data ()                          #|line 36|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 37|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 38|#)) #|line 39|#

                                                            #|line 40|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 41|#
  #| pass |#                                                #|line 42|# #|line 43|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 45|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 46|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 47|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 48|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMessages) #|line 49|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 50|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 51|#))) #|line 52|#
  )
(defun send_firstmsg_then_secondmsg (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 54|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmsg)  #|line 55|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmsg)  #|line 56|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 57|#) #|line 58|#
  )
(defun deracer_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 60|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 61|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 62|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 63|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 64|#
            (setf (slot-value  inst 'state)  "waitingForSecondmsg") #|line 65|#
            )
          (( equal    "2" (slot-value  msg 'port))          #|line 66|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 67|#
            (setf (slot-value  inst 'state)  "waitingForFirstmsg") #|line 68|#
            )
          (t                                                #|line 69|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case A) for deracer " (slot-value  msg 'port))  #|line 70|#) #|line 71|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmsg") #|line 72|#
        (cond
          (( equal    "1" (slot-value  msg 'port))          #|line 73|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmsg)  msg) #|line 74|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 75|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 76|#
            )
          (t                                                #|line 77|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case B) for deracer " (slot-value  msg 'port))  #|line 78|#) #|line 79|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmsg") #|line 80|#
        (cond
          (( equal    "2" (slot-value  msg 'port))          #|line 81|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmsg)  msg) #|line 82|#
            (funcall (quote send_firstmsg_then_secondmsg)   eh  inst  #|line 83|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 84|#
            )
          (t                                                #|line 85|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port (case C) for deracer " (slot-value  msg 'port))  #|line 86|#) #|line 87|#
            ))
        )
      (t                                                    #|line 88|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}"  #|line 89|#) #|line 90|#
        )))                                                 #|line 91|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 93|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 94|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 95|#))) #|line 96|#
  )
(defun low_level_read_text_file_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 98|#
  (let ((fname (slot-value (slot-value  msg 'datum) 'v)))
    (declare (ignorable fname))                             #|line 99|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 100|#) #|line 101|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 103|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 104|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 105|#))) #|line 106|#
  )
(defun ensure_string_datum_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 108|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  msg 'datum) 'kind) )) #|line 109|#
      (funcall (quote forward)   eh  ""  msg                #|line 110|#)
      )
    (t                                                      #|line 111|#
      (let ((emsg  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  msg 'datum)) #|line 112|#))
        (declare (ignorable emsg))
        (funcall (quote send_string)   eh  "✗"  emsg  msg   #|line 113|#)) #|line 114|#
      ))                                                    #|line 115|#
  )
(defclass Syncfilewrite_Data ()                             #|line 117|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 118|#)) #|line 119|#

                                                            #|line 120|# #|  temp copy for bootstrap, sends “done“ (error during bootstrap if not wired) |# #|line 121|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 122|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 123|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 124|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 125|#)))) #|line 126|#
  )
(defun syncfilewrite_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 128|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 129|#
    (cond
      (( equal    "filename" (slot-value  msg 'port))       #|line 130|#
        (setf (slot-value  inst 'filename) (slot-value (slot-value  msg 'datum) 'v)) #|line 131|#
        )
      (( equal    "input" (slot-value  msg 'port))          #|line 132|#
        (let ((contents (slot-value (slot-value  msg 'datum) 'v)))
          (declare (ignorable contents))                    #|line 133|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 134|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 135|#
                (funcall (slot-value  f 'write)  (slot-value (slot-value  msg 'datum) 'v)  #|line 136|#)
                (funcall (slot-value  f 'close) )           #|line 137|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  msg  #|line 138|#)
                )
              (t                                            #|line 139|#
                (funcall (quote send_string)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  msg  #|line 140|#) #|line 141|#
                ))))                                        #|line 142|#
        )))                                                 #|line 143|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 145|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 146|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 147|#
    (scount :accessor scount :initarg :scount :initform  0)  #|line 148|#)) #|line 149|#

                                                            #|line 150|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 151|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 152|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 153|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 154|#)))) #|line 155|#
  )
(defun stringconcat_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 157|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 158|#
    (cond
      (( equal    "1" (slot-value  msg 'port))              #|line 159|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (slot-value (slot-value  msg 'datum) 'v)  #|line 160|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 161|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg  #|line 162|#)
        )
      (( equal    "2" (slot-value  msg 'port))              #|line 163|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (slot-value (slot-value  msg 'datum) 'v)  #|line 164|#))
        (setf (slot-value  inst 'scount) (+ (slot-value  inst 'scount)  1)) #|line 165|#
        (funcall (quote maybe_stringconcat)   eh  inst  msg  #|line 166|#)
        )
      (t                                                    #|line 167|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad msg.port for stringconcat: " (slot-value  msg 'port))  #|line 168|#) #|line 169|#
        )))                                                 #|line 170|#
  )
(defun maybe_stringconcat (&optional  eh  inst  msg)
  (declare (ignorable  eh  inst  msg))                      #|line 172|#
  (cond
    (( >=  (slot-value  inst 'scount)  2)                   #|line 173|#
      (cond
        (( and  ( equal    0 (length (slot-value  inst 'buffer1))) ( equal    0 (length (slot-value  inst 'buffer2)))) #|line 174|#
          (funcall (quote runtime_error)   "something is wrong in stringconcat, both strings are 0 length"  #|line 175|#)
          )
        (t                                                  #|line 176|#
          (let (( concatenated_string  ""))
            (declare (ignorable  concatenated_string))      #|line 177|#
            (cond
              (( equal    0 (length (slot-value  inst 'buffer1))) #|line 178|#
                (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 179|#
                )
              (( equal    0 (length (slot-value  inst 'buffer2))) #|line 180|#
                (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 181|#
                )
              (t                                            #|line 182|#
                (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 183|# #|line 184|#
                ))
            (funcall (quote send_string)   eh  ""  concatenated_string  msg  #|line 185|#)
            (setf (slot-value  inst 'buffer1)  nil)         #|line 186|#
            (setf (slot-value  inst 'buffer2)  nil)         #|line 187|#
            (setf (slot-value  inst 'scount)  0)            #|line 188|#) #|line 189|#
          ))                                                #|line 190|#
      ))                                                    #|line 191|#
  ) #|  |#                                                  #|line 193|# #|line 194|#
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 195|# #|line 196|# #|line 197|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 198|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 199|#
      (cond
        ((not (equal   root_project  ""))                   #|line 200|#
          (setf  s (substitute  "_00_"  root_project  s)    #|line 201|#) #|line 202|#
          ))
      (cond
        ((not (equal   root_0D  ""))                        #|line 203|#
          (setf  s (substitute  "_0D_"  root_0D  s)         #|line 204|#) #|line 205|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 206|#)))) #|line 207|#
  )
(defun string_constant_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 209|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 210|#
    (funcall (quote send_string)   eh  ""  s  msg           #|line 211|#)) #|line 212|#
  )





