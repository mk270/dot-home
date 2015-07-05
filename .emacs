; startup
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq initial-major-mode (quote text-mode))

; Force the messages to 0, and kills the *Messages* buffer
;  - thus disabling it on startup.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Disabled *Completions*
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
            (kill-buffer buffer)))))

; droppings
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-by-copying t)

(add-to-list 'load-path "~/.emacs.d")

; indentation
(setq css-electric-keys nil)
(setq c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(tuareg-default-indent 2)
 '(tuareg-in-indent 2)
 '(tuareg-let-always-indent t)
 '(tuareg-let-indent 2)
 '(tuareg-method-indent 2))


; Tools: git
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "C-x g") 'magit-status)

(defun jta-reformat-xml ()
  "Reformats xml to make it readable (respects current selection)."
  (interactive)
  (save-excursion
    (let ((beg (point-min))
          (end (point-max)))
      (if (and mark-active transient-mark-mode)
          (progn
            (setq beg (min (point) (mark)))
            (setq end (max (point) (mark))))
        (widen))
      (setq end (copy-marker end t))
      (goto-char beg)
      (while (re-search-forward ">\\s-*<" end t)
        (replace-match ">\n<" t t))
      (goto-char beg)
      (indent-region beg end nil))))

(require 'column-marker)

(defun xah-new-empty-buffer ()
  "Open a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

(global-set-key (kbd "C-x 8") 'xah-new-empty-buffer)


; for FUCK's SAKE can developers not leave defaults the fuck ALONE?!
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
(setq electric-indent-mode -1) 
(setq-default c-electric-flag nil)

; Language: Java
(add-hook 'java-mode-hook (lambda ()
							(setq c-basic-offset 2
								  tab-width 2
								  indent-tabs-mode nil)))

;(add-hook 'java-mode-hook (lambda ()
;							(setq c-offsets-alist '((arglist-intro . +)))))
								  

; Language: Ocaml
(add-hook 'tuareg-mode-hook (lambda ()
							  (setq tuareg-default-indent 2
									indent-tabs-mode nil)))

; Language: Ada

(setq ada-auto-case nil)
(setq ada-indent-to-open-paren nil)
(setq ada-case-keyword 'downcase-word)
(setq ada-case-attribute 'downcase-word)
(setq ada-case-identifier 'downcase-word)

(add-hook 'ada-mode-hook (lambda ()
						   (setq-default indent-tabs-mode nil)))

;
(defun mk-atoll-setup ()
  "Set up directories for Atoll development"
  (interactive)
  (progn
    (setq default-directory "~/Src/atoll/apps/atoll/src")
    (setq compile-command "cd ~/Src/atoll && make")))

; enable single-keystroke kill buffer
(defun mk-kill-buffer ()
   "Kill current buffer unconditionally."
   (interactive)
   (kill-buffer (current-buffer)))

(global-set-key [f9] 'mk-kill-buffer)

