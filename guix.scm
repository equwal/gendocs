;;; guix.scm --- Guix package for gendocs.  Build with: guix build -f guix.scm
;;; Install with: guix package -f guix.scm
(use-modules (guix packages) (guix gexp) (guix build-system asdf)
             ((guix licenses) #:prefix license:)
             (gnu packages lisp) (gnu packages lisp-xyz) (gnu packages lisp-check))

(define %source-dir (dirname (current-filename)))

(define-public sbcl-gendocs
  (package
    (name "sbcl-gendocs")
    (version "0.0.0")
    (source (local-file %source-dir "gendocs-checkout"
                        #:recursive? #t
                        #:select? (lambda (file stat)
                                    (not (or (string-suffix? ".fasl" file)
                                             (string-contains file "/.git"))))))
    (build-system asdf-build-system/sbcl)
    (arguments (list #:asd-systems ''("gendocs")))
    (inputs (list
                  sbcl-docparser
                  sbcl-alexandria))
    (synopsis "Autogenerate docs from a template and docstrings")
    (description "Autogenerate docs from a template and docstrings.")
    (home-page "https://github.com/equwal/gendocs")
    (license license:gpl3)))

(define-public cl-gendocs
  (sbcl-package->cl-source-package sbcl-gendocs))

sbcl-gendocs
