(provide `czq-gnuplot)
(defun gene-gnuplot ()
  (interactive)
  (save-buffer)
  (shell-command (format "gnuplot %s" (buffer-name))))

(defun define-czq-gnuplot-keys ()
  (interactive)
  (define-key gnuplot-mode-map (kbd "C-c p") `gene-gnuplot))
