(provide `czq-sql)
(setq sql-term-name "tsql")

(setq sql-term-name "tsql")
(defun set-sql-term-name ()
  (interactive "")
  (make-local-variable `sql-term-name)
  ;; (setq sql-term-name (format "t%s" name))
  (czq-get-terminal-list)
  (setq sql-term-name   (completing-read "set sql term as: " czq-terminal-list))
  (message sql-term-name)
  )

(defun show-sql-term-name ()
  (interactive)
  (message (format "current term %s" sql-term-name)))

(defun exec-selected-in-sql ()
  (interactive "")
  (if (use-region-p)
      (progn
	(setq sql-command (buffer-substring (region-beginning) (region-end)))
	(run-in-sql-block-code sql-command)) 
    (progn
      (setq sql-command (thing-at-point `line))
      (run-in-sql sql-command))))
;; (setq sql-command  (replace-regexp-in-string "    " "" sql-command))
;; this is not working propertly, it seems isql now support directly paste?

(defun run-in-sql-block-code (command)
  (interactive "scommand")
  (run-in-sql sql-command)
  ;; (run-in-sql "\n")			;it seems we need this sometimes 
)


(setq czq-sql-term-frame-name "acer")
(defun run-in-sql (command)
  (interactive "scommand:")

  (save-current-buffer
    (progn
      (set-buffer sql-term-name)
      (term-send-raw-string (format "%s\n" command))))
    (let ((term-name sql-term-name))
    (if  (czq-get-frame czq-sql-term-frame-name)
	(with-selected-frame (czq-get-frame czq-sql-term-frame-name)
	   (switch-to-buffer term-name))))

  )


(defun  define-sql-keys ()
  (interactive)
  (define-key sql-mode-map (kbd "C-x C-e") `exec-selected-in-sql)
  (define-key sql-mode-map (kbd "C-c t") `set-sql-term-name)
  ;; (define-key sql-mode-map (kbd "C-c C-p") `czq-sql-autocomplete-new)
  ;; (define-key elpy-mode-map (kbd "C-c C-p") `czq-sql-autocomplete-new)
  ;; (define-key elpy-mode-map (kbd "C-c C-o") `czq-run-sql-client-import)
  ;; (define-key sql-mode-map (kbd "C-c i") `import-sql-file)
  ;; (define-key sql-mode-map (kbd "C-c s") `czq-sql-switch)
  ;; (define-key sql-mode-map (kbd "C-c c") `czq-sql-change-directory)
)

;; (setq czq-sql-client-load "import sys; sys.path.append(\"/home/chengzhengqian/.emacs.d/lisp/server/\"); from czq_server_sql_client import autocompleteInEmacs")

;; (defun czq-run-sql-client-import ()
;;   (interactive)
;;   (run-in-sql czq-sql-client-load))
;; ;;we extent it some common case
;; (defun czq-switch-to (old new)
;;   (interactive "sold:\nsnew")
;;   (setq czq-old-buffer-name (buffer-name))
;;   (setq czq-new-buffer-name (replace-regexp-in-string old new czq-old-buffer-name))
;;   (find-file czq-new-buffer-name)
;;   )
;; (defun czq-sql-to-gene ()
;;   (interactive)
;;   (czq-switch-to "plot\\.py" "gene.py")
;;   )
;; (defun czq-sql-to-plot ()
;;   (interactive)
;;   (czq-switch-to "gene\\.py" "plot.py")
;;   )

;; (defun czq-sql-switch (target)
;;   (interactive "starget(p,g):")
;;   (cond
;;    ((string= target "p") (czq-sql-to-plot))
;;    ((string= target "g") (czq-sql-to-gene))
;;    ))


;; (defun czq-sql-autocomplete-new ()
;;   (interactive)
;;   (run-in-sql "autocompleteInEmacs(globals())")
;;   )
