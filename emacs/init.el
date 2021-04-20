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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(markdown-mode which-key visual-fill-column use-package smooth-scrolling rainbow-delimiters org-bullets magit ivy-rich hydra helpful general exec-path-from-shell doom-themes doom-modeline counsel-projectile command-log-mode all-the-icons-dired)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
