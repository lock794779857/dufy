
(cl:in-package :cl-user)

(defpackage dufy-internal
  (:use :cl :alexandria)
  (:export
   :*dat-dir-path*
   :print-make-array
   :with-double-float
   :time-after-gc
   :stime-after-gc
   :time-median
   :with-profile

   :two-pi
   :nearly=
   :nearly<=
   :nearly-equal
   :subtract-with-mod
   :circular-nearer
   :circular-clamp
   :circular-lerp-loose
   :circular-lerp
   :circular-member
   :square
   :fast-expt

   :matrix33
   :+identity-matrix+
   :+empty-matrix+
   :invert-matrix33
   :multiply-mat-vec
   :multiply-mat-mat
   :multiply-matrices
))