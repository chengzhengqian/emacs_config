(provide 'czq-zoom)
;; http://blog.vivekhaldar.com/post/4809065853/dotemacs-extract-interactively-change-font-size
(defun czq-zoom-in ()
  "Increase font size by 10 points"
  (interactive)
  (set-face-attribute 'default (selected-frame)
                      :height
                      (+ (face-attribute 'default :height)
                         10)))

(defun czq-zoom-out ()
  "Decrease font size by 10 points"
  (interactive)
  (set-face-attribute 'default (selected-frame)
                      :height
                      (- (face-attribute 'default :height)
                         10)))

;;  add init function to carta
(defun czq-zoom-for-carta ()
  "set zoom for carta"
  (interactive)
  (set-face-attribute 'default (selected-frame)
                      :height 125))

(defun czq-zoom-for-desktop ()
  "set zoom for desktop"
  (interactive)
  (set-face-attribute 'default (selected-frame)
                      :height 130))

(defun czq-zoom-for-c55 ()
  "set zoom for c55"
  (interactive)
  (set-face-attribute 'default (selected-frame)
                      :height 125))

(defun czq-zoom-for-w530 ()
  "set zoom for w530"
  (interactive)
  (set-face-attribute 'default (selected-frame)
                      :height 125))

(defun czq-zoom-for-acer ()
  (interactive)
  ;; (set-frame-font "DejaVu Sans Mono-19")
  (set-frame-font "Monospace Bold 10")
  ;; (set-frame-font "Loma Bold 10")
  ;; (set-frame-font "Ubuntu Bold 10")
  )

(defun czq-zoom-in-global ()
  "Increase font size by 10 points"
  (interactive)
  (set-face-attribute 'default nil
                      :height
                      (+ (face-attribute 'default :height)
                         10)))

(defun czq-zoom-out-global ()
  "Decrease font size by 10 points"
  (interactive)
  (set-face-attribute 'default nil
                      :height
                      (- (face-attribute 'default :height)
                         10)))

;; change font size, interactively
(global-set-key (kbd "C->") 'czq-zoom-in)
(global-set-key (kbd "C-<") 'czq-zoom-out)

(defun czq-set-mono-font ()
  (interactive)
  (set-frame-font "DejaVu Sans Mono-19")
  )

(defun czq-set-buffer-local-mono ()
  "Sets font in current buffer"
  (interactive)
  (defface tmp-buffer-local-face 
    '((t :family "DejaVu Sans Mono"))
    "monospace")
  (buffer-face-set 'tmp-buffer-local-face))

;; set the frame font
;; (set-frame-font "Mono-14")
;; (set-frame-font "Sans-14")
;; (set-frame-font "Ubuntu-14")
;; (set-frame-font "DejaVu Sans Mono 13")
;; (font-family-list)
