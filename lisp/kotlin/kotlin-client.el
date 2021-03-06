(provide `kotlin-client)
(require `popup)

(setq czq-kotlin-server-port "9999")
(setq czq-kotlin-server-ip "192.168.1.103")
(setq czq-koltin-wait-time 2)

(defun start-kotlin-server-connection (port)
  (interactive "sserver port:")
  (kotlin-load-server-etc)
  (message (format "wait %d sec for the server to start" czq-koltin-wait-time))
  (sleep-for czq-koltin-wait-time)
  (setq czq-kotlin-stream (open-network-stream "kotlin-connection" nil czq-kotlin-server-ip port))
  (set-process-filter czq-kotlin-stream 'keep-kotlin-output)
  (message (format "start connection to %s:%s" czq-kotlin-server-ip port)))

(defun start-kotlin-server-default ()
  (interactive)
  (start-kotlin-server-connection czq-kotlin-server-port))

(defun keep-kotlin-output (process kotlin-output)
  (setq kotlin-kept (cons kotlin-output kotlin-kept)))
(defun empty-kotlin-output ()  (setq kotlin-kept nil))
(empty-kotlin-output)
(defun get-kotlin-output () (string-join (reverse kotlin-kept)))

;; (get-kotlin-output)
