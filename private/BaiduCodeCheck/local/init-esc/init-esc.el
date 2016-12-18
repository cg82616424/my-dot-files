;; check eagle.py exist
(defun check-eagle-exist () 'true)

;; run eagle
(defun run-eagle (&optional current-file-name)
  (setq dir-name (file-name-directory current-file-name))
  (setq need-check-file-name (file-name-nondirectory current-file-name))
  
  (if (check-eagle-exist)
      (shell-command-to-string (concat "cd " dir-name  " && eagle.py " need-check-file-name))
    (error "Cannot find eagle.py; You have to add it into you PATH.")))

;; eagle-style-check
(defun eagle-style-check ()
  (interactive)
  (progn
    (setq current-file-name (buffer-file-name))
    (switch-to-buffer-other-window "*eagle-style-checker*")
    (erase-buffer)
    (insert (run-eagle current-file-name))
    (goto-char (point-min))
    (while (re-search-forward "\\[\\(.+\\)\\(ERROR\\)\\(.+\\)\\]" nil t)
      (replace-match "[\\2]")
      (add-text-properties (match-beginning 0)
                           (match-end 0)
                           (list 'face '(:foreground "red"))))
    (goto-char (point-min))
    (while (re-search-forward "\\(\\[1;34m\\)\\(.*\\)\\(.+\\[1;m\\)" nil t)
      (replace-match "[\\2]")
      (add-text-properties (match-beginning 0)
                           (match-end 0)
                           (list 'face '(:foreground "purple")))
      )
    (other-window 1)))

;;(eagle-style-check)
(provide 'init-esc)
