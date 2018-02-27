(provide `insert-code-snippet)

(setq elpy-rpc-python-command "/home/chengzhengqian/anaconda3/bin/python")

(add-to-list 'load-path "~/.emacs.d/lisp/cython-cpp/")
(add-to-list 'load-path "~/.emacs.d/lisp/cuda-cpp/")
(add-to-list 'load-path "~/.emacs.d/lisp/haskell/")
(add-to-list 'load-path "~/.emacs.d/lisp/html/")
(require `cython-cpp)
(require `cuda-cpp)
(require `haskell-czq)
(require `html)
(require `realgud)

(defun insert-snippet-cpp (code)
  (interactive "sinsert i(mplement(io,implement only) and declare) cm(cython module) n(amespace) cl(ass) w(wrap) h(ead prevent) fl(or loop) d(ouble dp:*, f,fp, float) g(__global__) #(include) l(cublas h, handle v,set variable) c(comments /**/):")
  (cond
   ((string= code "cm") (call-interactively `insert-cpp-python-module-from-head-file))
   ((string= code "h") (call-interactively `insert-code-cpp-head-prevent-string))
   ((string= code "n") (call-interactively `insert-code-cpp-namespace))
   ((string= code "cl") (call-interactively `insert-code-cpp-class))
   ((string= code "io") (call-interactively `insert-code-cpp-implement-function))
   ((string= code "i") (call-interactively `insert-code-cpp-implement-function-with-declare-in-pxd))
   ((string= code "w") (call-interactively `insert-code-cpp-implement-function-and-wrap-in-cython))
   ((string= code "fl") (call-interactively `insert-code-cpp-for-loop))
   ((string= code "d") (insert "double "))
   ((string= code "dp") (insert "double* "))
   ((string= code "f") (insert "float "))
   ((string= code "fp") (insert "float* "))
   ((string= code "c") (progn (insert "/* */") (backward-char 2) ))
   ((string= code "g") (insert "__global__ "))
   ((string= code "n") (insert "__global__ "))
   ((string= code "#") (insert "#include "))
   ((string= code "lh") (call-interactively `insert-cublasHandle-code-with-init-and-destroy))
   ((string= code "lv") (call-interactively `insert-cublasDeviceVariable-code-with-init-and-destroy))

   ))

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun utilities-for-file (file)
  (interactive "sinsert: s(ave all) m(makefile, mc[clean], mn[No warning] r(revert no confirm)) rn(rename file), mo(makefile,for so from cc):\n")
  (cond
   ((string= file "s") (call-interactively `cython-cpp-save-all-files))
   ((string= file "m") (call-interactively `cython-cpp-generate-makefile))
   ((string= file "mc") (insert "clean:\n\trm *.cc *.o *.so"))
   ((string= file "mn") (insert "para=-Wno-cpp"))
   ((string= file "r") (revert-buffer-no-confirm))
   ((string= file "rn") (call-interactively `rename-file-and-buffer))
   ((string= file "mn") (insert "para=-Wno-cpp"))
   ((string= file "mo") (insert CZQ_cython_c_makefile_format_for_so_from_cc))
   ))


(defun insert-python-code (code)
  (interactive "scython(ci) ti(import tensorflow as tf) tp(tf.placeholder) tf(tf.float32) ts(tf.square), c(comment '''''') u(rl) t(   ), m(if ..main..) cn(connect to buffer ein) r(reload)")
  (cond ((string= code "ci") (insert "import numpy as np\ncimport numpy as np\n"))
	((string= code "ti") (insert "import tensorflow as tf\n"))
	((string= code "tp") (insert "tf.placeholder"))
	((string= code "tf") (insert "tf.float32"))
	((string= code "c") (progn (insert "\'\'\'\'\'\'") (backward-char 3)))
	((string= code "cn") (call-interactively `ein:connect-to-notebook-buffer))
	((string= code "u") (insert "url = \"\""))
	((string= code "t") (insert "    "))
	((string= code "m") (insert "if __name__==\"__main__\" : "))
	((string= code "r") (insert  "from importlib import reload as r"))
	))

(defun insert-haskell-code (code)
  (interactive "sd(efine) a(->) n(notion ::) t(type =>) l(language {-# #-})")
  (cond
   ((string= code "d") (call-interactively `insert-haskell-definition))
   ((string= code "a") (insert " -> "))
   ((string= code "n") (insert " :: "))
   ((string= code "t") (insert " => "))
   ((string= code "l") (progn (insert "{-# LANGUAGE  #-}") (backward-char 4)))
   ))

(defun insert-html-code (code)
  (interactive "st(ag) j(query tmpl) c(anvas) s(cript) f(function)")
  (cond ((string= code "t") (call-interactively `insert-xml-tag))
	((string= code "j") (call-interactively `insert-jquery-empty-template))
	((string= code "f") (call-interactively `insert-javascript-function))
	((string= code "c") (insert-xml-tag "canvas"))
	((string= code "s") (insert-xml-tag "script"))
	))

(defun format-code ()
  (interactive)
  (setq CZQ_file_extension (file-name-extension (buffer-name)))
  (cond

   ((string-prefix-p  "h" CZQ_file_extension) (call-interactively `format-cpp-code))
   ((string-prefix-p "c" CZQ_file_extension) (call-interactively `format-cpp-code))
   ((string-prefix-p "py" CZQ_file_extension ) (call-interactively `format-python-code))
   ((string-prefix-p  "js" CZQ_file_extension) (call-interactively `format-javascript-code))
   ))


(defun format-javascript-code ()
  (interactive)
  (save-buffer)
  (call-process "js-beautify" nil nil nil  (buffer-file-name) "-r") 
  (revert-buffer-no-confirm)
  (message "js-beautify has formated code")
  )

(defun realgud-pdb ()
  (interactive)
  (save-buffer)
  (realgud:pdb (format "pdb %s" (buffer-file-name)))
  )
(defun realgud-gdb ()
  (interactive)
  (save-buffer)
  (realgud:gdb (format "gdb %s" (file-name-sans-extension (buffer-file-name))))
  )
(global-set-key (kbd "C-c y") `realgud-short-key-mode)

(defun realgud-run ()
  (interactive)
  (setq CZQ_file_extension (file-name-extension (buffer-name)))
  (cond
   ((string= CZQ_file_extension "cpp") (call-interactively `realgud-gdb))
   ((string= CZQ_file_extension "h") (call-interactively `realgud-gdb))
   ((string= CZQ_file_extension "py") (call-interactively `realgud-pdb))
   ))

(global-set-key (kbd "C-c c") `insert-snippet-cpp)
(global-set-key (kbd "C-c p") `insert-python-code)
(global-set-key (kbd "C-c h") `insert-haskell-code)
(global-set-key (kbd "C-c w") `insert-html-code)
(global-set-key (kbd "C-c f") `utilities-for-file)
(global-set-key (kbd "C-c m") `format-code)
(global-set-key (kbd "C-c r") `realgud-run)
(global-set-key (kbd "C-c s") `cython-cpp-goto-function-in-target-file)
;; (global-set-key (kbd "C-c t") `generate_test_files)



  
(defun insert-code-cpp-for-loop (iter max)
  (interactive "siter:\nsmax:\n")
  (insert (format "for(int %s=0; %s<%s; %s++){  }" iter iter max iter))
  (backward-char 3)
  )
