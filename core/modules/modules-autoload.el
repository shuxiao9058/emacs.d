;;; modules-autoload.el --- summary -*- lexical-binding: t -*-

;; Author: shanyouli
;; Maintainer: shanyouli
;; Version: v0.1
;; Package-Requires: (subr-x cl-seq)
;; Homepage: https://github.com/shanyouli/emacs.d
;; Keywords: autoload load-path


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

;; commentary

;;; Code:

(defcustom md-autoload-save-directory
  (expand-file-name "autoload/"
                    (if (boundp 'lye-emacs-cache-dir)
                        lye-emacs-cache-dir
                      user-emacs-directory))
  "autoload save folder."
  :type 'directory)

(defcustom md-autoload-except-dir-list nil
  "Folder contains the file `md-autoload-except-dir-list' will be not return in the
`md/autoload-find-subdir-recursively+'."
  :type 'list)

(defcustom md-autoload-load-dir-alist nil
  "Need to generate a list of all files stored autoload, the corresponding file. The default format is '((dir . target))."
  :type 'list)

(defcustom md-atuoload-load-path-list nil
  "Using `md/autoload-add-load-path-list' to add it to the elements of the `laod-path'."
  :type 'list)


;;;###autoload
(defun md/autoload-find-subdir+ (dir)
  "Find all subdirectories in DIR. Don't-directories and directories contain
`md-autoload-except-dir-list' will be skipped"
  (require 'subr-x)
  (require 'cl-seq)
  (let (directory-list)
    (setq directory-list
          (thread-last (directory-files dir nil)
            (cl-remove-if (lambda (f) (string-prefix-p "." f)))
            (mapcar (lambda (d) (expand-file-name d dir)))
            (cl-remove-if-not #'file-directory-p)))
    (if md-autoload-except-dir-list
        (thread-first
            (lambda (d)
              (cl-remove-if-not (lambda (subdir) (file-exists-p (expand-file-name subdir d)))
                                md-autoload-except-dir-list))
          (cl-remove-if directory-list))
      directory-list)))

;;;###autoload
(defun md/autoload-find-subdir-recursively+ (dir)
  "Recursively find all subdirectories in DIR."
  (let ((subdir (md/autoload-find-subdir+ dir)))
    (nconc subdir (mapcan #'md/autoload-find-subdir+ subdir))))

(defun md/autoload-find-el-file-recurively+ (dir)
  "Find all `.el' files in DIR and its subdirectories."
  (let ((elfiles (directory-files dir t "\\.el\\'"))
        (subdir (md/autoload-find-subdir+ dir)))
    (nconc elfiles
           (mapcan #'md/autoload-find-el-file-recurively+ subdir))))



(defun md/autoload-get-autoload-file+ (file-name)
  "Confirm cache files that will be generated by the function
`md/autoload-creat-and-load-file' file names and directory."
  (if (string= file-name (file-name-nondirectory file-name))
      (expand-file-name (if (file-name-extension file-name)
                            file-name
                          (concat file-name "-loadfs.el"))
                        md-autoload-save-directory)
    (let ((dirname (file-name-directory file-name)))
      (unless (file-directory-p dirname)
        (make-directory (file-truename dirname) t))
      file-name)))

(defun md/autoload-create-and-load-file (dir target &optional forcep)
  " (md/autoload-create-and-load-file DIR TARGET &optional FORCEP)

Autoload directory `DIR' generated for a file named `TARGET' in. And loading it.
If the `TARGET' file already exists, Do nothing, only
when `FORCEP' is non-nil, forcibly regenerate a new DIR file autoload and loading it."
  (require 'autoload)
  (let ((generated-autoload-file target)
        (target (md/autoload-get-autoload-file+ target)))
    (when (or forcep (not (file-exists-p target)))
      (with-temp-file target
        (dolist (f (md/autoload-find-el-file-recurively+ dir))
          (let ((generated-autoload-load-name (file-name-sans-extension f)))
            (autoload-generate-file-autoloads f (current-buffer))))
        (insert (string-join `(,(char-to-string ?\C-l)
                               ";; Local Varibles:"
                               ";; version-control: never"
                               ";; no-byte-compile: t"
                               ";; no-update-autoloads: t"
                               ";; coding: utf-8"
                               ";; End:"
                               ,(format ";;; %s ends here"
                                        (file-name-nondirectory target)))
                             "\n")))
      (load target :no-error :no-message))))

(defun md/autoload-load-all-file (&optional load-all-p)
  "if `LOAD-ALL-P' is non-nil, Loading all the files autoload
`md/autoload-create-and-load-file-list' generated
Otherwise  loading all file from `md-autoload-save-directory'."
  (let* ((file-list (if load-all-p
                        (thread-last md-autoload-load-dir-alist
                          (mapcar #'cdr)
                          (mapcar #'md/autoload-get-autoload-file+))
                      (directory-files md-autoload-save-directory t "\\.el\\'"))))
    (dolist (f file-list)
        (load f :no-error :no-message))))

(defun md/autoload-create-and-load (load-alist &optional forcep)
  " (md/autoload-create-and-load LOAD-ALIST &optional FORCEP)
The `DIR' and `TARGET' variable combined is a function of
`md/autoload-create-and-load-file' variable `LOAD-ALIST'."

  (let* ((dir (car load-alist))
         (target (cdr load-alist)))
    (unless (memq dir (mapcar #'car md-autoload-load-dir-alist))
      (push load-alist md-autoload-load-dir-alist))
    (when (symbolp dir)
        (setq dir (symbol-value dir)))
    (when (symbolp target)
      (setq target (symbol-value target)))
    (md/autoload-create-and-load-file dir target forcep)))

;;;###autoload
(defun md/autoload-create-and-load-file-list ()
  "Create or loaded autoload.el for `md-autoload-load-dir-alist'."
  (mapc #'md/autoload-create-and-load md-autoload-load-dir-alist)
  (md/autoload-load-all-file))

;;;###autoload
(defun md-autoload-refresh-file (dir-name)
  "Refresh autoload.el a separate directory generated.
DIR-NAME exist in `(mapcar #'car md-autoload-load-dir-alist)'"
  (interactive
   (list
    (intern (completing-read "You need to regenerate the `autoload.el' directory: "
                             (mapcar #'car md-autoload-load-dir-alist)))))
  (let ((dir-list (assoc dir-name md-autoload-load-dir-alist)))
    (md/autoload-create-and-load dir-list t)))

;;;###autoload
(defun md-autoload-forcep-refresh-all ()
  "Force a refresh using autoload file directory generated list
    '(mapcar #'car md-autoload-load-dir-alist)'
and delete the extra files in the directory `md-autoload-save-directory'."

  (interactive)
  (mapc (lambda (dir-alist)
          (md/autoload-create-and-load dir-alist t))
        md-autoload-load-dir-alist)
  (md-autoload-remove-over-cache-file))

;;;###autoload
(defun md-autoload-remove-over-cache-file (&optional silent-p)
  "Remove the extra cache files."
  (interactive)
  (let* ((base-file (mapcar #'cdr md-autoload-load-dir-alist))
         (cache-file (directory-files md-autoload-save-directory t "\\.el\\'"))
        (base-file (mapcar #'md/autoload-get-autoload-file+ base-file)))
    (dolist (f cache-file)
      (unless (member f base-file)
        (when silent-p
          (message "Delete %s" f))
        (delete-file f)))))



;;; Adding processing `load-path 'is
;;;###autoload
(defun md/autoload-add-load-path (pathdir)
  "If the `PATHDIR' exists adding `load-path'."
  (let ((d (if (symbolp pathdir)
               (symbol-value pathdir)
             pathdir)))
    (if (file-directory-p d)
        (push d load-path))))

(defun md/autoload-add-load-path-list (pathlist)
  "`PATHLIST' elements added to the `LOAD-PATH'."
  (mapcar #'md/autoload-add-load-path  pathlist))

;;;###autoload
(defun md/autoload-add-subdir-load-path+ (pathdir &optional selfp recursivep)
  " (md/autoload-add-subdir-load-path+ PATHDIR &optional SELFP RECURSIVEP)
Add `PATHDIR' subdirectory path to `LOAD-PATH',
if you need to `PATHDIR' itself directory to `LOAD-PATH', `SELFP' is non-nil,
If you need to add subdirectories to `LOAD-PAT'H, RECURSIVEP  is non-nil."
  (let ((dir (if (symbolp pathdir)
                (symbol-value pathdir)
              pathdir)))
    (if selfp
        (md/autoload-add-load-path (file-truename dir)))
    (let ((d (if recursivep
                 (md/autoload-find-subdir-recursively+ dir)
               (md/autoload-find-subdir+ dir))))
      (md/autoload-add-load-path-list d))))

;;;###autoload
(defun md/autoload-add-load-path-list (&optional dir-list)
  "Add `DIR-LIST'or `md-autoload-load-path-list' of elements to the `load-path'."
  (let ((dir-list (or dir-list md-autoload-load-path-list)))
    (when dir-list
        (mapc (lambda (element)
            (if (listp element)
                (let ((pathdir (car element))
                      (selfp (cadr element))
                      (recursivep (caddr element)))
                  (md/autoload-add-subdir-load-path+ pathdir selfp recursivep))
              (md/autoload-add-load-path element)))
              dir-list))))

(provide 'modules-autoload)

;;; modules-autoload.el ends here