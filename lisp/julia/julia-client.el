;; provide autocomplete
(provide `julia-client)
(require `popup)

(setq czq-julia-server-port "2000")
(setq czq-julia-server-ip "127.0.0.1")


(defun start-julia-server-connection (port)
  (interactive "sserver port:")
  (start-julia-server-connection-with-ip czq-julia-server-ip port))

(defun start-julia-server-connection-with-ip (ip port)
  (interactive "sserver ip:\nsserver port:")
  (setq czq-julia-stream (open-network-stream "julia-connection" nil ip port))
  (set-process-filter czq-julia-stream 'keep-output)
  (message (format "start connection to %s:%s" ip port)))

;; Process julia-connection<1> connection broken by remote peer

;; Process julia-connection<2> connection broken by remote peer
;; (process-buffer czq-julia-stream)
;; (set-process-buffer czq-julia-stream nil)
;; (set-process-buffer czq-julia-stream (current-buffer))



(defun keep-output (process output)
  (setq kept (cons output kept)))
(defun empty-output ()  (setq kept nil))
(defun get-output () (string-join (reverse kept)))
;; (empty-output)

;; (length kept)
;; (split-string (nth 2 kept))

;; (setq popup (popup-create (point) 10 10))
;; (popup-set-list popup '("Foo" "Bar" "Baz"))
;; (popup-draw popup)
;; (popup-delete popup)
;; (message (popup-selected-item popup))
;; (popup-next popup)

(defun czq-julia-autocomplete ()
  (interactive)
  (setq czq-julia-str (thing-at-point `symbol))
  (empty-output)
  (process-send-string czq-julia-stream (format "%s\n" czq-julia-str))
  (sleep-for 0.1)
  (setq czq-julia-complete (popup-menu* (split-string (get-output))))
  (insert (substring czq-julia-complete (length czq-julia-str)))
  )

(defun czq-julia-end-loop ()
  (interactive)
  (process-send-string czq-julia-stream "!!end\n"))

(setq czq-julia-update-imported-module-command "[(v=eval(s);(typeof(v)==Module)&&(JuliaServer.addModule(s,v);println(\"add $s\"))) for s in names(Main;imported=true)];")

(defun czq-julia-update-imported-module ()
  (interactive)
  (run-in-julia czq-julia-update-imported-module-command))


;; (czq-julia-autocomplete "d")


