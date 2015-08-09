
; create temporary buffer and save it to a file
; get filename of current buffer
; calculate new filename

(defun mk-calculate-new-filename ()
  (concat (file-name-sans-extension (buffer-file-name)) ".html"))

(defun mk-surround (tag text)
  "Return <tag>\ntext\n</tag>"
  (concat "<" tag ">\n" text "\n</" tag ">"))

(defun mk-get-md-as-reveal ()
  "Return reveal.js equivalent of a ^L-delimited Markdown buffer"
  (let* 
      ((columns (split-string (buffer-string) ""))
       (pages (mapcar (lambda (s) (split-string s "")) columns))
       (pages-html (mapcar 
                    (lambda (page-group) 
                      (mapcar (lambda (page) 
                                (concat (mk-surround "section" page) "\n"))
                              page-group)) pages))
       (columns-html (mapcar (lambda (page-html-group)
                               (apply 'concat page-html-group)) pages-html)))
    (mapconcat (lambda (column-html)
                              (mk-surround "section" column-html))
               columns-html "\n")))
    
(defun mk-convert-md-to-reveal ()
  "Convert a buffer from ^L-delimited Markdown to reveal.js; save as %.html"
  (interactive)
  (let* ((saved-text (mk-get-md-as-reveal))
         (template-file "~/.home/data/md-to-reveal.inc")
         (template-text (with-temp-buffer
                          (insert-file-contents template-file)
                          (buffer-string)))
         (all-text (replace-regexp-in-string "{% content %}" saved-text 
                                             template-text))
         (file (mk-calculate-new-filename)))
    (if (file-exists-p file)
        (delete-file file))
    (append-to-file all-text nil file)
    (find-file file)
    (re-search-forward "<title>")
    (message (concat "You should set the <title> in " file))))











