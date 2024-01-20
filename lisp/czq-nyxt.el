;; we need to connect to the slime to lisp first

(defun czq-search-selected-in-nyxt ()
  (interactive "")
  (if (use-region-p)
	(setq czq-nyxt-search-content (buffer-substring (region-beginning) (region-end)))
	(setq czq-nyxt-search-content (thing-at-point 'symbol)))
  (czq-search-in-nyxt czq-nyxt-search-content)
  (message (format "search: %s" czq-nyxt-search-content))
  )




(setq czq-nyxt-google-search-pattern "(buffer-load (url \"http://www.google.com/search?q=%s+definition\"))")

(defun czq-search-in-nyxt (content)
  (with-current-buffer (get-buffer-create "*czq-slime*")
    (erase-buffer)
    (insert (format czq-nyxt-google-search-pattern content))
    (slime-eval-buffer)
    )
  )

(defun czq-nyxt-set-load-buffer-hook ()
  (interactive "")
  (with-current-buffer (find-file-noselect "~/share_workspace/nyxt/buffer-black-text.lisp")
  (slime-eval-buffer)))

(provide 'czq-nyxt)
