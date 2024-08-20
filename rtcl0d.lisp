

(defclass Message () (
    (port :accessor port :initform port)
    (datum :accessor datum :initform datum)))
(defclass Sender () (
    (name :accessor name :initform name)
    (component :accessor component :initform component)
    (port :accessor port :initform port)))



