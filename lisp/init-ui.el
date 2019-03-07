;;; init-ui.el --- Initialize ui configurations.     -*- lexical-binding: t; -*-

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

;; UI

;;; Code:

;; Logo
;; (setq facy-splash-image logo)

;; Title
;; (when (display-graphic-p)
;;   (setq frame-title-format
;;         '("Lye Emacs - "
;;           (:eval (if (buffer-file-name)
;;                      (abbreviate-file-name (buffer-file-name))
;;                    %b))))
;;   (setq icon-title-format frame-title-format))

;; Suppress GUI features
(when (display-graphic-p) 
  (setq use-file-dialog nil
        use-dialog-box nil
        inhibit-startup-screen t))
(setq initial-major-mode 'emacs-lisp-mode
      initial-buffer-choice nil)

;; Window size and features
(when (version< emacs-version  "27.0.0")
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
  (when (fboundp 'set-scroll-bar-mode)
    (set-scroll-bar-mode nil))
  
  ;; I generally prefer to hide the menu bar, but doing this on OS X
  ;; simply makes it update unreliably in GUI frames, so we make an
  ;; exception.
  (if *is-a-mac*
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                (set-frame-parameter frame 'menu-bar-lines
                                     (if (display-graphic-p frame)
                                         1 0))))
    (when (fboundp 'menu-bar-mode)
      (menu-bar-mode -1))))

(let ((no-border '(internal-border-width . 0)))
  (add-to-list 'default-frame-alist no-border)
  (add-to-list 'initial-frame-alist no-border))

;; Make *Scratch* buffer undelete
(defun lye/unkillable-scratch-buffer ()
  "Don't delete *Scratch*."
  (if (string= (buffer-name (current-buffer)) "*scratch*")
      (progn
	    (delete-region (point-min) (point-max))
	    (insert initial-scratch-message)
	    nil)
    t))
(add-hook 'kill-buffer-query-functions #'lye/unkillable-scratch-buffer)

;; Theme
;; Understand the topics currently in use
(defun lye/current-theme ()
  "what is the Current theme?"
  (interactive)
  (message "The Current theme is %s"
           (substring (format "%s" custom-enabled-themes) 1 -1)))

(if (display-graphic-p)
    (use-package doom-themes
      :init (load-theme 'doom-one t))
  (straight-use-package '(lazycat-theme :tyep git :host github
                                        :repo "lye95/lazycat-theme"))
    (require 'lazycat-theme))

;; Misc
(fset 'yes-or-no-p 'y-or-n-p) ; 以 y/n 取代 yes/no
(setq inhibit-startup-screen t) ; 不展示开始界面
;; (setq initial-scratch-message "") ; 不显示 scratch 中默认信息
;;(setq visible-bell t)
(setq ring-bell-function 'ignore) ; Turn off the error ringtone
(setq mouse-yank-at-point t) ; Paste at the cursor position instead of the mouse pointer
(setq x-select-enable-clipboard t) ; 支持 emacs 和外部程序的粘贴
(setq track-eol t) ; keep cursor at end of lines, Require line-move-visual is nil
(setq line-move-visual nil)
(setq inhibit-compacting-font-caches t) ; Don't compact font caches during GC.

;; Don't ask me when close emacs with process is running
(straight-use-package '(noflet :type git :host github :repo "nicferrier/emacs-noflet"))
(require 'noflet)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (noflet ((process-list ())) ad-do-it))

;;Don't ask me when kill process buffers
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))

;; set font
;; @see https://emacs-china.org/t/emacs/7268/2
(defun set-font (english chinese english-size chinese-size)
  (set-face-attribute 'default nil :font
                      (format   "%s:pixelsize=%d"  english english-size))
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family chinese :size chinese-size))))
;;(set-font "Source Code Pro" "simsun" 12 14)
(when (display-graphic-p)
  (set-font "Sarasa Mono SC" "Sarasa Mono SC" 14 14))

;; set startup frame-size
(defun lye/reset-frame-size (&optional frame)
  "set the frame-size."
  (interactive)
  (when frame
    (select-frame frame))
  (if *is-a-win*
      (progn
        (set-frame-width (selected-frame) 96)
        (set-frame-height (selected-frame) 32))
    (set-frame-size (selected-frame) 96 32)))

(when window-system
  (lye/reset-frame-size))
;;(add-hook 'emacs-startup-hook 'lye/reset-frame-size)
;; see https://github.com/syl20bnr/spacemacs/issues/4365#issuecomment-202812771
(add-hook 'after-make-frame-functions 'lye/reset-frame-size)

;; mode-line
(if (display-graphic-p)
    (progn
      ;; (use-package awesome-tray
      ;;   :straight (awesome-tray
      ;;              :type git
      ;;              :host github
      ;;              :repo "manateelazycat/awesome-tray")
      ;;   :ensure nil
      ;;   :commands (awesome-tray-mode)
      ;;   :init (awesome-tray-mode 1))
      (use-package doom-modeline
        :init
        ;; Only display the file name, wait for the mouse to move to the file name in the display path
        (setq doom-modeline-buffer-file-name-style 'buffer-name)
        (doom-modeline-mode)))
  (require 'init-modeline))

;; Do not use the mouse in the graphical interface
(when (display-graphic-p)
  (use-package disable-mouse
    :init (global-disable-mouse-mode)))

(provide 'init-ui)
;;; init-ui.el ends here
