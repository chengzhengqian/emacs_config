(provide `czq-julia)
(setq julia-term-name "tjulia")
(defun import-julia-file ()
  (interactive)
  (save-buffer)
  (setq current-julia-file (buffer-file-name))
  (run-in-julia (format "include(\"%s\")" current-julia-file))
  )

;; (push "good" czq-terminal-list)
(defun  czq-get-terminal-list ()
  (setq czq-terminal-list '())
  (dolist (buffer (buffer-list) )
    (with-current-buffer buffer
      (if (eq  major-mode 'term-mode)
	  (push (buffer-name) czq-terminal-list)))))

(defun set-julia-term-name ()
  (interactive "")
  (make-local-variable `julia-term-name)
  (czq-get-terminal-list)
  (setq julia-term-name   (completing-read "set julia term as: " czq-terminal-list))
  (message julia-term-name))

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

;; (defun exec-selected-in-julia-with-wrap (beginning end pattern)
;;   (setq julia-command (buffer-substring beginning end))
;;   (setq julia-command (replace-regexp-in-string "    " "" julia-command))
;;   (run-in-julia (format pattern  julia-command)))

;; we need to think about a better way to show the snapshot of the code
(setq czq-julia-max-inline-cmd-size 30)
;; (length (split-string julia-command "\n"))

(defun exec-selected-in-julia-with-wrap (beginning end pattern)
  (setq julia-command (buffer-substring beginning end))
  (setq julia-command (format pattern  julia-command))
  (if (> (length julia-command) czq-julia-max-inline-cmd-size)
      ;; if the size is big, we run it in a file
      (progn
	;; we must use the same directory, otherwise, the include comand will expand . wild card wrong
	(setq czq-julia-temp-file-name "./czq_julia_tmp.jl")
	(with-temp-file czq-julia-temp-file-name
	  (insert julia-command))
	(setq czq-julia-command-msg  (format "run:  <%s...%s> total %d characters " (substring-no-properties julia-command 0 10) (substring-no-properties julia-command -10 ) (length julia-command)))
	(run-in-julia-with-message (format "include(\"%s\")" czq-julia-temp-file-name) czq-julia-command-msg))	
    ;; if the size is small, we run it directly
  (run-in-julia julia-command)))

;; we now set the default frame to show the terminal
;; we should make this more general, to it later
(setq czq-julia-term-frame-name "acer")
(defun run-in-julia (command)
  (interactive "scommand:")
  (save-current-buffer
    (progn
      (set-buffer julia-term-name)
      (term-send-raw-string (format "%s\n" command))
      ))
  (let ((term-name julia-term-name))
    (if  (czq-get-frame czq-julia-term-frame-name)
	(with-selected-frame (czq-get-frame czq-julia-term-frame-name)
	   (switch-to-buffer term-name))))
  )

(defun run-in-julia-with-message (command msg)
  (interactive "scommand:")
  (save-current-buffer
    (progn
      (set-buffer julia-term-name)
      (term-send-raw-string (format "%s\n" command))
      (message msg)
      ))
  (let ((term-name julia-term-name))
    (if  (czq-get-frame czq-julia-term-frame-name)
	(with-selected-frame (czq-get-frame czq-julia-term-frame-name)
	   (switch-to-buffer term-name))))
  )

(defun czq-julia-send-ctrl-c-n-times (n)
  (interactive "nsend ctrl-c N times:")
  (dotimes (idx n)
    (save-current-buffer
        (progn
	  (set-buffer julia-term-name)
	  (term-send-raw-string "\3\n")
	  (sleep-for 0.1)
    ))))

;; if the directory contains ssh
;; (setq czq-test-ssh-directory "/ssh:gin:/burg/home/zc2255/workspace/vdat/VDAT.jl/")
(defun czq-process-directory (czq-test-ssh-directory)
  (replace-regexp-in-string "/ssh:.+:" "" czq-test-ssh-directory))


(defun cd-to-directory-of-current-file-in-julia ()
  (interactive)
  (run-in-julia (format "cd(\"%s\")" (czq-process-directory default-directory))))

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
  (define-key julia-mode-map (kbd "C-c C-i") `get-information-in-julia-for-selected)
  (define-key julia-mode-map (kbd "C-x C-r") `exec-function-in-julia)
  (define-key julia-mode-map (kbd "C-c t") `set-julia-term-name)
  (define-key julia-mode-map (kbd "C-c i") `import-julia-file)
  ;; (define-key julia-mode-map (kbd "C-c C-i") `julia-insert-snippet)
  ;; (define-key julia-mode-map (kbd "C-x j") `julia-insert-snippet)
  ;; (define-key julia-mode-map (kbd "C-c C-i") nil)
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
;; (setq czq-julia-client-start "JuliaCommon.czqEmacsSocket[\"default\"]=Sockets.connect(\"localhost\",9001)")
(setq czq-julia-client-start "CZQUtils.czqEmacsSocket[\"default\"]=Sockets.connect(\"localhost\",9001)")
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
;; (setq czq-simplified-julia-imenu-expression `((nil "\\(function\\|struct\\|macro\\) +\\([^ (]*\\)" 2)))

;; copied from the julia-mode
(setq czq-julia-imenu-generic-expression
  ;; don't use syntax classes, screws egrep
  '(("Function (_)" "[ \t]*function[ \t]+\\(_[^ \t\n]*\\)" 1)
    ("Function" "^[ \t]*function[ \t]+\\([^_][^\t\n]*\\)" 1)
    ("Const" "[ \t]*const \\([^ \t\n]*\\)" 1)
    ("Struct" "[ \t]*struct \\([^ \t\n]*\\)" 1)
    ("Type"  "^[ \t]*[a-zA-Z0-9_]*type[a-zA-Z0-9_]* \\([^ \t\n]*\\)" 1)
    ("Require"      " *\\(\\brequire\\)(\\([^ \t\n)]*\\)" 2)
    ("Include"      " *\\(\\binclude\\)(\\([^ \t\n)]*\\)" 2)
    ("Macro"      "^[ \t]*macro[ \t]+\\([^_][^\t\n]*\\)" 1)
    ;; ("Classes" "^.*setClass(\\(.*\\)," 1)
    ;; ("Coercions" "^.*setAs(\\([^,]+,[^,]*\\)," 1) ; show from and to
    ;; ("Generics" "^.*setGeneric(\\([^,]*\\)," 1)
    ;; ("Methods" "^.*set\\(Group\\|Replace\\)?Method(\"\\(.+\\)\"," 2)
    ;; ;;[ ]*\\(signature=\\)?(\\(.*,?\\)*\\)," 1)
    ;; ;;
    ;; ;;("Other" "^\\(.+\\)\\s-*<-[ \t\n]*[^\\(function\\|read\\|.*data\.frame\\)]" 1)
    ;; ("Package" "^.*\\(library\\|require\\)(\\(.*\\)," 2)
    ;; ("Data" "^\\(.+\\)\\s-*<-[ \t\n]*\\(read\\|.*data\.frame\\).*(" 1)))
    ))


;; add entry for struct
(defun czq-julia-set-imenu-expression ()
  (interactive)
  (setq imenu-generic-expression czq-julia-imenu-generic-expression))

(add-hook 'julia-mode-hook 'czq-julia-set-imenu-expression)

(defun czq-julia-set-original-imenu-expression ()
  (interactive)
    (setq imenu-generic-expression julia-imenu-generic-expression))




