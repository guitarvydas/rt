

(defclass Datum ()                                          #|line 1|#
  (
    (a :accessor a :initarg :a :initform  nil)              #|line 2|#
    (b :accessor b :initarg :b :initform  nil)              #|line 3|#
    (c :accessor c :initarg :c :initform  nil)              #|line 4|#)) #|line 5|#


(defun fresh-Datum ( a  b  c )
  (make-instance 'Datum  :a a  :b b  :c c ))
                                                            #|line 6|#





