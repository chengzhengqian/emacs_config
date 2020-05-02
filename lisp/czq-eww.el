(provide `czq-eww)

(setq czq-eww-alt-text "")
(defun czq-shr-show-alt-text ()
  "Show the ALT text of the image under point and copy it "
  (interactive)
  (let ((text (get-text-property (point) 'shr-alt)))
    (if (not text)
	(message "No image under point")
      (progn
	(setq czq-eww-alt-text (shr-fill-text text))
	(kill-new czq-eww-alt-text )
	(message "%s" czq-eww-alt-text)
	))))

(defun define-czq-eww-keys ()
  (interactive)
  (define-key eww-mode-map (kbd "A") `czq-shr-show-alt-text)
)
