;;; core-var.el --- Initialize core variables -*- lexical-binding: t -*-

;; Author: shanyouli
;; Maintainer: shanyouli
;; Version: v0.1
;; Package-Requires: ()
;; Homepage: https://github.com/shanyouli/emacs.d
;; Keywords: variables


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

;; Variables

;;; Code:

;;; customization
(defcustom lye-full-name "shanyouli"
  "Set user full name."
  :type 'string)

(defcustom lye-mail-address "shanyouli6@gmail.com"
  "Set user mail address."
  :type 'string)

(defcustom lye-package-archives 'emacs-china
  "Set package archives from which to fetch."
  :type '(choice (const :tag "Melpa" melpa)
                 (const :tag "Melpa-mirror" melpa-mirror)
                 (const :tag "Emacs-china" emacs-china)
                 (const :tag "Netease" netease)
                 (const :tag "Tuna" tuna)
                 (const :tag "Tencent" tencent)))

(defcustom lye-company-enable-yas nil
  "Enable yasnippet for company backends or not."
  :type  'boolean)

;;; Constants
(defconst lye-homepage  "https://github.com/shanyouli/emacs.d"
  "The Github page of My Emacs Configurations.")

(defconst system/windows (eq system-type 'windows-nt)
  "Are we running on a Windows System?")

(defconst system/mac (eq system-type 'darwin)
  "Are we running on a Mac System?")

(defconst system/linux (eq system-type 'gnu/linux)
  "Are we running on a GNU/Linux System?")

(defconst *root* (string-equal "root" (getenv "USER"))
  "Are you using ROOT user?")

(defconst lye-emacs-cache-dir (concat user-emacs-directory ".cache/")
  "Is the cache directory this?")

;;; Load `custom-file'
(setq custom-file (expand-file-name "custom.el" lye-emacs-cache-dir))
(when (file-exists-p custom-file) (load custom-file))

;; Set the temporal directory
(unless (file-exists-p lye-emacs-cache-dir)
  (make-directory lye-emacs-cache-dir))

(provide 'core-var)

;;; core-var.el ends here
