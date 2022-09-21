;;; init.el --- My heckin based init file
;; Author: 3Gigs <yanghuaxuan@gmail.com>

;;; Code:

;;;; SECTION: Startup

(setq byte-compile-warnings '(cl-functions))
(require 'cl-lib)
; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))
(setq debug-on-error t)
(setq package-enable-at-startup nil)
;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
	       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
            (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
          (with-current-buffer
	            (url-retrieve-synchronously
		               "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
			                'silent 'inhibit-cookies)
		          (goto-char (point-max))
			        (eval-print-last-sexp)))
      (load bootstrap-file nil 'nomessage))
;; Install use-package
(eval-when-compile
  (straight-use-package 'use-package))

;;;; SECTION: Packages

(use-package evil
  :straight t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config (evil-mode 1))
(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))
(use-package which-key
  :straight t
  :config
  (which-key-mode 1)
  (which-key-setup-minibuffer))
(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-city-lights t))
(use-package doom-modeline
  :straight t
  :config
  (setq doom-modeline-height 35)
  (doom-modeline-mode 1))
(use-package all-the-icons
  :straight t
  :if (display-graphic-p))
(use-package magit
  :straight t
  :config
  (with-eval-after-load 'magit-mode
    (add-hook 'after-save-hook 'magit-after-save-refresh-status t))
  (setq magit-status-buffer-switch-function
	#'magit-display-buffer-same-window-except-diff-v1))
(use-package treemacs
  :straight t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-no-delete-other-windows         t
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
	("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))
(use-package treemacs-all-the-icons
  :straight t
  :config (treemacs-load-theme "all-the-icons"))
(use-package treemacs-evil
  :straight t
  :after (treemacs evil))
(use-package treemacs-icons-dired
  :straight t
  :hook (dired-mode . treemacs-icons-dired-enable-once))
(use-package treemacs-magit
  :straight t
  :after (treemacs magit))
(use-package hydra
  :straight t
  :config
  ; Summon the hydra
  (global-set-key
  (kbd "C-M-W")
  (defhydra hydra-window () "Move around windows with hydra and vi binds"
  ("h" windmove-left)
  ("l" windmove-right)
  ("j" windmove-down)
  ("k" windmove-up)
  ("q" nil "cancel")))
  (global-set-key
  (kbd "C-M-R")
  (defhydra hydra-resize () "Resize window"
  ("h" shrink-window-horizontally)
  ("l" enlarge-window-horizontally)
  ("j" shrink-window)
  ("k" enlarge-window)
  ("q" nil "cancel"))))
(use-package company
  :straight t
  :config
  (company-mode))
(use-package lsp-mode
  :straight t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode)
(use-package lsp-treemacs
  :straight t
  :commands lsp-treemacs-errors-list)
(use-package origami
  :straight t)
;(use-package nano-modeline
;  :straight t
;  :config
;  (nano-modeline))
(use-package flycheck
  :straight t
  :init (global-flycheck-mode))
;:config (add-hook 'after-init-hook' 'global-flycheck-mode))
(use-package projectile
  :straight t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))
(use-package ivy
  :straight t
  :config
  (ivy-mode)
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  (ivy-count-format "%d/%d "))
(use-package counsel
  :straight t
  :config
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))
(use-package marginalia
  :straight t
  :init
  (marginalia-mode)
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle)))
;; Helm (Currently using Ivy)
;;(use-package helm
;;  :straight t
;;  :config (helm-autoresize-mode 1)
;;  (helm-mode)
;;  (setq
;;   helm-split-window-inside-p t
;;   helm-autoresize-max-height 40)
;;   (global-set-key (kbd "M-x") 'helm-M-x)
;;   (global-set-key (kbd "C-x b") 'helm-mini)
;;   (global-set-key (kbd "C-x C-f") 'helm-find-files)
;;   (global-set-key (kbd "C-h a") 'helm-apropos))
;;(use-package helm-swoop
;;  :straight t
;;  :after (helm))
;;(use-package helm-ag
;;  :straight t
;;  :after (helm))

(use-package dap-mode
  :straight t
  :config
  (dap-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (
require 'dap-cpptools))
(use-package org
  :straight t
  :hook
  (org-mode . org-indent-mode)
  (org-mode . variable-pitch-mode)
  :custom
  (org-agenda-files '("~/org" "~/RoamNotes"))
  (org-todo-keywords
   '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)" "STALLED(s)")))
  (org-log-done `time)
  (org-enforce-todo-dependencies t)
  (org-hide-emphasis-markers t)
  (org-src-fontify-natively t)
  (org-hidden-keywords '(title))
  :config
  (font-lock-add-keywords
   'org-mode
   ; Hide all org stars
   '(("^\\*+ "
      (0
       (prog1 nil
         (put-text-property (match-beginning 0) (match-end 0)
                            'face (list :foreground
                                        (face-attribute
                                         'default :background))))))))
  (let* ((variable-tuple
        (cond ((x-list-fonts "ETBembo") '(:font "ETBembo"))
              ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
              ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
              ((x-list-fonts "Verdana")         '(:font "Verdana"))
              ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
              (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))
    (custom-theme-set-faces
    'user
    `(variable-pitch ((t (,@variable-tuple :height 100 :weight thin))))
    `(fixed-pitch ((t (:family "JetBrains Mono" :heigth 90))))
    `(org-level-8 ((t (,@headline ,@variable-tuple))))
    `(org-level-7 ((t (,@headline ,@variable-tuple))))
    `(org-level-6 ((t (,@headline ,@variable-tuple))))
    `(org-level-5 ((t (,@headline ,@variable-tuple))))
    `(org-level-4 ((t (,@headline ,@variable-tuple))))
    `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.20))))
    `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.30))))
    `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.40))))
    `(org-block ((t (:weight normal :inherit (shadow fixed-pitch)))))
    `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))
    `(org-document-info  ((t (,@headline ,@variable-tuple :height 1.30 :underline nil)))))))
(use-package evil-org
  :straight t
  :after org
  :hook
  (org-mode . (lambda () evil-org-mode))
  (org-mode . (lambda () (setq display-line-numbers-type nil)))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(use-package org-roam
  :straight t
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-dailies-directory "dailies/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-complete-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))
(use-package zoom
  :straight t
  :config
  (zoom-mode)
  :custom
  (zoom-size '(0.618 . 0.618)))

(use-package dashboard
  :straight t
  :custom
  (dashboard-banner-logo-title "GNU Emacs!")
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-items '((recents . 5)
                     (bookmarks . 5)
                     (projects . 5)
                     (registers . 5)))
  :config
  (dashboard-setup-startup-hook))
    
;;;; SECTION: Misc. Config

;; For config that doesn't belong to any packages
; Disable scroll bar
(scroll-bar-mode -1)
; Set font
(add-to-list 'default-frame-alist '(font . "JetBrains Mono"))
; Enable CUA (Global copy-paste)
(cua-mode)
; Relative line numbers
;(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
; Disable automatic creation of backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old
(global-auto-revert-mode t)
(setq dired-auto-revert-buffer t)
; Use spaces
(setq-default indent-tabs-mode nil)

; Bind completions at point
(global-set-key (kbd "C-M-i") 'completion-at-point)
(let* ((agenda-map (make-sparse-keymap)))
    (define-key agenda-map (kbd "C-a") 'org-agenda)
    (define-key agenda-map (kbd "C-t") 'goto-todo)
    (global-set-key (kbd "C-a") agenda-map))

; No bell
(setq ring-bell-function 'ignore)

; Set variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu-bar-mode nil)
 '(org-agenda-files nil nil nil "Customized with use-package org")
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "JetBrains Mono" :heigth 90))))
 '(org-block ((t (:weight normal :inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande" :height 1.3 :underline nil))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande" :height 2.0 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande" :height 1.4))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande" :height 1.3))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande" :height 1.2))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande"))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#A0B3C5" :font "Lucida Grande"))))
 '(variable-pitch ((t (:font "Lucida Grande" :height 100 :weight thin)))))
