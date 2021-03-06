;;; bundles/elisp/package.el -*- lexical-binding: t -*-

(package! macrostep :commands macrostep-expand)
(package! elispfl :recipe (:type git :host github :repo "cireu/elispfl")
  :commands (elispfl-ielm-mode elispfl-mode))
(package! elisp-demos
  :commands (elisp-demos-advice-describe-function-1
             elisp-demos-advice-helpful-update))

(package! elisp-refs)

(package! helpful :commands (helpful-key
                              helpful-symbol
                              helpful-at-point
                              helpful-callable
                              helpful-variable
                              helpful-mode))
