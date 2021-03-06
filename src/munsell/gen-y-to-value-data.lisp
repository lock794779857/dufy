;;; This is a script file which generates fundamental data and saves
;;; them as a .lisp file.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload '(:alexandria :dufy/internal)))

(use-package :dufy/internal)

(defparameter *dest-path* (uiop:merge-pathnames* "y-to-value-data" (uiop:current-lisp-file-pathname)))

;; Converts munsell value to Y (in [0, 1]).
(defun munsell-value-to-y (v)
  (* v (+ 1.1914d0 (* v (+ -0.22533d0 (* v (+ 0.23352d0 (* v (+ -0.020484d0 (* v 0.00081939d0)))))))) 0.01d0))

(defun find-root (func rhs min max threshold)
  "bisection method"
  (let* ((mid (* 0.5d0 (+ min max)))
         (lhs (funcall func mid))
         (delta (abs (- lhs rhs))))
    (if (<= delta threshold)
        mid
        (if (> lhs rhs)
            (find-root func rhs min mid threshold)
            (find-root func rhs mid max threshold)))))

(defparameter y-to-munsell-value-table
  (make-array 1001 :element-type 'double-float :initial-element 0.0d0))

(setf (aref y-to-munsell-value-table 0) 0.0d0)
(setf (aref y-to-munsell-value-table 1000) 10.0d0)
(loop for y from 1 to 999
      do (setf (aref y-to-munsell-value-table y)
               (find-root #'munsell-value-to-y (* y 0.001d0) 0 10 1.0d-8)))

;; For test in development. Y should be in [0,1].
(defun y-to-munsell-value (y)
  (let* ((y1000 (* (alexandria:clamp y 0 1) 1000))
         (y1 (floor y1000))
         (y2 (ceiling y1000)))
    (if (= y1 y2)
        (aref y-to-munsell-value-table y1)
        (let ((r (- y1000 y1)))
          (+ (* (- 1 r) (aref y-to-munsell-value-table y1))
             (* r (aref y-to-munsell-value-table y2)))))))

;; Output
(uiop:with-output-file (out *dest-path* :if-exists :supersede)
  (format out ";;; This file is automatically generated by ~a.~%~%"
          (file-namestring *load-pathname*))
  (format out "~S~%~%" '(in-package :dufy/munsell))
  (print-make-array "+y-to-munsell-value-table+" y-to-munsell-value-table out))

(format t "The file is saved at ~A~%" *dest-path*)

#-swank(uiop:quit)
