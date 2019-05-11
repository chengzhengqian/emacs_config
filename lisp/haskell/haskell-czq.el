(provide `haskell-czq)
(setq haskell-term-name "thaskell")
;; the default path for ghci is pwd
(setq haskell-libs "-lLLVMWRAP -lLLVMDEBUG")
(setq haskell-libs "")
(defun set-haskell-term-name (name)
  (interactive "st(name):")
  (setq haskell-term-name (format "t%s" name))
  (message haskell-term-name)
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
  (save-excursion
   (save-window-excursion
     (progn
       (switch-to-buffer haskell-term-name)
       (term-send-raw-string ":quit\n")
       (sleep-for 0.1)
       (term-send-raw-string (format "stack ghci --ghci-options \"-L`pwd` %s\"\n"  haskell-libs))
       (term-send-raw-string (format ":load %s\n" current-haskell-file-name))))
   )
  )

(defun just-load-haskell-file ()
  (interactive)
  (setq current-haskell-file-name (buffer-name))
  (save-excursion
   (save-window-excursion
     (progn
       (switch-to-buffer haskell-term-name)
       ;; (term-send-raw-string ":quit\n")
       ;; (sleep-for 0.1)
       ;; (term-send-raw-string (format "stack ghci --ghci-options \"-L`pwd` %s\"\n"  haskell-libs))
       (term-send-raw-string (format ":load %s\n" current-haskell-file-name))))
   )
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
  (save-window-excursion
    (progn
      (switch-to-buffer haskell-term-name)
      (term-send-raw-string (format "%s\n" command))
      )))


(defun define-haskell-interactive-key ()
  (interactive)
  (define-key haskell-mode-map (kbd "C-x C-r") `load-haskell-file)
  (define-key haskell-mode-map (kbd "C-c i") `just-load-haskell-file)
  (define-key haskell-mode-map (kbd "C-x C-l") `just-load-haskell-file)
  (define-key haskell-mode-map (kbd "C-c C-l") `just-load-haskell-file)
  (define-key haskell-mode-map (kbd "C-x C-e") `exec-selected-in-haskell)
  (define-key haskell-mode-map (kbd "C-c C-i") `get-info-selected-in-haskell)
  )

(add-hook `haskell-mode-hook `define-haskell-interactive-key)
(setq czq-haskel-foreign-call-format "foreign import ccall \"%s\" %s::IO()")
(defun insert-foreign-call (name)
  (interactive "sname")
  (insert (format czq-haskel-foreign-call-format name name))
  )
