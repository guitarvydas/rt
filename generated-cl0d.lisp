

(defun clone_datum_bang ( d)
  (return-from undefined (new_datum_bang )))
(defun Message ( port datum)
  (list
    (cons 'port  port)
    (cons 'datum  datum) ))

(defun clone_port ( s)
  (return-from undefined (clone_string   s)))
#|  Utility for making a `Message`. Used to safely “seed“ messages |#
#|  entering the very top of a network. |#
(defun make_message ( port datum)
  (let (( p (clone_string   port)))
    (let (( m (Message  :port  p :datum ((assoc 'clone  datum) ))))
      (return-from undefined  m))))
(defun xyz ()
  (cond 
    ( x
        (setf  a  1))
    ( y
        (setf  a  2))
    (t
        (setf  a  3))))
(defun low_level_read_text_file_instantiate ( reg owner name template_data)
  (let (( name_with_id (gensym   "Low Level Read Text File")))
    (return-from undefined (make_leaf   name_with_id  owner  nil  low_level_read_text_file_handler))))
(defun low_level_read_text_file_handler ( eh msg)
  (let (( fname ((assoc 'srepr (assoc 'datum  msg)) )))
    ;; read text from a named file fname, send the text out on port "" else send error info on port "✗"
    ;; given eh and msg if needed
    (handler-bind ((error #'(lambda (condition) (send_string eh "✗" (format nil "~&~A~&" condition)))))
      (with-open-file (stream fname)
        (let ((contents (make-string (file-length stream))))
          (read-sequence contents stream)
          (send_string eh "" contents))))
    ))
(defun read_and_convert_json_file ( filename)
  ;; read json from a named file and convert it into internal form (a tree of routings)
  ;; return the routings from the function or print an error message and return nil
  (handler-bind ((error #'(lambda (condition) nil)))
    (with-open-file (json-stream "~/projects/rtlarson/eyeballs.json" :direction :input)
      (json:decode-json json-stream)))
  )




