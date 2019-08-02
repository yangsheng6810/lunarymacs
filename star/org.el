;;; Keys

(luna-with-eval-after-load 'key.general
  (general-define-key
   :keymaps 'org-mode-map
   "C-c i" #'luna-insert-heading
   "C-c <tab>" #'outline-toggle-children))

(defvar luna-todo-file "~/note/todo.org")

;;; Packages

(load-package toc-org
  :commands (toc-org-enable
             toc-org-insert-toc))

(load-package htmlize
  :commands
  org-html-export-to-html
  org-html-export-as-html)

(load-package olivetti
  :init
  (setq olivetti-body-width 80)
  :commands olivetti-mode)

(load-package org-download
  :defer t
  :init (add-hook 'org-mode-hook #'org-download-enable))

;;; Function

(defun luna-open-album-dir ()
  "Open ~/p/casouri/rock/day/album/."
  (interactive)
  (shell-command-to-string (format "open ~/p/casouri/rock/day/album/")))

;;; Config

(define-minor-mode luna-prose-mode
  "A mode that optimizes for prose editing."
  :lighter " PROSE"
  (if luna-prose-mode
      (progn
        ;; This should be used with `doom-cyberpunk-theme' or `doom-one-light-theme'(modified)
        ;; see casouri/doom-themes repo for more
        (variable-pitch-mode)
        (setq-local cursor-type 'bar)
        ;; (setq-local blink-cursor-interval 0.6)
        ;; (blink-cursor-mode)
        (setq-local line-spacing 0.2)
        (electric-pair-local-mode -1)
        (ignore-errors (flyspell-mode 1))
        (olivetti-mode))
    (message "Sorry, alea iacta est.")))

(add-hook 'org-mode-hook #'luna-org-hook)

(defun luna-org-hook ()
  "Configuration for Org Mode."
  (company-mode -1)
  (luna-prose-mode)
  (electric-quote-local-mode)
  (setq-local whitespace-style '(tab-mark))
  (whitespace-mode))

;;;; 中文换行空格问题
;;
;; https://github.com/hick/emacs-chinese#中文断行

;; (defun clear-single-linebreak-in-cjk-string (string)
;;   "clear single line-break between cjk characters that is usually soft line-breaks"
;;   (let* ((regexp "\\([\u4E00-\u9FA5]\\)\n\\([\u4E00-\u9FA5]\\)")
;;          (start (string-match regexp string)))
;;     (while start
;;       (setq string (replace-match "\\1\\2" nil nil string)
;;             start (string-match regexp string start))))
;;   string)

;; (defun ox-html-clear-single-linebreak-for-cjk (string backend info)
;;   (when (org-export-derived-backend-p backend 'html)
;;     (clear-single-linebreak-in-cjk-string string)))

;; (add-to-list 'org-export-filter-final-output-functions
;;              #'ox-html-clear-single-linebreak-for-cjk)

;;;; Org Agenda

(setq org-agenda-files (list luna-todo-file))
(setq org-todo-keywords
      '((sequence "TODO"
                  "NEXT"
                  "START"
                  "WAIT"
                  "DEFER"
                  "|"
                  "DONE"
                  "CANCEL")))
(setq org-agenda-custom-commands
      '(("d" "Default Agenda View"
         ((agenda "")
          (todo ""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))
                 (org-agenda-overriding-header "Unscheduled/deadline tasks:")))))))

(setq org-priority-faces
      '((?A . (:inherit font-lock-warning-face))
        (?B . (:inherit default))
        (?C . (:inherit font-lock-comment-face))))

(setq org-todo-keyword-faces
      '(("DEFER" . (:inherit default :weight bold))))


;;;; Org Capture

(with-eval-after-load 'org-capture
  (setq org-default-notes-file "~/note/index.org")
  (setq org-capture-templates
        (append org-capture-templates
                `(("t" "TODOs")
                  ("te" "Emacs" entry (file+olp "~/note/todo.org" "Emacs") "*** TODO %?")
                  ("th" "Homework" entry (file+olp "~/note/todo.org" "Homework") "*** TODO %?")
                  ("to" "Other" entry (file+olp "~/note/todo.org" "Other") "*** TODO %?")
                  ("ts" "School" entry (file+olp "~/note/todo.org" "School") "*** TODO %?")
                  ("tr" "Readlist" entry (file+olp "~/note/todo.org" "Readlist") "*** TODO %?")
                  ))))

;;; Blog

(luna-load-relative "star/org/blogs.el")