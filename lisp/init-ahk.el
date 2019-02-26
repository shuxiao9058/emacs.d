;;; init-ahk.el ---AutoHotKey Languages Configurations Initialize.  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  lye li

;; Author: lye li <shanyouli6@gmail.com>
;; Keywords: languages

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

;; AHK Configurations

;;; Code:

(use-package ahk-mode
  :mode "\\.ahk\\'"
  :defer t)

;; Runninng Wsl in Emacs
;; see @https://github.com/MatthewZMD/.emacs.d#bash-command
(defun lye/wsl-bash ()
  "Running windows subsystem Linux in emacs!"
  (interactive)
  (let ((shell-file-name "C:\\Windows\\System32\\wsl.exe"))
    (shell "*bash*")))

(provide 'init-ahk)
;;; init-ahk.el ends here
