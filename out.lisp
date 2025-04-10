#|  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 1|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 2|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 3|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 4|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 5|#)))) #|line 6|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 8|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 9|#
    (let ((s (slot-value (slot-value  msg 'datum) 'v)))
      (declare (ignorable s))                               #|line 10|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 11|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 12|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 13|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 14|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 15|#
              (cond
                (( equal    rc  0)                          #|line 16|#
                  (funcall (quote send)   eh  ""  (concatenate 'string  stdout  stderr)  msg  #|line 17|#)
                  )
                (t                                          #|line 18|#
                  (funcall (quote send)   eh  "✗"  (concatenate 'string  stdout  stderr)  msg  #|line 19|#) #|line 20|#
                  ))))))))                                  #|line 21|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 23|#
  #|  [ |#                                                  #|line 24|#
  #|      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 25|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 26|#
  #|  ] |#                                                  #|line 27|#
  (cond
    ((not (equal   nil  container_list))                    #|line 28|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 29|#
            #|  loop through every component in the diagram and look for names that start with “$“ or “'“  |# #|line 30|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 31|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 32|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 33|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 34|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 35|#
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  cmd  #'shell_out_instantiate  #|line 36|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 37|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 38|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 39|#
                        (let ((s  (subseq  name 1)          #|line 40|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  s  #'string_constant_instantiate  #|line 41|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 42|#)))) #|line 43|#
                      ))                                    #|line 44|#
                  ))                                        #|line 45|#
            ))                                              #|line 46|#
      ))
  (return-from generate_shell_components  reg)              #|line 47|# #|line 48|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 50|#
  (return-from first_char  (string (char  s 0))             #|line 51|#) #|line 52|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 54|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 55|#))) #|line 56|#
  )                                                         #|line 58|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 59|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 60|# #|line 61|#

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
(defun probe_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 16|# #|line 17|#
  (let ((s (slot-value (slot-value  mev 'datum) 'v)))
    (declare (ignorable s))                                 #|line 18|#
    (live_update  "Info"  (concatenate 'string  "  @"  (concatenate 'string (format nil "~a"  ticktime)  (concatenate 'string  "  "  (concatenate 'string  "probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "   s))))))) #|line 26|#) #|line 27|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 29|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 30|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 31|#))) #|line 32|#
  )
(defun trash_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 34|#
  #|  to appease dumped_on_floor checker |#                 #|line 35|#
  #| pass |#                                                #|line 36|# #|line 37|#
  )
(defclass TwoMevents ()                                     #|line 38|#
  (
    (firstmev :accessor firstmev :initarg :firstmev :initform  nil)  #|line 39|#
    (secondmev :accessor secondmev :initarg :secondmev :initform  nil)  #|line 40|#)) #|line 41|#

                                                            #|line 42|# #|  Deracer_States :: enum { idle, waitingForFirstmev, waitingForSecondmev } |# #|line 43|#
(defclass Deracer_Instance_Data ()                          #|line 44|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 45|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 46|#)) #|line 47|#

                                                            #|line 48|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 49|#
  #| pass |#                                                #|line 50|# #|line 51|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 53|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 54|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 55|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 56|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMevents) #|line 57|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 58|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 59|#))) #|line 60|#
  )
(defun send_firstmev_then_secondmev (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 62|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmev)  #|line 63|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmev)  #|line 64|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 65|#) #|line 66|#
  )
(defun deracer_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 68|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 69|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 70|#
        (cond
          (( equal    "1" (slot-value  mev 'port))          #|line 71|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmev)  mev) #|line 72|#
            (setf (slot-value  inst 'state)  "waitingForSecondmev") #|line 73|#
            )
          (( equal    "2" (slot-value  mev 'port))          #|line 74|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmev)  mev) #|line 75|#
            (setf (slot-value  inst 'state)  "waitingForFirstmev") #|line 76|#
            )
          (t                                                #|line 77|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case A) for deracer " (slot-value  mev 'port))  #|line 78|#) #|line 79|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmev") #|line 80|#
        (cond
          (( equal    "1" (slot-value  mev 'port))          #|line 81|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmev)  mev) #|line 82|#
            (funcall (quote send_firstmev_then_secondmev)   eh  inst  #|line 83|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 84|#
            )
          (t                                                #|line 85|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case B) for deracer " (slot-value  mev 'port))  #|line 86|#) #|line 87|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmev") #|line 88|#
        (cond
          (( equal    "2" (slot-value  mev 'port))          #|line 89|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmev)  mev) #|line 90|#
            (funcall (quote send_firstmev_then_secondmev)   eh  inst  #|line 91|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 92|#
            )
          (t                                                #|line 93|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case C) for deracer " (slot-value  mev 'port))  #|line 94|#) #|line 95|#
            ))
        )
      (t                                                    #|line 96|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}"  #|line 97|#) #|line 98|#
        )))                                                 #|line 99|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 101|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 102|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 103|#))) #|line 104|#
  )
(defun low_level_read_text_file_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 106|#
  (let ((fname (slot-value (slot-value  mev 'datum) 'v)))
    (declare (ignorable fname))                             #|line 107|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and mev if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 108|#) #|line 109|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 111|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 112|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 113|#))) #|line 114|#
  )
(defun ensure_string_datum_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 116|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  mev 'datum) 'kind) )) #|line 117|#
      (funcall (quote forward)   eh  ""  mev                #|line 118|#)
      )
    (t                                                      #|line 119|#
      (let ((emev  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  mev 'datum)) #|line 120|#))
        (declare (ignorable emev))
        (funcall (quote send)   eh  "✗"  emev  mev          #|line 121|#)) #|line 122|#
      ))                                                    #|line 123|#
  )
(defclass Syncfilewrite_Data ()                             #|line 125|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 126|#)) #|line 127|#

                                                            #|line 128|# #|  temp copy for bootstrap, sends "done“ (error during bootstrap if not wired) |# #|line 129|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 130|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 131|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 132|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 133|#)))) #|line 134|#
  )
(defun syncfilewrite_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 136|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 137|#
    (cond
      (( equal    "filename" (slot-value  mev 'port))       #|line 138|#
        (setf (slot-value  inst 'filename) (slot-value (slot-value  mev 'datum) 'v)) #|line 139|#
        )
      (( equal    "input" (slot-value  mev 'port))          #|line 140|#
        (let ((contents (slot-value (slot-value  mev 'datum) 'v)))
          (declare (ignorable contents))                    #|line 141|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 142|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 143|#
                (funcall (slot-value  f 'write)  (slot-value (slot-value  mev 'datum) 'v)  #|line 144|#)
                (funcall (slot-value  f 'close) )           #|line 145|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  mev  #|line 146|#)
                )
              (t                                            #|line 147|#
                (funcall (quote send)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  mev  #|line 148|#) #|line 149|#
                ))))                                        #|line 150|#
        )))                                                 #|line 151|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 153|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 154|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 155|#)) #|line 156|#

                                                            #|line 157|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 158|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 159|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 160|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 161|#)))) #|line 162|#
  )
(defun stringconcat_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 164|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 165|#
    (cond
      (( equal    "1" (slot-value  mev 'port))              #|line 166|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (slot-value (slot-value  mev 'datum) 'v)  #|line 167|#))
        (funcall (quote maybe_stringconcat)   eh  inst  mev  #|line 168|#)
        )
      (( equal    "2" (slot-value  mev 'port))              #|line 169|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (slot-value (slot-value  mev 'datum) 'v)  #|line 170|#))
        (funcall (quote maybe_stringconcat)   eh  inst  mev  #|line 171|#)
        )
      (( equal    "reset" (slot-value  mev 'port))          #|line 172|#
        (setf (slot-value  inst 'buffer1)  nil)             #|line 173|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 174|#
        )
      (t                                                    #|line 175|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port for stringconcat: " (slot-value  mev 'port))  #|line 176|#) #|line 177|#
        )))                                                 #|line 178|#
  )
(defun maybe_stringconcat (&optional  eh  inst  mev)
  (declare (ignorable  eh  inst  mev))                      #|line 180|#
  (cond
    (( and  (not (equal  (slot-value  inst 'buffer1)  nil)) (not (equal  (slot-value  inst 'buffer2)  nil))) #|line 181|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 182|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 183|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 184|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 185|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 186|#
            )
          (t                                                #|line 187|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 188|# #|line 189|#
            ))
        (funcall (quote send)   eh  ""  concatenated_string  mev  #|line 190|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 191|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 192|#) #|line 193|#
      ))                                                    #|line 194|#
  ) #|  |#                                                  #|line 196|# #|line 197|#
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 198|# #|line 199|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 200|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 201|#
      (cond
        ((not (equal   projectRoot  ""))                    #|line 202|#
          (setf  s (substitute  "_00_"  projectRoot  s)     #|line 203|#) #|line 204|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 205|#)))) #|line 206|#
  )
(defun string_constant_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 208|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 209|#
    (funcall (quote send)   eh  ""  s  mev                  #|line 210|#)) #|line 211|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 213|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 214|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 215|#))) #|line 216|#
  )
(defparameter  rand  0)                                     #|line 218|# #|line 219|#
(defun fakepipename_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 220|# #|line 221|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ ;rand' must be unique within a single run |# #|line 222|#
  (funcall (quote send)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  mev  #|line 223|#) #|line 224|#
  )                                                         #|line 226|#
(defclass Switch1star_Instance_Data ()                      #|line 227|#
  (
    (state :accessor state :initarg :state :initform  "1")  #|line 228|#)) #|line 229|#

                                                            #|line 230|#
(defun switch1star_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 231|#
  (let ((name_with_id (funcall (quote gensymbol)   "switch1*"  #|line 232|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Switch1star_Instance_Data) #|line 233|#))
      (declare (ignorable instp))
      (return-from switch1star_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'switch1star_handler  #|line 234|#)))) #|line 235|#
  )
(defun switch1star_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 237|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 238|#
    (let ((whichOutput (slot-value  inst 'state)))
      (declare (ignorable whichOutput))                     #|line 239|#
      (cond
        (( equal    "" (slot-value  mev 'port))             #|line 240|#
          (cond
            (( equal    "1"  whichOutput)                   #|line 241|#
              (funcall (quote forward)   eh  "1"  mev       #|line 242|#)
              (setf (slot-value  inst 'state)  "*")         #|line 243|#
              )
            (( equal    "*"  whichOutput)                   #|line 244|#
              (funcall (quote forward)   eh  "*"  mev       #|line 245|#)
              )
            (t                                              #|line 246|#
              (funcall (quote send)   eh  "✗"  "internal error bad state in switch1*"  mev  #|line 247|#) #|line 248|#
              ))
          )
        (( equal    "reset" (slot-value  mev 'port))        #|line 249|#
          (setf (slot-value  inst 'state)  "1")             #|line 250|#
          )
        (t                                                  #|line 251|#
          (funcall (quote send)   eh  "✗"  "internal error bad mevent for switch1*"  mev  #|line 252|#) #|line 253|#
          ))))                                              #|line 254|#
  )
(defclass StringAccumulator ()                              #|line 256|#
  (
    (s :accessor s :initarg :s :initform  "")               #|line 257|#)) #|line 258|#

                                                            #|line 259|#
(defun strcatstar_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 260|#
  (let ((name_with_id (funcall (quote gensymbol)   "String Concat *"  #|line 261|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringAccumulator)        #|line 262|#))
      (declare (ignorable instp))
      (return-from strcatstar_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'strcatstar_handler  #|line 263|#)))) #|line 264|#
  )
(defun strcatstar_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 266|#
  (let (( accum (slot-value  eh 'instance_data)))
    (declare (ignorable  accum))                            #|line 267|#
    (cond
      (( equal    "" (slot-value  mev 'port))               #|line 268|#
        (setf (slot-value  accum 's)  (concatenate 'string (slot-value  accum 's) (slot-value (slot-value  mev 'datum) 'v)) #|line 269|#)
        )
      (( equal    "fini" (slot-value  mev 'port))           #|line 270|#
        (funcall (quote send)   eh  "" (slot-value  accum 's)  mev  #|line 271|#)
        )
      (t                                                    #|line 272|#
        (funcall (quote send)   eh  "✗"  "internal error bad mevent for String Concat *"  mev  #|line 273|#) #|line 274|#
        )))                                                 #|line 275|#
  ) #|  all of the the built_in leaves are listed here |#   #|line 277|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 278|# #|line 279|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 280|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 281|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 282|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 283|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 284|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 285|#) #|line 286|# #|line 287|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 288|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 289|#) #|line 290|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 291|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 292|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "switch1*"  nil  #'switch1star_instantiate )  #|line 293|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "String Concat *"  nil  #'strcatstar_instantiate )  #|line 294|#)
  #|  for fakepipe |#                                       #|line 295|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 296|#) #|line 297|#
  )#|  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 1|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 2|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 3|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 4|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 5|#)))) #|line 6|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 8|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 9|#
    (let ((s (slot-value (slot-value  msg 'datum) 'v)))
      (declare (ignorable s))                               #|line 10|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 11|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 12|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 13|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 14|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 15|#
              (cond
                (( equal    rc  0)                          #|line 16|#
                  (funcall (quote send)   eh  ""  (concatenate 'string  stdout  stderr)  msg  #|line 17|#)
                  )
                (t                                          #|line 18|#
                  (funcall (quote send)   eh  "✗"  (concatenate 'string  stdout  stderr)  msg  #|line 19|#) #|line 20|#
                  ))))))))                                  #|line 21|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 23|#
  #|  [ |#                                                  #|line 24|#
  #|      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 25|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 26|#
  #|  ] |#                                                  #|line 27|#
  (cond
    ((not (equal   nil  container_list))                    #|line 28|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 29|#
            #|  loop through every component in the diagram and look for names that start with “$“ or “'“  |# #|line 30|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 31|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 32|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 33|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 34|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 35|#
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  cmd  #'shell_out_instantiate  #|line 36|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 37|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 38|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 39|#
                        (let ((s  (subseq  name 1)          #|line 40|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  s  #'string_constant_instantiate  #|line 41|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 42|#)))) #|line 43|#
                      ))                                    #|line 44|#
                  ))                                        #|line 45|#
            ))                                              #|line 46|#
      ))
  (return-from generate_shell_components  reg)              #|line 47|# #|line 48|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 50|#
  (return-from first_char  (string (char  s 0))             #|line 51|#) #|line 52|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 54|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 55|#))) #|line 56|#
  )                                                         #|line 58|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 59|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 60|# #|line 61|#

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
(defun probe_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 16|# #|line 17|#
  (let ((s (slot-value (slot-value  mev 'datum) 'v)))
    (declare (ignorable s))                                 #|line 18|#
    (live_update  "Info"  (concatenate 'string  "  @"  (concatenate 'string (format nil "~a"  ticktime)  (concatenate 'string  "  "  (concatenate 'string  "probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "   s))))))) #|line 26|#) #|line 27|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 29|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 30|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 31|#))) #|line 32|#
  )
(defun trash_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 34|#
  #|  to appease dumped_on_floor checker |#                 #|line 35|#
  #| pass |#                                                #|line 36|# #|line 37|#
  )
(defclass TwoMevents ()                                     #|line 38|#
  (
    (firstmev :accessor firstmev :initarg :firstmev :initform  nil)  #|line 39|#
    (secondmev :accessor secondmev :initarg :secondmev :initform  nil)  #|line 40|#)) #|line 41|#

                                                            #|line 42|# #|  Deracer_States :: enum { idle, waitingForFirstmev, waitingForSecondmev } |# #|line 43|#
(defclass Deracer_Instance_Data ()                          #|line 44|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 45|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 46|#)) #|line 47|#

                                                            #|line 48|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 49|#
  #| pass |#                                                #|line 50|# #|line 51|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 53|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 54|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 55|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 56|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMevents) #|line 57|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 58|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 59|#))) #|line 60|#
  )
(defun send_firstmev_then_secondmev (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 62|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmev)  #|line 63|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmev)  #|line 64|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 65|#) #|line 66|#
  )
(defun deracer_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 68|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 69|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 70|#
        (cond
          (( equal    "1" (slot-value  mev 'port))          #|line 71|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmev)  mev) #|line 72|#
            (setf (slot-value  inst 'state)  "waitingForSecondmev") #|line 73|#
            )
          (( equal    "2" (slot-value  mev 'port))          #|line 74|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmev)  mev) #|line 75|#
            (setf (slot-value  inst 'state)  "waitingForFirstmev") #|line 76|#
            )
          (t                                                #|line 77|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case A) for deracer " (slot-value  mev 'port))  #|line 78|#) #|line 79|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmev") #|line 80|#
        (cond
          (( equal    "1" (slot-value  mev 'port))          #|line 81|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmev)  mev) #|line 82|#
            (funcall (quote send_firstmev_then_secondmev)   eh  inst  #|line 83|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 84|#
            )
          (t                                                #|line 85|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case B) for deracer " (slot-value  mev 'port))  #|line 86|#) #|line 87|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmev") #|line 88|#
        (cond
          (( equal    "2" (slot-value  mev 'port))          #|line 89|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmev)  mev) #|line 90|#
            (funcall (quote send_firstmev_then_secondmev)   eh  inst  #|line 91|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 92|#
            )
          (t                                                #|line 93|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case C) for deracer " (slot-value  mev 'port))  #|line 94|#) #|line 95|#
            ))
        )
      (t                                                    #|line 96|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}"  #|line 97|#) #|line 98|#
        )))                                                 #|line 99|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 101|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 102|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 103|#))) #|line 104|#
  )
(defun low_level_read_text_file_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 106|#
  (let ((fname (slot-value (slot-value  mev 'datum) 'v)))
    (declare (ignorable fname))                             #|line 107|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and mev if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 108|#) #|line 109|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 111|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 112|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 113|#))) #|line 114|#
  )
(defun ensure_string_datum_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 116|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  mev 'datum) 'kind) )) #|line 117|#
      (funcall (quote forward)   eh  ""  mev                #|line 118|#)
      )
    (t                                                      #|line 119|#
      (let ((emev  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  mev 'datum)) #|line 120|#))
        (declare (ignorable emev))
        (funcall (quote send)   eh  "✗"  emev  mev          #|line 121|#)) #|line 122|#
      ))                                                    #|line 123|#
  )
(defclass Syncfilewrite_Data ()                             #|line 125|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 126|#)) #|line 127|#

                                                            #|line 128|# #|  temp copy for bootstrap, sends "done“ (error during bootstrap if not wired) |# #|line 129|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 130|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 131|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 132|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 133|#)))) #|line 134|#
  )
(defun syncfilewrite_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 136|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 137|#
    (cond
      (( equal    "filename" (slot-value  mev 'port))       #|line 138|#
        (setf (slot-value  inst 'filename) (slot-value (slot-value  mev 'datum) 'v)) #|line 139|#
        )
      (( equal    "input" (slot-value  mev 'port))          #|line 140|#
        (let ((contents (slot-value (slot-value  mev 'datum) 'v)))
          (declare (ignorable contents))                    #|line 141|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 142|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 143|#
                (funcall (slot-value  f 'write)  (slot-value (slot-value  mev 'datum) 'v)  #|line 144|#)
                (funcall (slot-value  f 'close) )           #|line 145|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  mev  #|line 146|#)
                )
              (t                                            #|line 147|#
                (funcall (quote send)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  mev  #|line 148|#) #|line 149|#
                ))))                                        #|line 150|#
        )))                                                 #|line 151|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 153|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 154|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 155|#)) #|line 156|#

                                                            #|line 157|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 158|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 159|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 160|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 161|#)))) #|line 162|#
  )
(defun stringconcat_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 164|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 165|#
    (cond
      (( equal    "1" (slot-value  mev 'port))              #|line 166|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (slot-value (slot-value  mev 'datum) 'v)  #|line 167|#))
        (funcall (quote maybe_stringconcat)   eh  inst  mev  #|line 168|#)
        )
      (( equal    "2" (slot-value  mev 'port))              #|line 169|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (slot-value (slot-value  mev 'datum) 'v)  #|line 170|#))
        (funcall (quote maybe_stringconcat)   eh  inst  mev  #|line 171|#)
        )
      (( equal    "reset" (slot-value  mev 'port))          #|line 172|#
        (setf (slot-value  inst 'buffer1)  nil)             #|line 173|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 174|#
        )
      (t                                                    #|line 175|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port for stringconcat: " (slot-value  mev 'port))  #|line 176|#) #|line 177|#
        )))                                                 #|line 178|#
  )
(defun maybe_stringconcat (&optional  eh  inst  mev)
  (declare (ignorable  eh  inst  mev))                      #|line 180|#
  (cond
    (( and  (not (equal  (slot-value  inst 'buffer1)  nil)) (not (equal  (slot-value  inst 'buffer2)  nil))) #|line 181|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 182|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 183|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 184|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 185|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 186|#
            )
          (t                                                #|line 187|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 188|# #|line 189|#
            ))
        (funcall (quote send)   eh  ""  concatenated_string  mev  #|line 190|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 191|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 192|#) #|line 193|#
      ))                                                    #|line 194|#
  ) #|  |#                                                  #|line 196|# #|line 197|#
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 198|# #|line 199|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 200|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 201|#
      (cond
        ((not (equal   projectRoot  ""))                    #|line 202|#
          (setf  s (substitute  "_00_"  projectRoot  s)     #|line 203|#) #|line 204|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 205|#)))) #|line 206|#
  )
(defun string_constant_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 208|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 209|#
    (funcall (quote send)   eh  ""  s  mev                  #|line 210|#)) #|line 211|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 213|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 214|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 215|#))) #|line 216|#
  )
(defparameter  rand  0)                                     #|line 218|# #|line 219|#
(defun fakepipename_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 220|# #|line 221|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ ;rand' must be unique within a single run |# #|line 222|#
  (funcall (quote send)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  mev  #|line 223|#) #|line 224|#
  )                                                         #|line 226|#
(defclass Switch1star_Instance_Data ()                      #|line 227|#
  (
    (state :accessor state :initarg :state :initform  "1")  #|line 228|#)) #|line 229|#

                                                            #|line 230|#
(defun switch1star_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 231|#
  (let ((name_with_id (funcall (quote gensymbol)   "switch1*"  #|line 232|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Switch1star_Instance_Data) #|line 233|#))
      (declare (ignorable instp))
      (return-from switch1star_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'switch1star_handler  #|line 234|#)))) #|line 235|#
  )
(defun switch1star_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 237|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 238|#
    (let ((whichOutput (slot-value  inst 'state)))
      (declare (ignorable whichOutput))                     #|line 239|#
      (cond
        (( equal    "" (slot-value  mev 'port))             #|line 240|#
          (cond
            (( equal    "1"  whichOutput)                   #|line 241|#
              (funcall (quote forward)   eh  "1"  mev       #|line 242|#)
              (setf (slot-value  inst 'state)  "*")         #|line 243|#
              )
            (( equal    "*"  whichOutput)                   #|line 244|#
              (funcall (quote forward)   eh  "*"  mev       #|line 245|#)
              )
            (t                                              #|line 246|#
              (funcall (quote send)   eh  "✗"  "internal error bad state in switch1*"  mev  #|line 247|#) #|line 248|#
              ))
          )
        (( equal    "reset" (slot-value  mev 'port))        #|line 249|#
          (setf (slot-value  inst 'state)  "1")             #|line 250|#
          )
        (t                                                  #|line 251|#
          (funcall (quote send)   eh  "✗"  "internal error bad mevent for switch1*"  mev  #|line 252|#) #|line 253|#
          ))))                                              #|line 254|#
  )
(defclass StringAccumulator ()                              #|line 256|#
  (
    (s :accessor s :initarg :s :initform  "")               #|line 257|#)) #|line 258|#

                                                            #|line 259|#
(defun strcatstar_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 260|#
  (let ((name_with_id (funcall (quote gensymbol)   "String Concat *"  #|line 261|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringAccumulator)        #|line 262|#))
      (declare (ignorable instp))
      (return-from strcatstar_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'strcatstar_handler  #|line 263|#)))) #|line 264|#
  )
(defun strcatstar_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 266|#
  (let (( accum (slot-value  eh 'instance_data)))
    (declare (ignorable  accum))                            #|line 267|#
    (cond
      (( equal    "" (slot-value  mev 'port))               #|line 268|#
        (setf (slot-value  accum 's)  (concatenate 'string (slot-value  accum 's) (slot-value (slot-value  mev 'datum) 'v)) #|line 269|#)
        )
      (( equal    "fini" (slot-value  mev 'port))           #|line 270|#
        (funcall (quote send)   eh  "" (slot-value  accum 's)  mev  #|line 271|#)
        )
      (t                                                    #|line 272|#
        (funcall (quote send)   eh  "✗"  "internal error bad mevent for String Concat *"  mev  #|line 273|#) #|line 274|#
        )))                                                 #|line 275|#
  ) #|  all of the the built_in leaves are listed here |#   #|line 277|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 278|# #|line 279|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 280|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 281|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 282|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 283|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 284|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 285|#) #|line 286|# #|line 287|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 288|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 289|#) #|line 290|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 291|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 292|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "switch1*"  nil  #'switch1star_instantiate )  #|line 293|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "String Concat *"  nil  #'strcatstar_instantiate )  #|line 294|#)
  #|  for fakepipe |#                                       #|line 295|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 296|#) #|line 297|#
  )#|  this needs to be rewritten to use the low_level "shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 1|#
(defun shell_out_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 2|#
  (let ((name_with_id (funcall (quote gensymbol)   "shell_out"  #|line 3|#)))
    (declare (ignorable name_with_id))
    (let ((cmd (split-sequence '(#\space)  template_data)   #|line 4|#))
      (declare (ignorable cmd))
      (return-from shell_out_instantiate (funcall (quote make_leaf)   name_with_id  owner  cmd  #'shell_out_handler  #|line 5|#)))) #|line 6|#
  )
(defun shell_out_handler (&optional  eh  msg)
  (declare (ignorable  eh  msg))                            #|line 8|#
  (let ((cmd (slot-value  eh 'instance_data)))
    (declare (ignorable cmd))                               #|line 9|#
    (let ((s (slot-value (slot-value  msg 'datum) 'v)))
      (declare (ignorable s))                               #|line 10|#
      (let (( ret  nil))
        (declare (ignorable  ret))                          #|line 11|#
        (let (( rc  nil))
          (declare (ignorable  rc))                         #|line 12|#
          (let (( stdout  nil))
            (declare (ignorable  stdout))                   #|line 13|#
            (let (( stderr  nil))
              (declare (ignorable  stderr))                 #|line 14|#
              (multiple-value-setq (stdout stderr rc) (uiop::run-program (concatenate 'string  cmd " "  s) :output :string :error :string)) #|line 15|#
              (cond
                (( equal    rc  0)                          #|line 16|#
                  (funcall (quote send)   eh  ""  (concatenate 'string  stdout  stderr)  msg  #|line 17|#)
                  )
                (t                                          #|line 18|#
                  (funcall (quote send)   eh  "✗"  (concatenate 'string  stdout  stderr)  msg  #|line 19|#) #|line 20|#
                  ))))))))                                  #|line 21|#
  )
(defun generate_shell_components (&optional  reg  container_list)
  (declare (ignorable  reg  container_list))                #|line 23|#
  #|  [ |#                                                  #|line 24|#
  #|      {;file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 25|#
  #|      {'file': 'simple0d.drawio', 'name': '...', 'children': [], 'connections': []} |# #|line 26|#
  #|  ] |#                                                  #|line 27|#
  (cond
    ((not (equal   nil  container_list))                    #|line 28|#
      (loop for diagram in  container_list
        do
          (progn
            diagram                                         #|line 29|#
            #|  loop through every component in the diagram and look for names that start with “$“ or “'“  |# #|line 30|#
            #|  {'file': 'simple0d.drawio', 'name': 'main', 'children': [{'name': 'Echo', 'id': 5}], 'connections': [...]}, |# #|line 31|#
            (loop for child_descriptor in (gethash  "children"  diagram)
              do
                (progn
                  child_descriptor                          #|line 32|#
                  (cond
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "$" ) #|line 33|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 34|#
                        (let ((cmd (funcall (slot-value  (subseq  name 1) 'strip) )))
                          (declare (ignorable cmd))         #|line 35|#
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  cmd  #'shell_out_instantiate  #|line 36|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component)   reg  generated_leaf  #|line 37|#))))
                      )
                    ((funcall (quote first_char_is)  (gethash  "name"  child_descriptor)  "'" ) #|line 38|#
                      (let ((name (gethash  "name"  child_descriptor)))
                        (declare (ignorable name))          #|line 39|#
                        (let ((s  (subseq  name 1)          #|line 40|#))
                          (declare (ignorable s))
                          (let ((generated_leaf (funcall (quote mkTemplate)   name  s  #'string_constant_instantiate  #|line 41|#)))
                            (declare (ignorable generated_leaf))
                            (funcall (quote register_component_allow_overwriting)   reg  generated_leaf  #|line 42|#)))) #|line 43|#
                      ))                                    #|line 44|#
                  ))                                        #|line 45|#
            ))                                              #|line 46|#
      ))
  (return-from generate_shell_components  reg)              #|line 47|# #|line 48|#
  )
(defun first_char (&optional  s)
  (declare (ignorable  s))                                  #|line 50|#
  (return-from first_char  (string (char  s 0))             #|line 51|#) #|line 52|#
  )
(defun first_char_is (&optional  s  c)
  (declare (ignorable  s  c))                               #|line 54|#
  (return-from first_char_is ( equal    c (funcall (quote first_char)   s  #|line 55|#))) #|line 56|#
  )                                                         #|line 58|# #|  TODO: #run_command needs to be rewritten to use the low_level “shell_out“ component, this can be done solely as a diagram without using python code here |# #|line 59|# #|  I'll keep it for now, during bootstrapping, since it mimics what is done in the Odin prototype _ both need to be revamped |# #|line 60|# #|line 61|#

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
(defun probe_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 16|# #|line 17|#
  (let ((s (slot-value (slot-value  mev 'datum) 'v)))
    (declare (ignorable s))                                 #|line 18|#
    (live_update  "Info"  (concatenate 'string  "  @"  (concatenate 'string (format nil "~a"  ticktime)  (concatenate 'string  "  "  (concatenate 'string  "probe "  (concatenate 'string (slot-value  eh 'name)  (concatenate 'string  ": "   s))))))) #|line 26|#) #|line 27|#
  )
(defun trash_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 29|#
  (let ((name_with_id (funcall (quote gensymbol)   "trash"  #|line 30|#)))
    (declare (ignorable name_with_id))
    (return-from trash_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'trash_handler  #|line 31|#))) #|line 32|#
  )
(defun trash_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 34|#
  #|  to appease dumped_on_floor checker |#                 #|line 35|#
  #| pass |#                                                #|line 36|# #|line 37|#
  )
(defclass TwoMevents ()                                     #|line 38|#
  (
    (firstmev :accessor firstmev :initarg :firstmev :initform  nil)  #|line 39|#
    (secondmev :accessor secondmev :initarg :secondmev :initform  nil)  #|line 40|#)) #|line 41|#

                                                            #|line 42|# #|  Deracer_States :: enum { idle, waitingForFirstmev, waitingForSecondmev } |# #|line 43|#
(defclass Deracer_Instance_Data ()                          #|line 44|#
  (
    (state :accessor state :initarg :state :initform  nil)  #|line 45|#
    (buffer :accessor buffer :initarg :buffer :initform  nil)  #|line 46|#)) #|line 47|#

                                                            #|line 48|#
(defun reclaim_Buffers_from_heap (&optional  inst)
  (declare (ignorable  inst))                               #|line 49|#
  #| pass |#                                                #|line 50|# #|line 51|#
  )
(defun deracer_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 53|#
  (let ((name_with_id (funcall (quote gensymbol)   "deracer"  #|line 54|#)))
    (declare (ignorable name_with_id))
    (let (( inst  (make-instance 'Deracer_Instance_Data)    #|line 55|#))
      (declare (ignorable  inst))
      (setf (slot-value  inst 'state)  "idle")              #|line 56|#
      (setf (slot-value  inst 'buffer)  (make-instance 'TwoMevents) #|line 57|#)
      (let ((eh (funcall (quote make_leaf)   name_with_id  owner  inst  #'deracer_handler  #|line 58|#)))
        (declare (ignorable eh))
        (return-from deracer_instantiate  eh)               #|line 59|#))) #|line 60|#
  )
(defun send_firstmev_then_secondmev (&optional  eh  inst)
  (declare (ignorable  eh  inst))                           #|line 62|#
  (funcall (quote forward)   eh  "1" (slot-value (slot-value  inst 'buffer) 'firstmev)  #|line 63|#)
  (funcall (quote forward)   eh  "2" (slot-value (slot-value  inst 'buffer) 'secondmev)  #|line 64|#)
  (funcall (quote reclaim_Buffers_from_heap)   inst         #|line 65|#) #|line 66|#
  )
(defun deracer_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 68|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 69|#
    (cond
      (( equal   (slot-value  inst 'state)  "idle")         #|line 70|#
        (cond
          (( equal    "1" (slot-value  mev 'port))          #|line 71|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmev)  mev) #|line 72|#
            (setf (slot-value  inst 'state)  "waitingForSecondmev") #|line 73|#
            )
          (( equal    "2" (slot-value  mev 'port))          #|line 74|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmev)  mev) #|line 75|#
            (setf (slot-value  inst 'state)  "waitingForFirstmev") #|line 76|#
            )
          (t                                                #|line 77|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case A) for deracer " (slot-value  mev 'port))  #|line 78|#) #|line 79|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForFirstmev") #|line 80|#
        (cond
          (( equal    "1" (slot-value  mev 'port))          #|line 81|#
            (setf (slot-value (slot-value  inst 'buffer) 'firstmev)  mev) #|line 82|#
            (funcall (quote send_firstmev_then_secondmev)   eh  inst  #|line 83|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 84|#
            )
          (t                                                #|line 85|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case B) for deracer " (slot-value  mev 'port))  #|line 86|#) #|line 87|#
            ))
        )
      (( equal   (slot-value  inst 'state)  "waitingForSecondmev") #|line 88|#
        (cond
          (( equal    "2" (slot-value  mev 'port))          #|line 89|#
            (setf (slot-value (slot-value  inst 'buffer) 'secondmev)  mev) #|line 90|#
            (funcall (quote send_firstmev_then_secondmev)   eh  inst  #|line 91|#)
            (setf (slot-value  inst 'state)  "idle")        #|line 92|#
            )
          (t                                                #|line 93|#
            (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port (case C) for deracer " (slot-value  mev 'port))  #|line 94|#) #|line 95|#
            ))
        )
      (t                                                    #|line 96|#
        (funcall (quote runtime_error)   "bad state for deracer {eh.state}"  #|line 97|#) #|line 98|#
        )))                                                 #|line 99|#
  )
(defun low_level_read_text_file_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 101|#
  (let ((name_with_id (funcall (quote gensymbol)   "Low Level Read Text File"  #|line 102|#)))
    (declare (ignorable name_with_id))
    (return-from low_level_read_text_file_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'low_level_read_text_file_handler  #|line 103|#))) #|line 104|#
  )
(defun low_level_read_text_file_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 106|#
  (let ((fname (slot-value (slot-value  mev 'datum) 'v)))
    (declare (ignorable fname))                             #|line 107|#

    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and mev if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
                                                            #|line 108|#) #|line 109|#
  )
(defun ensure_string_datum_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 111|#
  (let ((name_with_id (funcall (quote gensymbol)   "Ensure String Datum"  #|line 112|#)))
    (declare (ignorable name_with_id))
    (return-from ensure_string_datum_instantiate (funcall (quote make_leaf)   name_with_id  owner  nil  #'ensure_string_datum_handler  #|line 113|#))) #|line 114|#
  )
(defun ensure_string_datum_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 116|#
  (cond
    (( equal    "string" (funcall (slot-value (slot-value  mev 'datum) 'kind) )) #|line 117|#
      (funcall (quote forward)   eh  ""  mev                #|line 118|#)
      )
    (t                                                      #|line 119|#
      (let ((emev  (concatenate 'string  "*** ensure: type error (expected a string datum) but got " (slot-value  mev 'datum)) #|line 120|#))
        (declare (ignorable emev))
        (funcall (quote send)   eh  "✗"  emev  mev          #|line 121|#)) #|line 122|#
      ))                                                    #|line 123|#
  )
(defclass Syncfilewrite_Data ()                             #|line 125|#
  (
    (filename :accessor filename :initarg :filename :initform  "")  #|line 126|#)) #|line 127|#

                                                            #|line 128|# #|  temp copy for bootstrap, sends "done“ (error during bootstrap if not wired) |# #|line 129|#
(defun syncfilewrite_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 130|#
  (let ((name_with_id (funcall (quote gensymbol)   "syncfilewrite"  #|line 131|#)))
    (declare (ignorable name_with_id))
    (let ((inst  (make-instance 'Syncfilewrite_Data)        #|line 132|#))
      (declare (ignorable inst))
      (return-from syncfilewrite_instantiate (funcall (quote make_leaf)   name_with_id  owner  inst  #'syncfilewrite_handler  #|line 133|#)))) #|line 134|#
  )
(defun syncfilewrite_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 136|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 137|#
    (cond
      (( equal    "filename" (slot-value  mev 'port))       #|line 138|#
        (setf (slot-value  inst 'filename) (slot-value (slot-value  mev 'datum) 'v)) #|line 139|#
        )
      (( equal    "input" (slot-value  mev 'port))          #|line 140|#
        (let ((contents (slot-value (slot-value  mev 'datum) 'v)))
          (declare (ignorable contents))                    #|line 141|#
          (let (( f (funcall (quote open)  (slot-value  inst 'filename)  "w"  #|line 142|#)))
            (declare (ignorable  f))
            (cond
              ((not (equal   f  nil))                       #|line 143|#
                (funcall (slot-value  f 'write)  (slot-value (slot-value  mev 'datum) 'v)  #|line 144|#)
                (funcall (slot-value  f 'close) )           #|line 145|#
                (funcall (quote send)   eh  "done" (funcall (quote new_datum_bang) )  mev  #|line 146|#)
                )
              (t                                            #|line 147|#
                (funcall (quote send)   eh  "✗"  (concatenate 'string  "open error on file " (slot-value  inst 'filename))  mev  #|line 148|#) #|line 149|#
                ))))                                        #|line 150|#
        )))                                                 #|line 151|#
  )
(defclass StringConcat_Instance_Data ()                     #|line 153|#
  (
    (buffer1 :accessor buffer1 :initarg :buffer1 :initform  nil)  #|line 154|#
    (buffer2 :accessor buffer2 :initarg :buffer2 :initform  nil)  #|line 155|#)) #|line 156|#

                                                            #|line 157|#
(defun stringconcat_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 158|#
  (let ((name_with_id (funcall (quote gensymbol)   "stringconcat"  #|line 159|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringConcat_Instance_Data) #|line 160|#))
      (declare (ignorable instp))
      (return-from stringconcat_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'stringconcat_handler  #|line 161|#)))) #|line 162|#
  )
(defun stringconcat_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 164|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 165|#
    (cond
      (( equal    "1" (slot-value  mev 'port))              #|line 166|#
        (setf (slot-value  inst 'buffer1) (funcall (quote clone_string)  (slot-value (slot-value  mev 'datum) 'v)  #|line 167|#))
        (funcall (quote maybe_stringconcat)   eh  inst  mev  #|line 168|#)
        )
      (( equal    "2" (slot-value  mev 'port))              #|line 169|#
        (setf (slot-value  inst 'buffer2) (funcall (quote clone_string)  (slot-value (slot-value  mev 'datum) 'v)  #|line 170|#))
        (funcall (quote maybe_stringconcat)   eh  inst  mev  #|line 171|#)
        )
      (( equal    "reset" (slot-value  mev 'port))          #|line 172|#
        (setf (slot-value  inst 'buffer1)  nil)             #|line 173|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 174|#
        )
      (t                                                    #|line 175|#
        (funcall (quote runtime_error)   (concatenate 'string  "bad mev.port for stringconcat: " (slot-value  mev 'port))  #|line 176|#) #|line 177|#
        )))                                                 #|line 178|#
  )
(defun maybe_stringconcat (&optional  eh  inst  mev)
  (declare (ignorable  eh  inst  mev))                      #|line 180|#
  (cond
    (( and  (not (equal  (slot-value  inst 'buffer1)  nil)) (not (equal  (slot-value  inst 'buffer2)  nil))) #|line 181|#
      (let (( concatenated_string  ""))
        (declare (ignorable  concatenated_string))          #|line 182|#
        (cond
          (( equal    0 (length (slot-value  inst 'buffer1))) #|line 183|#
            (setf  concatenated_string (slot-value  inst 'buffer2)) #|line 184|#
            )
          (( equal    0 (length (slot-value  inst 'buffer2))) #|line 185|#
            (setf  concatenated_string (slot-value  inst 'buffer1)) #|line 186|#
            )
          (t                                                #|line 187|#
            (setf  concatenated_string (+ (slot-value  inst 'buffer1) (slot-value  inst 'buffer2))) #|line 188|# #|line 189|#
            ))
        (funcall (quote send)   eh  ""  concatenated_string  mev  #|line 190|#)
        (setf (slot-value  inst 'buffer1)  nil)             #|line 191|#
        (setf (slot-value  inst 'buffer2)  nil)             #|line 192|#) #|line 193|#
      ))                                                    #|line 194|#
  ) #|  |#                                                  #|line 196|# #|line 197|#
(defun string_constant_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 198|# #|line 199|#
  (let ((name_with_id (funcall (quote gensymbol)   "strconst"  #|line 200|#)))
    (declare (ignorable name_with_id))
    (let (( s  template_data))
      (declare (ignorable  s))                              #|line 201|#
      (cond
        ((not (equal   projectRoot  ""))                    #|line 202|#
          (setf  s (substitute  "_00_"  projectRoot  s)     #|line 203|#) #|line 204|#
          ))
      (return-from string_constant_instantiate (funcall (quote make_leaf)   name_with_id  owner  s  #'string_constant_handler  #|line 205|#)))) #|line 206|#
  )
(defun string_constant_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 208|#
  (let ((s (slot-value  eh 'instance_data)))
    (declare (ignorable s))                                 #|line 209|#
    (funcall (quote send)   eh  ""  s  mev                  #|line 210|#)) #|line 211|#
  )
(defun fakepipename_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 213|#
  (let ((instance_name (funcall (quote gensymbol)   "fakepipe"  #|line 214|#)))
    (declare (ignorable instance_name))
    (return-from fakepipename_instantiate (funcall (quote make_leaf)   instance_name  owner  nil  #'fakepipename_handler  #|line 215|#))) #|line 216|#
  )
(defparameter  rand  0)                                     #|line 218|# #|line 219|#
(defun fakepipename_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 220|# #|line 221|#
  (setf  rand (+  rand  1))
  #|  not very random, but good enough _ ;rand' must be unique within a single run |# #|line 222|#
  (funcall (quote send)   eh  ""  (concatenate 'string  "/tmp/fakepipe"  rand)  mev  #|line 223|#) #|line 224|#
  )                                                         #|line 226|#
(defclass Switch1star_Instance_Data ()                      #|line 227|#
  (
    (state :accessor state :initarg :state :initform  "1")  #|line 228|#)) #|line 229|#

                                                            #|line 230|#
(defun switch1star_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 231|#
  (let ((name_with_id (funcall (quote gensymbol)   "switch1*"  #|line 232|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'Switch1star_Instance_Data) #|line 233|#))
      (declare (ignorable instp))
      (return-from switch1star_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'switch1star_handler  #|line 234|#)))) #|line 235|#
  )
(defun switch1star_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 237|#
  (let (( inst (slot-value  eh 'instance_data)))
    (declare (ignorable  inst))                             #|line 238|#
    (let ((whichOutput (slot-value  inst 'state)))
      (declare (ignorable whichOutput))                     #|line 239|#
      (cond
        (( equal    "" (slot-value  mev 'port))             #|line 240|#
          (cond
            (( equal    "1"  whichOutput)                   #|line 241|#
              (funcall (quote forward)   eh  "1"  mev       #|line 242|#)
              (setf (slot-value  inst 'state)  "*")         #|line 243|#
              )
            (( equal    "*"  whichOutput)                   #|line 244|#
              (funcall (quote forward)   eh  "*"  mev       #|line 245|#)
              )
            (t                                              #|line 246|#
              (funcall (quote send)   eh  "✗"  "internal error bad state in switch1*"  mev  #|line 247|#) #|line 248|#
              ))
          )
        (( equal    "reset" (slot-value  mev 'port))        #|line 249|#
          (setf (slot-value  inst 'state)  "1")             #|line 250|#
          )
        (t                                                  #|line 251|#
          (funcall (quote send)   eh  "✗"  "internal error bad mevent for switch1*"  mev  #|line 252|#) #|line 253|#
          ))))                                              #|line 254|#
  )
(defclass StringAccumulator ()                              #|line 256|#
  (
    (s :accessor s :initarg :s :initform  "")               #|line 257|#)) #|line 258|#

                                                            #|line 259|#
(defun strcatstar_instantiate (&optional  reg  owner  name  template_data)
  (declare (ignorable  reg  owner  name  template_data))    #|line 260|#
  (let ((name_with_id (funcall (quote gensymbol)   "String Concat *"  #|line 261|#)))
    (declare (ignorable name_with_id))
    (let ((instp  (make-instance 'StringAccumulator)        #|line 262|#))
      (declare (ignorable instp))
      (return-from strcatstar_instantiate (funcall (quote make_leaf)   name_with_id  owner  instp  #'strcatstar_handler  #|line 263|#)))) #|line 264|#
  )
(defun strcatstar_handler (&optional  eh  mev)
  (declare (ignorable  eh  mev))                            #|line 266|#
  (let (( accum (slot-value  eh 'instance_data)))
    (declare (ignorable  accum))                            #|line 267|#
    (cond
      (( equal    "" (slot-value  mev 'port))               #|line 268|#
        (setf (slot-value  accum 's)  (concatenate 'string (slot-value  accum 's) (slot-value (slot-value  mev 'datum) 'v)) #|line 269|#)
        )
      (( equal    "fini" (slot-value  mev 'port))           #|line 270|#
        (funcall (quote send)   eh  "" (slot-value  accum 's)  mev  #|line 271|#)
        )
      (t                                                    #|line 272|#
        (funcall (quote send)   eh  "✗"  "internal error bad mevent for String Concat *"  mev  #|line 273|#) #|line 274|#
        )))                                                 #|line 275|#
  ) #|  all of the the built_in leaves are listed here |#   #|line 277|# #|  future: refactor this such that programmers can pick and choose which (lumps of) builtins are used in a specific project |# #|line 278|# #|line 279|#
(defun initialize_stock_components (&optional  reg)
  (declare (ignorable  reg))                                #|line 280|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "1then2"  nil  #'deracer_instantiate )  #|line 281|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?A"  nil  #'probeA_instantiate )  #|line 282|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?B"  nil  #'probeB_instantiate )  #|line 283|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "?C"  nil  #'probeC_instantiate )  #|line 284|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "trash"  nil  #'trash_instantiate )  #|line 285|#) #|line 286|# #|line 287|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Read Text File"  nil  #'low_level_read_text_file_instantiate )  #|line 288|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "Ensure String Datum"  nil  #'ensure_string_datum_instantiate )  #|line 289|#) #|line 290|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "syncfilewrite"  nil  #'syncfilewrite_instantiate )  #|line 291|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "stringconcat"  nil  #'stringconcat_instantiate )  #|line 292|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "switch1*"  nil  #'switch1star_instantiate )  #|line 293|#)
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "String Concat *"  nil  #'strcatstar_instantiate )  #|line 294|#)
  #|  for fakepipe |#                                       #|line 295|#
  (funcall (quote register_component)   reg (funcall (quote mkTemplate)   "fakepipename"  nil  #'fakepipename_instantiate )  #|line 296|#) #|line 297|#
  )