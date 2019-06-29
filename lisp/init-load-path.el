;;; init-load-path.el --- load path Initialize -*- lexical-binding: t -*-

;; Author: shanyouli
;; Maintainer: shanyouli
;; Version: v0.1
;; Package-Requires: (cl)
;; Homepage: homepage
;; Keywords: load-path


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

;; load-path

;;; Code:

;;; depends
(eval-when-compile (require 'cl))

;;; variable

;; constant
(defconst lye-emacs-site-lisp-dir
  (expand-file-name "site-lisp" user-emacs-directory)
  "The root directory of third packages.")

;; Variable variable
(defconst lye-emacs-user-init-dir
  (expand-file-name "lisp" user-emacs-directory)
  "Custom configuration.")

;;; functions

(defun lye/add-subdidrs-to-load-path (parent-dir)
  "Adds every non-hidden subdir of PARENT_DIR to `load-path'."
  (when (and parent-dir  (file-exists-p parent-dir))
    (let* ((default-directory parent-dir))
      (setq load-path
            (append
             (loop for dir in (directory-files parent-dir)
                   unless (string-match "\\." dir)
                   collecting (expand-file-name dir))
             load-path)))))

(defun lye/update-load-path (&rest _)
  "Update `load'."
  ;; add lye-emacs-user-load-path-dir to load-path
  (push lye-emacs-user-init-dir load-path)

  ;; add lye-emacs-site-lisp-dir to load-path
  (lye/add-subdidrs-to-load-path lye-emacs-site-lisp-dir))

(advice-add #'package-initialize :after #'lye/update-load-path)

(lye/update-load-path)

(provide 'init-load-path)

;;; init-load-path.el ends here