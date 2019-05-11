(provide `czq-latex)

(setq czq-latex-plot-patern "\\documentclass{standalone}\n\\usepackage{tikz}\n\\usetikzlibrary{arrows,decorations.markings,decorations.pathmorphing,patterns,positioning,calc,shapes}\n\\usepackage{adjustbox,resizegather}\\usepackage{xparse}\n\\usepackage{pgfplots}\n\\usepackage{pgfplotstable}\n\\begin{document}\n\\begin{tikzpicture}\n\n\n\\end{tikzpicture}\n\\end{document}\n")

(setq czq-latex-pgf-table-read-from-one-file "\\pgfplotstableread{}{\\%s}\n")

(setq czq-latex-pgf-table-read-from-two-files "\\pgfplotstableread{}{\\%s}\n\\pgfplotstableread{}{\\%sb}\n\\pgfplotstablecreatecol[copy column from table={\\%sb}{[index] 0}] {1} {\\%s}")

(defun insert-pgf-table-read-from-two-files (name)
  (interactive "sname")
  (insert (format czq-latex-pgf-table-read-from-two-files name name name name name))
  )

(defun insert-pgf-table-read-from-one-file (name)
  (interactive "sname")
  (insert (format czq-latex-pgf-table-read-from-one-file name)))
(defun insert-latex-code-snippet (tag)
  (interactive "splot(p) read one or two(r(t))")
  (cond
   ((string= tag "p") (insert czq-latex-plot-patern))
   ((string= tag "rt") (call-interactively `insert-pgf-table-read-from-two-files))
   ((string= tag "r") (call-interactively `insert-pgf-table-read-from-one-file))
   ))

(defun compile-latex-to-pdf ()
  (interactive)
  (save-buffer)
  (shell-command (format "texfot pdflatex %s" (buffer-file-name))))

(defun define-latex-keys ()
  (interactive)
  (define-key latex-mode-map (kbd "C-c l")  `insert-latex-code-snippet)
  (define-key latex-mode-map (kbd "C-c p")  `compile-latex-to-pdf))




