;;; modules-benchmark.el --- Measure startup and requir times -*- lexical-binding: t -*-

;; Author: shanyouli
;; Maintainer: shanyouli
;; Version: v0.1
;; Package-Requires: ()
;; Homepage: https://github.com/shanyouli/emacs.d
;; Keywords: benchmark


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; Measure startup and require times.

;; Copy from: https://github.com/purcell/emacs.d/blob/master/lisp/init-benchmarking.el

;;; Code:

(defun md-benchmark/time-subtract-millis (b a)
  (* 1000.0 (float-time (time-subtract b a))))


(defvar md-benchmark/require-times nil
  "A list of (FEATURE LOAD-START-TIME LOAD-DURATION).
LOAD-DURATION is the time taken in milliseconds to load FEATURE.")

(defun md-benchmark/require-times-wrapper (orig feature &rest args)
  "Note in `md-benchmark/require-times' the time taken to require each feature."
  (let* ((already-loaded (memq feature features))
         (require-start-time (and (not already-loaded) (current-time))))
    (prog1
        (apply orig feature args)
      (when (and (not already-loaded) (memq feature features))
        (let ((time (md-benchmark/time-subtract-millis (current-time) require-start-time)))
          (add-to-list 'md-benchmark/require-times
                       (list feature require-start-time time)
                       t))))))

(advice-add 'require :around 'md-benchmark/require-times-wrapper)


(define-derived-mode md-benchmark/require-times-mode tabulated-list-mode "Require-Times"
  "Show times taken to `require' packages."
  (setq tabulated-list-format
        [("Start time (ms)" 20 md-benchmark/require-times-sort-by-start-time-pred)
         ("Feature" 30 t)
         ("Time (ms)" 12 md-benchmark/require-times-sort-by-load-time-pred)])
  (setq tabulated-list-sort-key (cons "Start time (ms)" nil))
  ;; (setq tabulated-list-padding 2)
  (setq tabulated-list-entries #'md-benchmark/require-times-tabulated-list-entries)
  (tabulated-list-init-header)
  (when (fboundp 'tablist-minor-mode)
    (tablist-minor-mode)))

(defun md-benchmark/require-times-sort-by-start-time-pred (entry1 entry2)
  (< (string-to-number (elt (nth 1 entry1) 0))
     (string-to-number (elt (nth 1 entry2) 0))))

(defun md-benchmark/require-times-sort-by-load-time-pred (entry1 entry2)
  (> (string-to-number (elt (nth 1 entry1) 2))
     (string-to-number (elt (nth 1 entry2) 2))))

(defun md-benchmark/require-times-tabulated-list-entries ()
  (cl-loop for (feature start-time millis) in md-benchmark/require-times
           with order = 0
           do (incf order)
           collect (list order
                         (vector
                          (format "%.3f" (md-benchmark/time-subtract-millis start-time before-init-time))
                          (symbol-name feature)
                          (format "%.3f" millis)))))

(defun md-benchmark/require-times ()
  "Show a tabular view of how long various libraries took to load."
  (interactive)
  (with-current-buffer (get-buffer-create "*Require Times*")
    (md-benchmark/require-times-mode)
    (tabulated-list-revert)
    (display-buffer (current-buffer))))




(defun md-benchmark/show-init-time ()
  (message "init completed in %.2fms"
           (md-benchmark/time-subtract-millis after-init-time before-init-time)))

(add-hook 'after-init-hook 'md-benchmark/show-init-time)


(provide 'modules-benchmark)

;;; modules-benchmark.el ends here
