;; use the following code to load libraries
;; (add-to-list 'load-path "~/.emacs.d/lisp/")
;; (require 'multi-term)
;; (require `insert-code-snippet)
;; (require `my-settings)
;; (require `edit-server)


(provide `my-settings)

(require `package-settings)

;; (setq gdb-many-windows 1)

(global-set-key "\M-?" 'etags-select-find-tag-at-point)
(global-set-key "\M-." 'etags-select-find-tag)
(add-to-list `auto-mode-alist `("\\.pyx\\'" . cython-mode))
(add-to-list `auto-mode-alist `("\\.h\\'" . c++-mode))
(add-to-list `auto-mode-alist `("\\.pxd\\'" . cython-mode))
;; javascript mode
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;;the autocomplete does not useful
;; (add-hook 'js2-mode-hook 'ac-js2-mode)
;; (add-hook `js2-mode-hook `ac-js2-setup-auto-complete-mode)
;; (add-hook 'js2-mode-hook '(lambda () 
;; 			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
;; 			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
;; 			    (local-set-key "\C-cb" 'js-send-buffer)
;; 			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
;; 			    (local-set-key "\C-cl" 'js-load-file-and-go)
;; 			    (local-set-key "\C-c\C-r" 'js-send-region)
;; 			    ))

;; (setq elpy-rpc-python-command "/home/chengzhengqian/anaconda3/bin/python")
;; (setq elpy-rpc-python-command "/home/chengzhengqian/miniconda3/bin/python")

(if (file-exists-p "/home/chengzhengqian/anaconda3/bin/python")
    (setq elpy-rpc-python-command "/home/chengzhengqian/anaconda3/bin/python"))
(if (file-exists-p "/home/chengzhengqian/miniconda3/bin/python")
    (setq elpy-rpc-python-command "/home/chengzhengqian/miniconda3/bin/python"))

;; it seems that we need to load julia mode here
(require `julia-mode)

(add-to-list 'load-path "~/.emacs.d/lisp/cython-cpp/")
(add-to-list 'load-path "~/.emacs.d/lisp/cuda-cpp/")
(add-to-list 'load-path "~/.emacs.d/lisp/haskell/")
(add-to-list 'load-path "~/.emacs.d/lisp/html/")
(add-to-list 'load-path "~/.emacs.d/lisp/java/")
(require 'multi-term)
(require `cython-cpp)
(require `cuda-cpp)
(require `czq-haskell)
(require `html)
;; gdb is fine, seems
;; (require `realgud)
(setq gdb-many-windows nil)
(require `java-snippet)
(require `insert-code-snippet)

;; using this as necessary
;; (keyboard-translate ?\C-h ?\C-?)

(tool-bar-mode -1)
(menu-bar-mode -1)
;; on some case, scroll-bar is not defined
(if (boundp `scroll-bar-mode) (scroll-bar-mode -1))
(blink-cursor-mode -1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(electric-pair-mode)
(show-paren-mode 1)
(setq show-paren-delay 0)

(display-time-mode 1)
;; (setq display-time-format "%H:%M")
(setq display-time-format "%H:%M %a, %b %d, %Y")
(display-time-update)
(setq column-number-mode t)
(setq ring-bell-function 'ignore)

(setq tags-revert-without-query 1)
;;(setq tags-table-list `("/home/chengzhengqian/share_workspace/QL/DualProjection"))

;;I don't know why, but I need to add this to make it work in new computers, any way, everthing works now
;; just use elpy
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)   

(setq tags-table-list nil)

(global-set-key (kbd "C-c C-m") 'set-mark-command)
(global-set-key (kbd "C-c RET") 'set-mark-command)
(global-set-key (kbd "C-c a") 'beginning-of-buffer)
(global-set-key (kbd "C-c e") 'end-of-buffer)
(global-set-key (kbd "C-c j") 'imenu)
(global-set-key (kbd "C-x t") 'new-shell-or-term)
;; it seems eww has a better rendering
;; (global-set-key (kbd "C-c b") 'w3m-search)
;; update eww keys
(global-set-key (kbd "C-c b") 'eww-search-region)

;; we need to update the treatment of region, in case there is not region defined
;; (defun eww-search-region (beginning end)
;;   (interactive "r")
;;   (if (use-region-p)
;;       (eww (buffer-substring beginning end))
;;     (call-interactively `eww)))
(defun eww-search-region ()
  (interactive "")
  (if (use-region-p)
      (eww (buffer-substring  (region-beginning) (region-end)))
    (call-interactively `eww)))

;; (defun eww-search-in-handian (beginning end)
;;   (interactive "r")
;;   (if (use-region-p)
;;       (eww (format "https://www.zdic.net/hant/%s" (buffer-substring beginning end)))
;;     (call-interactively `eww)))
(defun eww-search-in-handian ()
  (interactive "")
  (if (use-region-p)
      (eww (format "https://www.zdic.net/hant/%s" (buffer-substring  (region-beginning) (region-end))))
    (call-interactively `eww)))


(global-set-key (kbd "C-c B") 'eww-search-in-handian)
;; (global-set-key (kbd "C-c B") 'w3m-search-new-session)
;; (global-set-key (kbd "<C-tab>") `w3m-next-buffer)
;; (global-set-key (kbd "<C-iso-lefttab>") `w3m-previous-buffer)
;; (global-set-key (kbd "C-c v") 'handian-search)
;; (global-set-key (kbd "C-h j") 'javadoc-lookup)

(defun handian-search (start end)
  (interactive "rWords:")
  (w3m-search w3m-search-default-engine (concat (buffer-substring (region-beginning) (region-end)) " 漢典"))
  )

(setq CZQ-term-name-pattern "t\\(.*\\)")
(defun new-shell-or-term (name)
     "wrap for new-shell or new-term"
     (interactive "sname(t[.*] for term):")
     (if (string-match-p  CZQ-term-name-pattern name)
	 (new-term name)
	 (new-shell name)
	 )
     )
;; terminal 
(defun new-shell (name)
  (interactive "sname:")
  (shell)
  (rename-buffer name)
  ;; (czq-set-buffer-local-mono)
  (message (format "start shell %s." name))
  )
;; update this function to change the new term behavior
(defun new-term-predefined (name)
  (cond
   ((string-match-p ".*julia.*" name) "julia --color=no")
   ((string-match-p ".*wolfram.*" name) "wolframscript")
   ((string-match-p ".*python.*" name) "source ~/add_conda.sh\nipython")
   (t "echo update new-term-predefined to change this behavior!")
   ))

;; (new-term-predefined "good")

(defun new-term (name)
  (interactive "sname:")
  (term "/bin/bash")
  (rename-buffer name)
  ;; we need to setup some predefined behavior
  ;; (czq-set-buffer-local-mono)
  (term-send-raw-string (format "%s\n" (new-term-predefined name)))
  (message (format "start term %s." name))
  )

(defun clear-term ()
  (interactive)
  (term-line-mode)
  (mark-whole-buffer)
  (call-interactively `kill-region)
  (term-char-mode)
  (term-send-raw-string "\n"))
;; intero is quite slow, disable it
;; (add-hook `haskell-mode-hook `intero-mode)


;; use this to set the tags
;; (setq tags-table-list `("/home/chengzhengqian/cloud/TAG_INC","/home/chengzhengqian/cloud/TAG_CPP"    ,"/home/chengzhengqian/cloud/TAG_LLVM"))
(setq tags-table-list `())



(require `my-dict)
;; disable w3m-agent 
;; (require `w3m-agent)
;; set eww

(setq eww-search-prefix "https://www.google.com/search?q=")
(defun czq-toggle-node ()
  (interactive)
  (progn
    (end-of-line)
    (call-interactively `origami-toggle-node)
    )
  )

;; this is the previous binding, remove them in the future
;; (global-set-key (kbd "C-c t") `czq-toggle-node)
(global-set-key (kbd "C-c C-t") `origami-close-all-nodes)
(global-set-key (kbd "C-c T") `origami-open-all-nodes)
;; motivated from vs code
;; this is not useful, we just one level and it is enought
;; (global-set-key (kbd "C-}") `czq-toggle-node) 
;; (global-set-key (kbd "C-{") `origami-close-all-nodes)
(global-set-key (kbd "C-}") `origami-open-node-recursively) 
(global-set-key (kbd "C-{") `origami-close-node-recursively)
;; to please cygwin login
;; (global-set-key (kbd "\235") `czq-toggle-node)
;; (global-set-key (kbd "\233") `origami-close-all-nodes)
;; ;; (global-set-key (kbd "C-c T") `origami-open-all-nodes)
;; update the elpy's key binding
;; (define-key elpy-mode-map   (kbd "C-c C-t") `origami-close-all-nodes)
(define-key elpy-mode-map   (kbd "M-.") `elpy-goto-definition)

;; add ggtags
(add-hook 'c++-mode-hook 'ggtags-mode)
(add-hook 'c-mode-hook 'ggtags-mode)
;; for gdb
(setq gdb-many-windows 1)

(defun remap-fsharp-key ()
  (define-key fsharp-mode-map   (kbd "C-c C-t") `origami-close-all-nodes)
  (define-key fsharp-mode-map   (kbd "C-c i") `fsharp-ac/show-tooltip-at-point)
)
;; add code enbrace
(add-hook 'c++-mode-hook 'origami-mode)
(add-hook 'c-mode-hook 'origami-mode)
(add-hook 'python-mode-hook 'origami-mode)
(add-hook 'fsharp-mode-hook 'remap-fsharp-key)
(add-hook 'fsharp-mode-hook 'origami-mode)


(add-hook `haskell-mode `origami-mode)

(defun change-term-mode ()
  (interactive)
  (if (term-in-line-mode) 
      (term-char-mode)
      (term-line-mode)))


(defun change-buffer-for-term ()
  (interactive)
  (term-set-escape-char ?\C-x)
  (define-key term-raw-map (kbd "C-x b") `switch-to-buffer)
  (define-key term-raw-map (kbd "C-x o") `other-window)
  (define-key term-raw-map (kbd "C-x j") `change-term-mode)
  (define-key term-raw-map (kbd "C-x r") `run-cling)
  )

(define-key term-mode-map (kbd "C-x j") `change-term-mode)

(add-hook `term-mode-hook `change-buffer-for-term)




;; set the lisp system
(setq inferior-lisp-program "sbcl")
(setq slime-contribs `(slime-fancy))
(setq haskell-program-name "stack ghci")

(require `cling)
;; <<<<<<< Updated upstream
(require `czq-python)
(add-to-list 'auto-mode-alist '("\\.jl\\'" . julia-mode))
(require `czq-julia)

;; (require `python)


;; there are some bugs
;; (require `mu4e-settings) 
;;  this is not set on every device

(add-to-list `load-path "~/.emacs.d/lisp/scala")
(require `czq-scala)
(add-to-list `load-path "~/.emacs.d/lisp/nodejs")
(require `czq-nodejs)
(require `czq-jsos)
(require `czq-latex)


;; flex
(add-to-list 'auto-mode-alist '("\\.l\\'" . c-mode))
(setq nrepl-use-ssh-fallback-for-remote-hosts `t)
(require `czq-java)
(require `czq-kotlin)

(require `regexpl)
(require `czq-gnuplot)

(add-to-list `load-path "~/.emacs.d/lisp/haskell")
(require `czq-haskell)
(require `czq-zoom)

;;  for quick command line support

(require `czq-desktop)

(defun czq-activate-pyim-as-cangjie ()
  (interactive)
  (require `pyim)
  (require `pyim-basedict)
  (require 'pyim-cangjie5dict)
  (pyim-basedict-enable)
  (pyim-cangjie5-enable)
  (setq pyim-default-scheme 'cangjie)
  (setq pyim-enable-shortcode nil)
  )

(require `czq-eww)
;; recreate scrat
(defun create-scratch-buffer ()
  "create a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(require `czq-scheme)

;; mathematica

(setq wolfram-program "wolframscript")
(setq wolfram-path "~/.WolframEngine/Applications")
(require `czq-wolfram)


(add-to-list 'auto-mode-alist '("\.m$" . wolfram-mode))

(require `czq-org)
(require `czq-proxy)

(add-to-list `load-path "~/.emacs.d/lisp/server")
(require `czq-server)
;; this is needed for windows synergy server
(setq x-alt-keysym `meta)

;; yasnippet

(require 'yasnippet)
(yas-global-mode 1)

;;  set date time
;; this fixed the eglot 
;; (defun project-root (project)
;;     (car (project-roots project)))

(require `czq-imenu-list)

;; ivy
(ivy-mode t)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(global-set-key (kbd "C-s") `swiper-isearch) 
;; 
;; (global-set-key (kbd "C-s") `isearch-forward) 
(global-set-key (kbd "M-x") `counsel-M-x)
;; (global-set-key (kbd "M-x") `execute-extended-command)
;; others seems not necessary
(global-set-key (kbd "C-c j") `counsel-imenu)

;;  somehow, we need to put this frist, otherwise, they use company-capf
;;  use `(x xx xxx)  for a group
(push `company-clang company-backends)
(global-set-key (kbd "C-M-i") `company-complete)


(defun czq-set-terminal-vertical-border-style ()
  (interactive)
  (set-face-background 'vertical-border "brightblack")
  (set-face-foreground 'vertical-border (face-background 'vertical-border)))

(require `czq-switch-frame)
(global-set-key (kbd "C-c s") `czq-switch-with-other-frame)

(defun czq-load-eaf ()
  (interactive)
  (add-to-list 'load-path "~/Application/emacs-application-framework/")
  (require 'eaf)
  (require 'eaf-browser)
  (require 'eaf-pdf-viewer)
  (require 'eaf-terminal)
  (require 'eaf-demo)
  (setq eaf-pdf-dark-mode nil)
  (setq eaf-browser-dark-mode t)
  (setq eaf-browser-default-zoom 1.5)
  ;; use android user agent
  (setq eaf-browser-pc-user-agent "Mozilla/5.0 (Linux; Android 12) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Mobile Safari/537.36")
  )
