;; gap mode
(autoload 'gap-mode "gap-mode" "Gap editing mode" t)
(setq auto-mode-alist (append (list '("\\.g$" . gap-mode)
                                    '("\\.gap$" . gap-mode))
                              auto-mode-alist))
(autoload 'gap "gap-process" "Run GAP in emacs buffer" t)

(setq gap-executable "/usr/bin/gap")
(setq gap-start-options ())
;; end gap mode
