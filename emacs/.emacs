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
 ;; cocoa emacs setting
 ((and
   (string-match "apple-darwin" system-configuration)
   (string-match "^23\." emacs-version))
  (progn
    (tool-bar-mode -1)
    (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
    (set-fontset-font "fontset-menlokakugo"
                      'unicode
                      (font-spec :family "Hiragino Kaku Gothic ProN" :size 16)
                      nil
                      'append)
    (add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
    ))
 ;; window-system setting
 (window-system
  (progn
    ;; linux setting
    (if (string-match "^23\." emacs-version)
        (progn
          (set-frame-font "Courier 10 Pitch-9")
          ))
    (tool-bar-mode nil)
    (setq inhibit-splash-screen t)
    (setq default-frame-alist
          (append
           '((width . 110))
           '((height . 46))
           '((top . 0))
           '((left . -1))
           default-frame-alist))
    (menu-bar-mode 1))
  (progn
    (setq inhibit-splash-screen t)
    (menu-bar-mode -1))
  ))

;; Recentf
(recentf-mode t)

;; line and column number mode
(line-number-mode t)
(column-number-mode t)

;; sense-region
(autoload 'sense-region-on "sense-region"
  "System to toggle region and rectangle." t nil)
(sense-region-on)

;; load local setting
(cond ((file-readable-p "~/.emacs.local") (load-file "~/.emacs.local")))

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

;; git-emacs
(require 'git-emacs)

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
          "#!/usr/local/bin/perl

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

;; anything
(require 'anything)
(require 'anything-config)
(setq anything-sources
      '(anything-c-source-buffers+
        anything-c-source-recentf))
(global-set-key "\C-xb" 'anything)
(defun anything-c-buffer-list ()
  "Return the list of names of buffers with boring buffers filtered out.
Boring buffers is specified by `anything-c-boring-buffer-regexp'
The first buffer in the list will be the last recently used
buffer that is not the current buffer."
  (let* ((buffers (mapcar 'buffer-name (buffer-list)))
         (buffers (append (cdr buffers) (list (car buffers))))
         (cur-buf-name (with-current-buffer anything-current-buffer
                         (and (current-buffer)
                              (buffer-name (current-buffer))))))
    (cond
     (cur-buf-name
      (setq buffers (delete cur-buf-name buffers))
      (add-to-list 'buffers cur-buf-name t)
      buffers)
     (t buffers))))

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
(require 'skk-autoloads)
(load-file "~/.skk")
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)

;; navi2ch
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)

;; emoji
(require 'emoji)

;; package
(load "package")
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


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
