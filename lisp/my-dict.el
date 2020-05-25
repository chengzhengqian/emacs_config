(provide `my-dict)
(add-to-list 'load-path "~/.emacs.d/lisp/dictionary_el")
(require `dictionary)
(global-set-key (kbd "C-c d") `dictionary-search)
(global-set-key (kbd "C-c l") `get-latin-from-words)

(setq max-mini-window-height 100)

(defun get-ascii-form (word)
  (setq czq-word word)
  (setq czq-latin-map `(( "ā" "a") ("ī" "i") ("ō","o") ("ē","e") ("ū" "u")))
  (mapc
   (lambda (m)
     ( let ((a (nth 0 m))
	      (b (nth 1 m)))
      (setq czq-word (replace-regexp-in-string a b czq-word))))
   czq-latin-map
   )
  czq-word
  )

;; it is more easy to show the output in a buffer
(setq czq-latin-buffer-name "*latin-words*")
(defun get-latin-from-words ()
  (interactive)
  (setq CZQ-latin-word (get-ascii-form (thing-at-point `word)))
  (setq CZQ-latin-definition  ( shell-command-to-string (format  "cd /home/chengzhengqian/cloud/word;./words %s"CZQ-latin-word)))
  ;; (save-window-excursion
  ;;   (find-file czq-latin-buffer-name))
  (get-buffer-create czq-latin-buffer-name)
  (with-current-buffer czq-latin-buffer-name
      (progn
	(erase-buffer)
	(insert (replace-regexp-in-string "\r" "" CZQ-latin-definition)))))


  ;; (message (replace-regexp-in-string "\r" "" CZQ-latin-definition))
  


;; we don't need w3m anymore
;; (require `w3m)
(defun get-workds-from-wiktioanry ()
  (interactive)
  (setq CZQ-latin-word (get-ascii-form (thing-at-point `word)))
  (w3m-goto-new-session-url (format "https://en.m.wiktionary.org/wiki/%s" CZQ-latin-word))
  )

;; (define-key w3m-mode-map (kbd "C-c w") `get-workds-from-wiktioanry)
