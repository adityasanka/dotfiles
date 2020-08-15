;;; symlink.el --- Link dotfiles configuration
;;; Commentary:

;;; Code:
(setenv "DOTFILES" "~/Work/repos/dotfiles")

(defun dotfiles-dir ()
  "Return the absolute path of dotfiles dir."
  (file-name-as-directory (getenv "DOTFILES")))

(defun emacs-dotfiles-dir ()
  "Return the absolute path of Emacs config dir."
  (file-name-as-directory (concat (dotfiles-dir) "emacs")))

;; load dotfiles snippets
(add-to-list 'load-path (emacs-dotfiles-dir))
(load-library "dotfiles")

;;; symlink.el ends here
