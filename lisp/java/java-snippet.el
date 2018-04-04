(provide `java-snippet)

(defun insert-java-snippet (code)
     (interactive "sjni(jn)")
     (cond
      ((string= "jn") (insert-java-jni-template))
      )
     )

(setq czq-java-jni-template "class %s {\n    public static void main(String[] args){\n        }\n    static {\n      System.loadLibrary(\"%s\");}\n\n}\n")
(defun insert-java-jni-template ()
  (let ((class-name (file-name-sans-extension (buffer-name))))
    (insert (format czq-java-jni-template class-name class-name))
    )
  )
