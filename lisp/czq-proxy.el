(provide `czq-proxy)
;; set up the default proxy , for desktop
;; there are some bugs for emacs 26.3, proxy make eww much faster
;; (setq url-proxy-services '(("no_proxy" . "localhost")
;;                            ("http" . "localhost:8080")
;;                            ("https" . "localhost:8080")))

(defun show-url-proxy ()
  (interactive)
  (message (format "current proxy is %s" url-proxy-services)))

(defun czq-disable-url-proxy ()
  (interactive)
  (setq url-proxy-services nil))

(defun czq-enable-url-proxy ()
  (interactive)
  (setq url-proxy-services '(("no_proxy" . "localhost")
                           ("http" . "localhost:8080")
                           ("https" . "localhost:8080"))))

