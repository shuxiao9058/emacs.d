;;; init-search.el --- Initialize Search Configurations -*- lexical-binding: t -*-

;; Author: shanyouli
;; Maintainer: shanyouli
;; Version: v0.1
;; Package-Requires: (use-package lazy-search color-rg browse-kill-ring .etc)
;; Homepage: https://github.com/shanyouli/emacs.d
;; Keywords: search


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

;; Initialize Search

;;; Code:

;;; Configurations

;; Uninstall some global shortcuts that may cause conflicts

;; Isearch and swiper
(if (locate-library "swiper")
    (use-package swiper
      :ensure nil
      :bind (("C-s" . swiper-isearch)
             :map swiper-map
             ([escape] . minibuffer-keyboard-quit))
      :config
      (setq swiper-action-recenter t))
  (use-package isearch
    :ensure nil
    :bind (("C-s" . isearch-forward))))

(provide 'init-search)

;;; init-search.el ends here
