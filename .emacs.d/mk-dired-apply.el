
;;; iterating over files in dired

; example functions to use

;(defun show-length-of-buffer (mybuffer)
;  "Displays the length of mybuffer"
;  (setq len (buffer-size))
;  (message "Buffer size %d %s" len (buffer-file-name mybuffer)))

;(defun mk-ada-recase-buffer (ignored)
;  (ada-adjust-case-buffer)
;  (save-buffer))

(defun apply-to-filename (fn filename)
  "opens up the file and gets the length of it, then messages the result"
  (let (fpath fname mybuffer len)
    (setq fpath filename)
    (setq fname (file-name-nondirectory fpath))
    (setq mybuffer (find-file fpath))
    (funcall fn mybuffer)
    (kill-buffer mybuffer)))

(defun for-each-dired-marked-file (fn)
  "Apply the function (currently fixed) to each marked buffer in dired mode"
  (interactive)
  (if (eq major-mode 'dired-mode)
      (let ((filenames (dired-get-marked-files)))
        (mapcar (lambda (filename) 
                  (funcall 'apply-to-filename fn filename)) filenames))
    (error (format "Not a Dired buffer \(%s\)" major-mode))))

(defun mk-dired-map ()
  "Prompt for elisp function to apply to marked dired buffers"
  (interactive)
  (let ((fn (read-from-minibuffer "Function to apply: " nil nil t)))
    (for-each-dired-marked-file fn)))



