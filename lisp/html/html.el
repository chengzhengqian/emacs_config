(provide `html)

(defun insert-xml-tag (tag)
  (interactive "stag:")
  (insert (format "<%s></%s>" tag tag))
  (backward-char (+ (length tag) 3))
  )

(defun insert-jquery-empty-template ()
  (interactive)
  (insert "<!document html>\n<html>\n<head>\n<title></title>\n</head>\n<body>\n<script src=\"jquery.js\"></script>\n</body>\n</html>"
	  ))


(defun insert-javascript-function (name args)
  (interactive "sname:\nsargs:\n")
  (insert (format "function %s(%s){};" name args))
  (backward-char 2)
  )

(defun insert-html-link (name url)
  (interactive "sname:\nsurl:\n")
  (insert (format "<a href=\"%s\">%s</a>" url name)))

(defun define-html-czq-keys ()
  (interactive)
  (define-key html-mode-map (kbd "C-c C-i") `insert-html-code)

  )

(defun insert-html-code (code)
  (interactive "st(ag) j(query tmpl) c(anvas) s(cript) f(function) p(check javascript properties,o,f,n,s), a(link)")
  (cond ((string= code "a") (call-interactively `insert-html-link))
   ((string= code "t") (call-interactively `insert-xml-tag))
	((string= code "j") (call-interactively `insert-jquery-empty-template))
	((string= code "f") (call-interactively `insert-javascript-function))
	((string= code "c") (insert-xml-tag "canvas"))
	((string= code "s") (insert-xml-tag "script"))
	((string= code "p") (call-interactively `check-javascript-object-properties))
	((string= code "p") (call-interactively `check-javascript-object-properties))
	((string= code "pf") (progn
			       (setq czq-filter-javascript-type "function")
			       (call-interactively `check-javascript-object-properties-with-type)
			       ))
	((string= code "ps") (progn
			       (setq czq-filter-javascript-type "string")
			       (call-interactively `check-javascript-object-properties-with-type)
			       ))
	((string= code "pn") (progn
			       (setq czq-filter-javascript-type "number")
			       (call-interactively `check-javascript-object-properties-with-type)
			       ))
	((string= code "po") (progn
			       (setq czq-filter-javascript-type "object")
			       (call-interactively `check-javascript-object-properties-with-type)
			       ))
	))
