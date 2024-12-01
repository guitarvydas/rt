
(jarray 
  (list 
    (obj 
      (list 
	("file" . "scanner.drawio") 
	("name" . "main")
	("children" . 
	  (jarray 
	    (list 
	      (obj 
		(list 
		  ("name" . "Delay") 
		  ("id" . 4))) 
	      (obj 
		(list 
		  ("name" . "Larson") 
		  ("id" . 7))))))
	("connections" . 
	  (jarray 
	    (list 
	      (obj 
		(list 
		  ("dir" . 0) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "") 
			("id" . 0))))
		  ("source_port" . "")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Larson") 
			("id" . 7))))
		  ("target_port" . "tick"))) 
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Delay") 
			("id" . 4))))
		  ("source_port" . "")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Larson") 
			("id" . 7))))
		  ("target_port" . "tick")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Larson") 
			("id" . 7))))
		  ("source_port" . "")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Delay") 
			("id" . 4))))
		  ("target_port" . "")))))))) 
    (obj 
      (list 
	("file" . "scanner.drawio") 
	("name" . "Larson")
	("children" . 
	  (jarray 
	    (list 
	      (obj 
		(list 
		  ("name" . "Count") 
		  ("id" . 4))) 
	      (obj 
		(list 
		  ("name" . "Reverser") 
		  ("id" . 8)))
	      (obj 
		(list 
		  ("name" . "Decode") 
		  ("id" . 13)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 26)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 28)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 29)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 32)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 34)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 36)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 38)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 40)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 42)))
	      (obj 
		(list 
		  ("name" . "@") 
		  ("id" . 44))))))
	("connections" . 
	  (jarray 
	    (list 
	      (obj 
		(list 
		  ("dir" . 0) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "") 
			("id" . 0))))
		  ("source_port" . "tick")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Count") 
			("id" . 4))))
		  ("target_port" . "adv"))) 
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Count") 
			("id" . 4))))
		  ("source_port" . "")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("target_port" . "N")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "7")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 34))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "8")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 32))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "9")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 29))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "9")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Reverser") 
			("id" . 8))))
		  ("target_port" . "K")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "0")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Reverser") 
			("id" . 8))))
		  ("target_port" . "J")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "5")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 38))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Reverser") 
			("id" . 8))))
		  ("source_port" . "")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "Count") 
			("id" . 4))))
		  ("target_port" . "rev")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "0")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 40))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "1")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 44))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "2")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 42))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "3")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 28))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "4")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 26))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 1) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "6")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "@") 
			("id" . 36))))
		  ("target_port" . "")))
	      (obj 
		(list 
		  ("dir" . 2) 
		  ("source" . 
		    (obj 
		      (list 
			("name" . "Decode") 
			("id" . 13))))
		  ("source_port" . "done")
		  ("target" . 
		    (obj 
		      (list 
			("name" . "") 
			("id" . 0))))
		  ("target_port" . ""))))))))))
