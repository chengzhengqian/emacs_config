(provide `czq-python)
(setq python-term-name "tpython")
(defun import-python-file ()
  (interactive)
  (save-buffer)
  (setq current-python-file (file-name-base (buffer-name)))
  (run-in-python (format "from %s import *" current-python-file))
  )

(setq python-term-name "tpython")
(defun set-python-term-name ()
  (interactive "")
  (make-local-variable `python-term-name)
  ;; (setq python-term-name (format "t%s" name))
  (czq-get-terminal-list)
  (setq python-term-name   (completing-read "set python term as: " czq-terminal-list))
  (message python-term-name)
  )

(defun show-python-term-name ()
  (interactive)
  (message (format "current term %s" python-term-name)))

(defun exec-selected-in-python ()
  (interactive "")
  (if (use-region-p)
      (progn
	(setq python-command (buffer-substring (region-beginning) (region-end)))
	(run-in-python-block-code python-command)) 
    (progn
      (setq python-command (thing-at-point `line))
      (run-in-python python-command))))
;; (setq python-command  (replace-regexp-in-string "    " "" python-command))
;; this is not working propertly, it seems ipython now support directly paste?

(defun run-in-python-block-code (command)
  (interactive "scommand")
  (run-in-python "%cpaste")
  (sleep-for 0.1)
  (run-in-python python-command)
  (run-in-python "--")
  ;; (run-in-python "\n")			;it seems we need this sometimes 
)

(defun exec-selected-in-python-with-module (beginning end)
  (interactive "r")
  (setq python-current-module-name (file-name-base (buffer-name)))
  (if (use-region-p)   (setq python-command (buffer-substring beginning end)) 
    (setq python-command (thing-at-point `symbol))
      )
  (run-in-python (format "%s.%s" python-current-module-name python-command))
  )


(setq czq-python-term-frame-name "acer")
(defun run-in-python (command)
  (interactive "scommand:")

  (save-current-buffer
    (progn
      (set-buffer python-term-name)
      (term-send-raw-string (format "%s\n" command))))
    (let ((term-name python-term-name))
    (if  (czq-get-frame czq-python-term-frame-name)
	(with-selected-frame (czq-get-frame czq-python-term-frame-name)
	   (switch-to-buffer term-name))))

  )

(setq czq-python-function-pattern "def \\(.*\\):\n")
(defun exec-function-in-python ()
  (interactive )
  (save-excursion
    (progn
    (search-backward-regexp czq-python-function-pattern)
    (setq python-command (match-string 1))
    (setq python-current-module-name (file-name-base (buffer-name)))  
    (run-in-python (format "%s" python-command)))))

(defun czq-python-change-directory ()
  (interactive)
  (setq czq-python-current-directory (file-name-directory (buffer-file-name)))
  (run-in-python (format "cd %s" czq-python-current-directory)))

(defun  define-python-keys ()
  (interactive)
  (define-key python-mode-map (kbd "C-x C-e") `exec-selected-in-python)
  (define-key python-mode-map (kbd "C-x C-r") `exec-function-in-python)
  (define-key python-mode-map (kbd "C-c t") `set-python-term-name)
  (define-key python-mode-map (kbd "C-c C-p") `czq-python-autocomplete-new)
  (define-key elpy-mode-map (kbd "C-c C-p") `czq-python-autocomplete-new)
  (define-key elpy-mode-map (kbd "C-c C-o") `czq-run-python-client-import)
  (define-key python-mode-map (kbd "C-c i") `import-python-file)
  (define-key python-mode-map (kbd "C-c s") `czq-python-switch)
  (define-key python-mode-map (kbd "C-c c") `czq-python-change-directory)
)

(setq czq-python-client-load "import sys; sys.path.append(\"/home/chengzhengqian/.emacs.d/lisp/server/\"); from czq_server_python_client import autocompleteInEmacs")

(defun czq-run-python-client-import ()
  (interactive)
  (run-in-python czq-python-client-load))
;;we extent it some common case
(defun czq-switch-to (old new)
  (interactive "sold:\nsnew")
  (setq czq-old-buffer-name (buffer-name))
  (setq czq-new-buffer-name (replace-regexp-in-string old new czq-old-buffer-name))
  (find-file czq-new-buffer-name)
  )
(defun czq-python-to-gene ()
  (interactive)
  (czq-switch-to "plot\\.py" "gene.py")
  )
(defun czq-python-to-plot ()
  (interactive)
  (czq-switch-to "gene\\.py" "plot.py")
  )

(defun czq-python-switch (target)
  (interactive "starget(p,g):")
  (cond
   ((string= target "p") (czq-python-to-plot))
   ((string= target "g") (czq-python-to-gene))
   ))


(defun czq-python-autocomplete-new ()
  (interactive)
  (run-in-python "autocompleteInEmacs(globals())")
  )
