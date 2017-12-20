(provide `my-dict)
(add-to-list 'load-path "~/.emacs.d/lisp/dictionary-el")
(require `dictionary)
(global-set-key (kbd "C-c d") `dictionary-search)
(global-set-key (kbd "C-c l") `get-latin-from-words)

(setq max-mini-window-height 100)
(defun get-latin-from-words ()
  (interactive)
  (setq CZQ-latin-word (thing-at-point `word))
  (setq CZQ-latin-definition  ( shell-command-to-string (format  "cd /home/chengzhengqian/cloud/word;./words %s"CZQ-latin-word)))
  (message (replace-regexp-in-string "\r" "" CZQ-latin-definition))
  )


