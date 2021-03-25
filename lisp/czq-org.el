(provide `czq-org)

(defun czq-org-large-latex-preview ()
  (interactive)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.5))
  (setq org-format-latex-options (plist-put org-format-latex-options :foreground "Black"))
  (setq org-format-latex-options (plist-put org-format-latex-options :background "White")))

(defun czq-org-normal-latex-preview ()
  ;; this is for carta display
  (interactive)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))
  (setq org-format-latex-options (plist-put org-format-latex-options :foreground "Black"))
  (setq org-format-latex-options (plist-put org-format-latex-options :background "White")))

(defun extract-formula-from-latex-preview-in-org ()
  (interactive)
  (save-excursion 
    (org-toggle-latex-fragment)
    (re-search-forward "\\\\begin{equation\\*}.*\\(\\(\n.*\\)*\\)\\\\end{equation\\*}")
    (setq czq-org-latex-string (match-string 1))
    (kill-new czq-org-latex-string ))
  (org-toggle-latex-fragment)
  (message (format "copy the formulas to clipboard with  %d characters " (length czq-org-latex-string)))
)

(defun define-org-keys ()
  (interactive)
  (define-key org-mode-map (kbd "C-x C-e") `extract-formula-from-latex-preview-in-org))
