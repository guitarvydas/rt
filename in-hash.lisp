(defun in-hash-table (key table)
  (multiple-value-bind (dont-care success)
      (gethash key table)
    (declare (ignore dont-care))
    success))