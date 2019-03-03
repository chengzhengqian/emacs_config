(setenv "LD_LIBRARY_PATH"
  (let ((current (getenv "LD_LIBRARY_PATH"))
        (new "/home/chengzhengqian/cloud/guile2.2/lib"))
    (if current (concat new ":" current) new)))

