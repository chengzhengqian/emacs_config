(provide `czq-gnuplot)
(defun gene-gnuplot ()
  (interactive)
  (save-buffer)
  (shell-command (format "gnuplot %s" (buffer-name))))

(defun define-czq-gnuplot-keys ()
  (interactive)
  (define-key gnuplot-mode-map (kbd "C-c p") `gene-gnuplot))

(setq gnuplot-term-name "tgnuplot")
(defun import-gnuplot-file ()
  (interactive)
  (save-buffer)
  (setq current-gnuplot-file (buffer-file-name))
  (run-in-gnuplot (format "include(\"%s\")" current-gnuplot-file))
  )
(defun set-gnuplot-term-name ()
  (interactive "")
  (make-local-variable `gnuplot-term-name)
  ;; (setq gnuplot-term-name (format "t%s" name))
  (czq-get-terminal-list)
  (setq gnuplot-term-name   (completing-read "set gnuplot term as: " czq-terminal-list))
  (message gnuplot-term-name)
  )
;; (defun exec-selected-in-gnuplot (beginning end)
;;   (interactive "r")
;;   (if (use-region-p)   (setq gnuplot-command (buffer-substring beginning end)) 
;;     (setq gnuplot-command (thing-at-point `symbol))
;;       )
;;   (run-in-gnuplot gnuplot-command)
;;   )

(defun exec-selected-in-gnuplot (beginning end)
  (interactive "r")
  (if (use-region-p)
  ;; (setq gnuplot-current-module-name (file-name-base (buffer-name)))
      (exec-selected-in-gnuplot-with-wrap beginning end  "%s")
    (exec-selected-in-gnuplot-with-wrap (line-beginning-position) (line-end-position)  "%s")))





(defun find-doc--selected-in-gnuplot (beginning end)
  (interactive "r")
  ;; (setq gnuplot-current-module-name (file-name-base (buffer-name)))
  (exec-selected-in-gnuplot-with-wrap beginning end  "?%s"))

(defun exec-selected-in-gnuplot-with-less (beginning end)
  (interactive "r")
  ;; (setq gnuplot-current-module-name (file-name-base (buffer-name)))
  (exec-selected-in-gnuplot-with-wrap beginning end  "@less %s"))

(defun exec-selected-in-gnuplot-with-wrap (beginning end pattern)
  (setq gnuplot-command (buffer-substring beginning end))
  (run-in-gnuplot (format pattern  gnuplot-command)))

(setq czq-gnuplot-term-frame-name "acer")
(defun run-in-gnuplot (command)
  (interactive "scommand:")
  (save-current-buffer
    (progn
      (set-buffer gnuplot-term-name)
      (term-send-raw-string (format "%s\n" command))
      ))
  (let ((term-name gnuplot-term-name))
    (if  (czq-get-frame czq-gnuplot-term-frame-name)
	(with-selected-frame (czq-get-frame czq-gnuplot-term-frame-name)
	   (switch-to-buffer term-name))))
  )

;; notice that we use in surface, so we need to map the home directory

(defun cd-to-directory-of-current-file-in-gnuplot ()
  (interactive)
  (setq czq-desktop-dir (replace-regexp-in-string "/home/chengzhengqian/" "/home/chengzhengqian/desktop/" default-directory) )
  (run-in-gnuplot (format "cd \"%s\"" czq-desktop-dir)))

;; this is not useful in gnuplot, we modify it as a block
(setq czq-gnuplot-function-pattern "function \\(.*\\)\n")
(defun exec-function-in-gnuplot ()
  (interactive )
  (save-excursion
    (progn
    (search-backward-regexp czq-gnuplot-function-pattern)
    (setq gnuplot-command (match-string 1))
    ;; (setq gnuplot-current-module-name (file-name-base (buffer-name)))  
    (run-in-gnuplot (format "%s"  gnuplot-command)))))

(defun exec-block-in-gnuplot ()
  (interactive)
  (save-excursion
    (backward-paragraph)
    (call-interactively 'set-mark-command)
    (forward-paragraph)
    (call-interactively 'exec-selected-in-gnuplot)
    )
  (deactivate-mark)
  )


(defun get-information-in-gnuplot-for-selected  (beginning end)
  (interactive "r")
  (exec-selected-in-gnuplot-with-wrap beginning end  "?%s"))

(defun  define-gnuplot-keys ()
  (interactive)
  (define-key gnuplot-mode-map (kbd "C-x C-e") `exec-selected-in-gnuplot)
  (define-key gnuplot-mode-map (kbd "C-x C-i") `get-information-in-gnuplot-for-selected)
  ;; (define-key gnuplot-mode-map (kbd "C-x C-r") `exec-function-in-gnuplot)
  (define-key gnuplot-mode-map (kbd "C-x C-r") `exec-block-in-gnuplot)
  (define-key gnuplot-mode-map (kbd "C-c t") `set-gnuplot-term-name)
  (define-key gnuplot-mode-map (kbd "C-c i") `import-gnuplot-file)
  (define-key gnuplot-mode-map (kbd "C-c C-i") `gnuplot-insert-snippet)
  ;; (define-key gnuplot-mode-map (kbd "C-x j") `gnuplot-insert-snippet)
  (define-key gnuplot-mode-map (kbd "C-c c") `cd-to-directory-of-current-file-in-gnuplot)
  (define-key gnuplot-mode-map (kbd "C-c d") `find-doc--selected-in-gnuplot)
  (define-key gnuplot-mode-map (kbd "C-c p") `czq-gnuplot-autocomplete)
  (define-key gnuplot-mode-map (kbd "C-c u") `czq-gnuplot-update-imported-module)
  (define-key gnuplot-mode-map (kbd "C-c p") `gene-gnuplot)
  )

(defun alist-keys (alist)
  (mapcar 'car alist))

;; (setq alist-gnuplot-greek-letter '(("Alpha" . "A") ("Beta" . "B")) )
;;
(setq alist-gnuplot-greek-letter-raw '(("A"."Alpha")("N"."Nu")("a"."alpha")("n"."nu")("B"."Beta")("O"."Omicron")("b"."beta")("o"."omicron")("C"."Chi")("P"."Pi")("c"."chi")("p"."pi")("D"."Delta")("Q"."Theta")("d"."delta")("q"."theta")("E"."Epsilon")("R"."Rho")("e"."epsilon")("r"."rho")("F"."Phi")("S"."Sigma")("f"."phi")("s"."sigma")("G"."Gamma")("T"."Tau")("g"."gamma")("t"."tau")("H"."Eta")("U"."Upsilon")("h"."eta")("u"."upsilon")("I"."iota")("W"."Omega")("i"."iota")("w"."omega")("K"."Kappa")("X"."Xi")("k"."kappa")("x"."xi")("L"."Lambda")("Y"."Psi")("l"."lambda")("y"."psi")("M"."Mu")("Z"."Zeta")("m"."mu")("z"."zeta")))
;; reverse key and value
(setq alist-gnuplot-greek-letter (mapcar (lambda (x) (cons (cdr x)  (car x))) alist-gnuplot-greek-letter-raw))


(defun czq-gnuplot-insert-greek-letter ()
  "insert greek letter in gnuplot"
  (interactive "")
  (setq czq-greek-letter (completing-read "choose greek letter" (alist-keys alist-gnuplot-greek-letter)))
  (setq czq-gnuplot-greek-letter (cdr (assoc czq-greek-letter alist-gnuplot-greek-letter)))  
  (insert (format "{/Symbol %s}" czq-gnuplot-greek-letter))
  )



