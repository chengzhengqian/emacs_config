(provide `czq-haskell)
(setq czq-haskell-term-name "thaskell")
;; the default path for ghci is pwd
(setq haskell-libs "-lLLVMWRAP -lLLVMDEBUG")
(setq haskell-libs "")
(defun set-czq-haskell-term-name (name)
  (interactive "st(name):")
  (make-local-variable `czq-haskell-term-name)
  (setq czq-haskell-term-name (format "t%s" name))
  (message czq-haskell-term-name)
  )

(defun insert-haskell-definition (name)
  (interactive "sname:")
  (insert (format "%s :: \n%s = \n" name name))
  (previous-line 2)
  (end-of-line)
  )

(setq czq-haskell-module-pattern "module %s\nwhere\n")
(defun insert-haskell-module ()
  (interactive)
  (setq czq-haskell-module-name (file-name-sans-extension (buffer-name)))
  (insert (format czq-haskell-module-pattern czq-haskell-module-name))
  )


(defun format-haskell-code ()
  (interactive)
  (save-buffer)
  (call-process "stylish-haskell" nil nil nil "-i" (buffer-name))
  (revert-buffer-no-confirm)
  (message "stylish-haskell format has formated code")
  )

(defun load-haskell-file ()
  (interactive)
  (setq current-haskell-file-name (buffer-name))
  (run-in-haskell ":quit")
  (sleep-for 0.1)
  (run-in-haskell (format "stack ghci --ghci-options \"-L`pwd` %s\"\n"  haskell-libs))
  (run-in-haskell (format ":load %s\n" current-haskell-file-name))
  )

(defun just-load-haskell-file ()
  (interactive)
  (setq current-haskell-file-name (buffer-name))
  (run-in-haskell (format ":load %s" current-haskell-file-name))
  )




(defun exec-selected-in-haskell (beginning end)
  (interactive "r")
  (if (use-region-p)   (setq haskell-command (buffer-substring beginning end)) 
    (setq haskell-command (thing-at-point `symbol))
      )
  (run-in-haskell haskell-command))

(defun get-info-selected-in-haskell (beginning end)
  (interactive "r")
  (if (use-region-p)   (setq haskell-command (buffer-substring beginning end)) 
    (setq haskell-command (thing-at-point `symbol))
      )
  (run-in-haskell (format ":info %s "haskell-command)))


(defun run-in-haskell (command)
  (interactive "scommand:")
  (save-current-buffer
      (set-buffer czq-haskell-term-name)
      (term-send-raw-string (format "%s\n" command))
      ))


(defun define-haskell-keys ()
  (interactive)
  (define-key haskell-mode-map (kbd "C-x C-r") `load-haskell-file)
  (define-key haskell-mode-map (kbd "C-c i") `just-load-haskell-file)
  (define-key haskell-mode-map (kbd "C-x C-l") `just-load-haskell-file)
  (define-key haskell-mode-map (kbd "C-c C-l") `just-load-haskell-file)
  (define-key haskell-mode-map (kbd "C-x C-e") `exec-selected-in-haskell)
  (define-key haskell-mode-map (kbd "C-c p") `czq-haskell-send-input-line-with-tab)
  )

(add-hook `haskell-mode-hook `define-haskell-interactive-key)
(setq czq-haskel-foreign-call-format "foreign import ccall \"%s\" %s::IO()")
(defun insert-foreign-call (name)
  (interactive "sname")
  (insert (format czq-haskel-foreign-call-format name name))
  )

(defun czq-haskell-get-input-before-line ()
  (interactive)
  (save-excursion
     (call-interactively `set-mark-command)
     (beginning-of-line)
     (setq czq-haskell-input-before-line (buffer-substring (region-beginning) (region-end)))
     (message czq-haskell-input-before-line))
  (deactivate-mark))

(defun czq-haskell-send-input-line-with-additional-string (s)
  (czq-haskell-get-input-before-line)
  (save-current-buffer
    (set-buffer czq-haskell-term-name)
    (term-send-raw-string "\C-a\C-k")
    (term-send-raw-string czq-haskell-input-before-line)
    (term-send-raw-string s)
    ))


(defun czq-haskell-send-input-line-with-tab ()
    (interactive)
  (czq-haskell-send-input-line-with-additional-string "\t"))
