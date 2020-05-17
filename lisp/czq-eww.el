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
	(message "text: %s" czq-eww-alt-text)
	))))

(defun czq-eww-write-image-url ()
  (with-temp-file "/home/chengzhengqian/cloud/eww_image_url"
    (progn (insert czq-image-url) (save-current-buffer))))

(setq czq-image-url "")
(defun czq-eww-get-image-url ()
    (interactive)
    (setq czq-image-url    (get-text-property (point) `image-url))    
    (czq-eww-write-image-url)
    (message "image: %s" czq-image-url)
  )
(defun define-czq-eww-keys ()
  (interactive)
  (define-key eww-mode-map (kbd "A") `czq-shr-show-alt-text)
  (define-key eww-mode-map (kbd "U") `czq-eww-get-image-url)
  (define-key eww-mode-map (kbd "=") `czq-increase-image-size-all-in-buffer)
  (define-key eww-mode-map (kbd "C-=") `czq-decrease-image-size-all-in-buffer)
)

(defun czq-has-image-at-point ()
  (interactive)
  (let ((czq-image (get-text-property (point) 'display)))
    (eq (car-safe czq-image) 'image)))
(setq czq-image-scale-rate 5)

(defun czq-increase-image-size-all-in-buffer ()
  (interactive)
  (save-excursion
    (progn
    (goto-char (point-min))
    (while (not (eobp)) (progn
		(if (czq-has-image-at-point)
		    (image-increase-size czq-image-scale-rate))
		(forward-line 1)
		)))))
(defun czq-decrease-image-size-all-in-buffer ()
  (interactive)
  (save-excursion
    (progn
    (goto-char (point-min))
    (while (not (eobp)) (progn
		(if (czq-has-image-at-point)
		    (image-decrease-size czq-image-scale-rate))
		(forward-line 1)
		)))))


;; (defun czq-eww-new (tag)
;;   (interactive "sTag:")
;;   (let ((url (read-from-minibuffer "Enter URL or keywords: ")))
;;     (switch-to-buffer (generate-new-buffer (format "*eww<%s>*" tag)))
;;     (eww-mode)
;;     (eww url)))
;; this is better implementation
(defun czq-eww-new (url)
  "Like `eww', but fetch URL in a new EWW buffer."
  (interactive (advice-eval-interactive-spec (cadr (interactive-form 'eww))))
  (let ((eww-suggest-uris (list (lambda () url))))
    (eww-open-in-new-buffer)))
