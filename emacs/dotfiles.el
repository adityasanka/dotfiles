;;; dotfiles.el --- Initialization for Emacs
;;; Commentary:
;;; Emacs startup file --- initialization for Emacs

;;; Code:
(defun custom-elisp-dir ()
  "Return the absolute path of custom elisp scripts."
  (file-name-as-directory (concat (dotfiles-dir) "emacs/elisp/")))

;; load custom elisp scripts
(add-to-list 'load-path (custom-elisp-dir))

(load-library "packages")         ;; package management

;; Company mode is a standard completion package that works well with lsp-mode.
(defun set-exec-path ()
  "Set GOPATH."
  (when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)))

(use-package exec-path-from-shell
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (set-exec-path))

(load-library "visual")           ;; visual preferences
(load-library "fonts")            ;; font preferences
(load-library "startup")          ;; splash settings
(load-library "fs")               ;; file management
 
;;; dotfiles.el ends here
