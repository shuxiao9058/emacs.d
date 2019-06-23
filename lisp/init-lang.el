;;; init-lang.el ---Some Program Language Initialize  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  lye li

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

;;

;;; Code:

;; json
(use-package json-mode :mode "\\.json\\'"   :defer t)

;; xml
(use-package web-mode
  :mode (("\\.xml\\'" . web-mode)
         ("\\fonts.conf\\'" . web-mode)
         ("\\.html\\'" . web-mode))
  :defer t)

;; yaml
(use-package yaml-mode
  ;; :init
  ;; (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode))
  :defer t)

;; markdown, md
(use-package markdown-mode
  :mode (("\\.md\\'" . gfm-mode))
  :defer t)

;; sh-mode
(use-package sh-script
  :ensure nil
  :mode (("\\.zsh\\'" . sh-mode)
         (".zshrc" . sh-mode))
  :hook (sh-mode . (lambda () (sh-set-shell "bash"))))
;; vimrc-major mode
(use-package vimrc-mode :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; PKGBUILD-mode
(use-package pkgbuild-mode
  :ensure t
  :mode (("/PKGBUILD\\'" . pkgbuild-mode))
  :defer t)

;;; prettify-mode
(use-package prettify-symbols-mode
  :ensure nil
  :init
  (setq-default prettify-symbols-alist
                '(
                  ("<-" . "←")
                  ("->" . ?→)
                  ("->>" . ?↠)
                  ("=>" . ?⇒)
                  ("map" . ?↦)
                  ("/=" . ?≠)
                  ("!=" . ?≠)
                  ("==" . ?≡)
                  ("<=" . ?≤)
                  (">=" . ?≥)
                  ("=<<" . (?= (Br . Bl) ?≪))
                  (">>=" . (?≫ (Br . Bl) ?=))
                  ("<=<" . ?↢)
                  (">=>" . ?↣)
                  ("&&" . ?∧)
                  ("||" . ?∨)
                  ("not" . ?¬)))
  (setq prettify-symbols-unprettify-at-point 'right-edge))

;;; yasnippet
(use-package yasnippet
  :hook (after-init . yas-global-mode)
  :config (use-package yasnippet-snippets))



(provide 'init-lang)
;;; init-lang.el ends here
