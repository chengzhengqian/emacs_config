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
  (set-frame-font "DejaVu Sans Mono-18")
)
