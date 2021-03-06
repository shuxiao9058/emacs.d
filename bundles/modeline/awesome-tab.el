;;; bundles/ui/awesome-tab.el.el -*- lexical-binding: t -*-

(with-eval-after-load 'awesome-tab

  ;; awesome-tab style: slant, wave,alternate,bar,box,chamfer,rounded,zigzag
  (setq awesome-tab-style 'zigzag)
  (setq awesome-tab-hide-tab-function 'lye/awesome-tab-hide-tab+)
  (add-hook 'lye-load-theme-hook #'lye/refresh-awesome-tab-mode+)

  (defun lye/awesome-tab-hide-tab+ (x)
    (let ((name (format "%s" x)))
      (or
       ;; Current window is not dedicated windows.
       (window-dedicated-p (selected-window))

       ;; Buffer name not match below dedicated window.
       (string-prefix-p "*esup" name)
       (string-prefix-p "*epc" name)
       (string-prefix-p "*helm" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*lsp" name)
       (unless (get-buffer "*scratch*")
         (string-prefix-p "*scratch*" name))
       (string-prefix-p "*One-Key*" name)
       (string-prefix-p "*sdcv" name)
       (string-prefix-p "*Flycheck" name)
       (string-prefix-p "*flycheck-posframe-buffer*" name)

       ;; Is not magit buffer.
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (defun lye/refresh-awesome-tab-mode+ ()
    "Refresh `awesome-tab-mode', especially after replacing themes."
    (when (awesome-tab-mode-on-p)
      (awesome-tab-mode -1)
      (awesome-tab-mode +1))))
