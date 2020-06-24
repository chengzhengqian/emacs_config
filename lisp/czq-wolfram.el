(provide `czq-wolfram)
(defun czq-wolfram-show-pprint ()
  (interactive)
  (setq czq-wolfram-tag (file-name-base (buffer-name)))
  (setq pretty-file (concat "/home/chengzhengqian/" ".pprint_" czq-wolfram-tag   ".org"))
  (setq pretty-buffer (find-file-noselect pretty-file t))
  ;; it is better not display it
  ;; (display-buffer pretty-buffer)
  
  (with-current-buffer pretty-buffer
    ;; (revert-buffer nil t nil)
    (revert-buffer-no-confirm)
    (rename-buffer (concat "*MathematicaPrettyPrint_"  czq-wolfram-tag "*"))
    (org-remove-latex-fragment-image-overlays)
    (org-toggle-latex-fragment)
))
 
(setq wolfram-term-name "twolfram")

(defun set-wolfram-term-name (name)
  (interactive "st(name):")
  (make-local-variable `wolfram-term-name)
  (setq wolfram-term-name (format "t%s" name))
  (message wolfram-term-name)
  )

(defun show-wolfram-term-name ()
  (interactive)
  (message (format "current term %s" wolfram-term-name)))

(defun exec-selected-in-wolfram (beginning end)
  (interactive "r")
  (if (use-region-p)
      (progn
	(setq wolfram-command (buffer-substring beginning end))
	(run-in-wolfram wolfram-command)) 
    (progn
      (setq wolfram-command (thing-at-point `line))
      (run-in-wolfram wolfram-command))))

(defun run-in-wolfram (command)
  (interactive "scommand:")
  (save-current-buffer
    (progn
      (set-buffer wolfram-term-name)
      (term-send-raw-string (format "%s\n" command)))
    ))

(defun  define-wolfram-keys ()
  (interactive)
  (define-key wolfram-mode-map (kbd "C-x C-e") `exec-selected-in-wolfram)
  (define-key wolfram-mode-map (kbd "C-c C-p") `print-selected-in-latex-in-wolfram-write)
  (define-key wolfram-mode-map (kbd "C-c p") `print-selected-in-latex-in-wolfram-append)
  (define-key wolfram-mode-map (kbd "C-c C-l") `czq-wolfram-load-predefined)
  (define-key wolfram-mode-map (kbd "C-c s") `czq-wolfram-show-pprint)
)

(setq czq-wolfram-predefined "Get[\"EPrint.m\"];")
(defun czq-wolfram-load-predefined ()
  (interactive)
  (run-in-wolfram czq-wolfram-predefined))


(defun print-selected-in-latex-in-wolfram (beginning end)
  (interactive "r")
  (setq czq-wolfram-tag (file-name-base (buffer-name)))
  (if (use-region-p)
	(setq wolfram-command (buffer-substring beginning end))
    (setq wolfram-command (thing-at-point `symbol)))
  (run-in-wolfram (format "EPrint[%s,\"%s\",\"%s\",%s]" wolfram-command
			  wolfram-command czq-wolfram-tag czq-wolfram-print-is-append ))
  (sleep-for 0.1)
  (czq-wolfram-show-pprint))

(defun print-selected-in-latex-in-wolfram-write ()
  (interactive)
  (setq czq-wolfram-print-is-append "False")
  (call-interactively `print-selected-in-latex-in-wolfram))

(defun print-selected-in-latex-in-wolfram-append ()
  (interactive)
  (setq czq-wolfram-print-is-append "True")
  (call-interactively `print-selected-in-latex-in-wolfram))
