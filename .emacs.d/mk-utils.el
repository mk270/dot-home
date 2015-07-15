(defun mk-to-preformatted-markdown (data)
  "Convert data from inside of HTML TT tag to preformatted markdown"
  (apply 'concat (mapcar (lambda (x) (concat "    " x "\n"))
                         (split-string data "\n"))))
  
(defun mk-replace-html-preformatted-with-markdown ()
  "Replace text in <PRE><TT>.*</TT></PRE> with markdown-formatted code"
  (interactive)
  (save-excursion
    (let ((pattern "<PRE><TT>\\([\0-\377[:nonascii:]]*?\\)</TT></PRE>"))
      (perform-replace pattern 
                       `(,(lambda (data count)
                            (mk-to-preformatted-markdown (match-string 1)))) 
                       nil t nil nil nil (point-min) (point-max)))))

(defun mk-underline-header (data)
  "make hyphen string of appropriate length and append it"
  (let ((underline (make-string (length data) ?-)))
    (concat data "\n" underline)))

(defun mk-html-header-to-markdown ()
  "Replace <H5>foo</H5> with equivalent markdown"
  (interactive)
  (save-excursion
    (let ((pattern "<H5>\\(.*?\\)</H5>"))
      (perform-replace pattern
                       `(,(lambda (data count)
                            (mk-underline-header (match-string 1))))
                       nil t nil nil nil (point-min) (point-max)))))

(defun mk-fix-ada-parens ()
  "Insert a space before relevant parens in an Ada source buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((pattern "\\([a-zA-Z]\\)("))
      (while (re-search-forward pattern nil t)
        (replace-match (concat (match-string 1) " ("))))
    (indent-region (point-min) (point-max))
    (save-buffer)))
                   
(defun mk-fix-ada-dot-ranges ()
  "Insert a space around range ellipses Ada source buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((pattern "\\([^ ]\\)\\.\\.\\([^ ]\\)"))
      (while (re-search-forward pattern nil t)
        (replace-match (concat (match-string 1) " .. " (match-string 2)))))
    (save-buffer)))

(defun mk-surround-with-spaces ()
  "Put spaces around the character at point"
  (interactive)
  (save-excursion
    (right-char)
    (insert " ")
    (left-char 2)
    (insert " ")))
  
;(global-set-key [f6] 'mk-surround-with-spaces)

(defun mk-trim-leading-whitespace (s)
  "Remove whitespace from beginning of string s"
  (replace-regexp-in-string "^\\s-*" "" s))

(defun mk-ada-reformat-arguments ()
  "Reformat Ada function/procedure arguments, Muen-style"
  (interactive)   
  (save-excursion
    (defun mk-advance-to-semi-or-rparen ()
      (re-search-forward "\\([);]\\)")
      (equal ";" (match-string 1)))
    (forward-sexp)
    (forward-sexp)
    (ada-previous-procedure)
    (forward-word)
    (forward-sexp)
    (insert "\n")
    (ada-tab)
    (while (mk-advance-to-semi-or-rparen)
      (insert "\n")
      (let ((beg (point)))
        (re-search-forward "[^\\s-]")
        (delete-region beg (point)))
      (ada-tab))
    
    (let ((end (point)))
      (search-backward "(")
      (forward-char)
      (let* ((argtext (buffer-substring (point) end))
             (arglines (mapcar 'mk-trim-leading-whitespace
                        (split-string argtext ";\\s-*" nil)))
             (max-length
              (apply 'max (mapcar 
                           (lambda (s) (length (car (split-string s " *:"))))
                           arglines)))
             (offset (+ max-length 1)))
        (search-backward "(")
        (forward-char)
        (while (progn
                 (let ((spaces (- offset (length (thing-at-point 'symbol)))))
                   (re-search-forward "\\(\\s-*?\\):")
                   (replace-match (make-string spaces '32) nil t nil 1))
                 (re-search-forward "[);]")
                 (if (equal (string (char-before)) ";")
                     (re-search-forward "[a-zA-Z]")
                   nil)))))
    (forward-char)
    (insert "\n")
    (ada-tab)))

