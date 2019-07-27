;;; lex-funcs.el --- Define functions.              -*- lexical-binding: t; -*-

;; Copyright (C) 2018  DESKTOP-RD96RHO

;; Author: DESKTOP-RD96RHO <lye@DESKTOP-RD96RHO>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Define functions.

;;; Code

;; Dos2Unix/Unix2Dos
(defun dos2unix ()
  "Convert the current buffer to UNIX file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-unix nil))

(defun unix2dos ()
  "Convert the current buffer to DOS file format."
  (interactive)
  (set-buffer-file-coding-system 'undecided-dos nil))

;; Revert buffer
(defun revert-current-buffer ()
  "Revert the current buffer."
  (interactive)
  (message "Revert this buffer.")
  (revert-buffer t t))
;; (bind-keys ("C-M-r" . revert-current-buffer))

;; Save a file as utf-8
(defun save-buffer-as-utf-8 (coding-system)
  "Revert a buffer with 'CODING-SYSTEM' and save as UTF-8."
  (interactive "zCoding system for visited file (default nil):")
  (revert-buffer-with-coding-system 'utf-8)
  (save-buffer))

;; Save a file as gbk
(defun save-buffer-with-gbk (coding-system)
  "Revert a buffer with `CODING-SYSTEM' and save as gbk."
  (interactive "zcoding system for visited file (default nil):")
  (revert-buffer-with-coding-system 'gbk)
  (save-buffer))

;; Revert a buffer as gbk
(defun revert-buffer-with-gbk ()
  "Reopen the buffer in gbk format."
  (interactive)
  (revert-buffer-with-coding-system 'gbk))

;; Revert a buffer as utf-8
(defun revert-buffer-with-utf-8 ()
  "Reopen the buffer in utf-8 format."
  (interactive)
  (revert-buffer-with-coding-system 'utf-8))

;; Recompile elpa directory
(defun recompile-elpa ()
  "Recompile packages in elpa directory.  Useful if you switch Emacs versions."
  (interactive)
  (byte-recompile-directory package-user-dir nil t))

;; Rename the current file
(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-file-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

;; Browse current HTML file
(defun browse-current-file ()
  "Open the current file as a URL using `browse-url'."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if (and (fboundp 'tramp-tramp-fle-p)
             (tramp-tramp-file-p file-name))
        (error "Cannot open tramp file")
      (browse-url (concat "file://" file-name)))))

;; add emacs startup time, copy from emacs-git(2018.02.22)
(defun lye/emacs-init-time ()
  "Copy `emacs-git'
Return a string giving the duration of the Emacs initialization."
  (interactive)
  (let ((str
         (format "%s seconds"
                 (float-time
                  (time-subtract after-init-time before-init-time)))))
    (if (called-interactively-p 'interactive)
        (message "%s" str)
      str)))

;;Edit files with root privileges
;; see @https://github.com/hlissner/doom-emacs/blob/develop/core/autoload/files.el
(defun lye/sudo-find-file (file)
  "Open FILE as root."
  (interactive
   (list (read-file-name "Open as root: ")))
  (when (file-writable-p file)
    (user-error "File is user writeable, aborting sudo"))
  (find-file (if (file-remote-p file)
                 (concat "/" (file-remote-p file 'method) ":"
                         (file-remote-p file 'user) "@"
                         (file-remote-p 'host) "|sudo:root@"
                         (file-remote-p file 'host) ":"
                         (file-remote-p file 'localname))
               (concat "/sudo:root@localhost:" file))))

(defun lye/sudo-this-file ()
  "Open the current file as root."
  (interactive)
  (lye/sudo-find-file (file-truename buffer-file-name)))

(defvar one-key-menu-funcs-alist nil
  "The `one-key' menu alist for FUNCTIONS.")

(setq one-key-menu-funcs-alist
      '((("d" . "Dos to unix") . dos2unix)
        (("u" . "Unix to Dos") . unix2dos)
        (("r" . "Revert current buffer.") revert-current-buffer)
        (("s" . "Save as utf-8") . save-buffer-as-utf-8)
        (("S" . "Save as GBK") . save-buffer-with-gbk)
        (("g" . "revert buffer GBK") . revert-buffer-with-gbk)
        (("U" . "Revert buffer with UTF-8") . revert-buffer-with-utf-8)
        (("m" . "Recompile elpa") . recompile-elpa)
        (("R" . "Rename this buffer") . rename-this-file-and-buffer)
        (("b" . "Browse current file") . browse-current-file)
        (("f" . "sudo find file") . lye/sudo-find-file)
        (("F" . "SUDO find this file") . lye/sudo-this-file)))

(defun one-key-menu-funcs ()
  "The `one-key' menu for FUNCTIONS"
  (interactive)
  (one-key-menu "FUNCTIONS" one-key-menu-funcs-alist t))

(provide 'lex-funcs)
;;; lex-funcs.el ends here