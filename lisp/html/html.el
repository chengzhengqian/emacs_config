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
