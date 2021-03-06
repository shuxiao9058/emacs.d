;;; bundles/editor/package.el.el -*- lexical-binding: t -*-


(package! rainbow-delimiters :commands rainbow-delimiters-mode)
(package! rainbow-mode :commands rainbow-mode)

(package! hungry-delete :commands global-hungry-delete-mode)
(package! highlight-indent-guides :commands highlight-indent-guides-mode)
(package! page-break-lines :commands global-page-break-lines-mode)

(package! elec-pair :build-in t :commands electric-pair-mode)

(package! delsel :build-in t :commands delete-selection-mode)

;; Chinese input automatically adds spaces in Chinese
;; (package! pangu-spacing :commands pagu-spacing-mode)

(package! whitespace :commands witespace-mode :build-in t)

(package! smart-align :recipe (:type git
                               :host github
                               :repo "manateelazycat/smart-align"
                               :no-byte-compile t)
          :commands smart-align)

(package! thing-edit
          :commands (thing-copy-word
                     thing-copy-symbol
                     thing-copy-filename
                     thing-copy-sexp
                     thing-copy-page
                     thing-copy-list
                     thing-copy-defun
                     thing-copy-parentheses
                     thing-copy-region-or-line
                     thing-copy-to-line-beginning
                     thing-copy-to-line-end

                     thing-cut-word
                     thing-cut-symbol
                     thing-cut-filename
                     thing-cut-sexp
                     thing-cut-page
                     thing-cut-list
                     thing-cut-defun
                     thing-cut-parentheses
                     thing-cut-region-or-line
                     thing-cut-to-line-beginning
                     thing-cut-to-line-end)
          :recipe (:type git
                   :host github
                   :repo "manateelazycat/thing-edit"))

;; avy
(package! avy :commands avy-setup-default)
(package! ace-pinyin :commands ace-pinyin-global-mode)

;; lazy-search and color-rg
(package! lazy-search :commands lazy-search
          :recipe (:type git
                   :host github
                   :repo "manateelazycat/lazy-search"
                   :no-byte-compile t))
(package! color-rg :if (executable-find "rg")
          :commands (color-rg-search-symbol
                     color-rg-search-input
                     color-rg-search-symbol-in-project
                     color-rg-search-input-in-project
                     color-rg-search-symbol-in-current-file
                     color-rg-search-input-in-current-file)
          :recipe (:type git
                   :host github
                   :repo "manateelazycat/color-rg"
                   :no-byte-compile t))

(package! insert-translated-name
          :recipe (:type git
                   :host github
                   :repo "manateelazycat/insert-translated-name")
          :commands (insert-translated-name-insert-original-translation
                     insert-translated-name-insert-with-underline
                     insert-translated-name-insert-with-line
                     insert-translated-name-insert-with-camel))

;; backup-file
(package! backup-file
          :recipe (:type git :host github
                   :repo "shanyouli/emacs-backup-file")
          :commands (backup-file backup-file-log)
          :if (and (not IS-WINDOWS) (executable-find "git")))
