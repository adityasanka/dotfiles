(defun dotfiles-dir ()
  "Return the absolute path of dotfiles dir."
  (file-name-directory (file-truename user-init-file)))

(defun custom-elisp-dir ()
  "Return the absolute path of custom files dir."
  (file-name-as-directory (concat (dotfiles-dir) "elisp")))

(add-to-list 'load-path (custom-elisp-dir))

(load-library "packages")           ;; package management
(load-library "env")                ;; setup env variables
(load-library "startup")            ;; splash settings
(load-library "fs")                 ;; file management
(load-library "visual")             ;; visual preferences
(load-library "fonts")              ;; font preferences
(load-library "kbd")                ;; keyboard preferences
(load-library "git")                ;; version control
(load-library "themes")             ;; doom modeline and themes
(load-library "generic-completion") ;; enhanced completion with ivy and counsel
(load-library "projects")           ;; project mgmt with projectile
(load-library "cs-org-mode")                ;; org mode preferences
(load-library "markdown")           ;; markdown support

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
