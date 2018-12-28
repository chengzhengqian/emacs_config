(provide `czq-nodejs)

(defun czq-nodejs-get-input-before-line ()
  (interactive)
  (save-excursion
     (call-interactively `set-mark-command)
     (beginning-of-line)
     (setq czq-nodejs-input-before-line (buffer-substring (region-beginning) (region-end)))
     (message czq-nodejs-input-before-line))
  (deactivate-mark))

(setq czq-nodejs-term-name "tnodejs")
(defun set-nodejs-term-name (name)
  (interactive "st(name):")
  (setq czq-nodejs-term-name (format "t%s" name))
  (message czq-nodejs-term-name)
  )

(setq nodejs-promp-pos 7)
(defun czq-nodejs-send-input-line-with-additional-string (s)
  (czq-nodejs-get-input-before-line)
  (save-current-buffer
    (set-buffer czq-nodejs-term-name)
    (term-send-raw-string "\C-a\C-k")
    (term-send-raw-string czq-nodejs-input-before-line)
    (term-send-raw-string s)
    ))
(defun czq-nodejs-send-input-line-with-tab ()
    (interactive)
  (czq-nodejs-send-input-line-with-additional-string "\t"))

(defun czq-nodejs-send-region-for-evaluation ()
  (interactive)
  (setq czq-nodejs-region (buffer-substring (region-beginning) (region-end)))
  (save-current-buffer
    (set-buffer czq-nodejs-term-name)
    (term-send-raw-string "\C-a\C-k")
    (term-send-raw-string "{\n")
    (term-send-raw-string czq-nodejs-region)
    (term-send-raw-string "\n}\n")
    ))

   
(defun czq-nodejs-send-input-line-with-enter ()
  (interactive)
  (if (region-active-p)
      (czq-nodejs-send-region-for-evaluation)
    (progn
      (end-of-line)
     (czq-nodejs-send-input-line-with-additional-string "\n")))
  (next-line))



(defun define-nodejs-keys ()
  (interactive)
 (define-key js2-mode-map (kbd "C-x p") `czq-nodejs-send-input-line-with-tab)
 (define-key js2-mode-map (kbd "C-x C-e") `czq-nodejs-send-input-line-with-enter)
 )

(defun js-comint-send-last-sexp ()
  (interactive)
  (czq-nodejs-send-input-line-with-enter))
