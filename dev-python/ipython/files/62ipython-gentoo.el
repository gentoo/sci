;;; ipython site-lisp configuration

(add-to-list 'load-path "@SITELISP@")
(eval-after-load "python-mode" '(require 'ipython))
