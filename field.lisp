(defun set-field (obj key-string v)
  (let ((key (intern (string-upcase key-string) "KEYWORD")))
    (let ((pair (assoc key obj)))
      (if pair
          (setf (cdr pair) v)
        nil))))

(defsetf field set-field)