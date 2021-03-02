;; another possible is to use hinit
(setq czq-haskell-process  (get-buffer-process (get-buffer "thaskell")))
(fset `czq-haskell-buffer-process-filter
      (process-filter czq-haskell-process ))

(czq-haskell-buffer-process-filter  czq-haskell-process "good\n")

(setq czq-haskell-info-buffer (get-buffer-create "*czq-haskell-info*"))

(defun save-output-haskell-info (process output)
  (with-current-buffer czq-haskell-info-buffer
    (progn (end-of-buffer)
	    (insert output))))

(set-process-filter czq-haskell-process `save-output-haskell-info)
(set-process-filter czq-haskell-process `czq-haskell-buffer-process-filter)




