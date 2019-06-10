(provide `czq-scala)

(defun czq-scala-get-input-before-line ()
  (interactive)
  (save-excursion
     (call-interactively `set-mark-command)
     (beginning-of-line)
     (setq czq-scala-input-before-line (buffer-substring (region-beginning) (region-end)))
     (message czq-scala-input-before-line))
  (deactivate-mark))

(setq czq-scala-term-name "tscala")
(defun set-scala-term-name (name)
  (interactive "st(name):")
  (setq czq-scala-term-name (format "t%s" name))
  (message czq-scala-term-name)
  )

(defun czq-scala-import-current-file ()
  (interactive)
  (setq czq-scala-script-name (file-name-base (buffer-name)))
  (save-current-buffer
    (set-buffer czq-scala-term-name)
    (term-send-raw-string (format "import $file.%s\n" czq-scala-script-name))))
(setq scala-promp-pos 7)
(defun czq-scala-send-input-line-with-additional-string (s)
  (czq-scala-get-input-before-line)
  (save-current-buffer
    (set-buffer czq-scala-term-name)
    (term-send-raw-string "\C-a\C-k")
    (term-send-raw-string czq-scala-input-before-line)
    (term-send-raw-string s)
    ))
(defun czq-scala-send-input-line-with-tab ()
    (interactive)
  (czq-scala-send-input-line-with-additional-string "\t"))

(defun czq-scala-send-region-for-evaluation ()
  (interactive)
  (setq czq-scala-region (buffer-substring (region-beginning) (region-end)))
  (save-current-buffer
    (set-buffer czq-scala-term-name)
    (term-send-raw-string "\C-a\C-k")
    ;; (term-send-raw-string "{\n")
    (term-send-raw-string czq-scala-region)
    ;; (term-send-raw-string "\n}\n")
    (term-send-raw-string "\n")
    ))

   
(defun czq-scala-send-input-line-with-enter ()
  (interactive)
  (if (region-active-p)
      (czq-scala-send-region-for-evaluation)
    (progn
      (end-of-line)
     (czq-scala-send-input-line-with-additional-string "\n")))
  (next-line))



(defun define-scala-keys ()
  (interactive)
 (define-key scala-mode-map (kbd "C-x p") `czq-scala-send-input-line-with-tab)
 (define-key scala-mode-map (kbd "C-x C-e") `czq-scala-send-input-line-with-enter)
 (define-key scala-mode-map (kbd "C-c i") `czq-scala-import-current-file))

(add-to-list `auto-mode-alist `("\\.sc\\'" . scala-mode))


