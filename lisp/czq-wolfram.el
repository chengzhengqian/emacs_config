(provide `czq-wolfram)
;; we add a default frame to show this

(setq czq-wolfram-preview-frame-name "carta")

(defun czq-wolfram-show-pprint ()
  (interactive)
  (setq czq-wolfram-tag (file-name-base (buffer-name)))
  (setq pretty-file (concat "/home/chengzhengqian/cloud/" ".pprint_" czq-wolfram-tag   ".org"))
  (setq pretty-buffer (find-file-noselect pretty-file t))
  ;; it is better not display it
  ;; (display-buffer pretty-buffer)
  (if  (czq-get-frame czq-wolfram-preview-frame-name)
	(with-selected-frame (czq-get-frame czq-wolfram-preview-frame-name)
	  (switch-to-buffer pretty-buffer)))
  (with-current-buffer pretty-buffer
    ;; (revert-buffer nil t nil)
    (revert-buffer-no-confirm)    
    (rename-buffer
     (concat "*MathematicaPrettyPrint_"  czq-wolfram-tag "*"))
    (org-remove-latex-fragment-image-overlays)
    (beginning-of-buffer)
    (org-toggle-latex-fragment)
))
 
(setq wolfram-term-name "twolfram")

;; (defun set-wolfram-term-name (name)
;;   (interactive "st(name):")
;;   (make-local-variable `wolfram-term-name)
;;   (setq wolfram-term-name (format "t%s" name))
;;   (message wolfram-term-name)
;;   )
(defun set-wolfram-term-name ()
  (interactive "")
  (make-local-variable `wolfram-term-name)
  (czq-get-terminal-list)
  (setq wolfram-term-name   (completing-read "set wolfram term as: " czq-terminal-list))
  (message wolfram-term-name))

(defun show-wolfram-term-name ()
  (interactive)
  (message (format "current term %s" wolfram-term-name)))

(defun import-wolfram-file ()
  (interactive)
  (save-buffer)
  (setq current-wolfram-file (buffer-file-name))
  (run-in-wolfram (format "Get[\"%s\"]" current-wolfram-file))
  )

(defun exec-selected-in-wolfram ()
  (interactive)
  (if (use-region-p)
      (progn
	(setq wolfram-command (buffer-substring (region-beginning) (region-end)))
	(run-in-wolfram wolfram-command)) 
    (progn
      (setq wolfram-command (thing-at-point `line))
      (run-in-wolfram wolfram-command))))

(setq czq-wolfram-term-frame-name "acer")
(defun run-in-wolfram (command)
  (interactive "scommand:")
  (save-current-buffer
    (progn
      (set-buffer wolfram-term-name)
      (term-send-raw-string (format "%s\n" command)))
    )
    (let ((term-name wolfram-term-name))
    (if  (czq-get-frame czq-wolfram-term-frame-name)
	(with-selected-frame (czq-get-frame czq-wolfram-term-frame-name)
	   (switch-to-buffer term-name))))
  )

(defun  define-wolfram-keys ()
  (interactive)
  (define-key wolfram-mode-map (kbd "C-x C-e") `exec-selected-in-wolfram)
  (define-key wolfram-mode-map (kbd "C-c C-p") `czq-wolfram-autocomplete)
  ;; (define-key wolfram-mode-map (kbd "C-c p") `print-selected-in-latex-in-wolfram-append)
  (define-key wolfram-mode-map (kbd "C-c p") `print-selected-in-latex-in-wolfram-write)
  (define-key wolfram-mode-map (kbd "C-c C-l") `czq-wolfram-load-predefined)
  (define-key wolfram-mode-map (kbd "C-c i") `import-wolfram-file)
  (define-key wolfram-mode-map (kbd "C-c C-o") `czq-wolfram-client-options)
  (define-key wolfram-mode-map (kbd "C-c C-i") `import-wolfram-file)
  (define-key wolfram-mode-map (kbd "C-c s") `czq-wolfram-show-pprint)
)

(setq czq-wolfram-client-start "czqEmacsEvalConnection=SocketConnect[\"localhost:9001\"] ")
(setq czq-wolfram-client-close "Close[czqEmacsEvalConnection]")
(defun czq-wolfram-client-options (op)
  (interactive "ss(tart),r(estart),c(lose)")
  (cond
   ((string= op "s")
    (progn (message "start connection")
		(run-in-wolfram czq-wolfram-client-start)
		))
   ((string= op "r")
    (progn (message "start connection")
	   (run-in-wolfram czq-wolfram-client-close)
	   (run-in-wolfram czq-wolfram-client-start)
	))
   ((string= op "c")
    (progn (message "start connection")
	   (run-in-wolfram czq-wolfram-client-close)
	   ))))


(defun czq-wolfram-autocomplete ()
  (interactive)
  (run-in-wolfram "autocompleteInEmacs[]"))

(setq czq-wolfram-predefined "Get[\"/home/chengzhengqian/Application/EPrint.m\"];Get[\"/home/chengzhengqian/.emacs.d/lisp/server/czq-server-wolfram-client.m\"];")
(defun czq-wolfram-load-predefined ()
  (interactive)
  (run-in-wolfram czq-wolfram-predefined))

;; maybe we should move  czq-wolfram-show-pprint into EPrint
(defun print-selected-in-latex-in-wolfram (beginning end)
  (interactive "r")
  (setq czq-wolfram-tag (file-name-base (buffer-name)))
  (if (use-region-p)
	(setq wolfram-command (buffer-substring beginning end))
    (setq wolfram-command (thing-at-point `symbol)))
  (run-in-wolfram (format "EPrint[%s,\"%s\",\"%s\",%s]" wolfram-command
			  wolfram-command czq-wolfram-tag czq-wolfram-print-is-append ))
  ;; we move to EPrint
  ;; (sleep-for 0.1)
  ;; (czq-wolfram-show-pprint)
  )

(defun print-selected-in-latex-in-wolfram-write ()
  (interactive)
  (setq czq-wolfram-print-is-append "False")
  (call-interactively `print-selected-in-latex-in-wolfram))

(defun print-selected-in-latex-in-wolfram-append ()
  (interactive)
  (setq czq-wolfram-print-is-append "True")
  (call-interactively `print-selected-in-latex-in-wolfram))

(defun extract-formula-from-latex-preview-in-org ()
  (interactive)
  (save-excursion 
    (org-toggle-latex-fragment)
    (re-search-forward "\\\\begin{equation\\*}.*\\(\\(\n.*\\)*\\)\\\\end{equation\\*}")
    (kill-new (match-string 1)) )
  (org-toggle-latex-fragment)
  (message "copy the formulas to clipboard")
)
(setq czq-wolfram-imenu-expression `((nil "^\\([^ =]+\\):=" 1)))

(defun czq-set-wolfram-imenu ()
  (interactive)
  (setq imenu-generic-expression czq-wolfram-imenu-expression)
  )

;; (add-to-list `wolfram-mode-hook `czq-set-wolfram-imenu)



