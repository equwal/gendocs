(asdf:defsystem :gendocs
  :version      "0.0.0"
  :description  "Autogenerate docs from a template and docstrings."
  :author       "Spenser Truex <myself@spensertruex.com>"
  :serial       t
  :license      "LicenseRef-CCAI-1.0"
  :depends-on (:docparser)
  :components   ((:file "gendocs")))
