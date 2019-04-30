(in-package :cl-user)

(defpackage #:gendocs
  (:use #:cl #:docparser)
  (:export #:gendocs))

(in-package #:gendocs)

(define-symbol-macro nl (format nil "~%"))
(defun gendocs (package template output &optional (template-flag "<TEMPL>"))
  (file-replace template-flag (md-docstrings package) template output))
(defun slurp (file)
  (let ((str (make-array 0 :element-type 'character :adjustable t :fill-pointer 0)))
    (with-open-file (i file)
      (loop for x = #1=(read-line i nil nil) then #1#
            do (when x (setf str (concatenate 'string str x nl)))
            until (not x)))
    str))

(defun md-docstrings (package)
  (let ((col nil))
    (do-packages (package (parse package))
      (do-nodes (n package)
        (push (format nil "~%") col)
        (push (node-docstring n) col)
        (push (format nil "~%") col)
        (push (format nil "~%") col)
        (push "`" col)
        (push (symbol-name (node-name n)) col)
        (push "`" col)
        (push (format nil "~%") col)))
    (print col)
    (apply #'concatenate 'string col)))
(defun file-replace (from to filein fileout)
  (with-open-file (i filein)
    (let ((str (slurp i)))
      (with-open-file (o fileout :direction :output :if-exists :overwrite)
        (write-string (str-replace from to str) o)))))
(defun str-replace (from to source)
  (let ((loc (search from source)))
    (concatenate 'string
                 (subseq source 0 loc)
                 to
                 (subseq source (+ loc (length from))))))
