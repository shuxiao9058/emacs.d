;;; /core/core-bundle.el -*- lexical-binding: t -*-

;; (dolist (b '((pyim :defer t)
;;              (term :defer t)
;;              ))
;;   (bundle! b))
(bundle! pyim :commands (lye/toggle-input-method lye//require-pyim))
;; (bundle! fcitx :defer t :if (and IS-LINUX (executable-find "fcitx-remote")))

(bundle! term :defer t)

(bundle! icons :if (and (display-graphic-p) (not IS-WINDOWS)))

(bundle! dict :commands lye/dict-point)

(bundle! hydra
  :commands (pretty-hydra-title
             hydra-ui-menu/body
             hydra-open-dir-menu/body
             one-key-functions/menu
             one-key-tmp-scratch/menu
             one-key-change-fontsize/menu
             one-key-adjust-opacity/menu))

(bundle! window)

(bundle! elisp :defer t)

(bundle! snails :defer t)
(bundle! ivy)

(bundle! rss :menu elfeed-hydra/body)

(bundle! company)

(bundle! dired)

(bundle! mode :defer t)

(bundle! yasnippet)

(bundle! lsp :defer t)

(bundle! flycheck :defer t)

(bundle! editor :menu (one-key-thing-edit/menu one-key-color-rg-search/menu))

(bundle! tools)

(bundle! treemacs)

(bundle! git :defer t :menu one-key-magit/menu)

;; DONE: Use bundle replace modules
;; (setq lye-use-modeline 'awetray)
(setq lye-use-modeline 'doom)
(bundle! modeline)

(bundle! org :defer 0.5)

(bundle! pdf :defer 0.5)

;; (bundle! evil)
