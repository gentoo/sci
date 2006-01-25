(setq load-path (cons "/usr/share/maxima/5.9.1/emacs" load-path))
(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'maxima "maxima" "Maxima interactive" t)
(setq auto-mode-alist (cons '("\\.max" . maxima-mode) auto-mode-alist))
(autoload 'emaxima-mode "emaxima" "EMaxima" t)
(add-hook 'emaxima-mode-hook 'emaxima-mark-file-as-emaxima)

