(defun dotfiles-dir ()
  "Return the absolute path of dotfiles dir."
  (file-name-directory (file-truename user-init-file)))

(defun custom-elisp-dir ()
  "Return the absolute path of custom files dir."
  (file-name-as-directory (concat (dotfiles-dir) "custom")))

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
