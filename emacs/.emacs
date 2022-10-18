;; add load-path
(let ((path (expand-file-name "~/.emacs.d/share/emacs/site-lisp"))
      (current-dir default-directory))
  (add-to-list 'load-path path)
  (cd path)
  (normal-top-level-add-subdirs-to-load-path)
  (cd current-dir))

;; encoding
;(utf-translate-cjk-mode t)
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

;; font-lock
;(global-font-lock-mode t)

;; initial visible setting
(cond
 ((or (eq window-system 'ns) (eq window-system 'mac))
  (when (>= emacs-major-version 23)
    (set-face-attribute 'default nil
			:family "monaco"
			:height 140)
    (set-fontset-font
     (frame-parameter nil 'font)
     'japanese-jisx0208
     '("Hiragino Maru Gothic Pro" . "iso10646-1"))
    (set-fontset-font
     (frame-parameter nil 'font)
     'japanese-jisx0212
     '("Hiragino Maru Gothic Pro" . "iso10646-1"))
    (set-fontset-font
     (frame-parameter nil 'font)
     'mule-unicode-0100-24ff
     '("monaco" . "iso10646-1"))
    (setq face-font-rescale-alist
	  '(("^-apple-hiragino.*" . 1.2)
	    (".*osaka-bold.*" . 1.2)
	    (".*osaka-medium.*" . 1.2)
	    (".*courier-bold-.*-mac-roman" . 1.0)
	    (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
	    (".*monaco-bold-.*-mac-roman" . 0.9)
	    ("-cdac$" . 1.3)))
    (tool-bar-mode -1)
    (setq default-frame-alist
          (append
           '((width . 110))
           '((height . 46))
           '((top . 0))
           '((left . -1))
           default-frame-alist))
    )))
(setq inhibit-splash-screen t)

;; Recentf
(recentf-mode t)

;; line and column number mode
(line-number-mode t)
(column-number-mode t)

;; sense-expand-region
;; DO "M-x package-install expand-region" and "M-x package-install multiple-cursors" to use
(require 'sense-expand-region)
(global-set-key (kbd "C-@") 'sense-expand-region)

;; set permission +x for #!
(add-hook 'after-save-hook 'my-chmod-script)
(defun my-chmod-script() (interactive) (save-restriction (widen)
 (let ((name (buffer-file-name)))
  (if (and (not (string-match ":" name))
           (not (string-match "/\\.[^/]+$" name))
           (equal "#!" (buffer-substring 1 (min 3 (point-max)))))
     (progn (set-file-modes name (logior (file-modes name) 73))
            (message "Wrote %s (chmod +x)" name)
    ))
)))

;; set scroll-step
(setq scroll-step 1)
(setq scroll-conservatively 1)
(setq scroll-margin 0)
(setq search-highlight t)
(auto-compression-mode t)
(setq garbage-collection-message t)

;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)

;; cperl-mode setting
(defalias 'perl-mode 'cperl-mode)
(autoload 'cperl-mode "cperl-mode" "alternate mode for editing perl script." t)
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\|cgi\\|t\\)$" . cperl-mode))

;; cperl-mode
;(add-hook 'cperl-mode-hook
;          (lambda ()
;            (set-face-bold-p 'cperl-array-face nil)
;            (set-face-bold-p 'cperl-hash-face nil)
;            (set-face-italic-p 'cperl-hash-face nil)))
(add-hook 'cperl-mode-hook
          (lambda()
            (require 'perl-completion)
            (perl-completion-mode t)))
;(add-hook 'cperl-mode-hook
;          (lambda ()
;            (when (require 'auto-complete nil t)
;              (auto-complete-mode t)
;              (make-variable-buffer-local 'ac-sources)
;              (setq ac-sources
;                    '(ac-source-perl-completion)))))

(setq cperl-indent-parens-as-block t)
(setq cperl-close-paren-offset -4)
(setq cperl-indent-level 4)
(setq cperl-highlight-variables-indiscriminately t)
(setq cperl-continued-statement-offset 4)
(setq cperl-brace-offset -4)
(setq cperl-label-offset -4)
;(setq cperl-comment-column 40)
(setq-default indent-tabs-mode nil)

;; highlight
(show-paren-mode t)
(transient-mark-mode 1)

;; switch to buffer
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; indent-region shortcut
(global-set-key "\C-x\C-i" 'indent-region)
(global-set-key "\C-x\C-o" 'align)

;; recent buffer
(defun switch-to-other-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))
(global-set-key "\M-o" 'switch-to-other-buffer)

;; PBP
;(setq fill-column 78)
;(setq auto-fill-mode t)

;; don't show meta
(delete 'sgml-html-meta-auto-coding-function auto-coding-functions)
(setq auto-coding-functions nil)

;; html-helper-mode
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(add-to-list 'auto-mode-alist '("\\.\\(xhtml\\|html\\|tt\\|inc\\)$" . html-helper-mode))
(setq html-helper-basic-offset 4)
(setq html-helper-never-indent t)
(setq html-helper-verbose nil)

(require 'sgml-mode)
(add-hook 'html-helper-mode-hook
          '(lambda ()
             (set (make-local-variable 'indent-line-function)
                  'sgml-indent-line)
             (define-key html-helper-mode-map (kbd "TAB") 'indent-for-tab-command)))

(setq html-helper-new-buffer-template
      '("<!DOCTYPE html>\n"
        "<html>\n\n"
        "<head>\n"
        "  <meta charset=\"utf-8\">\n"
        "  <title>" p "</title>\n"
        "</head>\n\n"
        "<body>\n  " p "\n"
        "</body>\n\n"
        "</html>\n"))

;; html-tt
(require 'html-tt)
(add-hook 'html-helper-mode-hook 'html-tt-load-hook)

;; pcl-cvs mode
(autoload 'cvs-update "pcl-cvs"
  "Run a 'cvs update' in the current working directory. Feed the
output to a *cvs* buffer and run cvs-mode on it.
If optional prefix argument LOCAL is non-nil, 'cvs update -l' is run."
  t)

(autoload 'cvs-update-other-window "pcl-cvs"
  "Run a 'cvs update' in the current working directory. Feed the
output to a *cvs* buffer, display it in the other window, and run
cvs-mode on it.

If optional prefix argument LOCAL is non-nil, 'cvs update -l' is run."
  t)

(global-set-key "\C-xe" 'cvs-examine)

;; psvn
(require 'psvn)
(global-set-key "\C-xy" 'svn-status)

;; auto-insert
(require 'autoinsert)
(add-hook 'find-file-not-found-hooks 'auto-insert)
(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-alist
      (append
       '(
         (("\\.pm$" . "Perl Module")
          nil
          "package " _ ";

use strict;
use warnings;

1;")
         (("\\.\\(pl\\|cgi\\)$" . "Perl Script")
          nil
          "#!/usr/bin/env perl

use strict;
use warnings;

" _ )
         )
       auto-insert-alist))

;; yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.\\(yml\\|yaml\\)$" . yaml-mode))

;; show last new line
;(when (boundp 'show-trailing-whitespace) (setq-default show-trailing-whitespace t))

;; c-mode
(add-hook 'c-mode-hook
          (lambda ()
            (c-set-style "cc-mode")))

;; helm
;; DO "M-x package-install helm" to use
(global-set-key "\C-xb" 'helm-mini)

;; iswitchb
;(iswitchb-mode t)
;(add-hook 'iswitchb-define-mode-map-hook
;          'iswitchb-my-keys)
;(defun iswitchb-my-keys ()
;  "Add my keybindings for iswitchb."
;  (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
;  (define-key iswitchb-mode-map [left] 'iswitchb-prev-match)
;  (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
;  (define-key iswitchb-mode-map " " 'iswitchb-next-match)
;  (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)
;  )

;; for skk
;(require 'skk-autoloads)
(load-file "~/.skk")
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)

;; navi2ch
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)

;; emoji
;(require 'emoji)

;; package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; java
(add-to-list 'auto-mode-alist '("\\.java$" . java-mode))
(defun ant-compile ()
  "Traveling up the path, find build.xml file and run compile."
  (interactive )
  (with-temp-buffer
    (while (and (not (file-exists-p "build.xml"))
                (not (equal "/" default-directory)))
      (cd ".."))
    (set (make-local-variable 'compile-command)
         (concat "cd " default-directory " && "
                 "ant -emacs debug"))
    (call-interactively 'compile)))
(add-hook 'java-mode-hook
          (lambda ()
            (local-set-key "\C-c\C-k" 'ant-compile)))

;; markdown-mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.\\(md\\|mdwn\\|mdt\\|markdown\\)" . markdown-mode)
            auto-mode-alist))

;; load local setting
(cond ((file-readable-p "~/.emacs.local") (load-file "~/.emacs.local")))
