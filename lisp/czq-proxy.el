(provide `czq-proxy)
(setq url-proxy-services '(("no_proxy" . "localhost")
                           ("http" . "localhost:8080")
                           ("https" . "localhost:8080")))

