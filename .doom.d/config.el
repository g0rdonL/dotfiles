;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setenv "LANG" "")
(setq mac-command-modifier 'ctrl)
(map! "C-q" (lambda(&optional window frame force)
              (interactive)
              (if (= 1 (length (window-list frame)))
                  (delete-frame frame force)
                (delete-window window))))
;; (setq user-emacs-directory "~/.emacs.d/")
(setq user-emacs-directory "/Users/gordonlee/meili/gordon.lee_dacs_at_okg.com/110/Documents/emacs.d/")
(setq default-directory "/Users/gordonlee/meili/gordon.lee_dacs_at_okg.com/110")
(load user-init-file)


;; Fonts
(setq doom-font (font-spec :family "VictorMono Nerd Font" :size 14)
      doom-big-font (font-spec :family "VictorMono Nerd Font" :size 18)
      doom-unicode-font (font-spec :family "Font Awesome 6 Free")
      doom-variable-pitch-font (font-spec :family "Crimson Pro" :size 14)
      doom-serif-font (font-spec :family "IBM Plex Serif"))
(setq doom-theme 'doom-dracula
      doom-themes-enable-bold t
      doom-themes-enable-italic t
      doom-themes-treemacs-enable-variable-pitch nil)
(setq org-element-use-cache nil)
(map! :i "C-<tab>" #'+company/complete)
;; (after! company
;;   ;; (setq company-show-quick-access t)
;;   ;; (define-key company-active-map (kbd "<tab>") 'company-complete-selection)
;;   (add-hook 'evil-normal-state-entry-hook #'company-abort) ;; make aborting less annoying.
;;   (setq company-idle-delay 0.1)
;;   )
;; (add-hook 'flycheck-mode-hook (lambda() (flycheck-popup-tip-mode -1)))
(defun text-hook()
  (mixed-pitch-mode)
  (variable-pitch-mode)
  (lsp))

(add-hook 'org-mode-hook 'text-hook)
;; (add-hook 'org-mode-hook #'variable-pitch-mode)
(add-hook 'markdown-mode-hook 'text-hook)
;; (add-hook 'markdown-mode-hook #'variable-pitch-mode)
(setq mixed-pitch-set-height t)
(setq lsp-grammarly-dialect "british")

;; variable-sized headings in org mode
(custom-set-faces!
  '('hl-line nil)
  '(variable-pitch :family "Crimson Pro" :height 168)
  '(font-lock-builtin-face :slant italic)
  '(font-lock-comment-face :slant italic)
  '(font-lock-function-name-face :weight bold :slant italic)
  '(font-lock-keyword-face :slant italic))
(setq-default major-mode 'org-mode)
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)


(add-hook 'before-save-hook
          (lambda ()
            (org-babel-map-src-blocks nil
              (if (equal (alist-get :format (org-babel-parse-header-arguments header-args) "yes") "yes")
                  (+format--org-region nil nil)))))

(set-company-backend!
  '(text-mode
    markdown-mode
    gfm-mode)
  '(:seperate
    ;; company-ispell
    company-files
    company-yasnippet))
(set-company-backend! 'ess-r-mode '(company-R-args company-R-objects company-dabbrev-code :separate))

;; Connect to main workspace on incomming emacsclient session
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))
(add-hook 'doom-first-buffer-hook
          (defun +abbrev-file-name ()
            (setq-default abbrev-mode t)
            (setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir))))
(after! evil
  (setq evil-ex-substitute-global t     ; I like my s/../.. to by global by default
        ;; evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil)) ; Don't put overwritten text in the kill ring
;; whitespace
;; (remove-hook 'after-change-major-mode-hook #'doom-highlight-non-default-indentation-h)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/x/notes/")
(setq org-hide-emphasis-markers t)

(setq treemacs-position 'right)


;; (after! before-save-hook
;;   (setq highlight-indent-guides-mode 'nil)
;;   (setq highlight-indent-guides-mode 1))

(defun org-checkbox-todo ()
  "Switch header TODO state to DONE when all checkboxes are ticked, to TODO otherwise"
  (let ((todo-state (org-get-todo-state)) beg end)
    (unless (not todo-state)
      (save-excursion
        (org-back-to-heading t)
        (setq beg (point))
        (end-of-line)
        (setq end (point))
        (goto-char beg)
        (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
                               end t)
            (if (match-end 1)
                (if (equal (match-string 1) "100%")
                    (unless (string-equal todo-state "DONE")
                      (org-todo 'done))
                  (unless (string-equal todo-state "TODO")
                    (org-todo 'todo)))
              (if (and (> (match-end 2) (match-beginning 2))
                       (equal (match-string 2) (match-string 3)))
                  (unless (string-equal todo-state "DONE")
                    (org-todo 'done))
                (unless (string-equal todo-state "TODO")
                  (org-todo 'todo)))))))))
(add-hook 'org-checkbox-statistics-hook 'org-checkbox-todo)
(setq evil-normal-state-cursor '(box "#bd93f9")
      evil-emacs-state-cursor '(box "#bd93f9")
      evil-replace-state-cursor '(hbar "#ff5555")
      evil-operator-state-cursor '(hollow "#ff5555")
      evil-insert-state-cursor '(bar "#8be9fd")
      evil-visual-state-cursor '(box "#8be9fd"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq scroll-step 1)
(setq scroll-margin 2 ; It's nice to maintain a little margin
      undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t)                       ; By default while in insert all changes are one big
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

(map! "C-/" #'(lambda ()
                "Toggles commenting on the current line if no region is defined,
   otherwise toggles comments on the region"
                (interactive "*")
                (let ((use-empty-active-region t) (mark-even-if-inactive nil))
                  (cond
                   ((use-region-p) (comment-or-uncomment-region (region-beginning) (region-end)))
                   (t (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))))

;; (after! ispell
;;   ;; Don't spellcheck org blocks
;;   (pushnew! ispell-skip-region-alist
;;             '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:")
;;             '("#\\+BEGIN_SRC" . "#\\+END_SRC")
;;             '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))

;;   )
(setq fancy-splash-image "~/.doom.d/doomEmacsDracula.svg")

;; (setq projectile-project-search-path '"~/dev/")
(setq js-indent-level 2)
(setq projectile-sort-order 'modification-time)
(setq projectile-enable-caching t)
(setq projectile-file-exists-remote-cache-expire (* 10 60))
(setq projectile-require-project-root nil)
(setq projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/.local/straight/repos/"))
(defun projectile-ignored-project-function (filepath)
  "Return t if FILEPATH is within any of `projectile-ignored-projects'"
  (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))

(use-package! systemd
  :defer t)
(use-package! keycast
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast--update t)
          (add-to-list 'global-mode-string '("" mode-line-keycast " ")))
      (remove-hook 'pre-command-hook 'keycast--update)
      (setq global-mode-string (remove '("" mode-line-keycast " ") global-mode-string))))
  (custom-set-faces!
    '(keycast-command :inherit doom-modeline-debug
                      :height 0.9)
    '(keycast-key :inherit custom-modified
                  :height 1.1
                  :weight bold)))

(use-package! screenshot
  :defer t
  :config (setq screenshot-upload-fn "upload %s 2>/dev/null"))
(setq lsp-auto-guess-root t)
(setq lsp-eldoc-render-all nil)
(setq lsp-pyright-typechecking-mode 'nil)
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-doc-show-with-mouse t)
(setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=yes")
(after! solidity-mode
  (setq solidity-comment-style 'slash)
  (set-docsets! 'solidity-mode "Solidity")
  (set-company-backend! 'solidity-mode 'company-solidity)

  (use-package! solidity-flycheck  ; included with solidity-mode
    :when (featurep! :checkers syntax)
    :config
    (setq flycheck-solidity-solc-addstd-contracts t)
    (when (funcall flycheck-executable-find solidity-solc-path)
      (setq solidity-flycheck-solc-checker-active t)
      (add-to-list 'flycheck-checkers 'solidity-checker nil #'eq))
    (when (funcall flycheck-executable-find solidity-solium-path)
      (unless solidity-flycheck-solc-checker-active (setq solidity-flycheck-solium-checker-active t))
      (add-to-list 'flycheck-checkers 'solium-checker nil #'eq)))

  (use-package! company-solidity
    :when (featurep! :completion company)
    :config (delq! 'company-solidity company-backends)))
(defvar emojify-disabled-emojis
  '(;; Org
    "◼" "☑" "☸" "⚙" "⏩" "⏪" "⬆" "⬇" "❓"
    ;; Terminal powerline
    "✔"
    ;; Box drawing
    "▶" "◀"
    ;; I just want to see this as text
    "©" "™")
  "Characters that should never be affected by `emojify-mode'.")
(defadvice! emojify-delete-from-data ()
  "Ensure `emojify-disabled-emojis' don't appear in `emojify-emojis'."
  :after #'emojify-set-emoji-data
  (dolist (emoji emojify-disabled-emojis)
    (remhash emoji emojify-emojis)))
(defun emojify--replace-text-with-emoji (orig-fn emoji text buffer start end &optional target)
  "Modify `emojify--propertize-text-for-emoji' to replace ascii/github emoticons with unicode emojis, on the fly."
  (if (or (not emoticon-to-emoji) (= 1 (length text)))
      (funcall orig-fn emoji text buffer start end target)
    (delete-region start end)
    (insert (ht-get emoji "unicode"))))
(define-minor-mode emoticon-to-emoji
  "Write ascii/gh emojis, and have them converted to unicode live."
  :global nil
  :init-value nil
  (if emoticon-to-emoji
      (progn
        (setq-local emojify-emoji-styles '(ascii github unicode))
        (advice-add 'emojify--propertize-text-for-emoji :around #'emojify--replace-text-with-emoji)
        (unless emojify-mode
          (emojify-turn-on-emojify-mode)))
    (setq-local emojify-emoji-styles (default-value 'emojify-emoji-styles))
    (advice-remove 'emojify--propertize-text-for-emoji #'emojify--replace-text-with-emoji)))
(setq all-the-icons-scale-factor 1.1)

(map! :leader
      (:prefix-map ("f" . "file")
       :desc "Browse private config"       "p"   #'doom/open-private-config
       "P"   nil))

;; which key
;;
(which-key-mode)
(setq which-key-idle-delay 0.5) ;; I need the help, I really do
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

;; modeline
                                        ; expect utf8 by default
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

                                        ; nicer default buffer name
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

(after! doom-modeline
  (doom-modeline-def-modeline 'main
    '(bar matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info minor-modes checker input-method buffer-encoding major-mode process vcs "  "))) ; <-- added padding here;; to get information about any of these functions/macros, move the cursor over
(after! doom-modeline
  (doom-modeline-def-segment buffer-name
    "Display the current buffer's name, without any other information."
    (concat
     (doom-modeline-spc)
     (doom-modeline--buffer-name)))

  (doom-modeline-def-segment pdf-icon
    "PDF icon from all-the-icons."
    (concat
     (doom-modeline-spc)
     (doom-modeline-icon 'octicon "file-pdf" nil nil
                         :face (if (doom-modeline--active)
                                   'all-the-icons-red
                                 'mode-line-inactive)
                         :v-adjust 0.02)))

  (defun doom-modeline-update-pdf-pages ()
    "Update PDF pages."
    (setq doom-modeline--pdf-pages
          (let ((current-page-str (number-to-string (eval `(pdf-view-current-page))))
                (total-page-str (number-to-string (pdf-cache-number-of-pages))))
            (concat
             (propertize
              (concat (make-string (- (length total-page-str) (length current-page-str)) ? )
                      " P" current-page-str)
              'face 'mode-line)
             (propertize (concat "/" total-page-str) 'face 'doom-modeline-buffer-minor-mode)))))

  (doom-modeline-def-segment pdf-pages
    "Display PDF pages."
    (if (doom-modeline--active) doom-modeline--pdf-pages
      (propertize doom-modeline--pdf-pages 'face 'mode-line-inactive)))

  (doom-modeline-def-modeline 'pdf
    '(bar window-number pdf-pages pdf-icon buffer-name)
    '(misc-info matches major-mode process vcs)))

(use-package! doas-edit
  :if (executable-find "doas")
  :commands doas-edit-find-file doas-edit
  :init
  (map!
   [remap doom/sudo-find-file] #'doas-edit-find-file
   [remap doom/sudo-this-file] #'doas-edit))

;; (setq ispell-dictionary "british-ize")
;; (setq ispell-personal-dictionary "~/.doom.d/dictionary.pws")

(defun elcord--disable-if-no-frames (f)
  (when (let ((frames (delete f (visible-frame-list))))
          (or (null frames)
              (and (null (cdr frames))
                   (eq (car frames) terminal-frame))))
    (elcord-mode -1)
    (add-hook 'after-make-frame-functions (lambda(f) (elcord-mode +1)))))
(add-hook 'elcord-mode-hook
          (lambda()
            (if elcord-mode
                (add-hook 'delete-frame-functions 'elcord--disable-if-no-frames)
              (remove-hook 'delete-frame-functions 'elcord--disable-if-no-frames))))
(elcord-mode 1)
(setq elcord-quiet t)
(setq elcord-use-major-mode-as-main-icon t)
(setq elcord-editor-icon '"emacs_icon")



(defconst brace-regexp
  "[^{]{[^{}]*}")
(defconst python-f-string-regexp
  "f\\('.*?[^\\]'\\|\".*?[^\\]\"\\)")
(defun python-f-string-font-lock-find (limit)
  (while (re-search-forward python-f-string-regexp limit t)
    (put-text-property (match-beginning 0) (match-end 0)
                       'face 'font-lock-string-face)
    (let ((start (match-beginning 0)))
      (while (re-search-backward brace-regexp start t)
        (put-text-property (1+ (match-beginning 0)) (match-end 0)
                           'face 'font-lock-type-face))))
  nil)
(with-eval-after-load 'python
  (font-lock-add-keywords
   'python-mode
   `((python-f-string-font-lock-find))
   'append))
(defadvice! prompt-for-buffer (&rest _)
  :after 'window-split (switch-to-buffer))

(after! python
  (setq python-shell-interpreter "python3"))

(setq bookmark-default-file "~/.doom.d/bookmarks")  ;;define file to use.

(use-package lsp-pyright
  :hook (python-mode . (lambda () (require 'lsp-pyright)))
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3")))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\node_modules\\'"))

(setq-hook! prog-mode tab-always-indent t)      ; tab indents instead of selecting brackets
(map! :mode prog-mode
      :nvmi [tab] #'indent-for-tab-command)

(prefer-coding-system       'utf-8)     ; set default utf8
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(defun evil-insert-jk-for-normal-mode ()
  (interactive)
  (insert "j")
  (let ((event (read-event nil)))
    (if (= event ?k)
      (progn
        (backward-delete-char 1)
        (evil-normal-state))
      (push event unread-command-events))))
(define-key evil-insert-state-map "j" 'evil-insert-jk-for-normal-mode)

                                        ; prepare the arguments
(setq dotfiles-git-dir (concat "--git-dir=" (expand-file-name "~/.dotfiles")))
(setq dotfiles-work-tree (concat "--work-tree=" (expand-file-name "~")))

;; function to start magit on dotfiles
(defun dotfiles-magit-status ()
  (interactive)
  (add-to-list 'magit-git-global-arguments dotfiles-git-dir)
  (add-to-list 'magit-git-global-arguments dotfiles-work-tree)
  (call-interactively 'magit-status))
(map! :leader
      (:prefix "g"
       "d" #'dotfiles-magit-status))

;; wrapper to remove additional args before starting magit
(defun magit-status-with-removed-dotfiles-args ()
  (interactive)
  (setq magit-git-global-arguments (remove dotfiles-git-dir magit-git-global-arguments))
  (setq magit-git-global-arguments (remove dotfiles-work-tree magit-git-global-arguments))
  (call-interactively 'magit-status))
;; redirect global magit hotkey to our wrapper
;; (global-set-key (kbd "C-x g") 'magit-status-with-removed-dotfiles-args)


(map! :leader
      (:prefix "g"
       "g" #'magit-status-with-removed-dotfiles-args))
;; (map! "SPC g g" #'magit-status-with-removed-dotfiles-args)
(map! :after magit
      :map magit-file-mode-map
      :leader
      (:prefix "g"
       "g" #'magit-status-with-removed-dotfiles-args))
;; (define-key magit-file-mode-map (kbd "C-x g") 'magit-status-with-removed-dotfiles-args)
(setq vimish-fold-indication-mode 'left-fringe )

(setq-default delete-by-moving-to-trash t)      ; delete files to trash
(setq-default window-combination-resize t)      ; take new window space from all other windows (not just current)
(setq-default x-stretch-cursor t)               ; stretch cursor to the glyph width


                                        ; split window prompt
(setq evil-vsplit-window-right t
      evil-split-window-below t)
