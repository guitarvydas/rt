

(defun gensym (s)
  (progn
    (let (name_with_id f"{s}{subscripted_digit (counter)}")
      (inc counter 1)
      
      (return-from gensym name_with_id)))
  )



