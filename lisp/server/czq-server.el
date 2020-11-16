;; this is an experimental project
;; a general server that allows convenient autocomplete features from various script language. Julia, Python, WolframScript is planned.
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

(defun czq-server-filter (proc string)
  (setq czq-server-echo-string (eval-string-to-string string))
  (process-send-string proc  (format "%d\n" (length czq-server-echo-string)))
  (process-send-string proc (format "%s\n" czq-server-echo-string))
  )

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
  (setq czq-complete (popup-menu* czq-results))
  (insert (substring czq-complete (length str)))
  czq-complete
  )


