;; Ido mode
(when (> emacs-major-version 21)
  (ido-mode t)
  (setq ido-enable-prefix nil
	ido-enable-flex-matching t
	ido-use-filename-at-point 'guess))

;; add .emacs.d/themes to custom-theme-load-path
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
;; Org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock); not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;(defun my-kill-emacs ()
;  "save some buffers, then exit unconditionally"
;  (interactive)
;  (save-some-buffers nil t)
;  (kill-emacs))
;(global-set-key (kbd "C-x C-c") 'my-kill-emacs)

;; Backup files? Not hanks
(setq make-backup-files nil)

;; No splash screen
(setq inhibit-startup-message t
     inhibit-startup-echo-area-message t)

;; Simpler regexp for re-builder
(require 're-builder)
(setq reb-re-syntax 'string)

;; Just 'y or n' please
(fset 'yes-or-no-p 'y-or-n-p)

;; Auto save files should go in ~/.emacs.d/autosaves
;; while backups go in ~/.emacs.d/backups
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
;; create the autosave directory since Emacs won't
(make-directory "~/.emacs.d/autosaves/" t)

;; Save a list of recent files opened
(recentf-mode 1)

;; Highlight matching parentheses when the pointer is on them
(show-paren-mode 1)

;; Hunspell please
(setq ispell-program-name "hunspell")

;; 4 spaces for tab
(setq tab-width 4)

;; Highlight selection
(transient-mark-mode t)

;; No toolbar
(tool-bar-mode -1)

;; Edit tar/jar/gzip files automatically
(auto-compression-mode 1)

;; SavePlace
;; remember last position of cursor in any file
(require 'saveplace)
(setq-default save-place t)

;; Rainbow delimiters
;; highlight parentheses in a different colour according to their depth
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)
