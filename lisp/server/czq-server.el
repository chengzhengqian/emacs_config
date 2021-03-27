;; this is an experimental project
;; a general server that allows convenient autocomplete features from various script language. Julia, Python, WolframScript is planned.
;; we have implemented the basic function to julia, mathematica, and python
(provide `czq-server)
(defvar czq-server-port 9001
  "port of the czq server")

(defun czq-start-eval-server ()
  (interactive)
  (message (format "server starts at %d" czq-server-port))
  (setq czq-server-process (make-network-process :name "czq-server" :buffer "*czq-server*" :family 'ipv4 :service czq-server-port :sentinel 'czq-server-sentinel :filter 'czq-server-filter :server 't) )
  )

;; the string should be sepected by ;
;; and has the following form
;;   X ; X
(defun eval-string-to-string (string)
  (condition-case err
      (prin1-to-string (eval (car (read-from-string string))))
    (error (error-message-string err)))
 )

(defun eval-sexp-to-string (sexp)
  (condition-case err
      (prin1-to-string (eval sexp))
    (error (error-message-string err)))
 )
;; we need to debug this function
(setq czq-server-filter-is-debug nil)

;; (setq czq-server-filter-is-debug t)

(setq czq-server-filter-current-string "")
(defun czq-server-filter (proc string)
  (setq czq-server-filter-current-string (concat czq-server-filter-current-string string))
  (setq czq-server-filter-current-result (ignore-errors (read czq-server-filter-current-string)))
  (if czq-server-filter-current-result
      (progn	
	(if czq-server-filter-is-debug
	    (with-current-buffer (get-buffer-create "*czq-server-input-debug*")
	      (end-of-buffer)
	      (insert czq-server-filter-current-string)
	      (insert "\n===========")
	      (insert (format-time-string "%Y-%m-%dT%T %S"))
	      (insert "===========\n")
	      )
	  )
	;; (setq czq-server-echo-string (eval-string-to-string czq-server-filter-current-string))
	(setq czq-server-echo-string (eval-sexp-to-string czq-server-filter-current-result))
	(process-send-string proc  (format "%d\n" (length czq-server-echo-string)))
	(process-send-string proc (format "%s\n" czq-server-echo-string))
	(setq czq-server-filter-current-string "")
  )))

  ;; reply to the server
  ;; (setq czq-server-tokens (split-string string ";"))
  ;; (setq czq-server-input (first czq-server-tokens))
  ;; (setq czq-server-options (cdr-safe czq-server-tokens))
  ;; (setq czq-server-select (popup-menu* czq-server-options))
  ;; (insert (substring czq-server-select (length czq-server-input)))
  ;; (setq czq-server-select  (popup-menu* (split-string string ",")))
  ;; (message czq-server-select)








;; 123123

;; (cdr czq-server-tokens)
(defun czq-server-sentinel (proc msg)
  ;; (message msg)
  )


;; (split-string "1,2,3" ",")

;; we need to define some function to manipulate string

;; (thing-at-point `symbol)

(defun strip-font-info (str)
  (let* ((result str)
       (start  0)
       (end    (length result)))
  (set-text-properties start end nil result)
  result))

(defun czq-autocomplete (str result)
  (if (string= "" result)
      (setq czq-results `(,str))
        (setq czq-results (split-string  result ",")))
  (setq czq-complete
	(with-local-quit (popup-menu* czq-results)))
  (if czq-complete (insert (substring czq-complete (length str))))
  czq-complete
  )


;; now, we add some function to extract the symbol
;;  a.b.c, --> ("a.b", "c")
;; notice we should take care of parenthesis.

;; (defun czq-get-symbol-for-autocomplete ()
;;   (interactive)
;;   (setq czq-end-postion (point))
  
;;   )

(defun czq-go-backward-until-not-symbol ()
  (interactive)
  (search-backward-regexp "[^a-zA-Z0-9_.]")
  ;; (message (char-to-string (char-after)))
  (setq czq-current-char (char-to-string (char-after)))
  (setq czq-is-parenthesis (assoc czq-current-char czq-parenthesis-map-rev))
  (if (not (eq  czq-is-parenthesis nil))
      (progn (czq-go-backward-until-match-parenthesis (cdr czq-is-parenthesis))
	     (czq-go-backward-until-not-symbol))
    )
  )
(defun czq-find-match-part-for-auto-complete ()
  (interactive)
  (setq czq-end-position (point))
  (save-excursion
    (progn
      (czq-go-backward-until-not-symbol)
      (setq czq-start-position (point))))
  (save-excursion
    (progn (if (not (search-backward "." nil t)) (beginning-of-buffer))
	   (setq czq-dot-position (point))))
  ;; (message (format "%d,%d,%d" czq-start-position czq-dot-position czq-end-position))
  (if (< czq-start-position czq-dot-position)
      (format "%s\n%s" (buffer-substring-no-properties (1+ czq-start-position) czq-dot-position)
	    (buffer-substring-no-properties (1+ czq-dot-position) czq-end-position))
    (format "%s" (buffer-substring-no-properties (1+ czq-start-position) czq-end-position))
    )
  )

(defun czq-go-backward-until-match-parenthesis (target)
  (interactive "starget\n")
  (search-backward-regexp czq-rgexp-not-parenthsis)
  (setq czq-current-char (char-to-string (char-after)))
  (setq czq-is-match (string-equal czq-current-char target))
  (if (not czq-is-match)
      (progn
	(setq czq-is-parenthesis (assoc czq-current-char czq-parenthesis-map-rev))
	(if czq-is-parenthesis
	    (progn
	      (czq-go-backward-until-match-parenthesis (cdr czq-is-parenthesis))
	      (czq-go-backward-until-match-parenthesis target)
	      ))
	))
  )

;; (setq czq-current-char "]")
;; (setq target "[")

;; (setq czq-rgexp-not-parenthsis "[](){}[]")
;; ;;  test example


;; ;; a+a[1+2*(1+2)].b.c
;; ;; good
;; (setq czq-current-char "]")
;; (setq target "[")



(setq czq-parenthesis-map `(("(" . ")")
			    ("[" ."]")
			    ("{" ."}")))
(setq czq-parenthesis-map-rev `((")" . "(")
			    ("]". "[")
			    ("}"."{")))


(defun czq-send-string-term (term-name command)
  (with-current-buffer (get-buffer term-name)
  (term-send-raw-string (format "%s\n" command))))
