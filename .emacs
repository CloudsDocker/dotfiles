;; Safe load per dotemacs.de
(defvar safe-load-error-list ""
        "*List of files that reported errors when loaded via safe-load")

(defun safe-load (file &optional noerror nomessage nosuffix)
  "Load a file.  If error when loading, report back, wait for
   a key stroke then continue on"
  (interactive "f")
  (condition-case nil (load file noerror nomessage nosuffix) 
    (error 
      (progn 
       (setq safe-load-error-list  (concat safe-load-error-list  " " file))
       (message "****** [Return to continue] Error loading %s" safe-load-error-list )
        (sleep-for 1)
       nil))))

(defun safe-load-check ()
 "Check for any previous safe-load loading errors.  (safe-load.el)"
  (interactive)
  (if (string-equal safe-load-error-list "") () 
               (message (concat "****** error loading: " safe-load-error-list))))
;;

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.2")

; manually sets alt key to meta, I don't want super to be meta.
(setq x-alt-keysym 'meta)

(setq ring-bell-function 'ignore)
(toggle-scroll-bar -1)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(css-electric-keys nil)
 '(ido-everywhere t)
 '(ido-mode (quote both) nil (ido))
 '(inhibit-startup-screen t)
 '(pivotal-api-token "8ce844bfbc3de5022ac77fba060f3cd2"))
(if window-system
    (tool-bar-mode 0))
(setq frame-title-format "%b")
(setq make-backup-files nil) 
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;; (setq indent-line-function 'insert-tab)

;; aliases because I am l'lazy
(defalias 'couc 'comment-or-uncomment-region)
(global-set-key (kbd "C-c c m") 'couc)

(setq tramp-default-method "ssh")
(transient-mark-mode 1)
(setq x-select-enable-clipboard t)

;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(require 'ido)

(require 'tabbar)
(if (not tabbar-mode)
	(tabbar-mode))
(setq tabbar-buffer-groups-function
	(lambda ()
    (list "All Buffers")))
(setq tabbar-buffer-list-function
	(lambda ()
     	  (remove-if
     	   (lambda(buffer)
     	     (find (aref (buffer-name buffer) 0) " *"))
     	   (buffer-list))))

    
;;(global-set-key (kbd "TAB") 'self-insert-command)

;; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-font-lock-mode 1)

(iswitchb-mode 1)
 (defun iswitchb-local-keys ()
      (mapc (lambda (K) 
	      (let* ((key (car K)) (fun (cdr K)))
    	        (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	    '(("<right>" . iswitchb-next-match)
	      ("<left>"  . iswitchb-prev-match)
	      ("<up>"    . ignore             )
	      ("<down>"  . ignore             ))))
    (add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;; For programming in J
(autoload 'j-mode "j-mode.el"  "Major mode for J." t)
(autoload 'j-shell "j-mode.el" "Run J from emacs." t)
(setq auto-mode-alist
      (cons '("\\.ij[rstp]" . j-mode) auto-mode-alist))

; path of jconsole, et al
(setq j-path "~/bin/j701/bin/")

; if you don't need plotting, etc. 
(setq j-command "jconsole")

; Example from: http://jeremy.zawodny.com/emacs/emacs-4.html
; (setq auto-mode-alist (cons '("\\.html$" . html-helper-mode) auto-mode-alist))

; #!@$ing Rakefiles
(setq auto-mode-alist (cons '("Rakefile" . ruby-mode) auto-mode-alist))
; And Gemfiles
(setq auto-mode-alist (cons '("Gemfile" . ruby-mode) auto-mode-alist))


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python dev stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(require 'python-mode)
(setq interpreter-mode-alist
      (cons '("python" . python-mode)
          interpreter-mode-alist)

      python-mode-hook
      '(lambda () (progn
           (set-variable 'py-indent-offset 4)
           (set-variable 'py-smart-indentation nil)
           (set-variable 'indent-tabs-mode nil) )))

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport 't)

(global-set-key (kbd "C-M-n") 'next-error)

;; (defun py-complete ()
;;   (interactive)
;;   (let ((pymacs-forget-mutability t))
;;     (if (and 
;;          (and (eolp) (not (bolp)) 
;;          (not (char-before-blank))))
;;       (insert (pycomplete-pycomplete (py-symbol-near-point) (py-find-global-imports)))
;;       (indent-for-tab-command))))

;; (defun py-find-global-imports ()
;;   (save-excursion
;;     (let (first-class-or-def imports)
;;       (goto-char (point-min))
;;       (setq first-class-or-def
;;         (re-search-forward "^ *\\(def\\|class\\) " nil t))
;;       (goto-char (point-min))
;;       (setq imports nil)
;;       (while (re-search-forward
;;           "\\(import \\|from \\([A-Za-z_][A-Za-z_0-9\\.]*\\) import \\).*"
;;           nil t)
;;     (setq imports (append imports
;;                   (list (buffer-substring
;;                      (match-beginning 0) 
;;                      (match-end 0))))))  
;;       imports)))

;; (define-key py-mode-map "\M-\C-i" 'py-complete)
;; (define-key py-mode-map "\t" 'py-complete)

;; (provide 'pycomplete)

(require 'auto-complete)
(global-auto-complete-mode t)

;; end python dev

(require 'color-grep)

;;; Text files
(require 'markdown-mode)
(add-to-list 'auto-mode-alist
	     '("\\.md$" . markdown-mode))
(add-hook 'text-mode-hook (lambda ()
			    (turn-on-auto-fill)
			    (setq-default line-spacing 5)
			    (setq indent-tabs-mode nil)))
(require 'redo)       ; enables C-r (redo key)
(require 'rect-mark)  ; enables nice-looking block visual mode

;;; Magit
(require 'magit)

(defun reload-dot-emacs ()
  "Save the .emacs buffer if needed, then reload .emacs."
  (interactive)
  (let ((dot-emacs "~/.emacs"))
    (and (get-file-buffer dot-emacs)
         (save-buffer (get-file-buffer dot-emacs)))
    (load-file dot-emacs))
  (message "Re-initialized!"))

;; Reload read-only files in sudo automatically
;; Uses tramp, don't be stupid and not have tramp loaded.
(defun th-rename-tramp-buffer ()
  (when (file-remote-p (buffer-file-name))
    (rename-buffer
     (format "%s:%s"
             (file-remote-p (buffer-file-name) 'method)
             (buffer-name)))))

(add-hook 'find-file-hook
          'th-rename-tramp-buffer)

(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it's read-only."
  (if (and (not (file-writable-p (ad-get-arg 0)))
           (y-or-n-p (concat "File "
                             (ad-get-arg 0)
                             " is read-only.  Open it as root? ")))
      (th-find-file-sudo (ad-get-arg 0))
    ad-do-it))

(defun th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file))))
;; shortcut to reopen in sudo
(global-set-key (kbd "C-c o s") 'th-find-file-sudo)

;; deletes selected text
(delete-selection-mode t)

;; Thus, ‘M-w’ with no selection copies the current line, ‘C-w’ kills it entirely, 
;; and ‘C-a M-w C-y’ duplicates it. As the interactive-form property only affects 
;; the commands’ interactive behavior, they are safe for other functions to call.
(put 'kill-ring-save 'interactive-form
     '(interactive
       (if (use-region-p)
           (list (region-beginning) (region-end))
         (list (line-beginning-position) (line-beginning-position 2)))))
    (put 'kill-region 'interactive-form      
     '(interactive
       (if (use-region-p)
           (list (region-beginning) (region-end))
         (list (line-beginning-position) (line-beginning-position 2)))))

(defun duplicate-start-of-line-or-region ()
  (interactive)
  (if mark-active
      (duplicate-region)
    (duplicate-start-of-line)))

(defun duplicate-start-of-line ()
  (let ((text (buffer-substring (point)
                                (beginning-of-thing 'line))))
    (forward-line)
    (push-mark)
    (insert text)
    (open-line 1)))

(defun duplicate-region ()
  (let* ((end (region-end))
         (text (buffer-substring (region-beginning)
                                 end)))
    (goto-char end)
    (insert text)
    (push-mark end)
    (setq deactivate-mark nil)
    (exchange-point-and-mark)))
(global-set-key [(meta shift down)] 'duplicate-start-of-line-or-region)

(require 'pivotal-tracker)
(require 'color-theme)
(color-theme-initialize)
(color-theme-midnight)

;; Don't use set-default-font, the mf'er won't work in your clients!
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Inconsolata")))))

;; needs to come last because color-theme is presumptuous
(if (window-system) (set-frame-size (selected-frame) 131 90))
