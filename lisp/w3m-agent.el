(provide `w3m-agent)
(defvar wicked/w3m-fake-user-agents ;; (1)
   `(
     ("ie6" . "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)")
     ("ff3" . "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008070206 Firefox/3.0.1")
     ("ff2" . "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080208 Firefox/2.0.0.13")
     ("ie7" . "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727)")
     ("ie5.5" . "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98)")
     ("iphone" . "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_0 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5A347 Safari/525.20")
     ("safari" . "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; en-us) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13")
     ("google" . "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"))
   "*Associative list of user agent names and strings.")

 (defvar wicked/w3m-fake-user-agent-sites ;; (2)
   '((".*" . "iphone"))
   "*Associative list of regular expressions matching URLs and the agent keyword or value.
 The first matching entry will be used.")

 (defun wicked/w3m-set-user-agent (agent)
   "Set the user agent to AGENT based on `wicked/w3m-fake-user-agents'.
 If AGENT is not defined in `wicked/w3m-fake-user-agents', it is used as the user agent.
 If AGENT is empty, the default w3m user agent will be used."
   (interactive
    (list
     (completing-read "User-agent [w3m]: "
                    (mapcar 'car wicked/w3m-fake-user-agents)
                    nil nil nil nil "w3m"))) ;; (3)
   (if agent
       (progn
        (setq w3m-user-agent
              (or
               (and (string= agent "") (assoc "w3m" wicked/w3m-fake-user-agents)) ;; (4)
               (cdr (assoc agent wicked/w3m-fake-user-agents)) ;; (5)
               agent)) ;; (6)
        (setq w3m-add-user-agent t))
     (setq w3m-add-user-agent nil)))

 (defun wicked/w3m-reload-this-page-with-user-agent (agent)
   "Browse this page using AGENT based on `wicked/w3m-fake-user-agents'.
 If AGENT is not defined in `wicked/w3m-fake-user-agents', it is used as the user agent.
 If AGENT is empty, the default w3m user agent will be used."
   (interactive (list (completing-read "User-agent [w3m]: "
                    (mapcar 'car wicked/w3m-fake-user-agents)
                    nil nil nil nil "w3m")))
   (let ((w3m-user-agent w3m-user-agent)
       (w3m-add-user-agent w3m-add-user-agent))
     (wicked/w3m-set-user-agent agent) ;; (7)
     (w3m-reload-this-page)))

 (defadvice w3m-header-arguments (around wicked activate) ;; (8)
   "Check `wicked/w3m-fake-user-agent-sites' for fake user agent definitions."
   (let ((w3m-user-agent w3m-user-agent)
         (w3m-add-user-agent w3m-add-user-agent)
         (sites wicked/w3m-fake-user-agent-sites))
     (while sites
       (if (string-match (caar sites) (ad-get-arg 1))
         (progn
           (wicked/w3m-set-user-agent (cdar sites))
           (setq sites nil))
       (setq sites (cdr sites))))
     ad-do-it))


