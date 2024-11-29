

(defclass Datum ()                                          #|line 1|#
  (
    (a :accessor a :initarg :a :initform  nil)              #|line 2|#)) #|line 4|#


(defun fresh-Datum ( a )
  (make-instance 'Datum  :a a ))
                                                            #|line 5|#





