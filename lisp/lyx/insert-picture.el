(setq format-schroedinger
      "\\begin_layout Itemize
\\begin_inset Graphics
	filename schroedinger/plot/quadratic_mix_type_crx_eg_egs_id_%d_value_ng_C_0.%d00000_alpha_0.%d00000.png
	scale 20

\\end_inset


\\begin_inset Graphics
	filename schroedinger/plot/quadratic_mix_type_crx_eg_egs_id_%d_value_ngs_C_0.%d00000_alpha_0.%d00000.png
	scale 20

\\end_inset


\\begin_inset Graphics
	filename schroedinger/plot/quadratic_mix_type_crx_eg_egs_id_%d_value_l_C_0.%d00000_alpha_0.%d00000.png
	scale 20

\\end_inset


\\end_layout")

;; some examples to use iteration in elisp
(defun insert-schroedinger ()
  (interactive)
  (dolist (id (number-sequence 7 7) nil)
    (dolist (C (number-sequence 0 9) nil)
      (dolist (alpha (number-sequence 1 9) nil)
	(insert (format format-schroedinger id C alpha id C alpha id C alpha))
	))))

