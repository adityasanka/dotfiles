(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(defun dot/dotfiles-dir ()
  "Return the absolute path of dotfiles dir."
  (file-name-directory (file-truename user-init-file)))

(defun dot/custom-elisp-dir ()
  "Return the absolute path of custom files dir."
  (file-name-as-directory (concat (dot/dotfiles-dir) "lisp")))

(add-to-list 'load-path (dot/custom-elisp-dir))

(load-library "dot-packages")      ;; package management
(load-library "dot-env")           ;; setup env variables
(load-library "dot-startup")       ;; splash settings
(load-library "dot-fs")            ;; file management
(load-library "dot-visual")        ;; visual preferences
(load-library "dot-fonts")         ;; font preferences
(load-library "dot-kbd")           ;; keyboard preferences
(load-library "dot-git")           ;; version control
(load-library "dot-themes")        ;; doom modeline and themes
(load-library "dot-ivy")           ;; enhanced completion with ivy and counsel
(load-library "dot-projects")      ;; project mgmt with projectile
(load-library "dot-org")           ;; org mode preferences
(load-library "dot-md")            ;; markdown support
