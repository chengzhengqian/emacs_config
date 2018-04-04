(provide `cython-cpp)
(setq CZQ_head_string_prev_double_format "#ifndef %s_H\n#define %s_H\n\n#endif\n\n")
(setq CZQ_cpp_namespace_format "namespace %s{\n\n}\n")
(setq CZQ_pxd_namespace_format "cdef extern from \"%s.h\" namespace \"%s\":\n\n\n")
(setq CZQ_namespace_end_format "####namespace:%s####")
(setq CZQ_namespace_end_reg_format "####namespace:\\(.*?\\)####")
(setq CZQ_cpp_class_format "  class %s{\n  public:\n    %s();\n\n  };\n")
(setq CZQ_pxd_class_format "    cdef cppclass %s:\n")
(setq CZQ_pyx_class_format "cdef class %s_p:\n    cdef %s* c_%s\n\n    def __cinit__(self):\n        self.c_%s = new %s()\n\n    def __dealloc__(self):\n        del self.c_%s\n\n")
(setq CZQ_class_end_format "++++class:%s++++namespace:%s++++")
(setq CZQ_class_end_reg_format "\\+\\+\\+\\+class:\\(.*?\\)\\+\\+\\+\\+namespace:\\(.*?\\)\\+\\+\\+\\+")
(setq CZQ_cpp_function_declare_reg_format " \\([^[:space:]]*?\\) \\([^[:space:]]*?\\)(\\(.*?\\));")
(setq CZQ_cpp_function_declare_message "%s %s(%s) is defined in class %s namespace %s")
(setq CZQ_cpp_function_implement_format "  %s %s::%s(%s){\n  }" )
(setq CZQ_pxd_function_declare_format "        %s %s(%s)\n" )
(setq CZQ_pxd_function_declare_format_constructor "        %s(%s)\n" )
(setq CZQ_pxd_function_static_decorator "        @staticmethod\n")
(setq CZQ_pyx_function_wrap_format "    def %s(self,%s):\n        return self.c_%s.%s(%s)\n\n\n" )
(setq CZQ_pyx_function_wrap_format_for_static "    @staticmethod\n    def %s(%s):\n        return %s.%s(%s)\n\n\n" )
(setq CZQ_pyx_replace_arg_test_for_empty ".+ .+")
(setq CZQ_cpp_comment_format "/* %s */")
(setq CZQ_python_comment_format "# %s #")
(setq CZQ_cpp_cpp_file_head_format "/****%s_CPP****/\n\#include\"%s.h\"\n")
(setq CZQ_cpp_pyx_file_head_format "##****%s_PYX****##\nfrom %s cimport *\n")
(setq CZQ_cpp_pxd_file_head_format "##****%s_PXD****##\n")

(setq CZQ_cython_cpp_makefile_format "%s.so:%s.o %s_p.o\n\tg++ -shared -pthread -o $@ $^  $(lib) \n%s.o:%s.cpp %s.h\n\tg++ -c -fPIC -O3 $(para) $(inc) -o $@ $<\n%s.cc:%s.pyx %s.pxd %s.h\n\tcython --cplus -o $@ $<\n%s_p.o:%s.cc\n\tg++ -c -fPIC -O3 $(para) -I/home/chengzhengqian/anaconda3/include/python3.6m  $(inc) -o $@ $<\n\n")
(setq CZQ_cython_cpp_makefile_format_with_cuda "%s.so:%s.o %s_p.o\n\tg++ -shared -pthread -o $@ $^  $(lib) -L/usr/local/cuda/lib64/ -lcudart\n%s.cu: %s.cpp\n\tln -sf $< $@\n%s.o:%s.cu %s.h\n\tnvcc -c  --compiler-options \"-fPIC -O3\" $(para) $(inc)-o $@ $<\n%s.cc:%s.pyx %s.pxd %s.h\n\tcython --cplus -o $@ $<\n%s_p.o:%s.cc\n\tg++ -c -fPIC -O3 $(para) -I/home/chengzhengqian/anaconda3/include/python3.6m   $(inc) -o $@ $<\n\n")

(setq CZQ_cython_c_makefile_format_for_so_from_cc "\n\tcython $< -o $(basename $<).cc\n\tgcc -shared -O3 -I/home/chengzhengqian/anaconda3/include/python3.6m  -o $@ -fPIC $(basename $<).cc"
      )
(setq CZQ_string_implement_func "//i")
(setq CZQ_string_implement_func_and_declare "//d")
(setq CZQ_string_implement_func_declare_and_wrap "//w")

(setq CZQ_cython_cpp_function_reg_in_h " \\([^[:space:]]*?\\)(.*?);")
;; (setq CZQ_cython_cpp_function_reg_in_cpp "::\\([^[:space:]]*?\\)(.*?) {")
(setq  CZQ_cython_cpp_function_reg_in_cpp "::\\(.*?\\)(.*?){")
(setq CZQ_cython_cpp_function_reg_in_pxd " \\([^[:space:]]*?\\)(.*?)")
(setq CZQ_cython_cpp_function_reg_in_pyx " \\([^[:space:]]*?\\)(.*?):")

(setq CZQ_cython_cpp_function_reg_format_in_h " %s(.*?);")
(setq CZQ_cython_cpp_function_reg_format_in_cpp "%s(.*?){")
(setq CZQ_cython_cpp_function_reg_format_in_pxd " %s(.*?)")
(setq CZQ_cython_cpp_function_reg_format_in_pyx " %s(.*?):")

(setq CZQ_cython_args_pointer_pattern "\\([^[:space:]]*?\\)\\*")
(setq CZQ_cython_args_pointer_pattern_for_variable "\\([^[:space:]]*\\)\\*\\([^[:space:]]*\\)")
(setq CZQ_cython_args_numpy_array_pattern "np.ndarray[%s, ndim=1, mode=\"c\"] ")
(setq CZQ_cython_args_numpy_array_call_pattern "&%s[0]")

(defun get-cpp-head-preventing-double-string ()
  (progn
    (setq CZQ_head_file_base (upcase (file-name-base buffer-file-name)))
    (format CZQ_head_string_prev_double_format CZQ_head_file_base CZQ_head_file_base))
  )

(defun insert-cpp-python-module-from-head-file ()
  "this will generate necessary files to build a standard cpp python module"
  (interactive)
  (insert-code-cpp-head-prevent-string)
  (insert-cython-cpp-file)
  (insert-cython-pxd-file)
  (insert-cython-pyx-file)
  )

(defun insert-cython-cpp-file ()
  (interactive)
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".cpp"))
    (beginning-of-buffer)
    (insert (format CZQ_cpp_cpp_file_head_format (upcase CZQ_head_file_base) CZQ_head_file_base))
    ))

(defun insert-cython-cpp-namespace (name)
  (interactive)
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".cpp"))
    (end-of-buffer)
    (insert-code-cpp-namespace-only name)
    ))

(defun insert-cython-pxd-namespace (name)
  "add cdef extern for namespace in pxd"
  (interactive)
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pxd"))
    (end-of-buffer)
    (insert-code-pxd-namespace-only name)
    ))

(defun insert-cython-pyx-file ()
  "set up cython wrap file"
  (interactive)
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pyx"))
    (beginning-of-buffer)
    (insert (format CZQ_cpp_pyx_file_head_format (upcase CZQ_head_file_base) CZQ_head_file_base))
    ))

(defun insert-cython-pxd-file ()
  "set up cpp declare for cython "
  (interactive)
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pxd"))
    (beginning-of-buffer)
    (insert (format CZQ_cpp_pxd_file_head_format (upcase CZQ_head_file_base) CZQ_head_file_base))
    ))
    
(defun insert-cython-cpp-class-ending (name)
  "insert class ending in .cpp file before namespace ending"
  (interactive "sname:")
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".cpp"))
    (beginning-of-buffer)
    (goto-cpp-namespace-ending CZQ_cpp_current_namespace)
    (insert (format CZQ_cpp_comment_format (format CZQ_class_end_format name CZQ_cpp_current_namespace)))
    (insert "\n\n\n")
    (previous-line)
    ))

(defun insert-cython-cpp-function ()
  "insert function before class ending"
  (interactive )
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".cpp"))
    (beginning-of-buffer)
    (goto-cpp-class-ending CZQ_cpp_current_class  CZQ_cpp_current_namespace)
    (insert (format CZQ_cpp_function_implement_format  CZQ_cpp_current_function_return CZQ_cpp_current_class CZQ_cpp_current_function_name CZQ_cpp_current_function_args))
    (insert "\n\n\n")
    (previous-line)    (previous-line)    (previous-line)
    ))

(defun insert-cython-pxd-function ()
  "insert function before class ending in pxd, add static method support"
  (interactive )
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pxd"))
    (beginning-of-buffer)
    (goto-cpp-class-ending CZQ_cpp_current_class  CZQ_cpp_current_namespace)
    (if (eq CZQ-cpp-cython-method-is-static nil)
	nil
      (progn (insert CZQ_pxd_function_static_decorator))
	)
    (if (string= CZQ_cpp_current_function_return "")
	(insert (format CZQ_pxd_function_declare_format_constructor  CZQ_cpp_current_function_name CZQ_cpp_current_function_args))
	(insert (format CZQ_pxd_function_declare_format  CZQ_cpp_current_function_return CZQ_cpp_current_function_name CZQ_cpp_current_function_args))

      )))

(defun insert-cython-pyx-function ()
  "insert wrap function before class ending in pyx"
  (interactive )
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pyx"))
    (beginning-of-buffer)
    (goto-cpp-class-ending CZQ_cpp_current_class  CZQ_cpp_current_namespace)
    (if (eq CZQ-cpp-cython-method-is-static nil)
	(setq CZQ_pyx_function_wrap_format_temp CZQ_pyx_function_wrap_format)
      (setq CZQ_pyx_function_wrap_format_temp CZQ_pyx_function_wrap_format_for_static)
      )
    (insert (format CZQ_pyx_function_wrap_format_temp   CZQ_cpp_current_function_name (replace-function-args-into-pyx-declare-form CZQ_cpp_current_function_args) CZQ_cpp_current_class   CZQ_cpp_current_function_name (replace-function-args-into-pyx-call-form CZQ_cpp_current_function_args) ))
    ))

(defun insert-cython-pxd-class (name)
  "insert class declare in .pxd file before namespace ending"
  (interactive "sname:")
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pxd"))
    (beginning-of-buffer)
    (goto-cpp-namespace-ending CZQ_cpp_current_namespace)
    (previous-line)
    (insert (format CZQ_pxd_class_format name))
    (insert (format CZQ_python_comment_format (format CZQ_class_end_format name CZQ_cpp_current_namespace)))
    (insert "\n\n\n")
    (previous-line)
    ))

(defun insert-cython-pyx-class (name)
  "insert warp class  in .pyx file "
  (interactive "sname:")
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pyx"))
    (end-of-buffer)
    (insert (format CZQ_pyx_class_format name name name name name name ))
    (insert (format CZQ_python_comment_format (format CZQ_class_end_format name CZQ_cpp_current_namespace)))
    (insert "\n")
    (previous-line)
    ))
  
(defun insert-code-cpp-head-prevent-string ()
  (interactive)
  (insert (get-cpp-head-preventing-double-string))
  (previous-line)  (previous-line)
  (previous-line)  (previous-line)
  )

(defun insert-code-cpp-namespace-only (name)
  (interactive "snamespace:")
  (insert (format CZQ_cpp_namespace_format name))
  (previous-line)
  (previous-line) 
  (insert "\n")
  (insert (format CZQ_cpp_comment_format (format CZQ_namespace_end_format name)))
  (previous-line)
  )

(defun insert-code-pxd-namespace-only (name)
  (interactive "snamespace:")
  (insert (format CZQ_pxd_namespace_format CZQ_head_file_base name))
  (insert (format CZQ_python_comment_format (format CZQ_namespace_end_format name)))
  (previous-line)
  (previous-line)
  (previous-line)
  )

(defun insert-code-cpp-namespace (name)
  "insert namespace in .h, and generate corresponding coes in .cpp .pxd"
  (interactive "snamespace:")
  (insert-code-cpp-namespace-only name)
  (insert-cython-cpp-namespace name)
  (insert-cython-pxd-namespace name)
  )

(defun insert-code-cpp-class-only (name)
  (interactive "sclass:")
  (insert (format CZQ_cpp_class_format name name))
  (previous-line)
  (previous-line)
  (insert "\n")
  (insert (format CZQ_cpp_comment_format (format CZQ_class_end_format name CZQ_cpp_current_namespace)))
  (previous-line)
  )

(defun insert-code-cpp-class (name)
  (interactive "sclass:")
  (save-excursion  (get-cpp-namespace))
  (insert-code-cpp-class-only name)
  (save-excursion
    (insert-cython-cpp-class-ending name)
    (insert-cython-pxd-class name)
    (insert-cython-pyx-class name)
    ))

(defun insert-code-cpp-implement-function ()
  "insert implement function in .cpp"
  (interactive)
  (get-cpp-function-declare-from-this-line)
  (insert-cython-cpp-function)
  (save-excursion (insert CZQ_string_implement_func))
  )

(defun insert-code-cpp-implement-function-with-declare-in-pxd()
  "insert implement function in .cpp"
  (interactive)
  (insert-code-cpp-implement-function)
  (insert-cython-pxd-function)
  (save-excursion (insert CZQ_string_implement_func_and_declare))
  )

(defun insert-code-cpp-implement-function-and-wrap-in-cython ()
  "insert implement function in .cpp and wrap in cython"
  (interactive)
  (insert-code-cpp-implement-function-with-declare-in-pxd)
  (insert-cython-pyx-function)
  (save-excursion (insert CZQ_string_implement_func_declare_and_wrap))
  )

(defun get-cpp-namespace ()
  "this will set CZQ_cpp_current_namespace and go to begining of the line of tne ending mark"
  (interactive)
  (search-forward-regexp CZQ_namespace_end_reg_format)
  (setq CZQ_cpp_current_namespace (match-string 1))
  (beginning-of-line)
  )
(defun get-cpp-namespace-class ()
  "this will set CZQ_cpp_current_namespace(class) and go to begining of the line of tne ending mark"
  (interactive)
  (search-forward-regexp CZQ_class_end_reg_format)
  (setq CZQ_cpp_current_class (match-string 1))
  (setq CZQ_cpp_current_namespace (match-string 2))
  (beginning-of-line)
  )

(defun get-cpp-static-information-from-this-line ()
  "get whether the method is static or "
  (interactive)
  (let ((current-line-txt (thing-at-point `line t)))
    (setq CZQ-cpp-cython-method-is-static (string-match-p "static " current-line-txt))

    )
  )
(defun get-cpp-function-declare-from-this-line ()
  "get class ending information, get function information"
  (interactive)
  (save-excursion (get-cpp-static-information-from-this-line))
  (save-excursion (get-cpp-namespace-class))
  (save-excursion
    (beginning-of-line)
    (search-forward-regexp CZQ_cpp_function_declare_reg_format)
    (setq CZQ_cpp_current_function_return (match-string 1))
    (setq CZQ_cpp_current_function_name (match-string 2))
    (setq CZQ_cpp_current_function_args (match-string 3))
    (message (format CZQ_cpp_function_declare_message CZQ_cpp_current_function_return CZQ_cpp_current_function_name CZQ_cpp_current_function_args CZQ_cpp_current_class CZQ_cpp_current_namespace))
    ))

(defun goto-cpp-namespace-ending (name)
  "this will go to begining of the line of tne ending mark"
  (interactive "sname:")
  (search-forward (format CZQ_namespace_end_format name))
  (beginning-of-line)
  )

(defun goto-cpp-class-ending (class_name namespace_name)
  "this will  go to begining of the line of tne ending mark for class in given namespace"
  (interactive "sclass:\nsnamespace:")
  (search-forward (format CZQ_class_end_format class_name namespace_name))
  (beginning-of-line)
  )

(defun format-python-code ()
  (interactive)
  (save-buffer)
  (call-process "autopep8" nil nil nil "-i" (buffer-name))
  (revert-buffer-no-confirm)
  (message "autopep8 has formated code")
  )

(defun format-cpp-code ()
  (interactive)
  (save-buffer)
  (call-process "clang-format" nil nil nil "-i" (buffer-name))
  (revert-buffer-no-confirm)
  (message "clang-format has formated code")
  )

(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))


(defun cython-cpp-save-all-files ()
  (interactive)
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".h"))
    (save-buffer))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".cpp"))
    (save-buffer))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pxd"))
    (save-buffer))
  (save-window-excursion
    (find-file (concat CZQ_head_file_base  ".pyx"))
    (save-buffer)))


(defun cython-cpp-generate-makefile ()
  (interactive)
  (setq CZQ_head_file_directory (file-name-directory  buffer-file-name))
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_directory  "makefile"))
    (end-of-buffer)
    (insert (format CZQ_cython_cpp_makefile_format  CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base  CZQ_head_file_base  CZQ_head_file_base))
    ))

(defun cython-cpp-generate-makefile-with-cuda ()
  (interactive)
  (setq CZQ_head_file_directory (file-name-directory  buffer-file-name))
  (setq CZQ_head_file_base (file-name-base buffer-file-name))
  (save-window-excursion
    (find-file (concat CZQ_head_file_directory  "makefile"))
    (end-of-buffer)
    (insert (format CZQ_cython_cpp_makefile_format_with_cuda  CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base  CZQ_head_file_base  CZQ_head_file_base CZQ_head_file_base CZQ_head_file_base))
    ))

(defun replace-function-args-into-call-form (arg)
  (interactive "s:arg")
  (progn
  (setq CZQ_arg_list (split-string arg "[ ,]+"))
  (setq CZQ_arg_length (length CZQ_arg_list))
  (setq CZQ_call_index_list (number-sequence 1 CZQ_arg_length 2))
  (mapconcat `identity  (mapcar (lambda (n) (nth n CZQ_arg_list)) CZQ_call_index_list)
 ", ")
  ))

(defun replace-function-args-into-pyx-declare-form (arg)
  "basically, map f* into numpy array in declaretion, add support for f* a or f *a"
  (interactive "s:arg")
  (if (string-match-p CZQ_pyx_replace_arg_test_for_empty arg)
  (progn
    (setq CZQ_arg_list (split-string arg "[ ,]+"))
    (setq CZQ_arg_length (length CZQ_arg_list))
    (setq CZQ_count 0)
    (setq CZQ_call_index_list (number-sequence 1 CZQ_arg_length 2))
    (while (< CZQ_count CZQ_arg_length)
      (if (equal (mod CZQ_count 2) 0)
	  (progn
	    (setq CZQ_args_type (nth CZQ_count CZQ_arg_list))
	    (if
		(string-match-p CZQ_cython_args_pointer_pattern CZQ_args_type)
		(progn
		 (string-match CZQ_cython_args_pointer_pattern CZQ_args_type)
		 (setq CZQ_args_numpy_type (match-string 1 CZQ_args_type))
		 (setf (nth (+ 1 CZQ_count) CZQ_arg_list)
		       (concat (format CZQ_cython_args_numpy_array_pattern
				       CZQ_args_numpy_type)
			       (nth (+ 1 CZQ_count) CZQ_arg_list))))
	      (progn
		(setf (nth (+ 1 CZQ_count) CZQ_arg_list)
		       (concat  (nth CZQ_count CZQ_arg_list) " "
			       (nth (+ 1 CZQ_count) CZQ_arg_list))))))
	(progn
	  (setq CZQ_args_type_name (nth CZQ_count CZQ_arg_list))
	  (if
	      (string-match-p CZQ_cython_args_pointer_pattern_for_variable CZQ_args_type_name)
	      (progn
		(string-match CZQ_cython_args_pointer_pattern_for_variable CZQ_args_type_name)
		(setq CZQ_arg_numpy_type (nth (- CZQ_count 1) CZQ_arg_list))
		(setq CZQ_arg_numpy_name (match-string 2 CZQ_args_type_name))
		(setf (nth CZQ_count CZQ_arg_list)
		      (concat (format CZQ_cython_args_numpy_array_pattern CZQ_arg_numpy_type ) CZQ_arg_numpy_name)))
	    nil
	    )))
      (setq CZQ_count (+ CZQ_count 1))
      )
    (mapconcat `identity  (mapcar (lambda (n) (nth n CZQ_arg_list)) CZQ_call_index_list)
 ", ")
    )
  arg
  )
  )
  

(defun replace-function-args-into-pyx-call-form (arg)
  "basically, map f* into numpy array; notice this is not always right, as some format code tool prefer int *a, instead of int* a, so we need to modify code to suitable for these cases"
  (interactive "s:arg")
  (if (string-match-p CZQ_pyx_replace_arg_test_for_empty arg)
  (progn
    (setq CZQ_arg_list (split-string arg "[ ,]+"))
    (setq CZQ_arg_length (length CZQ_arg_list))
    (setq CZQ_count 0)
    (setq CZQ_call_index_list (number-sequence 1 CZQ_arg_length 2))
    (while (< CZQ_count CZQ_arg_length)
      (if
	  (equal (mod CZQ_count 2) 0)
	  (progn
	    (setq CZQ_args_type (nth CZQ_count CZQ_arg_list))
	    (if (string-match-p CZQ_cython_args_pointer_pattern CZQ_args_type)
	       (progn
		 (string-match CZQ_cython_args_pointer_pattern CZQ_args_type)
		 (setq CZQ_args_numpy_type (match-string 1 CZQ_args_type))
		 (setf (nth (+ 1 CZQ_count) CZQ_arg_list)
		       (format CZQ_cython_args_numpy_array_call_pattern (nth (+ 1 CZQ_count) CZQ_arg_list))))
	       nil)
	    )
	(progn
	  (setq CZQ_args_type_name (nth CZQ_count CZQ_arg_list))
	  (if
	      (string-match-p CZQ_cython_args_pointer_pattern_for_variable CZQ_args_type_name)
	      (progn
		(string-match CZQ_cython_args_pointer_pattern_for_variable CZQ_args_type_name)
		(setq CZQ_arg_numpy_name (match-string 2 CZQ_args_type_name))
		(setf (nth CZQ_count CZQ_arg_list) (format CZQ_cython_args_numpy_array_call_pattern CZQ_arg_numpy_name)
		     ))
	    nil
	    ))
	)
      (setq CZQ_count (+ CZQ_count 1))
      )
  (mapconcat `identity  (mapcar (lambda (n) (nth n CZQ_arg_list)) CZQ_call_index_list)
 ", ")
  )
  arg
  )
  )

(defun get-function-name ()
  "get the function name in .h, .cpp, .pxd, .pyx"
  (interactive)
  (setq CZQ_current_buffer_extension (file-name-extension (buffer-name)))
  (save-excursion
    (end-of-line)
    (cond
     ((string= CZQ_current_buffer_extension "h") (search-backward-regexp CZQ_cython_cpp_function_reg_in_h))
     ((string= CZQ_current_buffer_extension "cpp") (search-backward-regexp CZQ_cython_cpp_function_reg_in_cpp))
     ((string= CZQ_current_buffer_extension "pxd") (search-backward-regexp CZQ_cython_cpp_function_reg_in_pxd))
     ((string= CZQ_current_buffer_extension "pyx") (search-backward-regexp CZQ_cython_cpp_function_reg_in_pyx))
     ))
    
  (setq CZQ_current_function_name (match-string 1))
  (message CZQ_current_function_name)
  )


(defun cython-cpp-goto-function-in-target-file (target-file)
  "get function name and class maker in current file, go to the corresponding files"
  (interactive "starget: (h,c,d,p)")
  (save-excursion (get-cpp-namespace-class))
  (get-function-name)
  (setq CZQ_cpp_goto_base_name (file-name-sans-extension (buffer-file-name)))
  (cond
   ((string= target-file "h") (setq CZQ_cpp_goto_extension ".h"))
   ((string= target-file "c") (setq CZQ_cpp_goto_extension ".cpp"))
   ((string= target-file "d") (setq CZQ_cpp_goto_extension ".pxd"))
   ((string= target-file "p") (setq CZQ_cpp_goto_extension ".pyx"))
   (t (setq CZQ_cpp_goto_extension ".h"))
   )
  (find-file (concat CZQ_cpp_goto_base_name CZQ_cpp_goto_extension))
  (beginning-of-buffer)
  (goto-cpp-class-ending CZQ_cpp_current_class  CZQ_cpp_current_namespace)
  ;;this does not matter in the end
  (set-text-properties 0 (length CZQ_current_function_name) nil CZQ_current_function_name)
  (cond
   ((string= target-file "h") (setq CZQ_cpp_goto_function_format (format CZQ_cython_cpp_function_reg_format_in_h CZQ_current_function_name)))
   ((string= target-file "c") (setq CZQ_cpp_goto_function_format (format CZQ_cython_cpp_function_reg_format_in_cpp CZQ_current_function_name)))
   ((string= target-file "d") (setq CZQ_cpp_goto_function_format (format CZQ_cython_cpp_function_reg_format_in_pxd CZQ_current_function_name)))
   ((string= target-file "p") (setq CZQ_cpp_goto_function_format (format CZQ_cython_cpp_function_reg_format_in_pxd CZQ_current_function_name)))
   (t (setq CZQ_cpp_goto_function_format (format CZQ_cython_cpp_function_reg_format_in_h CZQ_current_function_name)))
   )
  (search-backward-regexp CZQ_cpp_goto_function_format)
  ;; (search-backward-regexp "evalString(.*?){")
  )


(setq CZQ_test_file_cpp_filename_format "%s_C_%s_N_%s.cpp")
(setq CZQ_test_file_cpp_name_format "%s_C_%s_N_%s")
(setq CZQ_test_file_cpp_file_format "#include \"%s.h\"\n\nint main(){\n  %s::%s %s_t=%s::%s();\n}\n")
(setq CZQ_test_file_cpp_file_makefile "%s:%s.cpp %s.h\n\tg++ $(para) -o $@ $< %s.o")
(setq CZQ_test_file_python_filename_format "%s_p_C_%s_N_%s.py")
(setq CZQ_test_file_python_name_format "%s_p_C_%s_N_%s")
(setq CZQ_test_file_python_file_format "import %s\nt=%s.%s_p()")
(setq CZQ_test_file_python_file_makefile "r:\n\tipython -i %s.py")


(defun generate_test_files (types)
  "generate files for test"
  (interactive "sgenerate test files c(pp),p(python)")
  (save-excursion (get-cpp-namespace-class))
  (setq CZQ_current_file_directory (file-name-directory (buffer-file-name)))
  (setq CZQ_current_file_base (file-name-base (buffer-file-name)))
  (cond
   ((string= types "c") (call-interactively `generate_test_files_for_cpp))
   ((string= types "p") (call-interactively `generate_test_files_for_python))
   )
  )

(defun generate_test_files_for_python ()
  (interactive)
  (save-window-excursion
    (find-file (concat CZQ_current_file_directory (format CZQ_test_file_python_filename_format CZQ_current_file_base CZQ_cpp_current_class CZQ_cpp_current_namespace)))
    (insert (format CZQ_test_file_python_file_format CZQ_current_file_base CZQ_current_file_base CZQ_cpp_current_class))
    (save-buffer)
    (find-file (concat CZQ_current_file_directory "makefile"))
    (end-of-buffer)
    (setq CZQ_current_makefile_target (format CZQ_test_file_python_name_format  CZQ_current_file_base CZQ_cpp_current_class CZQ_cpp_current_namespace))
    (insert (format CZQ_test_file_python_file_makefile CZQ_current_makefile_target))
    (save-buffer)
    ))

(defun generate_test_files_for_cpp ()
  (interactive)
  (save-window-excursion
    (find-file (concat CZQ_current_file_directory (format CZQ_test_file_cpp_filename_format CZQ_current_file_base CZQ_cpp_current_class CZQ_cpp_current_namespace)))
    (insert (format CZQ_test_file_cpp_file_format CZQ_current_file_base CZQ_cpp_current_namespace CZQ_cpp_current_class CZQ_cpp_current_class CZQ_cpp_current_namespace CZQ_cpp_current_class))
    (save-buffer)
    (find-file (concat CZQ_current_file_directory "makefile"))
    (end-of-buffer)
    (setq CZQ_current_makefile_target (format CZQ_test_file_cpp_name_format  CZQ_current_file_base CZQ_cpp_current_class CZQ_cpp_current_namespace))
    (insert (format CZQ_test_file_cpp_file_makefile CZQ_current_makefile_target CZQ_current_makefile_target CZQ_current_file_base CZQ_current_file_base))
    (add-to-makefile-all CZQ_current_makefile_target)
    (save-buffer)
    ))

(defun add-to-makefile-all (target)
  (interactive)
  (beginning-of-buffer)
  (end-of-line)
  (insert (concat "  " target))
  )

