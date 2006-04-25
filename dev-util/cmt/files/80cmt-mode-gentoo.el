;; Automatically load the CMT mode.

(autoload 'cmt-mode "cmt-mode" "CMT requirements file editing mode." t)
(setq auto-mode-alist 
      (append (list (cons "requirements$" 'cmt-mode)) auto-mode-alist))

