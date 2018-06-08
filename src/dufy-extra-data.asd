;;; -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :dufy-extra-data
  :serial t
  :depends-on (:dufy-core)
  :components ((:module "extra-data"
		:components
		((:file "package")
                 (:file "illuminants-data")))))
