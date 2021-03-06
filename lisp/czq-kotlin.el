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
(setq czq-kotlin-plugin-path "/home/chengzhengqian/share_workspace/kotlin/emacs_plugin/")

(setq czq-kotlin-reflection-path (format "%s/%s" czq-kotlin-plugin-path "czqKotlinReflection.kt"))
(setq czq-kotlin-server-path (format "%s/%s" czq-kotlin-plugin-path "czqKotlinServer.kt"))

      
(defun kotlin-load-server-etc ()
  (interactive)
  (run-in-kotlin (format ":load %s"czq-kotlin-server-path ))
  (run-in-kotlin (format ":load %s"czq-kotlin-reflection-path ))
  )

(defun set-kotlin-term-name (name)
  (interactive "st(name):")
  (make-local-variable `kotlin-term-name)
  (setq kotlin-term-name (format "t%s" name))
  (message kotlin-term-name)
  )

(defun show-kotlin-term-name ()
  (interactive)
  (message (format "current term %s" kotlin-term-name)))

(setq czq-kotlin-query-method  "methodStartsWith(%s::class.java,\"%s\")" )

(defun kotlin-completion-for-region (beginning end)
  (interactive "r")
  (get-region-or-statement-for-kotlin)
  (setq czq-kotlin-completion-targets (split-string kotlin-command "\\."))
  (setq czq-kotlin-obj(nth 0 czq-kotlin-completion-targets))
  (setq czq-kotlin-name (nth 1 czq-kotlin-completion-targets))
  (empty-kotlin-output)
  (run-in-kotlin (format czq-kotlin-query-method czq-kotlin-obj czq-kotlin-name))
  (setq czq-kotlin-str (thing-at-point `symbol))
  (message (format "get: %s" czq-kotlin-obj))
  (sleep-for 0.8)
  (setq czq-kotlin-complete (popup-menu* (split-string (get-kotlin-output))))
  (insert (substring czq-kotlin-complete (length czq-kotlin-str)))
  )


;; (defun kotlin-completion-for-region-for-field (beginning end)
;;   (interactive "r")
;;   (get-region-or-symbol-for-koltin)
;;   (setq czq-kotlin-completion-targets (split-string kotlin-command "\\."))
;;   (setq czq-kotlin-obj(nth 0 czq-kotlin-completion-targets))
;;   (setq czq-kotlin-name (nth 1 czq-kotlin-completion-targets))
;;   (run-in-kotlin (format "fieldStartsWith(%s,\"%s\")" czq-kotlin-obj czq-kotlin-name)))

(defun get-region-or-default-for-koltin ()
    (if (use-region-p)   (setq kotlin-command (buffer-substring beginning end)) 
    (setq kotlin-command (thing-at-point `line))
    ))

(defun get-region-or-symbol-for-koltin ()
  (if (use-region-p)   (setq kotlin-command (buffer-substring beginning end)) 
    (setq kotlin-command (thing-at-point `symbol))
    ))

;;  match  Adf.asdf
;;  match  Adf.
;;  match  Adfdf


(defun get-statement-for-kotlin ()
  (interactive)
  (save-excursion
    (setq czq-kotlin-end (point))
    (setq czq-kotlin-char-before (char-before (point)))
    (if (not (= czq-kotlin-char-before ?. ))
	(backward-word))
    (setq czq-kotlin-char-before (char-before (point)))
    (if  (= czq-kotlin-char-before ?. )
	(backward-word))
    (setq czq-kotlin-start (point)))
  (buffer-substring czq-kotlin-start czq-kotlin-end)
  )



(defun get-region-or-statement-for-kotlin ()
  (interactive)
  (if (use-region-p)   (setq kotlin-command (buffer-substring beginning end)) 
    (setq kotlin-command (get-statement-for-kotlin))
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

;; (setq czq-kotlin-function-pattern "def \\(.*\\):\n")
;; (defun exec-function-in-kotlin ()
;;   (interactive )
;;   (save-excursion
;;     (progn
;;     (search-backward-regexp czq-kotlin-function-pattern)
;;     (setq kotlin-command (match-string 1))
;;     (setq kotlin-current-module-name (file-name-base (buffer-name)))  
;;     (run-in-kotlin (format "%s" kotlin-command)))))

;; ;; (defun czq-kotlin-change-directory ()
;; ;;   (interactive)
;; ;;   (setq czq-kotlin-current-directory (buffer-file-name))
;; ;;   (run-in-kotlin ))

(defun  define-kotlin-keys ()
  (interactive)
  (define-key kotlin-mode-map (kbd "C-x C-e") `exec-selected-in-kotlin)
  ;; (define-key kotlin-mode-map (kbd "C-c r") `kotlin-load-reflection)
  (define-key kotlin-mode-map (kbd "C-c t") `set-kotlin-term-name)
  (define-key kotlin-mode-map (kbd "C-c i") `import-kotlin-file)
  ;; (define-key kotlin-mode-map (kbd "C-c m") `kotlin-completion-for-region)
  ;; (define-key kotlin-mode-map (kbd "C-c o") `kotlin-completion-for-region-for-field)
  (define-key kotlin-mode-map (kbd "C-c p") `kotlin-completion-for-region)
  ;; (define-key kotlin-mode-map (kbd "C-c c") `czq-kotlin-change-directory)
)
(add-to-list `load-path "~/.emacs.d/lisp/kotlin")
(require `kotlin-client)

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
