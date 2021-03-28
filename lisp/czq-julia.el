(provide `czq-julia)
(setq julia-term-name "tjulia")
(defun import-julia-file ()
  (interactive)
  (save-buffer)
  (setq current-julia-file (buffer-file-name))
  (run-in-julia (format "include(\"%s\")" current-julia-file))
  )
(defun set-julia-term-name (name)
  (interactive "st(name):")
  (make-local-variable `julia-term-name)
  (setq julia-term-name (format "t%s" name))
  (message julia-term-name)
  )
(defun show-julia-term-name ()
  (interactive)
  (message (format "current term %s" julia-term-name)))

;; (defun exec-selected-in-julia (beginning end)
;;   (interactive "r")
;;   (if (use-region-p)   (setq julia-command (buffer-substring beginning end)) 
;;     (setq julia-command (thing-at-point `symbol))
;;       )
;;   (run-in-julia julia-command)
;;   )

;; update the method so it works when the region is not set
(defun exec-selected-in-julia ()
  (interactive "")
  (if (use-region-p)
  ;; (setq julia-current-module-name (file-name-base (buffer-name)))
      (exec-selected-in-julia-with-wrap (region-beginning) (region-end)  "%s")
           (exec-selected-in-julia-with-wrap (line-beginning-position) (line-end-position)  "%s")))

(defun get-methods-selected-in-julia (beginning end)
  (interactive "r")
  (if (use-region-p)
  ;; (setq julia-current-module-name (file-name-base (buffer-name)))
      (exec-selected-in-julia-with-wrap beginning end  "methods(%s)")
    (run-in-julia (format "methods(%s)"(thing-at-point 'symbol) ))
          ))

(defun find-doc--selected-in-julia (beginning end)
  (interactive "r")
  ;; (setq julia-current-module-name (file-name-base (buffer-name)))
  (if (use-region-p)
      (exec-selected-in-julia-with-wrap beginning end  "?%s")
    (run-in-julia (format "?%s" (thing-at-point `symbol)))
    ))

(defun exec-selected-in-julia-with-less (beginning end)
  (interactive "r")
  ;; (setq julia-current-module-name (file-name-base (buffer-name)))
  (exec-selected-in-julia-with-wrap beginning end  "@less %s"))

(defun exec-selected-in-julia-with-wrap (beginning end pattern)
  (setq julia-command (buffer-substring beginning end))
  (setq julia-command (replace-regexp-in-string "    " "" julia-command))
  (run-in-julia (format pattern  julia-command)))

(defun run-in-julia (command)
  (interactive "scommand:")
  (save-current-buffer
    (progn
      (set-buffer julia-term-name)
      (term-send-raw-string (format "%s\n" command))
      )))

(defun cd-to-directory-of-current-file-in-julia ()
  (interactive)
  (run-in-julia (format "cd(\"%s\")" default-directory)))

(setq czq-julia-function-pattern "function \\(.*\\)\n")
(defun exec-function-in-julia ()
  (interactive )
  (save-excursion
    (progn
    (search-backward-regexp czq-julia-function-pattern)
    (setq julia-command (match-string 1))
    ;; (setq julia-current-module-name (file-name-base (buffer-name)))  
    (run-in-julia (format "%s"  julia-command)))))

(defun get-information-in-julia-for-selected  (beginning end)
  (interactive "r")
  (exec-selected-in-julia-with-wrap beginning end  "?%s"))

(defun  define-julia-keys ()
  (interactive)
  (define-key julia-mode-map (kbd "C-x C-e") `exec-selected-in-julia)
  (define-key julia-mode-map (kbd "C-x C-i") `get-information-in-julia-for-selected)
  (define-key julia-mode-map (kbd "C-x C-r") `exec-function-in-julia)
  (define-key julia-mode-map (kbd "C-c t") `set-julia-term-name)
  (define-key julia-mode-map (kbd "C-c i") `import-julia-file)
  ;; (define-key julia-mode-map (kbd "C-c C-i") `julia-insert-snippet)
  ;; (define-key julia-mode-map (kbd "C-x j") `julia-insert-snippet)
  (define-key julia-mode-map (kbd "C-c C-i") `eldoc-print-current-symbol-info)
  (define-key julia-mode-map (kbd "C-c c") `cd-to-directory-of-current-file-in-julia)
  (define-key julia-mode-map (kbd "C-c C-m") `get-methods-selected-in-julia)
  (define-key julia-mode-map (kbd "C-c d") `find-doc--selected-in-julia)
  (define-key julia-mode-map (kbd "C-c p") `czq-julia-autocomplete-new)
  (define-key julia-mode-map (kbd "C-c C-p") `czq-julia-autocomplete-new)
  (define-key julia-mode-map (kbd "C-c C-o") `czq-julia-client-options)
  (define-key julia-mode-map (kbd "C-c u") `czq-julia-update-imported-module)
  )

(defun julia-insert-snippet (tag)
  (interactive "st(test) d(oc)")
  (cond
   ((string= tag "t") (progn (insert "@test ==") (backward-char 2)))
   ((string= tag "d") (progn (insert "\"\"\"\n\n\"\"\"") (previous-line) (beginning-of-line)))
   (t (message (format "unknow %s" tag)))
   ))



(add-hook `julia-mode-hook `define-julia-keys)

(add-to-list `load-path "~/.emacs.d/lisp/julia")
(require `julia-client)

(defun czq-julia-autocomplete-new ()
  (interactive)
  (run-in-julia "autocompleteInEmacs()")
  )

(setq czq-julia-client-preload "include(\"/home/chengzhengqian/.emacs.d/lisp/server/czq-server-julia-client.jl\")")
(setq czq-julia-client-start "JuliaCommon.czqEmacsSocket[\"default\"]=Sockets.connect(\"localhost\",9001)")
(setq czq-julia-client-close "close(czqEmacsEvalConnection)")
(defun czq-julia-client-options (op)
  (interactive "ss(tart),r(estart),c(lose)")
  (cond
   ((string= op "s")
    (progn (message "start connection")
		(run-in-julia czq-julia-client-preload)
		(run-in-julia czq-julia-client-start)
		))
   ((string= op "r")
    (progn (message "start connection")
	   (run-in-julia czq-julia-client-close)
	   (run-in-julia czq-julia-client-start)
	))
   ((string= op "c")
    (progn (message "start connection")
	   (run-in-julia czq-julia-client-close)
	   ))))

;; add hook to julia mode

;; the stock expression is too cumbersom
(setq czq-simplified-julia-imenu-expression `((nil "\\(function\\|struct\\|macro\\) +\\([^ (]*\\)" 2)))
(defun czq-julia-set-simplified-imenu-expression ()
    (setq imenu-generic-expression czq-simplified-julia-imenu-expression))

;; (add-hook 'julia-mode-hook 'czq-julia-set-simplified-imenu-expression)



