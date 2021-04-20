;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Log commands in a buffer
(use-package command-log-mode)

;; Compose key sequences
(use-package hydra)

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
