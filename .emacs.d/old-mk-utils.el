; presumably this already exists, but I don't know what it's called
(defun mk-trimmer-find-replace (search replacement)
  "unconditionally replace text from start of buffer"
  (goto-char 1)
  (while (search-forward search nil t) (replace-match replacement nil t)))

(defun mk-clean-trimmer-buffer ()
  "clean up a buffer of misOCRed text"
  (interactive)

  (mapc
   (lambda (i) (mk-trimmer-find-replace (car i) (nth 1 i)))
   '(
	 (" :" ":")
	 (" ;" ";")
	 ("tho*" "tho'")
	 (" ?" "?")
	 (" j " "; ")
	 ))

  (goto-char 1)
  (query-replace-regexp "\\([a-z]\\)M\\([^a-z]\\)" "\\1'd\\2")
  (ispell-buffer)
)

(defun mk-fix-strlcs ()
  "fix up occurrences of strcat, strcpy and sprintf"
  (interactive)

  (goto-char 1)
  (query-replace-regexp "sprintf(\\([a-z0-9]*\\)," "snprintf(\\1, sizeof(\\1),")
  (goto-char 1)
  (query-replace-regexp "strcat(\\([^,]*\\), \\(.*\\));" "strlcat(\\1, \\2, sizeof(\\1));")
  (goto-char 1)
  (query-replace-regexp "strcpy(\\([^,]*\\), \\(.*\\));" "strlcpy(\\1, \\2, sizeof(\\1));"))

(defun mk-textit-enclose-region ()
  "enclose region in textit{} tags"

  (interactive)

  (let ((saved-end (region-end))
		(saved-beginning (region-beginning)))
	(goto-char saved-end)
	(insert "}")
	(goto-char saved-beginning)
	(insert "\\textit{")))
