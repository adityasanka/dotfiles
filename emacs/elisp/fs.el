;; store backup files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))

;; store auto-save files in the tmp dir
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
