;; (defun A ( d)
;;  (cdr (assoc 'data d)))
(defun B ( d)
   (_assoc 'zzz (cdr (_assoc 'data d))))
;; (funcall (assoc 'zzz (cdr (assoc 'data d)))   "UTF_8"))
;;(defun srepr_datum_bytes ( d)
;; (funcall (cdr (assoc 'decode (cdr (assoc 'data  d))))   "UTF_8")))
