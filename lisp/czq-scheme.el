(provide `czq-scheme)

(defun  define-scheme-keys ()
  (interactive)
  (define-key scheme-mode-map (kbd "C-c i") `geiser-doc-symbol-at-point)
)



