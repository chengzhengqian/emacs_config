;; this aims to be a general library for tcp connection in elisp

(defun start-tcp-connection-with-filter (ip port name filter )
  (let ((connection (open-network-stream name nil ip port)))
    (set-process-filter connection filter)
    connection))

(setq czq-python-tcp-output "")
(setq czq-python-tcp-connection
      (start-tcp-connection-with-filter "localhost" "10011" "python-czq"
					(lambda (process output)
					  (setq czq-python-tcp-output (cons output czq-python-tcp-output)))))

(process-send-string czq-python-tcp-connection "123\n")

(eval `(setq czq-test  1))

;; add a macro framework
;; (eval `(setq ,(intern (format "czq-%s-test" "a")) 1))

