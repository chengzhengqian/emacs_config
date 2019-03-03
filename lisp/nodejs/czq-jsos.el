(provide `czq-jsos)

(setq czq-jsos-term-name "tjsos")

(defun czq-jsos-get-input-before-line ()
  (interactive)
  (save-excursion
     (call-interactively `set-mark-command)
     (beginning-of-line)
     (setq czq-jsos-input-before-line (buffer-substring (region-beginning) (region-end)))
     (message czq-jsos-input-before-line))
  (deactivate-mark))

(setq czq-jsos-term-name "tjsos")
(defun set-jsos-term-name (name)
  (interactive "st(name):")
  (setq czq-jsos-term-name (format "t%s" name))
  (message czq-jsos-term-name)
  )

(setq jsos-promp-pos 7)
(defun czq-jsos-send-input-line-with-additional-string (s)
  (czq-jsos-get-input-before-line)
  (save-current-buffer
    (set-buffer czq-jsos-term-name)
    (term-send-raw-string czq-jsos-input-before-line)
    (term-send-raw-string s)
    ))
(defun czq-jsos-send-input-line-with-tab ()
    (interactive)
  (czq-jsos-send-input-line-with-additional-string "\t"))

(defun czq-jsos-send-region-for-evaluation ()
  (interactive)
  (setq czq-jsos-region (buffer-substring (region-beginning) (region-end)))
  (save-current-buffer
    (set-buffer czq-jsos-term-name)
    (setq czq-jsos-region (replace-regexp-in-string "\n" "" czq-jsos-region))
    (term-send-raw-string czq-jsos-region)
    (term-send-raw-string "\n")
    ))

   
(defun czq-jsos-send-input-line-with-enter ()
  (interactive)
  (if (region-active-p)
      (czq-jsos-send-region-for-evaluation)
    (progn
      (end-of-line)
     (czq-jsos-send-input-line-with-additional-string "\n")))
)


(defun js-send-last-sexp ()
  (interactive)
  (czq-jsos-send-input-line-with-enter))

(defun define-jsos-keys ()
  (interactive)
 (define-key js2-mode-map (kbd "C-x p") `czq-js-complete)
 (define-key js2-mode-map (kbd "C-x C-e") `czq-jsos-send-input-line-with-enter)
 )

(defun js-comint-send-last-sexp ()
  (interactive)
  (czq-jsos-send-input-line-with-enter))


(setq jni-primitive-list `(
			   ("jboolean","Boolean")
			   ("jbyte","Byte")
			   ("jchar","Char")
			   ("jshort","Short")
			   ("jint","Int")
			   ("jlong","Long")
			   ("jfloat","Float")
			   ("jdouble","Double")
			   ("void","Void")
			   ))

(setq jni-sig-to-primitive-list `(
			   ("\"z\"","Boolean")
			   ("\"b\"","Byte")
			   ("\"c\"","Char")
			   ("\"s\"","Short")
			   ("\"i\"","Int")
			   ("\"j\"","Long")
			   ("\"f\"","Float")
			   ("\"d\"","Double")
			   ("\"v\"","Void")
			   ))
(setq jsos-js-init-files-list
      `("primitive"
	"modifier"
	"types"
	"method"
	"constructor"
	"array"
	"android"
	))

(defun generate-js-init ()
  (interactive)
  (setq jni-generic-current-line (thing-at-point `line))
  (dolist (value jsos-js-init-files-list)
  (next-line)
  (insert jni-generic-current-line)
  (previous-line)
  (beginning-of-line)
  (re-search-forward "init" nil t)
  (replace-match value)
  (re-search-forward "init" nil t)
  (replace-match value)
  ))

(defun generate-generic-jni ()
  (interactive)
  (setq jni-generic-current-line (thing-at-point `line))
  (dolist (value jni-primitive-list)
  (next-line)
  (insert jni-generic-current-line)
  (previous-line)
  (beginning-of-line)
  (re-search-forward "jobject" nil t)
  (replace-match (elt value 0))
  (re-search-forward "Object" nil t)
  (replace-match (elt value 1))
  ))
(defun generate-generic-jni-table ()
  (interactive)
  (setq jni-generic-current-line (thing-at-point `line))
  (dolist (value jni-sig-to-primitive-list)
  (next-line)
  (insert jni-generic-current-line)
  (previous-line)
  (beginning-of-line)
  (re-search-forward "\"l\"" nil t)
  (replace-match (elt value 0))
  (re-search-forward "Object" nil t)
  (replace-match (elt value 1))
  ))

(defun generate-generic-jni-void ()
  (interactive)
  (setq jni-generic-current-line (thing-at-point `line))
  (dolist (value jni-primitive-list)
  (next-line)
  (insert jni-generic-current-line)
  (previous-line)
  (beginning-of-line)
  (re-search-forward "Object" nil t)
  (replace-match (elt value 1))
  (end-of-line)
  (re-search-backward "jobject" nil t)
  (replace-match (elt value 0))
  ))



(defun get-js-output (buf str)
  (setq czq-js-output str)
  (setq czq-js-list (split-string czq-js-output ","))
  (setq czq-js-selected (popup-menu* (cons czq-js-partial-input czq-js-list)))
  (insert (substring czq-js-selected (length czq-js-partial-input)))
  )


(defun czq-js-connect ()
  (interactive)
  (open-network-stream "js" (current-buffer) "192.168.1.101" "10000")
  (set-process-filter (get-process "js") `get-js-output))

(defun czq-find-words ()
  (interactive)
  (setq czq-js-partial-input (thing-at-point `word))
  (if (equal czq-js-partial-input nil) (setq czq-js-partial-input ""))
  (save-excursion
    (progn
      (if (not (string= czq-js-partial-input "")) (backward-word))
      (if (char-equal (char-before) ?.)
	  (progn
	   (backward-char 1)
	   (setq czq-js-previous-input (thing-at-point `word)))
	(setq czq-js-previous-input "this"))
      (message (format "%s:%s" czq-js-previous-input czq-js-partial-input)))))


(defun czq-js-complete ()
  (interactive)
  (czq-find-words)
  (process-send-string "js"
		       (format "getAllPropertiesStartWith(%s,\"%s\");\n" czq-js-previous-input czq-js-partial-input))
)



