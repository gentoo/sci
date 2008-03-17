
;;; site-lisp configuration for sfst-syntax

(add-to-list 'load-path "@SITELISP@")

(autoload 'sfst-mode "ebuild-mode"
  "Major mode for SFST-PL files" t)

(add-to-list 'auto-mode-alist '("\\.fst\\'" . sfst-mode))
