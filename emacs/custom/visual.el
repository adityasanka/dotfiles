(scroll-bar-mode -1) ; Disable visual scroll bar
(tool-bar-mode -1)   ; Disable the tool bar
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(menu-bar-mode -1)   ; Disable menu bar

;; Setup the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Set fringe color to nil
(set-face-attribute 'fringe nil :background nil)

;; Set line height
(setq-default line-spacing 0.5)

;; Disable line numbers for some modes
(dolist (mode `(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

;; Enable smooth scrolling
(use-package smooth-scrolling
  :ensure t
  :init (smooth-scrolling-mode 1))

;; Highlight delimiters like parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
