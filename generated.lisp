
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)

(defun attempt_tick (&optional  parent  eh)                                                                             #|line 1|#
    (cond
      ((not (equal  (cdr (assoc ' state  eh))  "idle"))                                                                 #|line 2|#
            (funcall  force_tick    parent   eh )                                                                       #|line 3|#
        ))                                                                                                              #|line 4|#
)





(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
#|  Nothing to see here. |#                                                                                             #|line 1|#




