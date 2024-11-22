
(load "~/quicklisp/setup.lisp")
(ql:quickload :cl-json)
(defun dict-fresh () nil)

(defun dict-lookup (d key-string)
(let ((pair (assoc key-string d :test 'equal)))
(if pair
(cdr pair)
nil)))

(defun dict-is-dict? (d) (listp d))

(defun dict-in? (key-string d)
(if (and d (dict-is-dict? d))
(let ((pair (assoc key-string d :test 'equal)))
(if pair t nil))
nil))

(defun field (key obj)
(let ((pair (assoc key obj :test 'equal)))
(if pair (cdr pair) nil)))
(defun set-field (obj key-string v)
(let ((key (intern (string-upcase key-string) "KEYWORD")))
(let ((pair (assoc key obj :test 'equal)))
(if pair
(setf (cdr pair) v)
nil))))

(defsetf field set-field)
                                                            #|line 1|# #|line 2|#
(defun Component_Registry (&optional )                      #|line 3|#
  (list
    (cons "templates"  nil)                                 #|line 4|#) #|line 5|#)
                                                            #|line 6|#
(defun Template (&optional  name  template_data  instantiator) #|line 7|#
  (list
    (cons "name"  name)                                     #|line 8|#
    (cons "template_data"  template_data)                   #|line 9|#
    (cons "instantiator"  instantiator)                     #|line 10|#) #|line 11|#)
                                                            #|line 12|#
(defun make_component_registry (&optional )
  (declare (ignorable ))                                    #|line 13|#
  (return-from make_component_registry (funcall (quote Component_Registry) )) #|line 14|# #|line 15|#
  )
(defun register_component (&optional  reg  template)
  (declare (ignorable  reg  template))
  (return-from register_component (funcall (quote abstracted_register_component)   reg  template )) #|line 17|#
  )
(defun abstracted_register_component (&optional  reg  template)
  (declare (ignorable  reg  template))                      #|line 19|#
  (let ((name (field "name"  template)))
    (declare (ignorable name))                              #|line 20|#
    (let ((templates_alist (field "templates"  reg)))
      (declare (ignorable templates_alist))                 #|line 21|#
      (setf  reg (cons (cons  "templates" (setf  templates_alist (cons (cons  name  template)  templates_alist)))  reg)) #|line 22|#
      (return-from abstracted_register_component  reg)      #|line 23|#)) #|line 24|#
  )
(defun test (&optional )
  (declare (ignorable ))                                    #|line 26|#
  (let (( reg (funcall (quote make_component_registry) )))
    (declare (ignorable  reg))                              #|line 27|#
    (setf  reg (funcall (quote register_component)   reg (funcall (quote Template)   "c1"  1  2 )  #|line 28|#))
    (setf  reg (funcall (quote register_component)   reg (funcall (quote Template)   "c2"  3  4 )  #|line 29|#))
    (setf  reg (funcall (quote register_component)   reg (funcall (quote Template)   "c3"  5  6 )  #|line 30|#))
    (format *standard-output* "~a" (dict-in?  "c2" (field "templates"  reg))) #|line 31|#
    (return-from test (dict-lookup  (field "templates"  reg)  "c2")) #|line 32|#) #|line 33|#
  )





