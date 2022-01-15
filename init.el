;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(setq warning-suppress-types '('(el)))

(require 'cl-lib)
;; SECTION: PACKAGES
;; use straight.el
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

; Enable use-package
; Use-package config
(eval-when-compile
  (straight-use-package 'use-package))
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
	doom-themes-enable-italic t))
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
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
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
(use-package hydra)
  :straight t
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
(use-package typescript-mode
  :straight t
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 4))
(use-package origami
  :straight t)
;(use-package nano-modeline
;  :straight t
;  :config
;  (nano-modeline))
(use-package flycheck
  :straight t
  :init (global-flycheck-mode)
  :config (add-hook 'after-init-hook' #'global-flycheck-mode))
(use-package projectile
  :straight t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))
(use-package helm
  :straight t
  :config (helm-autoresize-mode 1)
  (helm-mode)
  (setq
   helm-split-window-inside-p t
   helm-autoresize-max-height 40)
   (global-set-key (kbd "M-x") 'helm-M-x)
   (global-set-key (kbd "C-x b") 'helm-mini)
   (global-set-key (kbd "C-x C-f") 'helm-find-files)
   (global-set-key (kbd "C-h a") 'helm-apropos))
(use-package helm-swoop
  :straight t
  :after (helm))
(use-package helm-ag
  :straight t
  :after (helm))
(use-package dap-mode
  :straight t
  :config
  (dap-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools))
(use-package org
  :straight t
  :custom
  (org-agenda-files '("~/org" "~/RoamNotes"))
  (org-todo-keywords
   '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)" "STALLED(s)")))
  (org-log-done `time)
  (org-enforce-todo-dependencies t)
  (org-hide-emphasis-markers t))
(use-package evil-org
  :straight t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
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
    
;; section: MISC CONFIG
; Most configs are part of the packages section. This is for config that I prefer would be here instead
; Load theme
(load-theme 'doom-city-lights t)
; Disable scroll bar
(scroll-bar-mode -1)
; Set font
(add-to-list 'default-frame-alist '(font . "JetBrains Mono"))
;; Prettify? TODO
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
   ("q" nil "cancel")))
; Enable CUA (Global copy-paste)
(cua-mode)
; Relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
; Set startup screen
(setq initial-buffer-choice (lambda () get-buffer-create "*dashboard*"))
; Disable auto-save
(setq auto-save-default nil)
;; Write backups to ~/.emacs.d/backup/
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old
(global-auto-revert-mode t)
(setq dired-auto-revert-buffer t)
(setq-default indent-tabs-mode nil)

; Shortcuts for common uses
(defun goto-todo () "Goto ~/org/Cooode.org" (interactive)
       (split-window-horizontally)
       (find-file "~/org/Cooode.org"))
(defun goto-config () "Goto Emacs config" (interactive)
       (split-window-below)
       (find-file (concat user-emacs-directory "init.el")))

(global-set-key (kbd "C-c c") 'goto-config)

; Bind completions at point
(global-set-key (kbd "C-M-i") 'completion-at-point)
(let* ((agenda-map (make-sparse-keymap)))
    (define-key agenda-map (kbd "C-a") 'org-agenda)
    (define-key agenda-map (kbd "C-t") 'goto-todo)
    (global-set-key (kbd "C-a") agenda-map))

;(goto-todo) (lambda () "Go to TODO file" (interactive) (find-file "~/org/Cooode.org")))

;; SECTION: SETTINGS FROM EMACS CUSTOMIZE
(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "d47f868fd34613bd1fc11721fe055f26fd163426a299d45ce69bef1f109e1e71" "fb3edc31220f6ffa986dbbb184c45c7684e0c4e04fbd6ea44a33cc52291c3894" "82e799bb68717f8cafe76263134e32e1e142add3563e49099927d517a39478d0" default))
 '(helm-minibuffer-history-key "M-p")
 '(menu-bar-mode nil)
 '(org-agenda-files
   '("~/RoamNotes/20220114211727-org_mode_beautifying.org" "/home/threegigs/test.org" "/home/threegigs/org/Calc1_Optimization.org" "/home/threegigs/org/Cooode.org" "/home/threegigs/RoamNotes/20220113235130-org_mode.org" "/home/threegigs/RoamNotes/20220114002348-org_roam_fleeting_notes.org" "/home/threegigs/RoamNotes/20220114012627-zettelkasten_method.org" "/home/threegigs/RoamNotes/20220114021724-emacs.org" "/home/threegigs/RoamNotes/20220114021859-elisp.org" "/home/threegigs/RoamNotes/20220114022220-elisp_quoting.org" "/home/threegigs/RoamNotes/20220114023410-elisp_anonymous_functions.org" "/home/threegigs/RoamNotes/20220114024120-org_roam_capture_templates.org" "/home/threegigs/RoamNotes/20220114032034-org_mode_agenda.org" "/home/threegigs/RoamNotes/20220114210048-org_checkboxes.org") nil nil "Customized with use-package org")
 '(package-selected-packages '(gigs-splash evil-org use-package ##))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t nil)))
 '(mode-line-buffer-id ((t nil)))
 '(mode-line-emphasis ((t nil)))
 '(mode-line-highlight ((t nil)))
 '(nano-modeline-active ((t nil)))
 '(nano-modeline-active-name ((t nil)))
 '(nano-modeline-active-primary ((t nil)))
 '(nano-modeline-active-secondary ((t nil)))
 '(nano-modeline-active-status-** ((t nil)))
 '(nano-modeline-active-status-RO ((t (:background "dark red"))))
 '(nano-modeline-active-status-RW ((t (:background "black"))))
 '(nano-modeline-inactive ((t nil)))
 '(nano-modeline-inactive-name ((t nil)))
 '(nano-modeline-inactive-primary ((t nil)))
 '(nano-modeline-inactive-secondary ((t nil)))
 '(nano-modeline-inactive-status-** ((t nil)))
 '(nano-modeline-inactive-status-RO ((t nil)))
 '(nano-modeline-inactive-status-RW ((t nil))))

