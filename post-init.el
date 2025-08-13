;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(add-hook 'after-init-hook #'global-auto-revert-mode)

;; recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(add-hook 'after-init-hook #'recentf-mode)

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(add-hook 'after-init-hook #'savehist-mode)

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(add-hook 'after-init-hook #'save-place-mode)

;; Set fill column

(use-package frame
  :preface
  (defun abroekhof/set-default-font ()
    (interactive)
    (when (member "JetBrainsMono Nerd Font" (font-family-list))
      (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font"))
    (set-face-attribute 'default nil
                        :height 120
                        :weight 'normal))
  :ensure nil
  :config
  (setq initial-frame-alist '((fullscreen . maximized)))
  (abroekhof/set-default-font))

(use-package emacs
  :init
  (setq-default fill-column 80)
  (delete-selection-mode t)
  (electric-pair-mode t))

(use-package project
  :init
  (setq project-vc-extra-root-markers '(".project")))

(use-package crux
  :ensure t
  :bind
  (("C-a" . crux-move-beginning-of-line)
   ("C-x 4 t" . crux-transpose-windows)
   ("C-x K" . crux-kill-other-buffers)
   ("C-x C-d" . crux-duplicate-current-line-or-region)
   ("C-c f r" . crux-rename-buffer-and-file)
   ("C-c f d" . crux-delete-file-and-buffer)
   ("C-o" . crux-smart-open-line)
   ("C-k" . crux-smart-kill-line))
  :config
  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify)
  (crux-with-region-or-point-to-eol kill-ring-save)
  (defalias 'rename-file-and-buffer #'crux-rename-file-and-buffer))

(use-package vterm
  :ensure t
  :defer t
  :commands vterm
  :config
  ;; Speed up vterm
  (setq vterm-timer-delay 0.01))

(use-package vertico
  ;; (Note: It is recommended to also enable the savehist package.)
  :ensure t
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))

(use-package orderless
  ;; Vertico leverages Orderless' flexible matching capabilities, allowing users
  ;; to input multiple patterns separated by spaces, which Orderless then
  ;; matches in any order against the candidates.
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  ;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
  ;; In addition to that, Marginalia also enhances Vertico by adding rich
  ;; annotations to the completion candidates displayed in Vertico's interface.
  :ensure t
  :defer t
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

(use-package wgrep
  :ensure t)

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface.
  :ensure t
  :defer t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("C-s" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))


(use-package eglot
  :ensure nil
  :defer t
  :commands (eglot
             eglot-rename
             eglot-ensure
             eglot-rename
             eglot-format-buffer)

  :custom
  (eglot-report-progress nil)  ; Prevent minibuffer spam

  :config
  ;; Optimizations
  (fset #'jsonrpc--log-event #'ignore)
  (setq jsonrpc-event-hook nil)

  :hook
  (python-mode . eglot-ensure)
  (protobuf-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  (c++-ts-mode . eglot-ensure))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode c++-ts-mode)
                 . ("clangd"
                    "-j=8"
                    "--malloc-trim"
                    "--background-index"
                    "--clang-tidy"
                    "--enable-config"
                    "--completion-style=detailed"
                    "--pch-storage=memory")))
  (add-to-list 'eglot-server-programs
               '((protobuf-mode)
                 . ("protols")))
  (add-to-list 'eglot-server-programs
               '((yaml-mode)
                 . ("yaml-language-server"
                    "--stdio"))))

;; Apheleia is an auto-formatter.
(use-package apheleia
  :ensure t
  :defer t
  :commands (apheleia-mode
             apheleia-global-mode)
  :hook ((prog-mode . apheleia-mode)))

(use-package corfu
  :ensure t
  :defer t
  :commands (corfu-mode global-corfu-mode)

  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))

  :custom
  _  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)

  :config
  (setq corfu-auto t)
  
  ;; Enable Corfu
  :init
  (global-corfu-mode))

(use-package kind-icon
  :ensure t
  :after corfu
  ;:custom
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :ensure t
  :defer t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(pixel-scroll-precision-mode)

(display-time-mode)


(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))
(setq auth-sources '("~/.authinfo"))

(use-package markdown-mode
  :hook ((markdown-mode . visual-line-mode)))

(use-package yaml-mode
  :ensure t)

(use-package json-mode
  :ensure t)

(use-package bazel
  :ensure t
  :mode
  (("\\.bzl$" . bazel-mode)
   ("\\.bazel" . bazel-mode)
   ("^WORKSPACE$" . bazel-mode)))

(use-package protobuf-mode
  :ensure t)

(use-package ace-window
  :ensure t
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind (("M-o" . ace-window)
         ("M-O" . ace-swap-window)))

;; Move through windows with Shift-<arrow keys>
(windmove-default-keybindings 'shift) ; You can use other modifiers here

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode))

(use-package blacken
  :ensure t
  :defer t
  :custom
  (blacken-allow-py36 t)
  (blacken-skip-string-normalization t)
  :hook (python-mode-hook . blacken-mode))

(use-package jinja2-mode
  :ensure t
  :mode (("\\.jinja$" . jinja2-mode)))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))




(use-package ef-themes
  :ensure t
  :config
  (load-theme 'ef-dream :no-confirm))


;; UNDO TREE
;; The `undo-tree' package provides an advanced and visual way to
;; manage undo history. It allows you to navigate and visualize your
;; undo history as a tree structure, making it easier to manage
;; changes in your buffers.
(use-package undo-tree
  :defer t
  :ensure t
  :hook
  (after-init . global-undo-tree-mode)
  :init
  (setq undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t
        ;; Increase undo limits to avoid losing history due to Emacs' garbage collection.
        ;; These values can be adjusted based on your needs.
        ;; 10X bump of the undo limits to avoid issues with premature
        ;; Emacs GC which truncates the undo history very aggressively.
        undo-limit 800000                     ;; Limit for undo entries.
        undo-strong-limit 12000000            ;; Strong limit for undo entries.
        undo-outer-limit 120000000)           ;; Outer limit for undo entries.
  :config
  ;; Set the directory where `undo-tree' will save its history files.
  ;; This keeps undo history across sessions, stored in a cache directory.
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.cache/undo"))))


;;; DOOM MODELINE
;; The `doom-modeline' package provides a sleek, modern mode-line that is visually appealing
;; and functional. It integrates well with various Emacs features, enhancing the overall user
;; experience by displaying relevant information in a compact format.
(use-package doom-modeline
  :ensure t
  :defer t
  :custom
  (doom-modeline-buffer-file-name-style 'buffer-name)  ;; Set the buffer file name style to just the buffer name (without path).
  (doom-modeline-project-detection 'project)           ;; Enable project detection for displaying the project name.
  (doom-modeline-buffer-name t)                        ;; Show the buffer name in the mode line.
  (doom-modeline-vcs-max-length 25)                    ;; Limit the version control system (VCS) branch name length to 25 characters.
  :config
  (setq doom-modeline-icon t)                      ;; Enable icons in the mode line if nerd fonts are used.
  :hook
  (after-init . doom-modeline-mode))


;;; INDENT-GUIDE
;; The `indent-guide' package provides visual indicators for indentation levels 
;; in programming modes, making it easier to see code structure at a glance. 
;; It draws vertical lines (by default, a character of your choice) at each 
;; level of indentation, helping to improve readability and navigation within 
;; the code.
(use-package indent-guide
  :defer t
  :ensure t
  :hook
  (prog-mode . indent-guide-mode)  ;; Activate indent-guide in programming modes.
  :config
  (setq indent-guide-char "│"))    ;; Set the character used for the indent guide.


(use-package pet
  :ensure t
  :config
  (add-hook 'python-base-mode-hook 'pet-mode -10))

(use-package gptel
  :config
  (setq gptel-model 'gemini-2.0-flash
        gptel-backend (gptel-make-gemini "Gemini"
                        :key (gptel-api-key-from-auth-source "generativelanguage.googleapis.com")
                        :stream t)))

;; Basic Org Mode setup
(require 'org)

;; Key bindings for common org commands
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; File paths - create these directories if they don't exist
(setq org-directory "~/org")
(unless (file-directory-p org-directory)
  (make-directory org-directory :parents t))
(setq org-default-notes-file (concat org-directory "/notes.org"))

;;; Org Agenda Configuration
(setq org-agenda-files (list org-default-notes-file))
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-span 7)

;; Define TODO states with fast selection keys
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")))

;; Make TODO state changes log when they were completed
(setq org-log-done 'time)

;; Capture templates
(setq org-capture-templates
      '(("t" "Tasks" entry
         (file+headline "" "Inbox")
         "* TODO %?\n %U")
        ("m" "Meeting" entry
         (file+headline "" "Meetings")
         "* %?\n %U")
        ("j" "Journal Entry" entry
         (file+datetree "journal.org")
         "* %U\n%?")))

;; (setq org-capture-templates
;;       ;; Explaination of values here:
;;       ;; https://orgmode.org/manual/Template-elements.html#Template-elements
;;       `(("t" "Todo" entry (file+olp+datetree "" "Engineering Worklog") "**** TODO %?\n%a" :tree-type week)
;;         ("m" "Meeting" entry (file+olp+datetree "" "Engineering Worklog") "**** %?\n%t" :tree-type week)
;;         ("i" "Item" entry (file+olp+datetree "" "Engineering Worklog") "**** %?\n%a" :tree-type week)
;;         ("a" "Action item" entry (file+olp+datetree "" "Engineering Worklog") "* WAITING %?\n:PROPERTIES:\n:WAITING_ON: %^{Who owns this?}\n:END:\n %i %U %a" :tree-type week)
;;         ("p" "Perf Note" entry (file+olp+datetree "" "Engineering Worklog") "* %? :perf:\n\n %i %U" :tree-type week)
;;         ))


;; Refile targets - allows refiling to tasks.org or other journal entries
(setq org-refile-targets '((nil :maxlevel . 3)
                           (org-agenda-files :maxlevel . 2)))

;; Show refile targets as a completing-read (helm/ivy will use their UI if installed)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-use-outline-path 'file)

;; Save all org buffers after refile
(advice-add 'org-refile :after 'org-save-all-org-buffers)

;; Some additional useful settings
(setq org-startup-indented t)           ;; Display files with indentation
(setq org-agenda-start-on-weekday nil)  ;; Start agenda on current day
(setq org-agenda-span 7)                ;; Show 7 days in agenda view
