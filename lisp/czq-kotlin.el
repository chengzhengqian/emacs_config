(provide `czq-kotlin)
(setq kotlin-term-name "tkotlin")
(defun import-kotlin-file ()
  (interactive)
  (setq current-kotlin-file (buffer-file-name))
  (run-in-kotlin (format ":load %s" current-kotlin-file))
  )

(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

;; (defun kotlin-load-reflection ()
;;   (interactive)
;;   (run-in-kotlin (get-string-from-file "/home/chengzhengqian/.emacs.d/lisp/czq_kotlin_reflection.kt")))
(setq czq-kotlin-reflection-path "/home/chengzhengqian/share_workspace/kotlin/emacs_plugin/czq_kotlin_reflection.kt")
(defun kotlin-load-reflection ()
  (interactive)
  (run-in-kotlin (format ":load %s"czq-kotlin-reflection-path )))

(defun set-kotlin-term-name (name)
  (interactive "st(name):")
  (make-local-variable `kotlin-term-name)
  (setq kotlin-term-name (format "t%s" name))
  (message kotlin-term-name)
  )

(defun show-kotlin-term-name ()
  (interactive)
  (message (format "current term %s" kotlin-term-name)))

(defun kotlin-completion-for-region (beginning end)
  (interactive "r")
  (get-region-or-default-for-koltin)
  (setq czq-kotlin-completion-targets (split-string kotlin-command "\\."))
  (setq czq-kotlin-obj(nth 0 czq-kotlin-completion-targets))
  (setq czq-kotlin-name (nth 1 czq-kotlin-completion-targets))
  (run-in-kotlin (format "methodStartsWith(%s,\"%s\")" czq-kotlin-obj czq-kotlin-name)))

(defun get-region-or-default-for-koltin ()
    (if (use-region-p)   (setq kotlin-command (buffer-substring beginning end)) 
    (setq kotlin-command (thing-at-point `symbol))
    ))
(defun exec-selected-in-kotlin (beginning end)
  (interactive "r")
  (get-region-or-default-for-koltin)
  (setq kotlin-command  (replace-regexp-in-string "    " "" kotlin-command))
  (run-in-kotlin kotlin-command)
  )

(defun exec-selected-in-kotlin-with-module (beginning end)
  (interactive "r")
  (setq kotlin-current-module-name (file-name-base (buffer-name)))
  (if (use-region-p)   (setq kotlin-command (buffer-substring beginning end)) 
    (setq kotlin-command (thing-at-point `symbol))
      )
  (run-in-kotlin (format "%s.%s" kotlin-current-module-name kotlin-command))
  )

(defun run-in-kotlin (command)
  (interactive "scommand:")

  (save-current-buffer
    (progn
      (set-buffer kotlin-term-name)
      (term-send-raw-string (format "%s\n" command)))
    ))

(setq czq-kotlin-function-pattern "def \\(.*\\):\n")
(defun exec-function-in-kotlin ()
  (interactive )
  (save-excursion
    (progn
    (search-backward-regexp czq-kotlin-function-pattern)
    (setq kotlin-command (match-string 1))
    (setq kotlin-current-module-name (file-name-base (buffer-name)))  
    (run-in-kotlin (format "%s" kotlin-command)))))

(defun czq-kotlin-change-directory ()
  (interactive)
  (setq czq-kotlin-current-directory (buffer-file-name))
  (run-in-kotlin ))
(defun  define-kotlin-keys ()
  (interactive)
  (define-key kotlin-mode-map (kbd "C-x C-e") `exec-selected-in-kotlin)
  (define-key kotlin-mode-map (kbd "C-c r") `kotlin-load-reflection)
  (define-key kotlin-mode-map (kbd "C-c t") `set-kotlin-term-name)
  (define-key kotlin-mode-map (kbd "C-c i") `import-kotlin-file)
  (define-key kotlin-mode-map (kbd "C-c m") `kotlin-completion-for-region)
  (define-key kotlin-mode-map (kbd "C-c c") `czq-kotlin-change-directory)
)


;;we extent it some common case
;; (defun czq-switch-to (old new)
;;   (interactive "sold:\nsnew")
;;   (setq czq-old-buffer-name (buffer-name))
;;   (setq czq-new-buffer-name (replace-regexp-in-string old new czq-old-buffer-name))
;;   (find-file czq-new-buffer-name)
;;   )

;; (defun czq-kotlin-to-gene ()
;;   (interactive)
;;   (czq-switch-to "plot\\.py" "gene.py")
;;   )
;; (defun czq-kotlin-to-plot ()
;;   (interactive)
;;   (czq-switch-to "gene\\.py" "plot.py")
;;   )

;; (defun czq-kotlin-switch (target)
;;   (interactive "starget(p,g):")
;;   (cond
;;    ((string= target "p") (czq-kotlin-to-plot))
;;    ((string= target "g") (czq-kotlin-to-gene))
;;    ))
