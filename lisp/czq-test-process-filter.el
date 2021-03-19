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


;; we assume we only use this function for a given terminal one times

(defun czq-store-default-filter-and-process-for-given-buffer (name)
  (setq czq-stored-process  (get-buffer-process (get-buffer name)))
  (fset `czq-stored-buffer-process-filter
	(process-filter czq-stored-process ))
  )

(czq-store-default-filter-and-process-for-given-buffer "trun")
(set-process-filter czq-stored-process `czq-filter-hide-input)
(set-process-filter czq-stored-process `czq-stored-buffer-process-filter)
(set-process-filter (get-buffer-process (get-buffer "tjulia")) `czq-stored-buffer-process-filter)
(set-process-filter (get-buffer-process (get-buffer "tjulia")) `term-emulate-terminal)
(process-filter (get-buffer-process (get-buffer "trun")))


(defun czq-filter-hide-input (process output)
  (message output)
)

(czq-send-string-term "tjulia" "function test1(x,y)\nx+y\nend")

