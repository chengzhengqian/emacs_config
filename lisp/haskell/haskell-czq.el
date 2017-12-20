(provide `haskell-czq)

(defun insert-haskell-definition (name)
  (interactive "sname:")
  (insert (format "%s :: \n%s = \n" name name))
  (previous-line 2)
  (end-of-line)
  )


