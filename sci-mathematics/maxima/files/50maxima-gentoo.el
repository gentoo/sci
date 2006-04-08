;; maxima mode
(setq load-path (cons "/usr/shar/maxima/PV/emacs" load-path))
(autoload 'maxima-mode "maxima" "Maxima mode" t)
(autoload 'maxima "maxima" "Maxima interactive" t)
(setq auto-mode-alist (cons '("\\.max" . maxima-mode) auto-mode-alist))
(autoload 'dbl "dbl" "Make a debugger to run lisp, maxima and or gdb in" t)
(autoload 'gcl-mode "gcl" "Major mode for editing maxima code and interacting with debugger" t)
(setq auto-mode-alist (cons '("\\.ma?[cx]\\'" . maxima-mode) auto-mode-alist))

;; emaxima mode
(autoload 'emaxima-mode "emaxima" "EMaxima" t)
(add-hook 'emaxima-mode-hook 'emaxima-mark-file-as-emaxima)

