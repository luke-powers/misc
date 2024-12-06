;;; Basics
;;;;;;;;;
;(setq debug-on-error t)

;; Start emacs server
(server-start)
;; ID
(setq user-mail-address "los.powers@gmail.com")
(setq user-full-name "Luke Powers")

;;; Requires
;;;;;;;;;;;;
(require 'company)
(require 'counsel-codesearch)
(require 'elpy)
(require 'lsp-mode)
(require 'multi-term)
(require 'multiple-cursors)
(require 'package)
(require 'smart-tab)
(require 'yasnippet)


;;; Look/Feel Customizations.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Tell emacs to paste the x primary buffer to the cursor rather than
;; where the mouse pointer is located.
(setq mouse-yank-at-point t)

;; Turn on font-lock mode.
(global-font-lock-mode 'enable)

;; Set scrolling by one line.
(setq scroll-setp 1)

;; Enable deleting selected text.
(delete-selection-mode t)

;; Turn on mouse wheel.
(mouse-wheel-mode 1)

;; Use "y or n" answers instead of full words "yes or no".
(fset 'yes-or-no-p 'y-or-n-p)

;; Move scroll bar to other side.
(set-scroll-bar-mode 'right)

;; Disable beep.
(setq ring-bell-function 'ignore)

;; Disable Uppercase/Lowercase region.
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Stop asking to save abbreviations.
(setq save-abbrevs nil)

;; Disable toolbar.
(tool-bar-mode -1)

;; Disable menubar.
(menu-bar-mode -99)

;; Inhibit splash screen.
(setq inhibit-splash-screen t)

;; Disable backup files.
(setq make-backup-files nil)

;; Put auto-save-list files somewhere else.
(set 'auto-save-list-file-prefix "/home/lpowers/.trash/.saves-")

;; Display column number in mode line.
(setq column-number-mode t)

;; Auto dim other buffers
(add-hook 'after-init-hook (lambda ()
  (when (fboundp 'auto-dim-other-buffers-mode)
    (auto-dim-other-buffers-mode t))))

;; Ivy and counsel codesearch
(ivy-mode 1)

;; Smart tab
(global-smart-tab-mode 1)

;; Company text completion
(global-company-mode)

;; For forge access to github
(setq auth-sources '("~/.authinfo"))

;; Turn off iconfiy since that causes emacs to freeze under xmonad
;; but we still want ctrl-z to suspend in tty.
(defun iconify-or-deiconify-frame ()
  (interactive)
  (make-frame-visible)
)

;; Set line numbers to be relative
(setq display-line-numbers-type 'relative)

;; Turn on show paren mode -- might not be needed with new tabcomplete.
(setq show-paren-mode 'true)

;; Turn off all tabs.
(setq-default indent-tabs-mode nil)

;; Scroll one line.
(defun scroller-up ()
  (interactive)
  (if current-prefix-arg
      (scroll-up current-prefix-arg)
    (scroll-up 1)))
(defun scroller-down ()
      (interactive)
  (if current-prefix-arg
      (scroll-down current-prefix-arg)
    (scroll-down 1)))

;; Delete the current line like vim dd.
(defun kill-current-line (&optional n)
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (let ((kill-whole-line t))
      (kill-line n))))

;; Copy a line rather than kill the line.
(defun copy-line (&optional arg)
  "Do a kill-line but copy rather than kill. This function directly calls
kill-line, so see documentation of kill-line for how to use it including prefix
argument and relevant variables. This function works by temporarily making the
buffer read-only, so it is suggested to set kill-read-only-ok to t."
  (interactive "p")
  (toggle-read-only 1)
  (kill-line arg)
  (toggle-read-only 0))
(setq-default kill-read-only-ok t)

;; Pull from PRIMARY (middle mouse).
(defun get-primary ()
  (interactive)
  (insert
   (gui-get-primary-selection)))

;; Highlight chars AFTER column 88 and show whitespace
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-line "#0448A4")
(set-face-background 'whitespace-line "#BFBFBF")
(set-face-background 'whitespace-trailing "yellow")
(set-face-foreground 'whitespace-trailing "black")
(set-face-background 'whitespace-tab "#DEDE0E")
;;whitespace-style needs 'face'
;;http://debbugs.gnu.org/cgi/bugreport.cgi?bug=7097
(setq whitespace-style (quote (face
                               lines-tail
                               trailing
                                                                                                       tabs
                               trailing-mark
                               tabs-mark)) ;or '(lines) for the whole line this line is longer than 79!
whitespace-line-column 88)
(global-hl-line-mode 1)
(set-face-background 'hl-line "#F0F0F0")
;; Set region highlight color
(set-face-attribute 'region nil :background "#F87837")

;;; Hydras
;;;;;;;;;;
;; Zoom hydra
(defhydra hydra-zoom (global-map "C-=")
  "zoom"
  ("=" text-scale-increase "in")
  ("-" text-scale-decrease "out")
  ("0" text-scale-set "default"))

;; Expand window hydra
(defhydra hydra-window-size (global-map "M-h")
  "window size"
  ("h" shrink-window "shrink vertical")
  ("H" enlarge-window "enlarge vertical")
  ("M-h" shrink-window-horizontally "shrink horizontal")
  ("M-H" enlarge-window-horizontally "enlarge horizontal")
  ("0" balance-windows "reset"))

;;; Elisp
;;;;;;;;;

(add-hook #'emacs-lisp-mode-hook #'display-line-numbers-mode)

;;; PHP (and other C based languages) indent 2 spaces.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset 2)
(setq basic-offset 2)

;;; HTML/CSS/JS
;;;;;;;;;;;;;;;;;

(add-hook #'mhtml-mode-hook #'emmet-mode)
(add-hook #'mhtml-mode-hook #'display-line-numbers-mode)

;; Javascript
; indent 2 spaces.
(add-hook #'js-mode-hook #'display-line-numbers-mode)
(setq js-indent-level 2)

;; CSS
(add-hook 'css-mode-hook #'display-line-numbers-mode)

;;; Markdown
;;;;;;;;;;;;
(add-hook #'markdown-mode-hook #'yas-minor-mode)

;;; Perl
;;;;;;;

;; indent 2 spaces.
(defalias 'perl-mode 'cperl-mode)
(setq cperl-indent-level 2
      cperl-close-paren-offset -2
      cperl-continued-statement-offset 2
      cperl-indent-parens-as-block t
      cperl-tab-always-indent t)

;;; Tramp
;;;;;;;;;

;; defaults.
(setq tramp-default-method "ssh")
(setq password-cache-expiry nil)

;;; Custom keybindings minor mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar custom-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))

    ;; go to link at point
    (define-key map (kbd "C-M-<return>") 'markdown-follow-link-at-point)

    ;; multiple cursors
    (define-key map (kbd "s-.") 'mc--mark-symbol-at-point)
    (define-key map (kbd "C-c C->") 'mc/edit-lines)
    (define-key map (kbd "C->") 'mc/mark-next-like-this-symbol)
    (define-key map (kbd "C-<") 'mc/mark-previous-like-this-symbol)
    (define-key map (kbd "C-c C-<") 'mc/mark-all-like-this)
    (define-key map (kbd "C-c C-.") 'mc/mark-all-symbols-like-this)


    ;; Better movements
    (define-key map (kbd "C-M-n") 'forward-list)
    (define-key map (kbd "C-M-p") 'backward-list)
    (define-key map (kbd "M-n") 'scroller-up)
    (define-key map (kbd "M-p") 'scroller-down)

    ;; Search all files
    (define-key map (kbd "s-s") 'rgrep)

    ;; Delete line (ala vim dd)
    (define-key map (kbd "C-M-k") 'kill-current-line)

    ;; Copy from primary clipboard (middle mouse click)
    (define-key map (kbd "C-M-y") 'get-primary)

    ;; Clear buffer, good for terminal
    (define-key map (kbd "C-x C-<delete>") 'erase-buffer)

    ;; Proper go-to.
    (define-key map (kbd "C-M-g") 'goto-line)

    ;; Use query-replace-regexp.
    (define-key map (kbd "C-M-t") 'query-replace-regexp)

    ;; Show changes to file.
    (define-key map (kbd "<f11>") (lambda() (interactive) (diff-buffer-with-file (buffer-name))))

    ;; Calculator.
    (define-key map (kbd "<f8>") 'calc-grab-region)

    ;; Comment region.
    (define-key map (kbd "C-c 2") 'comment-region)

    ;; Uncomment region.
    (define-key map (kbd "C-c 3") 'uncomment-region)

    ;; Redefine unused keys for bookmarks.
    (define-key map (kbd "<f5>") 'bookmark-set)
    (define-key map (kbd "<f9>") 'bookmark-jump)

    ;; Better search key binds with regexp.
    (local-unset-key (kbd "C-M-s"))
    (define-key map (kbd "C-s") 'isearch-forward-regexp)
    (define-key map (kbd "C-M-s") 'isearch-forward-symbol-at-point)

    ;; Better find file
    (local-unset-key (kbd "C-x C-f"))
    (local-unset-key (kbd "C-x f"))
    (local-unset-key (kbd "C-c C-l"))
    (define-key map (kbd "C-x f") 'find-file-other-window)
    (define-key map (kbd "C-x C-f") 'project-find-file)
    (define-key map (kbd "C-c C-l") 'project-switch-project)
    (define-key map (kbd "C-x C-M-f") 'ffap-other-window)

    ;; Better window navigation
    (define-key map (kbd "C-s-n") 'windmove-down)
    (define-key map (kbd "C-s-p") 'windmove-up)
    (define-key map (kbd "C-s-a") 'windmove-left)
    (define-key map (kbd "C-s-f") 'windmove-right)
    (define-key map (kbd "C-s-o") 'other-window)
    map)
  "custom-keys-minor-mode keymap.")

(define-minor-mode custom-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " custom-keys")

(defun custom-keys-minibuffer-disable-hook ()
  (custom-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'custom-keys-minibuffer-disable-hook)
(custom-keys-minor-mode 1)

;;; YASnippets
;;;;;;;;;;;;;;

(yas-reload-all)
;; Remove Yasnippet's default tab key binding.
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
;; Set Yasnippet's key binding to shift+tab.
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)

;;; Package management
;;;;;;;;;;;;;;;;;;;;;

;; Add repos.
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)


;;; Org mode
;;;;;;;;;;;

;(require 'org)

;;; Date functions
;;;;;;;;;;;;;;;;;;;

(defun iso8601 ()
  (shell-command-to-string "date +%Y-%m-%dT%H:%M:%S"))

(defun isodate ()
    (shell-command-to-string "date +%Y-%m-%d"))

(defun iiso8601 ()
    ;; Insert iso8601 datetime.
  (interactive)
  (insert (iso8601)))

(defun iisodate ()
    (interactive)
    (insert (isodate)))

(defun isotime ()
  ;; Insert iso8601 time.
  (interactive)
  (insert (shell-command-to-string "date +%H:%M:%S")))

(defun configure-simple-code-folding ()
  (hs-minor-mode)
  (global-set-key (kbd "<f6>") 'hs-hide-all)
  (global-set-key (kbd "M-<f6>") 'hs-show-all))

;;; lsp-mode
;;;;;;;;;;;;

;; adjust keybindings
(with-eval-after-load 'tooltip-mode
  (define-key lsp-mode-map (kbd "C-d") nil)
)

;;; Golang
;;;;;;;;;;

;; yasnippets for golang
(add-hook 'go-mode-hook #'yas-minor-mode)
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'display-line-numbers-mode)
(add-hook 'go-mode-hook #'custom-keys-minor-mode)
(add-hook 'go-mode-hook #'configure-simple-code-folding)
(add-hook 'go-mode-hook (lambda ()
                            (add-hook 'before-save-hook
                                      #'gofmt-before-save)))

(setq go-guru-command "/home/lpowers/go/bin/guru")
(setq lsp-go-analyses '((shadow . t)
                        (simplifycompositelit . :json-false)))


;;; Dart
;;;;;;;;
(setq lsp-dart-closing-labels nil)
(setq lsp-dart-flutter-fringe-colors nil)
(setq lsp-dart-main-code-lens nil)
(add-hook 'dart-mode-hook 'lsp)
(add-hook 'dart-mode-hook #'display-line-numbers-mode)
(add-hook 'go-mode-hook #'custom-keys-minor-mode)
(add-hook 'go-mode-hook #'configure-simple-code-folding)

;;; Python
;;;;;;;;;

;; Enable yasnippets for python
(add-hook 'python-mode-hook #'yas-minor-mode)

;; Associate .wsgi with python mode.
(add-to-list `auto-mode-alist
             '("\\.wsgi\\'" . python-mode))

;; Associate .tac with python mode.
(add-to-list `auto-mode-alist
             '("\\.tac\\'" . python-mode))

;; Python code summarizing
;;(global-set-key [f6] 'toggle-selective-display)
(defun configure-code-folding-elpy ()
  (configure-simple-code-folding)
  (global-set-key (kbd "C-<f6>") 'elpy-folding-toggle-at-point)
  )
(defun toggle-selective-display (column)
  (hs-minor-mode)
  (interactive "p")
  (set-selective-display
   (if selective-display nil (or column 1)))
  )
(defun toggle-folding (column)
  (interactive "p")
  (if (hs-already-hidden-p)
      (hs-show-all)
    (elpy-folding-hide-leafs))
  )
(defun elpy-keys ()
  "Rebind useful elpy keys."
  (define-key elpy-mode-map (kbd "C-c C-n") 'end-of-defun)
  (define-key elpy-mode-map (kbd "C-c C-p") 'beginning-of-defun)
  (define-key elpy-mode-map (kbd "C-x C-g") 'elpy-goto-definition-or-rgrep)
  (define-key elpy-mode-map (kbd "C-<tab>") 'elpy-company-backend))

(elpy-enable)
(add-hook 'python-mode-hook 'display-line-numbers-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook (lambda ()
                              (add-hook 'before-save-hook
                                        'clean-python-syntax
                                        nil
                                        'local)))

;; (add-hook 'python-mode-hook (lambda () (eldoc-mode -1)))
(setq jedi:complete-on-dot t)
(add-hook 'elpy-mode-hook 'elpy-keys)
(add-hook 'elpy-mode-hook 'configure-code-folding-elpy)
(add-hook 'elpy-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '((company-dabbrev-code company-yasnippet elpy-company-backend)))))
;; Elpy better goto definition
(defun elpy-goto-definition-or-rgrep ()
  "Go to the definition of the symbol at point, if found. Otherwise, run `elpy-rgrep-symbol'."
  (interactive)
  (ring-insert find-tag-marker-ring (point-marker))
  (condition-case nil (elpy-goto-definition-other-window)
    (error (condition-case nil (jedi:goto-definition)
             (error (elpy-rgrep-symbol
                                (concat "\\(def\\|class\\)\s" (thing-at-point 'symbol) "(")))))))

;; Python syntax cleaner
;; Meant to be used in a save-hook.
(defun clean-python-syntax ()
  "Run `py-isort-before-save` then `elpy-black-fix-code`."
  (interactive)
  (bookmark-set "xx")
  (py-isort-before-save)
  (elpy-black-fix-code)
  (bookmark-jump "xx")
)

;; auto-format code on save
(add-hook 'elpy-mode-hook (lambda ()
                            (add-hook 'before-save-hook
                                      'clean-python-syntax nil t)))

;; Flycheck preferred to flymake.
(when (require 'flycheck nil t)
 (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(add-hook 'sh-mode-hook 'flycheck-mode)
(setq flycheck-shellcheck-follow-sources nil)

;;; Multi-term
;;;;;;;;;;;;;;
(add-hook 'term-mode-hook 'disable-smart-tab-w-mterm)
(add-hook 'term-mode-hook 'unset-keys)
(defun disable-smart-tab-w-mterm ()
  "Disable smart tab when multi-term is running."
  (smart-tab-mode-off))
(defun term-primary-paster ()
  "Paste PRIMARY selection without mouse interaction."
  (interactive)
  (term-send-raw-string (gui-get-primary-selection)))
(defun term-send-kill-line ()
  "Kill line in multi-term mode with the possibility to paste it
   like in a normal shell."
  (interactive)
  (kill-line)
  (term-send-raw-string (kbd "C-k")))
(defun unset-keys ()
  "Unset annoying keys"
  (local-unset-key (kbd "M-p"))
  (local-unset-key (kbd "M-n"))
  )

;;; From the customizer
;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(connection-local-criteria-alist
   '(((:application tramp :protocol "kubernetes")
      tramp-kubernetes-connection-local-default-profile)
     ((:application tramp :protocol "flatpak")
      tramp-container-connection-local-default-flatpak-profile
      tramp-flatpak-connection-local-default-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile
      tramp-connection-local-default-shell-profile)
     ((:application eshell) eshell-connection-default-profile)))
 '(connection-local-profile-alist
   '((tramp-flatpak-connection-local-default-profile
      (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin"
                         "/usr/bin" "/sbin" "/usr/sbin"
                         "/usr/local/bin" "/usr/local/sbin"
                         "/local/bin" "/local/freeware/bin"
                         "/local/gnu/bin" "/usr/freeware/bin"
                         "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin"
                         "/opt/sbin" "/opt/local/bin"))
     (tramp-kubernetes-connection-local-default-profile
      (tramp-config-check . tramp-kubernetes--current-context-data)
      (tramp-extra-expand-args 97
                               (tramp-kubernetes--container
                                (car tramp-current-connection))
                               104
                               (tramp-kubernetes--pod
                                (car tramp-current-connection))
                               120
                               (tramp-kubernetes--context-namespace
                                (car tramp-current-connection))))
     (tramp-container-connection-local-default-flatpak-profile
      (tramp-remote-path "/app/bin" tramp-default-remote-path "/bin"
                         "/usr/bin" "/sbin" "/usr/sbin"
                         "/usr/local/bin" "/usr/local/sbin"
                         "/local/bin" "/local/freeware/bin"
                         "/local/gnu/bin" "/usr/freeware/bin"
                         "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin"
                         "/opt/sbin" "/opt/local/bin"))
     (tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o"
                                        "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o" "state=abcde" "-o"
                                        "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format (pid . number)
                                          (euid . number)
                                          (user . string)
                                          (egid . number) (comm . 52)
                                          (state . 5) (ppid . number)
                                          (pgrp . number)
                                          (sess . number)
                                          (ttname . string)
                                          (tpgid . number)
                                          (minflt . number)
                                          (majflt . number)
                                          (time . tramp-ps-time)
                                          (pri . number)
                                          (nice . number)
                                          (vsize . number)
                                          (rss . number)
                                          (etime . tramp-ps-time)
                                          (pcpu . number)
                                          (pmem . number) (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o"
                                        "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o" "stat=abcde" "-o"
                                        "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format (pid . number)
                                          (user . string)
                                          (group . string) (comm . 52)
                                          (state . 5) (ppid . number)
                                          (pgrp . number)
                                          (ttname . string)
                                          (time . tramp-ps-time)
                                          (nice . number)
                                          (etime . tramp-ps-time)
                                          (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o"
                                        "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                        "-o"
                                        "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format (pid . number)
                                          (euid . number)
                                          (user . string)
                                          (egid . number)
                                          (group . string) (comm . 52)
                                          (state . string)
                                          (ppid . number)
                                          (pgrp . number)
                                          (sess . number)
                                          (ttname . string)
                                          (tpgid . number)
                                          (minflt . number)
                                          (majflt . number)
                                          (time . tramp-ps-time)
                                          (pri . number)
                                          (nice . number)
                                          (vsize . number)
                                          (rss . number)
                                          (etime . number)
                                          (pcpu . number)
                                          (pmem . number) (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh") (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":") (null-device . "/dev/null"))
     (eshell-connection-default-profile (eshell-path-env-list))))
 '(elpy-rpc-timeout nil)
 '(flycheck-python-pycompile-executable "python3")
 '(magit-log-margin '(t "%Y-%m-%dT%H " magit-log-margin-width t 18))
 '(markdown-command "/usr/bin/pandoc")
 '(package-selected-packages
   '(auto-dim-other-buffers cargo-mode company-go company-jedi counsel
                            counsel-codesearch counsel-pydoc
                            counsel-tramp dart-mode
                            docker-compose-mode docker-tramp
                            dockerfile-mode elpy emacsql
                            emacsql-sqlite emmet-mode eslint-fix
                            flx-ido flycheck-pkg-config
                            flycheck-pycheckers flycheck-pyflakes
                            flymake-yaml flymake-yamllint
                            font-lock-studio forge git-timemachine
                            go-guru go-mode golint gore-mode guru-mode
                            highlight highlight-indentation hover ivy
                            ivy-hydra js2-mode linum-relative
                            lorem-ipsum lsp-dart lsp-mode
                            lsp-tailwindcss magit magit-gh-pulls
                            multi-term multiple-cursors perspective
                            py-isort pyenv-mode python-test rust-mode
                            smart-tab smart-tabs-mode swiper web-mode
                            xml-rpc yasnippet))
 '(python-shell-completion-native-disabled-interpreters '("pypy" "ipython" "python"))
 '(python-shell-interpreter "python3")
 '(term-bind-key-alist
   '(("C-c C-c" . term-interrupt-subjob)
     ("C-c C-j" . term-line-mode)
     ("C-c C-k" . term-char-mode)
     ("C-c ESC" . term-send-esc)
     ("C-k" . term-send-kill-line)
     ("C-m" . term-send-return)
     ("C-r" . term-send-reverse-search-history)
     ("C-s" . isearch-forward)
     ("C-y" . term-paste)
     ("C-z" . term-stop-subjob)
     ("C-M-y" . term-primary-paster)
     ("<C-backspace>" . term-send-backward-kill-word)
     ("M-f" . term-send-forward-word)
     ("M-b" . term-send-backward-word)
     ("M-p" . term-send-up)
     ("C-p" . term-send-up)
     ("M-n" . term-send-down)
     ("M-M" . term-send-forward-kill-word)
     ("M-N" . term-send-backward-kill-word)
     ("M-d" . term-send-delete-word)
     ("<M-backspace>" . term-send-backward-kill-word)
     ("M-," . term-send-raw)
     ("M-." . comint-dynamic-complete))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "DAMA" :family "Ubuntu Mono"))))
 '(auto-dim-other-buffers-face ((t (:background "#abb"))))
 '(font-lock-variable-name-face ((t (:foreground "black")))))
(put 'magit-clean 'disabled nil)
(put 'erase-buffer 'disabled nil)
