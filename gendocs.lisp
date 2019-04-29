(defpackage #:gendocs
  (:use #:cl)
  (:export :gendocs))
(in-package :gendocs)
(define-symbol-macro nl (format nil "~%"))
(defun slurp (file)
  (with-open-file (i file)
    (read-sequence (make-array 64 :element-type 'character :adjustable t)
                   i)))
(defun gendocs (inputs-pathlist packages outputs-pathlist
                &optional (delimiters '(#\< . #\>)))
  (loop for p in packages
        for i in inputs-pathlist
        for o in outputs-pathlist
        do (template-replace i
                             o
                             (md-docstrings p)
                             delimiters)))
(defun md-docstrings (package)
  (let ((pairs (read-docstrings package)))
    (loop for p in pairs
          collect (concatenate 'string nl
                               "`" (car p) "`" nl
                               (cdr p) nl))))
(defun read-docstrings (package)
  "Read the docstrings from a file"
  (loop for x being the external-symbols of package
        collect (cons (symbol-name x) (documentation x 'function))))
(defun template-replace (input output replacement-string delimiters)
  (with-open-file (o output :direction :output)
    (write-sequence (str-replace (concatenate 'string
                                              (string (car delimiters))
                                              (pathname-name input)
                                              (string (cdr delimiters)))
                                 replacement-string
                                 (slurp input))
                    o)))
(defun str-replace (from to source)
  (let ((loc (search from source)))
    (concatenate 'string
                 (subseq source 0 loc)
                 to
                 (subseq source (+ loc (length from))))))
