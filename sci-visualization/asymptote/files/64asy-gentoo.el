;; begin asy-mode
(autoload 'asy-mode "asy-mode.el" "Asymptote major mode." t)
(setq auto-mode-alist (cons (cons "\\.asy$" 'asy-mode) auto-mode-alist))
;; end asy-mode
