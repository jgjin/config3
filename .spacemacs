;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(
     auto-completion
     bm
     (c-c++ :variables
            c-basic-offset 4
            c-c++-default-mode-for-headers 'c++-mode
            c-c++-enable-clang-support t
            clang-format-style "{BasedOnStyle: google, IndentWidth: 4}")
     csv
     elixir
     elm
     emacs-lisp
     evil-snipe
     git
     helm
     html
     javascript
     latex
     (lsp :variables
          lsp-enable-indentation nil)
     markdown
     org
     pdf
     protobuf
     python
     react
     rust
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom
            shell-default-shell 'eshell
            shell-default-term-shell "/usr/bin/zsh"
            shell-enable-smart-eshell t)
     sql
     syntax-checking
     typescript
     yaml
     )
   dotspacemacs-additional-packages
   '(
     bazel-mode
     drag-stuff
     evil-smartparens
     graphql-mode
     zzz-to-char
     )
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '()
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  (setq-default
   dotspacemacs-gc-cons '(100000000 0.1)
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update t
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-startup-buffer-show-version t
   ;; vim-style-remap-Y-to-y$ nil
   vim-style-visual-feedback t
   ;; vim-style-ex-substitute-global nil
   vim-style-visual-line-move-text t
   vim-style-retain-visual-state-on-shift t
   dotspacemacs-startup-banner 'official
   dotspacemacs-startup-lists '((recents . 6)
                                (projects . 6))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-initial-scratch-message nil
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light)
   dotspacemacs-mode-line-theme 'doom
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-enable-paste-transient-state t
   dotspacemacs-which-key-delay 2
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   dotspacemacs-loading-progress-bar nil
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-undecorated-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 70
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers nil
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode t
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-enable-server nil
   dotspacemacs-server-socket-dir nil
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("rg" "ag")
   dotspacemacs-frame-title-format "%I@%S"
   dotspacemacs-icon-title-format nil
   dotspacemacs-zone-out-when-idle nil
   dotspacemacs-whitespace-cleanup t
   dotspacemacs-default-font '("Source Code Pro"
                               :size 36
                               :weight normal
                               :width normal)
   ))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  "Configuration function for user code.
   Called at end of Spacemacs initialization."
  (add-hook 'bazel-mode-hook (lambda ()
                               (remove-hook 'before-save-hook #'yapfify-buffer t)
                               (add-hook 'before-save-hook #'bazel-format nil t)))
  (add-hook 'elm-mode-hook #'lsp)
  (add-hook 'python-mode-hook #'yapf-mode)
  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)

  (global-company-mode)
  (global-hungry-delete-mode)

  (define-key evil-visual-state-map (kbd "M-h") 'drag-stuff-left)
  (define-key evil-visual-state-map (kbd "M-j") 'drag-stuff-down)
  (define-key evil-visual-state-map (kbd "M-k") 'drag-stuff-up)
  (define-key evil-visual-state-map (kbd "M-l") 'drag-stuff-right)

  (global-set-key (kbd "M-z") #'zzz-up-to-char)
  (global-set-key (kbd "C-M-z") #'zzz-to-char)

  (defun maybe-add-newline-at-buf-start ()
    (if (and (char-equal (char-after (point-min)) ?\n)
             (char-equal (char-after (1+ (point-min))) ?\n))
        ""
      "\n"))

  (defun maybe-add-newline-at-buf-end ()
    (if (and (char-equal (char-before (point-max)) ?\n)
             (char-equal (char-before (1- (point-max))) ?\n))
        ""
      "\n"))

  ;; (global-set-key [f12]
  ;; 		            '(lambda ()
  ;; 		               (interactive)
  ;; 		               (if (buffer-file-name)
  ;; 		                   (let*
  ;; 			                     ((fName (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
  ;; 			                      (ifDef (concat "#ifndef " fName "_H" "\n#define " fName "_H"
  ;;                                            (maybe-add-newline-at-buf-start)))
  ;; 			                      (begin (point-marker))
  ;; 			                      )
  ;; 			                   (progn
  ;; 			                     (if (< (- (point-max) (point-min)) 5 )
  ;; 			                         (progn
  ;; 				                         (insert "\nclass " (capitalize fName) "{\npublic:\n\nprivate:\n\n};\n")
  ;; 				                         (goto-char (point-min))
  ;; 				                         (next-line-nomark 3)
  ;; 				                         (setq begin (point-marker))
  ;; 				                         )
  ;; 			                       )

  ;; 			                     (goto-char (point-min))
  ;; 			                     (insert ifDef)
  ;; 			                     (goto-char (point-max))
  ;; 			                     (insert (maybe-add-newline-at-buf-end) "#endif" " //" fName "_H")
  ;; 			                     (goto-char begin))
  ;; 			                   )
  ;; 		                 (message (concat "Buffer " (buffer-name) " must have a filename"))
  ;; 		                 )
  ;; 		               )
  ;; 		            )
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.

(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol nil)
 '(evil-want-fine-undo t)
 '(package-selected-packages
   '(ob-elixir flycheck-mix flycheck-credo alchemist elixir-mode tide typescript-mode import-js grizzl add-node-modules-path evil-smartparens seeing-is-believing rvm ruby-tools ruby-test-mode ruby-refactor ruby-hash-syntax rubocopfmt rubocop rspec-mode robe rbenv rake minitest helm-gtags ggtags enh-ruby-mode dap-mode bui counsel-gtags counsel swiper ivy chruby bundler inf-ruby org-brain org-ql drag-stuff csv-mode treemacs-persp terminal-here helm-ls-git flycheck-ycmd flycheck-elsa company-ycmd ycmd request-deferred bazel-mode helm-rtags google-c-style flycheck-rtags disaster cquery cpp-auto-include company-rtags rtags company-c-headers clang-format ccls zzz-to-char evil-snipe emojify emoji-cheat-sheet-plus company-emoji flycheck-elm elm-test-runner elm-mode reformatter gnu-elpa-keyring-update yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode dash-functional helm-pydoc cython-mode anaconda-mode pythonic ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hydra lv hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile projectile pkg-info epl helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist highlight evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu elisp-slime-nav dumb-jump f dash s diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core popup async)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
