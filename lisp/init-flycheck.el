;;; init-flycheck.el --- Initialize Flycheck Configurations.  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  lye li

;; Author: lye li <shanyouli6@gamil.com


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

;;

;;; Code:

(use-package flycheck
  :diminish flycheck-mode
  :init (dolist (hook (list
		       'scheme-mode-hook
		       'python-mode-hook))
	  (add-hook hook '(lambda ()
			    (flycheck-mode 1))))
  :config
  (setq flycheck-indication-mode 'right-fringe)
  (setq flycheck-emacs-lisp-load-path 'inherit)

  ;; Only check while saving and opening files
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  )

(when (display-graphic-p)
  (use-package flycheck-posframe
    :after flycheck
    :hook (flycheck-mode . flycheck-posframe-mode)))

(use-package flycheck-color-mode-line
  :after flycheck
  :hook (flycheck-mode . flycheck-color-mode-line-mode))

(provide 'init-flycheck)
;;; init-flycheck.el ends here
