(setq package-enable-at-startup nil)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; 1. Elpaca Bootstrap FIRST
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; 2. Install use-package support
(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t)
  (setq use-package-always-ensure t)
)
(elpaca-wait)


;; UI behavior & Theme (Replaces package.el)
(setq inhibit-startup-screen t) 
(cua-mode t) 


;; Define your synonym dictionary using regular expressions
(defvar my/orderless-synonyms
  '(("quit"  . "\\(quit\\|delete\\|close\\|kill\\)")
    ("close" . "\\(quit\\|delete\\|close\\|kill\\)")
    ("del"   . "\\(delete\\|kill\\|remove\\)")
    ("file"  . "\\(file\\|document\\|buffer\\)")))

;; Create the custom matching style
(defun my/orderless-synonym-style (pattern)
  "If PATTERN exists in our dictionary, return its synonym regex."
  (cdr (assoc pattern my/orderless-synonyms)))



;; elpaca install packages
(use-package compat)
(use-package transient)
(use-package atom-one-dark-theme
  :config
  (load-theme 'atom-one-dark t))
(use-package standard-keys-mode
  :vc (:url "https://github.com/DevelopmentCool2449/standard-keys-mode"
       :rev :newest)
  :config
  (standard-keys-mode 1))
(use-package casual
  :bind ("C-," . my-casual-menu))
;;(use-package vim-tab-bar
;;  :commands vim-tab-bar-mode
;;  :hook (after-init . vim-tab-bar-mode))
(use-package savehist
  :ensure nil ;; error otherwise
  :config
  (add-to-list 'savehist-additional-variables 'read-expression-history)
  (savehist-mode 1))
(use-package vim-tab-bar
  :config
  (vim-tab-bar-mode 1))
(use-package markdown-mode :demand t)
(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode)
  :config (global-visual-line-mode 1)
)
(use-package treesit-auto
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
(use-package pet
  :hook (python-mode . pet-mode))
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-popupinfo-direction 'right) ; Show docs to the right of the menu
  :config
  (global-corfu-mode)
  (corfu-popupinfo-mode 1)) ; Enable the docstring panel
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  :config
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-buster))
(use-package vertico
  :config (vertico-mode 1))
(use-package vertico-posframe
  :after vertico
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  (vertico-posframe-mode 1))
;; Configure Orderless to use the new style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '(file (styles partial-completion)))
  ;; THIS is the line that actually turns your synonyms on!
  (orderless-matching-styles '(my/orderless-synonym-style
                               orderless-literal
                               orderless-regexp)))



;; SYNCRONIZE
(elpaca-wait) ;; Force Elpaca to finish markdown-mode before next line


;; 5. Rest of configuration (Vertico, Corfu, Casual, etc.)



;; ----------------------------- 
;; Install + load Atom One theme 
;; ----------------------------- 
;;(unless (package-installed-p 'atom-one-dark-theme) 
;;  (package-install 'atom-one-dark-theme)) 
;;(load-theme 'atom-one-dark t) 

;; ----------------------------- 
;; UI behavior 
;; ----------------------------- 
(setq inhibit-startup-screen t) 
(cua-mode t) 

;; ----------------------------- 
;; Font fallback (symbols + emoji) 
;; ----------------------------- 
;;(set-fontset-font t 'symbol  "Noto Sans Symbols 2" nil 'prepend) 
;;(set-fontset-font t 'unicode "DejaVu Sans"         nil 'prepend) 
;;(set-fontset-font t 'unicode "Noto Sans Symbols"   nil 'prepend) 
;;(set-fontset-font t 'unicode "Noto Sans Symbols 2" nil 'prepend) 
;;(set-fontset-font t 'symbol  "Noto Color Emoji"    nil 'prepend) 






(defun my-casual-menu () 
  (interactive) 
  (pcase major-mode 
    ((guard (bound-and-true-p isearch-mode)) (casual-isearch-tmenu)) 
    ('dired-mode (casual-dired-tmenu)) 
    ('magit-status-mode (casual-magit-tmenu)) 
    (_ (casual-editkit-main-tmenu)))) 


(global-set-key [S-down-mouse-1] nil)
(global-set-key [S-mouse-1] 'mouse-set-region)

;; Global bindings. Load immediately.
(keymap-global-set "M-<up>"    'windmove-up)
(keymap-global-set "M-<down>"  'windmove-down)
(keymap-global-set "M-<left>"  'windmove-left)
(keymap-global-set "M-<right>" 'windmove-right)
(keymap-global-set "C-(" 'split-window-right)
(keymap-global-set "C-)" 'split-window-below)

;; Core Emacs hook. Evaluate immediately.
(add-hook 'kill-buffer-hook #'my/save-buffer-before-kill)

;; Delay evaluation until package exists.
(with-eval-after-load 'standard-keys-mode
  (keymap-set standard-keys-default-keymap "C-t" #'tab-new)
  (keymap-set standard-keys-default-keymap "C-<prior>" #'tab-previous)
  (keymap-set standard-keys-default-keymap "C-<next>"  #'tab-next)
  (keymap-set standard-keys-default-keymap "C-S-w"   #'tab-bar-undo-close-tab)
  (keymap-set standard-keys-default-keymap "M-w"   #'kill-current-buffer)
  (keymap-set standard-keys-default-keymap "C-w" #'my/close-tab-or-split-or-buffer)
  (keymap-set standard-keys-default-keymap "M-S-w" #'my/undo-kill-buffer)
  (keymap-set standard-keys-default-keymap "C-0" (lambda () (interactive) (text-scale-set 0)))
  (keymap-unset standard-keys-default-keymap "C-<return>")
  (keymap-unset standard-keys-default-keymap "C-RET")
  (keymap-set standard-keys-default-keymap "C-<return>" #'my/bare-newline)
)

(defun my/close-tab-or-split-or-buffer ()
  (interactive)
  (cond
   ((> (length (tab-bar-tabs)) 1) (tab-close))
   ((> (count-windows) 1)         (delete-window))
   (t                             (kill-current-buffer))))



(defvar my/killed-buffers '())

(defun my/save-buffer-before-kill ()
  (push (list (buffer-name)
              (buffer-string)
              major-mode
              (buffer-file-name))
        my/killed-buffers))

(defun my/undo-kill-buffer ()
  (interactive)
  (when my/killed-buffers
    (let* ((buf    (pop my/killed-buffers))
           (name   (nth 0 buf))
           (text   (nth 1 buf))
           (mode   (nth 2 buf))
           (file   (nth 3 buf)))
      (switch-to-buffer (get-buffer-create name))
      (insert text)
      (funcall mode)
      (when file (set-visited-file-name file)))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(adaptive-wrap atom-one-dark-theme casual centaur-tabs markdown-mode
                   pet rust-mode standard-keys-mode treesit-auto vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )




(tab-bar-mode -1)
(tab-line-mode -1)






(tool-bar-mode -1)


(setq cua-keep-region-on-copy t)
(setq standard-keys-copy-keep-region t)

(defadvice standard-keys-copy-region-or-line (after keep-region activate)
  (setq deactivate-mark nil))


(setq-default line-spacing 0)


(set-face-attribute 'default nil :family "Mononoki Nerd Font")
(set-fontset-font t 'unicode "Mononoki Nerd Font"         nil 'append) 
(set-fontset-font t 'emoji  "Twitter Color Emoji" nil 'prepend)
;;(set-fontset-font t 'symbol "pang" nil 'p)
;;(set-fontset-font t 'symbol "Twemoji" nil 'append)


(defun pipe-region-to-shell (start end command)
  (interactive "r\nsShell command: ")
  (shell-command-on-region start end command t t))

(global-set-key (kbd "C-\\") 'pipe-region-to-shell)

(global-display-line-numbers-mode 1)

(setq initial-major-mode 'markdown-mode)
(setq initial-scratch-message "")


(defvar my/line-number-face-remaps nil)

(defun sync-line-number-height ()
  (dolist (remap my/line-number-face-remaps)
    (face-remap-remove-relative remap))
  (setq my/line-number-face-remaps nil)
  (let ((scale (expt text-scale-mode-step text-scale-mode-amount)))
    (push (face-remap-add-relative 'line-number :height scale)
          my/line-number-face-remaps)
    (push (face-remap-add-relative 'line-number-current-line :height scale)
          my/line-number-face-remaps)))

(add-hook 'text-scale-mode-hook #'sync-line-number-height)


(set-face-attribute 'default nil :height 247)
(text-scale-set 0)

(setq scroll-conservatively 101)
(setq scroll-margin 1)


(defun my/newline-preserve-indent ()
  (interactive)
  (let ((indent (save-excursion
                  (beginning-of-line)
                  (looking-at "[ \t]*")
                  (match-string 0))))
    (newline)
    (insert indent)))



(global-set-key (kbd "RET") #'my/newline-preserve-indent)
(global-set-key (kbd "S-RET") #'my/newline-preserve-indent)

(defun my/bare-newline ()
  (interactive)
  (let ((electric-indent-inhibit t))
    (newline)))

(electric-indent-mode -1)
(setq-default indent-tabs-mode nil)




(with-eval-after-load 'markdown-mode
  (setq markdown-fontify-code-blocks-natively t)
  (add-to-list 'markdown-code-lang-modes '("bash" . bash-ts-mode)))





(global-prettify-symbols-mode +1)




;; Unbind the default mark command from C-SPC
(global-unset-key (kbd "C-SPC"))

;; Bind C-SPC to the LSP completion trigger
(global-set-key (kbd "C-SPC") 'completion-at-point)



;; background transparency
(add-to-list 'default-frame-alist '(alpha-background . 80))
(set-frame-parameter nil 'alpha-background 88)


(defun m3ga-tab-open (file)
  "Open FILE in a new tab, reusing existing frame.
If FILE is already open in a tab, switch to it.
Otherwise open FILE in a new tab in the existing frame."
  (interactive "f")
  (let ((existing-tab
         (cl-find-if
          (lambda (tab)
            (equal (alist-get 'name tab) (abbreviate-file-name file)))
          (tab-bar-tabs))))
    (if existing-tab
        (tab-bar-switch-to-tab (alist-get 'name existing-tab))
      (tab-bar-new-tab)
      (find-file file)))
  (select-frame-set-input-focus (selected-frame)))
  
  


(add-hook 'emacs-startup-hook
          (lambda ()
            (setopt gc-cons-threshold 800000
                    gc-cons-percentage 0.1
                    file-name-handler-alist startup/file-name-handler-alist)))

;;; Store customization file in separate file
;; (Optional)
;; (setopt custom-file (concat user-emacs-directory "config-lisp-files/custom.el"))
;; (load custom-file)

;; Disable theme on Terminal and enable Mouse Support
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  (if (eq system-type 'window-nt)
      (disable-theme (car custom-enabled-themes))))

;; For emacs-31
;;(dolist (content `("whatever/path/" ,user-emacs-directory
;;                   ,(concat user-emacs-directory "config-lisp-files/")))
;;  (add-to-list 'trusted-content content))


;; The following code shown below is in case you prefer
;; to use separate files, be careful where you copy.
(let ((configuration-directory (concat user-emacs-directory "config-lisp-files/")))
;; ;; PACKAGES
;;(load (concat configuration-directory "packages"))

;; ;; INTERNAL CONFIGURATIONS
;; (load (concat configuration-directory "internal-configurations"))

;; ;; KEY MAPPINGS
;; (load (concat configuration-directory "key-mappings"))

;; ;; SYNTAX HIGHLIGHTING
;; (load (concat configuration-directory "syntax-highlighting"))

;; ;; GUI ENHANCEMENT
;; (load (concat configuration-directory "tool-bar"))
;; (load (concat configuration-directory "menu-bar"))

;; ;; MISC
;; (load (concat configuration-directory "minibuffer"))
;; (load (concat configuration-directory "ui-enchantment"))
;; (load (concat configuration-directory "misc"))

;; ;; SYNTAX AND SPELL CHECKING
;; (load (concat configuration-directory "syntax-checking"))
;; (load (concat configuration-directory "spell-checking"))

;; ;; WINDOWS AND FRAMES
;; (load (concat configuration-directory "window-management"))

;; ;; LSP CONFIGURATION
;; (load (concat configuration-directory "lsp"))

;; ;; FiLE MANAGEMENT
;; (load (concat configuration-directory "file-management"))

;; ;; COMPLETION
;; (load (concat configuration-directory "smart-completion"))

;; ;; MODELINE
;; (load (concat configuration-directory "mode-line"))

;; ;; THEMES
;; (load (concat configuration-directory "custom-themes"))

;; ;; DASHBOARD
;; (load (concat configuration-directory "dashboard"))

;; ;; CONFIGURING ORG MODE
;; (load (concat configuration-directory "org-mode"))

;; ;; CENTAUR TABS
;; (load (concat configuration-directory "window-tabs"))

;; ;; SNIPPETS
;; (load (concat configuration-directory "code-snippets"))

;; ;; AUTO-INSERT
;; (load (concat configuration-directory "auto-insert-templates"))

;; ;; ENABLE LIGATURES
;; (load (concat configuration-directory "font-ligatures"))

;; ;; START EMACS CLIENT AT STARTING EMACS
;; (require 'server)
;; (unless (server-running-p) (server-start))

;; ;; For fix a Woman Error
;; (savehist-mode t))

;; close the let
)

;; 7. Restoration Hook
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist startup/file-name-handler-alist)
            (setq gc-cons-threshold 800000)))
