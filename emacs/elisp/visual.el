;;; visual.el --- UI preferences
;;; Commentary:
;;; Visual preferences for Emacs

;;; Code:

;; Hide menu bar
(menu-bar-mode -1)
;; Hide tool bar
(tool-bar-mode -1)
;; Hide scroll bar
(toggle-scroll-bar -1)

;; Enable smooth scrolling
(use-package smooth-scrolling
  :ensure t
  :init (smooth-scrolling-mode 1))

;; Show line numbers
(global-linum-mode t)
;; Add solid line separator
(setq linum-format "%4d \u2502 ")
;; Set fringe color to nil
(set-face-attribute 'fringe nil :background nil)
;; Set line height
(setq-default line-spacing 0.5)

;; Dracula Theme
;; (use-package dracula-theme
;;  :ensure t)

;; Modeline
(use-package all-the-icons)
(use-package doom-modeline
      :ensure t
      :hook (after-init . doom-modeline-mode))

;; Github Theme
(use-package github-theme
  :ensure t
  :config
  (load-theme 'github t))

;; Distraction Free Window
(use-package darkroom
  :ensure t)

;;; visual.el ends here
