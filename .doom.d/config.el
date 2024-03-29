(setq user-full-name "Davis Schenkenberger"
      user-mail-address "davisschenk@gmail.com")

(setq doom-theme 'doom-one)
(setq! doom-unicode-font (font-spec :family "FiraCode Nerd Font"))

(setq display-line-numbers-type 'relative)

(defun file-to-string (file)
  "Load a file into a string"
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(setq which-key-idle-delay 0.5)

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

(setq emojify-emoji-set "twemoji-v2")

(require 'ox-extra)
(ox-extras-activate '(-header-blocks ignore-headlines))

(after! org
  (map! :map org-mode-map :leader
        "t x" #'org-latex-preview
        "t e" #'org-toggle-pretty-entities))

(after! org-roam
  (setq org-roam-v2-ack t)
  (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section
              #'org-roam-unlinked-references-insert-section))
  (setq org-roam-directory (file-truename "~/Documents/roam/notes")))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; (use-package! dnd
;;     :after org
;;     :load-path "~/Developer/Tools/dnd-mode/dnd-mode.el"
;;     :config (setq dnd-snippet-dir "~/Developer/Tools/dnd-mode/snippets")
;; )

;; (load! "lisp/dnd-mode.el")
;;(setq dnd-snippet-dir "~/Developer/Tools/dnd-mode/snippets")

(defun davis/time-call (time-call &rest args)
  (message "Ohai %s" args)
  (let ((start-time (float-time))
        (result (apply time-call args)))
    (message "Function call took %f seconds" (- (float-time) start-time))
    result))

(advice-add 'org-babel-execute-src-block :around #'davis/time-call)

(after! ox-latex
  (add-to-list 'org-latex-classes '(
    "cheatsheet"
    (file-to-string "latex_classes/cheatsheet.tex")
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(add-to-list 'org-latex-classes
             '("koma-article" "\\documentclass{scrartcl}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("koma-report" "\\documentclass{scrreprt}"))

(add-to-list 'org-latex-classes
             '("homework" "\\documentclass[12pt]{article}"))

(after! org
  (setq
   org-latex-minted-options '(("bgcolor" "white") ("breaklines" "true") ("linenos" "true") ("style" "tango"))
   org-latex-listings 'minted
   org-latex-packages-alist '(("" "minted"))
   org-latex-pdf-process
   '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "%latex -shell-escape -interaction nonstopmode -output-directory %o %f")))

(setq org-latex-hyperref-template
   "\\hypersetup{
 pdfauthor={%a},
 pdftitle={%t},
 pdfkeywords={%k},
 pdfsubject={%d},
 pdfcreator={%c},
 pdflang={%L},
 colorlinks=true,
 linkcolor={cyan}
}")

(after! org (plist-put org-format-latex-options :scale 3.0))

(use-package-hook! evil
  :pre-init
  (setq evil-respect-visual-line-mode t) ;; sane j and k behavior
  t)

(use-package! string-inflection
  :commands (string-inflection-all-cycle
             string-inflection-toggle
             string-inflection-camelcase
             string-inflection-lower-camelcase
             string-inflection-kebab-case
             string-inflection-underscore
             string-inflection-capital-underscore
             string-inflection-upcase)
  :init
  (map! :leader :prefix ("c~" . "naming convention")
        :desc "cycle" "~" #'string-inflection-all-cycle
        :desc "toggle" "t" #'string-inflection-toggle
        :desc "CamelCase" "c" #'string-inflection-camelcase
        :desc "downCase" "d" #'string-inflection-lower-camelcase
        :desc "kebab-case" "k" #'string-inflection-kebab-case
        :desc "under_score" "_" #'string-inflection-underscore
        :desc "Upper_Score" "u" #'string-inflection-capital-underscore
        :desc "UP_CASE" "U" #'string-inflection-upcase)
  (after! evil
    (evil-define-operator evil-operator-string-inflection (beg end _type)
      "Define a new evil operator that cycles symbol casing."
      :move-point nil
      (interactive "<R>")
      (string-inflection-all-cycle)
      (setq evil-repeat-info '([?g ?~])))
    (define-key evil-normal-state-map (kbd "g~") 'evil-operator-string-inflection)))

(setq projectile-project-search-path '(("~/Developer/Personal" . 1)
                                       ("~/Developer/School" . 2)
                                       ("~/Developer/Work" . 2)
                                       ("~/Developer/Scripts" . 0)
                                       ("~/Documents" . 1)))

(use-package! ob-julia
  :commands org-babel-execute:julia
  :config
  (setq org-babel-julia-command-arguments
        `("--sysimage"
          ,(when-let ((img "~/.local/lib/julia.so")
                      (exists? (file-exists-p img)))
             (expand-file-name img))
          "--threads"
          ,(number-to-string (- (doom-system-cpus) 2))
          "--banner=no")))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("go" "python" "ipython" "bash" "sh" "rust"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

(use-package! graphviz-dot-mode
  :commands graphviz-dot-mode
  :mode ("\\.dot\\'" . graphviz-dot-mode)
  :init
  (after! org
    (setcdr (assoc "dot" org-src-lang-modes)
            'graphviz-dot)))

(use-package! company-graphviz-dot
  :after graphviz-dot-mode)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(python-mode . ("ruff-lsp"))))

(flycheck-define-checker python-ruff
  "A Python syntax and style checker using the ruff utility.
To override the path to the ruff executable, set
`flycheck-python-ruff-executable'.
See URL `http://pypi.python.org/pypi/ruff'."
  :command ("ruff"
            "--format=text"
            (eval (when buffer-file-name
                    (concat "--stdin-filename=" buffer-file-name)))
            "-")
  :standard-input t
  :error-filter (lambda (errors)
                  (let ((errors (flycheck-sanitize-errors errors)))
                    (seq-map #'flycheck-flake8-fix-error-level errors)))
  :error-patterns
  ((warning line-start
            (file-name) ":" line ":" (optional column ":") " "
            (id (one-or-more (any alpha)) (one-or-more digit)) " "
            (message (one-or-more not-newline))
            line-end))
  :modes python-mode)

(add-to-list 'flycheck-checkers 'python-ruff)
