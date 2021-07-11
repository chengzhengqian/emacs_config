(setq czq-frame-list `())

(add-to-list `czq-frame-list `("w530" . ,(selected-frame)))



(defun czq-add-to-framelist (name)
  (add-to-list `czq-frame-list `(,name . ,(selected-frame))))

(defun czq-get-frame (name)
 (cdr (assoc name czq-frame-list)))

(defun czq-get-buffer (name)
  (with-selected-frame (czq-get-frame name)
    (window-buffer)))

(defun czq-get-line-number (name)
  (with-selected-frame (czq-get-frame name)
    (line-number-at-pos)))

(defun czq-switch-to-buffer (framename buffer)
  (with-selected-frame (czq-get-frame framename)
    (switch-to-buffer buffer)
    ))

(defun czq-goto-line (framename line)
  (with-selected-frame (czq-get-frame framename)
    (with-selected-window (selected-window)
      (goto-line line)
      (recenter-top-bottom))
    ))

(defun czq-switch-two-frame (name1 name2)
  (setq czq-buffer-1 (czq-get-buffer name1))
  (setq czq-buffer-2 (czq-get-buffer name2))
  (setq czq-line-number-1 (czq-get-line-number name1))
  (setq czq-line-number-2 (czq-get-line-number name2))
  (czq-switch-to-buffer name1 czq-buffer-2)
  (czq-goto-line name1 czq-line-number-2)
  (czq-switch-to-buffer name2 czq-buffer-1)
  (czq-goto-line name2 czq-line-number-1)
  )

(defun czq-find-frame-name (frame)
  (car (rassoc frame czq-frame-list)))

(defun czq-alist-keys (alist)
  (mapcar 'car alist))

(defun czq-switch-with-other-frame ()
  (interactive)
  (setq czq-current-frame-name (czq-find-frame-name (selected-frame)))
  (setq czq-other-frame-name (completing-read (format "%s <-> :" czq-current-frame-name) (delete czq-current-frame-name (czq-alist-keys czq-frame-list))))
  (czq-switch-two-frame czq-current-frame-name czq-other-frame-name)
  )


  
;; (czq-alist-keys czq-frame-list)
(provide `czq-switch-frame)
