;; Initialize package sources
(require 'package)

;; Setup package archives
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")
	("melpa" . "https://melpa.org/packages/")))

;; Initialize package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already present
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Ensure that every package is installed
(setq use-package-always-ensure t)

;; Use separate file for storing customization info
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(defun dot/dotfiles-dir ()
  "Return the absolute path of dotfiles dir."
  (file-name-directory (file-truename user-init-file)))

(defun dot/custom-elisp-dir ()
  "Return the absolute path of custom files dir."
  (file-name-as-directory (concat (dot/dotfiles-dir) "lisp")))

(add-to-list 'load-path (dot/custom-elisp-dir))

(use-package "dot-env" :ensure nil)           ;; setup env variables
(use-package "dot-startup" :ensure nil)       ;; splash settings
(use-package "dot-fs" :ensure nil)            ;; file management
(use-package "dot-visual" :ensure nil)        ;; visual preferences
(use-package "dot-fonts" :ensure nil)         ;; font preferences
(use-package "dot-kbd" :ensure nil)           ;; keyboard preferences
(use-package "dot-git" :ensure nil)           ;; version control
(use-package "dot-themes" :ensure nil)        ;; doom modeline and themes
(use-package "dot-ivy" :ensure nil)           ;; enhanced completion with ivy and counsel
(use-package "dot-projects" :ensure nil)      ;; project mgmt with projectile
(use-package "dot-org" :ensure nil)           ;; org mode preferences
(use-package "dot-md" :ensure nil)            ;; markdown support
