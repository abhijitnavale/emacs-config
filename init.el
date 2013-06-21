;;; init.el --- Configuration for my Emacs
;;; Commentary:
;;;;Copyright (C) 2012  Yuri da Costa Albuquerque
;;;;
;;;;This program is free software: you can redistribute it and/or modify
;;;;it under the terms of the GNU General Public License as published by
;;;;the Free Software Foundation, either version 3 of the License, or
;;;;(at your option) any later version.
;;;;
;;;;This program is distributed in the hope that it will be useful,
;;;;but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;;GNU General Public License for more details.
;;;;
;;;;You should have received a copy of the GNU General Public License
;;;;along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/Dropbox/org/metas.org" "~/Dropbox/org/agenda.org" "~/Dropbox/org/lpic.org")))
 '(smtpmail-smtp-server "mail.tap4mobile.com.br")
 '(smtpmail-smtp-service 25)
 '(socks-server (quote ("Default server" "localhost" 9050 5))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Misc
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/plugins/erc-sasl")
(setq make-backup-files nil)
(setq gnus-button-url 'browse-url-generic
      browse-url-generic-program "google-chrome"
      browse-url-browser-function gnus-button-url)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(global-auto-revert-mode 1)
(add-hook 'find-file-hook #'(lambda ()
                              (setq indicate-buffer-boundaries t)))
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)
(global-set-key [s-left] 'windmove-left)
(global-set-key [s-right] 'windmove-right)
(global-set-key [s-up] 'windmove-up)
(global-set-key [s-down] 'windmove-down)
(put 'dired-find-alternate-file 'disabled nil)
(ido-mode 1)
(setq-default indent-tabs-mode nil)
(add-to-list 'auto-mode-alist '("PKGBUILD" . pkgbuild-mode))

;;Clean up
(defun cleanup-buffer-safe ()
  (interactive)
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8)
  (untabify (point-min) (point-max)))
(defun cleanup-buffer ()
  (interactive)
  (cleanup-buffer-safe)
  (indent-region (point-min) (point-max)))
(add-hook 'before-save-hook 'cleanup-buffer)
(global-set-key (kbd "C-c s") 'cleanup-buffer)

;; Ruby
(add-hook 'ruby-mode-hook 'zossima-mode)
(setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
(setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))

;; ERC + Tor
(setq socks-override-functions nil)
(setq erc-server "10.40.40.40")
(setq erc-nick "Denommus")
(setq erc-server-connect-function
      #'(lambda (name buffer host service &rest parameters)
          (let ((hosts (list "10.40.40.40" "10.40.40.41")))
            (apply
             (if (member host hosts)
                 'socks-open-network-stream
               'open-network-stream)
             (append (list name buffer host service) parameters)))))
(require 'socks)
(require 'erc)
(require 'erc-sasl)
(add-to-list 'erc-sasl-server-regexp-list "10\\.40\\.40\\.40")
(add-to-list 'erc-sasl-server-regexp-list "10\\.40\\.40\\.41")
(setq ercn-notify-rules
      '((current-nick . all)
        (query-buffer . all)))
(require 'notifications)
(add-hook 'ercn-notify
          #'(lambda (nickname message)
              (notifications-notify
               :title "ERC"
               :body (concatenate 'string nickname ": " message))))

;; Tetris
(setq tetris-score-file
      "~/.emacs.d/tetris-scores")

;; Packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;;BBDB
(add-to-list 'load-path "~/.emacs.d/plugins/bbdb-2.35/lisp")
(require 'bbdb)
(bbdb-initialize 'gnus 'message)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'mail-setup-hook 'bbdb'insinuate-sendmail)
(setq bbdb-file "~/Dropbox/bbdb")
(setq bbdb-complete-name-full-completion t)
(setq bbdb-completion-type 'primary-or-name)
(setq bbdb-complete-name-allow-cycling t)

;;Org-Mode
(setq org-log-done 'time)
(setq org-agenda-include-diary t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-directory "~/Dropbox/org")
(setq org-agenda-files
      (list
       (concat org-directory "/agenda.org")
       (concat org-directory "/lpic.org")))
(setq org-mobile-inbox-for-pull (concat org-directory "/agenda.org"))
(setq org-mobile-directory (concat org-directory "/MobileOrg"))
(load "~/.emacs.d/plugins/brazilian-holidays.el")
(add-hook 'org-mode-hook 'visual-line-mode)
(add-to-list 'load-path "~/.emacs.d/plugins/org-git-link")
(require 'org-git-link)

;;Diary
(setq diary-file "~/Dropbox/diary")
(setq calendar-and-diary-frame-parameters
      '((name . "Calendar") (title . "Calendar")
        (height . 20) (width . 78)
        (minibuffer . t)))
(setq calendar-date-style "european")

;;Jabber
(setq jabber-account-list '(("yuridenommus@gmail.com"
                             (:network-server . "talk.google.com")
                             (:connection-type . ssl))))

;;Twittering Mode
(setq twittering-use-master-password t)
(setq twittering-cert-file "/etc/ssl/certs/ca-certificates.crt")
(setq twittering-icon-mode t)
(setq twittering-mode-hook
      #'(lambda()
          (local-set-key (kbd "C-c p") 'twittering-goto-previous-uri)
          (local-set-key (kbd "C-c n") 'twittering-goto-next-uri)))
(setq twittering-initial-timeline-spec-string
      '(":home"
        ":replies"
        ":favorites"
        ":direct_messages"
        ":search/emacs/"))

;; Python
(setq python-command "python2")
(setq pdb-path '/usr/lib/python2.7/pdb.py
      gud-pdb-command-name (symbol-name pdb-path))
(defadvice pdb (before gud-query-cmdline activate)
  "Provide a better default command line when called interactively."
  (interactive
   (list (gud-query-cmdline pdb-path
                            (file-name-nondirectory buffer-file-name)))))

;; HTML
(setq html-mode-hook
      #'(lambda ()
          (local-set-key (kbd "C-c C-r") 'browse-url-of-file)))

;; C code
(c-add-style "qt" '("stroustrup" (indent-tabs-mode . nil) (tab-width . 4)))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook #'(lambda () (c-set-style "qt")))

;;After Initialize
(add-hook
 'after-init-hook
 #'(lambda ()
     ;; Packages
     (lexical-let ((auto-install-packages
                    '(bundler
                      auctex
                      clojure-mode
                      nrepl
                      ercn
                      erc-image
                      yasnippet
                      magit
                      js2-mode
                      slime
                      paredit
                      csharp-mode
                      dired+
                      org-mime
                      git-commit-mode
                      gitconfig-mode
                      lua-mode
                      pkgbuild-mode
                      ruby-block
                      ruby-compilation
                      rinari
                      zossima
                      yaml-mode
                      jabber
                      popup
                      elscreen
                      show-css
                      pretty-symbols-mode
                      browse-kill-ring
                      twittering-mode)))
       (mapcar #'(lambda (pkg)
                   (unless (package-installed-p pkg)
                     (package-install pkg))) auto-install-packages))

     ;; SLIME
     (load (expand-file-name "~/quicklisp/slime-helper.el"))
     (setq inferior-lisp-program "sbcl --noinform --no-linedit")
     (defun custom-repl-mode-hook ()
       (define-key slime-repl-mode-map [S-up] #'windmove-up)
       (define-key slime-repl-mode-map [S-down] #'windmove-down))
     (add-hook 'slime-repl-mode-hook #'custom-repl-mode-hook)
     (add-hook 'slime-mode-hook #'(lambda () (slime-setup '(slime-indentation))))

     ;; ParEdit
     (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
     (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
     (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
     (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
     (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
     (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
     (add-hook 'scheme-mode-hook           #'enable-paredit-mode)
     (add-hook 'clojure-mode-hook          #'paredit-mode)
     (add-hook 'slime-repl-mode-hook #'(lambda () (paredit-mode +1)))
     (defun override-slime-repl-bindings-with-paredit ()
       (define-key slime-repl-mode-map
         (read-kbd-macro paredit-backward-delete-key) nil))
     (add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

     ;; Ruby
     (global-rinari-mode)

     ;; Org2blog
     (setq org2blog/wp-blog-alist
           '(("wordpress"
              :url "http://dharmaprogramming.wordpress.com/xmlrpc.php"
              :username "Denommus")))

     ;; Magit
     (add-hook 'dired-mode-hook
               #'(lambda ()
                   (local-set-key (kbd "<f5>") 'magit-status)))

     ;; Pretty Symbols
     (add-to-list 'pretty-symbol-categories 'relational)
     (add-to-list 'pretty-symbol-categories 'misc)
     (add-to-list 'pretty-symbol-patterns '(?& misc "&amp;" (twittering-mode)))
     (add-hook 'twittering-mode-hook #'pretty-symbols-mode)
     (add-hook 'lisp-mode-hook #'pretty-symbols-mode)
     (add-hook 'emacs-lisp-mode-hook #'pretty-symbols-mode)

     ;; ERC
     (require 'erc-image)
     (add-to-list 'erc-modules 'image)
     (erc-update-modules)

     ;; Elscreen
     (elscreen-start)
     (global-set-key (kbd "C-M-_") #'elscreen-previous)
     (global-set-key (kbd "C-M-+") #'elscreen-next)

     ;; YASnippet
     (require 'yasnippet)
     (yas--initialize)
     (yas-load-directory "~/.emacs.d/snippets")))
(provide 'init)
;;; init.el ends here
