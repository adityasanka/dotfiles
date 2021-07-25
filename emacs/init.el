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
;; Log package loading and configuration details
(setq use-package-verbose t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "21:00"))

;; Inhibit startup message
(setq inhibit-startup-message t)

;; default is :warning, which displays all warnings except :debug warnings
(setq warning-minimum-level :error)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun dot/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	   (format "%.2f seconds"
		   (float-time
		     (time-subtract after-init-time before-init-time)))
	   gcs-done))

(add-hook 'emacs-startup-hook #'dot/display-startup-time)

;; load env variables from shell
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)))

;; Use separate file for storing customization info
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Default window size
(add-to-list 'default-frame-alist '(width . 150))
(add-to-list 'default-frame-alist '(height . 48))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-navigator t)
  (dashboard-set-footer nil)
  (dashboard-page-separator "\n\n")
  (dashboard-items '((recents  . 5))))

(scroll-bar-mode -1) ; Disable visual scroll bar
(tool-bar-mode -1)   ; Disable the tool bar
(tooltip-mode -1)    ; Disable tooltips
(menu-bar-mode -1)   ; Disable menu bar
(set-fringe-mode 10) ; Give some breathing room

;; Transparent title bar
(when (memq window-system '(mac ns))
   ; nil for dark text
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t)))

;; Disable text and icon for title bar
(setq frame-title-format nil)
(setq icon-title-format nil)

;; Enable smooth scrolling
(use-package smooth-scrolling
  :ensure t
  :init (smooth-scrolling-mode 1))

;; Let the text breath. Increase line spacing
(setq-default line-spacing 0.5)

(global-visual-line-mode 1)

;; Highlight current line
(add-hook 'prog-mode-hook 'hl-line-mode )

(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode `(org-mode-hook
		markdown-mode-hook
		dired-mode-hook
		term-mode-hook
		vterm-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

;; Better help with heplful
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Keyboard hints with which-key
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Log commands in a buffer
(use-package command-log-mode
  :commands command-log-mode)

;; Compose key sequences
(use-package hydra
  :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

;; Convenient key bindings 
(use-package general
  :after (ivy counsel)
  :config  
  (general-create-definer rune/leader-keys
			 :keymaps '(emacs)
			 :prefix "SPC"
			 :prefix "C-SPC")
  (rune/leader-keys
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")
   "ts" '(hydra-text-scale/body :which-key "scale-text")))

(general-define-key
 "C-M-j" 'counsel-switch-buffer)

;; Set default font
(set-face-attribute 'default nil :font "Ubuntu Mono-18" :weight 'normal)
;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font  "Ubuntu Mono-18" :weight 'normal)

(let ((ligatures `((?-  ,(regexp-opt '("-|" "-~" "---" "-<<" "-<" "--" "->" "->>" "-->")))
		     (?/  ,(regexp-opt '("/**" "/*" "///" "/=" "/==" "/>" "//")))
		     (?*  ,(regexp-opt '("*>" "***" "*/")))
		     (?<  ,(regexp-opt '("<-" "<<-" "<=>" "<=" "<|" "<||" "<|||" "<|>" "<:" "<>" "<-<"
					   "<<<" "<==" "<<=" "<=<" "<==>" "<-|" "<<" "<~>" "<=|" "<~~" "<~"
					   "<$>" "<$" "<+>" "<+" "</>" "</" "<*" "<*>" "<->" "<!--")))
		     (?:  ,(regexp-opt '(":>" ":<" ":::" "::" ":?" ":?>" ":=" "::=")))
		     (?=  ,(regexp-opt '("=>>" "==>" "=/=" "=!=" "=>" "===" "=:=" "==")))
		     (?!  ,(regexp-opt '("!==" "!!" "!=")))
		     (?>  ,(regexp-opt '(">]" ">:" ">>-" ">>=" ">=>" ">>>" ">-" ">=")))
		     (?&  ,(regexp-opt '("&&&" "&&")))
		     (?|  ,(regexp-opt '("|||>" "||>" "|>" "|]" "|}" "|=>" "|->" "|=" "||-" "|-" "||=" "||")))
		     (?.  ,(regexp-opt '(".." ".?" ".=" ".-" "..<" "...")))
		     (?+  ,(regexp-opt '("+++" "+>" "++")))
		     (?\[ ,(regexp-opt '("[||]" "[<" "[|")))
		     (?\{ ,(regexp-opt '("{|")))
		     (?\? ,(regexp-opt '("??" "?." "?=" "?:")))
		     (?#  ,(regexp-opt '("####" "###" "#[" "#{" "#=" "#!" "#:" "#_(" "#_" "#?" "#(" "##")))
		     (?\; ,(regexp-opt '(";;")))
		     (?_  ,(regexp-opt '("_|_" "__")))
		     (?\\ ,(regexp-opt '("\\" "\\/")))
		     (?~  ,(regexp-opt '("~~" "~~>" "~>" "~=" "~-" "~@")))
		     (?$  ,(regexp-opt '("$>")))
		     (?^  ,(regexp-opt '("^=")))
		     (?\] ,(regexp-opt '("]#"))))))
    (dolist (char-regexp ligatures)
      (apply (lambda (char regexp) (set-char-table-range
				    composition-function-table
				    char `([,regexp 0 font-shape-gstring])))
	     char-regexp)))

;; icon fonts to prettify doom mode line
(use-package all-the-icons
  :init
  (when (and (not (member "all-the-icons" (font-family-list)))
	     (window-system))
    (all-the-icons-install-fonts t)))

;; Better completion with ivy and counsel
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)	
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons-ivy-rich
  :after ivy
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
   :after (ivy all-the-icons-ivy-rich)
   :init
   (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

;; Better sorting with prescient
(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

(use-package doom-themes
  :custom
  ((doom-themes-enable-bold t)
   (doom-themes-enable-italic t)
   (doom-themes-padded-modeline t))
  :config
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  (load-theme 'doom-dracula t))

;; Better modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  ;; Show column number in modeline
  (column-number-mode))

;; store backup files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

;; store auto-save files in the tmp dir
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom
  (delete-by-moving-to-trash t))

(use-package dired-single
  :after dired
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :after dired
  :commands (dired dired-jump)
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

;; Want this to run on every file open for org mode
(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 2.0)
		  (org-level-2 . 1.7)
		  (org-level-3 . 1.4)
		  ;(org-level-4 . 1.2)
		  (org-level-5 . 1.0)
		  (org-level-6 . 1.0)
		  (org-level-7 . 1.0)
		  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Alegreya" :weight 'normal :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

;; Org mode that comes bundled with Emacs is usually out of date
;; org-plus-contrib has the latest version with all the recent community contributions
;; (use-package org-plus-contrib)

(use-package org
  :commands (org-capture org-agenda)
  :hook (org-mode-hook . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
	org-hide-emphasis-markers t)
  (efs/org-font-setup))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package visual-fill-column
  :defer t
  :hook ((org-mode . visual-fill-column-mode)
	 (markdown-mode . visual-fill-column-mode))
  :custom
  (visual-fill-column-width 120)
  (visual-fill-column-center-text t))

(setq org-confirm-babel-evaluate nil)

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
			   (expand-file-name "~/Work/repos/dotfiles/emacs/dotfiles.org"))
	 ;; Dynamic scoping to the rescue
	 (let ((org-confirm-babel-evaluate nil))
	   (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package magit
  :commands (magit-status magit-get-current-branch))

(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  :custom
  ((projectile-completion-system 'ivy)
   (projectile-sort-order 'recently-active))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Work/repos")
    (setq projectile-project-search-path '("~/Work/repos")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

;; Highlight delimiters like parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package company
  :bind
  (:map company-active-map ("<tab>" . company-complete-selection))
  (:map lsp-mode-map ("<tab>" . company-indent-or-complete-common))
  :custom	
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  ;; avoid resizing of popup while typing.
  (company-tooltip-maximum-width 80)
  (company-tooltip-minimum-width 80))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :custom
  (lsp-completion-provider :company-capf)
  (lsp-enable-which-key-integration t)
  (lsp-headerline-breadcrumb-enable nil))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show-with-cursor nil))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy
  :after lsp)

(defun dot/set-markdown-header-font-sizes ()
  (dolist (face '((markdown-header-face-1 . 2.0)
		  (markdown-header-face-2 . 1.7)
		  (markdown-header-face-3 . 1.4)
		  (markdown-header-face-4 . 1.1)
		  (markdown-header-face-5 . 1.0)))
    (set-face-attribute (car face) nil :font "Alegreya" :weight 'normal :height (cdr face))))

(defun dot/markdown-mode-hook ()
  (dot/set-markdown-header-font-sizes))

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-command "multimarkdown")
  (markdown-hide-urls t)
  (markdown-fontify-code-blocks-natively t)
  :config
  (add-hook 'markdown-mode-hook 'dot/markdown-mode-hook))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(with-eval-after-load 'lsp
    (lsp-register-custom-settings
     '(("gopls.completeUnimported" t t)
       ("gopls.staticcheck" t t))))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  (python-shell-interpreter "python3"))

(use-package lsp-pyright
  :ensure t
  :after (python-mode lsp-mode))

(use-package py-isort
  :ensure t
  :after (python-mode)
  :config
  (setq py-isort-options '("--profile=black")))

(use-package python-black
  :ensure t
  :after python-mode)

;; Set up before-save hooks to format buffer.
(defun dot/python-save-hooks ()
  (add-hook 'before-save-hook #'py-isort-buffer t t)
  (add-hook 'before-save-hook #'python-black-buffer t t))

(add-hook 'python-mode-hook #'dot/python-save-hooks)

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

(use-package term
  :commands term
  :config
  (setq explicit-shell-file-name "zsh") ;; Change this to bash, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  (setq vterm-shell "zsh")                         ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))
