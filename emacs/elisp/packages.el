;; Package Management
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
	("marmalade" . "http://marmalade-repo.org/packages/")
	("melpa stable" . "http://stable.melpa.org/packages/")
	("melpa" . "http://melpa.milkbox.net/packages/")))

;;; Install use-package if not available
(require 'package)
(setq package-enable-at-startup nil) ; ?
(package-initialize) ; ?
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
