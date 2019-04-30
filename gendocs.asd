(asdf:defsystem :gendocs
  :version      "0.0.0"
  :description  "Autogenerate docs from a template and docstrings."
  :author       "Spenser Truex <myself@spensertruex.com>"
  :serial       t
  :license      "GNU GPL, version 3"
  :depends-on (:docparser)
  :components   ((:file "gendocs")))
