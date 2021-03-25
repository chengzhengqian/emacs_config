(provide `czq-imenu-list)

;; use imenu list
(global-set-key (kbd "C-'") `imenu-list-smart-toggle)
(global-set-key (kbd "C-c C-j") `czq-imenu-list-goto-entry)
(setq imenu-list-size 0.3)

;; patch the imenu update list so it can works with multiple frames
;; (defun imenu-list--show-current-entry ()
;;   "Move the imenu-list buffer's point to the current position's entry."
;;   (setq czq-has-ilist-in-this-frame (get-buffer-window (imenu-list-get-buffer-create)))
;;   (when t
;;     (let ((line-number (cl-position (imenu-list--current-entry)
;;                                     imenu-list--line-entries
;;                                     :test 'equal)))
;;       (if czq-has-ilist-in-this-frame
;;        (with-selected-window  (get-buffer-window (imenu-list-get-buffer-create))
;;          (goto-char (point-min))
;;          (forward-line line-number)
;;          (hl-line-mode 1))
;;        (with-current-buffer  (imenu-list-get-buffer-create)
;;          (goto-char (point-min))
;;          (forward-line line-number)
;;          (hl-line-mode 1))
;;       ))))

;; we have better solution


(defun czq-imenu-list--find-entry (line-number)
  "Find in `imenu-list--line-entries' the entry in the current line."
  (nth (1- line-number) imenu-list--line-entries))

(defun czq-imenu-list-goto-entry (line-number)
  "Switch to the original buffer and display the entry under point."
  (interactive "nEntry:")
  (let ((entry (czq-imenu-list--find-entry line-number)))
    (imenu entry)
    (run-hooks 'imenu-list-after-jump-hook)
    (imenu-list--show-current-entry)))

;;  this is the orginal implement; there are some problem in calculating the line number when use with wit-selected-frame

(defun czq-imenu-list--show-current-entry-old (line-number)
  "Move the imenu-list buffer's point to the current position's entry."
  (when (get-buffer-window (imenu-list-get-buffer-create))
      (with-selected-window (get-buffer-window (imenu-list-get-buffer-create))
	;; (message (format "czq %d" line-number ))
        (goto-char (point-min))
        (forward-line line-number)
        (hl-line-mode 1))))

;; the patched implement
(defun czq-imenu-list--show-current-entry ()
  "Move the imenu-list buffer's point to the current position's entry."
  (setq czq-imenu-line-number  (cl-position (imenu-list--current-entry)
					    imenu-list--line-entries
					    :test 'equal))
  (dolist (frame (frame-list))
    (with-selected-frame frame
      (czq-imenu-list--show-current-entry-old czq-imenu-line-number)
      )))
(defun czq-patch-imenu-list ()
  (fset `imenu-list--show-current-entry `czq-imenu-list--show-current-entry))
