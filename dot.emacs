(cond ((>= emacs-major-version 22) (setq inhibit-startup-message  t)))
(cond ((>= emacs-major-version 22) (custom-set-variables  '(fringe-mode 0 nil (fringe)) )
 ))
(cond ((>= emacs-major-version 22) ( global-linum-mode t) ))
(cond ((>= emacs-major-version 22) ( setq linum-format "%4d ") ))

(cond ((>= emacs-major-version 21) (tool-bar-mode 0)))
(speedbar -1)

;;(set-default-font "-microsoft-consolas-medium-r-normal--12-*")
(set-default-font "Consolas-10")

(modify-frame-parameters nil '((wait-for-wm . nil)))
(setq x-select-enable-clipboard t)
;;(setq default-frame-alist '((font . "-microsoft-consolas-medium-r-normal--12-*")))
(setq default-frame-alist '((font . "Consolas-10")))
(set-face-italic-p 'italic nil)
;;(setq-default line-spacing 2)

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/polymode")
(add-to-list 'load-path "~/.emacs.d/polymode/modes")

;; Tabbar
;;(when window-system 
(require 'tabbar)
(tabbar-mode t)
(defun tabbar-buffer-groups ()
  "Return the list of group names the current buffer belongs to.
This function is a custom function for tabbar-mode's tabbar-buffer-groups.
This function group all buffers into 3 groups:
Those Dired, those user buffer, and those emacs buffer.
Emacs buffer are those starting with “*”."
  (list (cond
	 ((string-equal "*" (substring (buffer-name) 0 1)) "Emacs Buffer" )
	 ((eq major-mode 'dired-mode) "Dired" )
	 (t "User Buffer" )
	 ))) 
(setq tabbar-buffer-groups-function 'tabbar-buffer-groups)
(global-set-key "\M-t" 'tabbar-forward-tab)
(global-set-key [M-s-left] 'tabbar-backward)
(global-set-key [M-s-right] 'tabbar-forward)
;;  )  ;; Tabbar end


;; choose c or cpp mode for header file
(defun bh-choose-header-mode ()
  (interactive)
  (if (string-equal (substring (buffer-file-name) -2) ".h")
      (progn
        ;; OK, we got a .h file, if a .m file exists we'll assume it's
        ;; an objective c file. Otherwise, we'll look for a .cpp file.
        (let ((dot-m-file (concat (substring (buffer-file-name) 0 -1) "m"))
              (dot-cpp-file (concat (substring (buffer-file-name) 0 -1) "cpp")))
          (if (file-exists-p dot-m-file)
              (progn
                (objc-mode)
                )
            (if (file-exists-p dot-cpp-file)
                (c++-mode)
              )
            )
          )
        )
    )
  )
(add-hook 'find-file-hook 'bh-choose-header-mode)
;; end of choose c or cpp mode for header file

;; (menu-bar-mode -1)
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
	;; use 120 char wide window for largeish displays
	;; and smaller 80 column windows for smaller displays
	;; pick whatever numbers make sense for you
	(if (> (x-display-pixel-width) 1440)
	    (add-to-list 'default-frame-alist (cons 'width 85))
	  (add-to-list 'default-frame-alist (cons 'width 85)))
	;; for the height, subtract a couple hundred pixels
	;; from the screen height (for panels, menubars and
	;; whatnot), then divide by the height of a char to
	;; get the height we want
	(add-to-list 'default-frame-alist (cons 'width 87))
	(add-to-list 'default-frame-alist 
		     (cons 'height (/ (- (x-display-pixel-height) 100)
				      (frame-char-height)))))))
(setq initial-frame-alist '((top . 0) (left . 500)))
(set-frame-size-according-to-resolution)

(global-font-lock-mode t)
(transient-mark-mode t)
(add-hook 'text-mode-hook (lambda () (set-buffer-file-coding-system 'unix)))
(modify-frame-parameters nil '((wait-for-wm . nil)))  

(global-set-key "\M-g" 'goto-line)
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)
(defun do-nothing () nil)
(setq ring-bell-function `do-nothing)
(setq next-line-add-newlines nil)

(autoload 'R-mode "~/opt/ess/lisp/ess-site" "R mode" t)
(add-to-list 'auto-mode-alist '("\\.[Rr]$" . R-mode))

(autoload 'markdown-mode "markdown-mode" "Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;;(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))
;;(add-to-list 'auto-mode-alist '("\\.rmd\\'" . markdown-mode))

(autoload 'php-mode "php-mode" "php-mode " t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(require 'poly-R)
(require 'poly-markdown)
;;; MARKDOWN
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;;; R modes
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
(add-to-list 'auto-mode-alist '("\\.rmd" . poly-markdown+r-mode))

;; folding for nxml-mode
(setq auto-mode-alist (append '(("\\.\\(xml\\|XML\\)$"  . nxml-mode) ) auto-mode-alist) )
(defun my-nxml-mode-hook ()
  "Functions to run when in nxml mode."
  (setq nxml-sexp-element-flag t)
  (hs-minor-mode 1))
(add-hook 'nxml-mode-hook 'my-nxml-mode-hook)
(eval-after-load "hideshow.el"
  (let ((nxml-mode-hs-info '(nxml-mode ("^\\s-*\\(<[^/].*>\\)\\s-*$" 1) "^\\s-*</.*>\\s-*$")))
	(when (not (member nxml-mode-hs-info hs-special-modes-alist))
	  (setq hs-special-modes-alist
			(cons nxml-mode-hs-info hs-special-modes-alist)))))

(cond
 ((executable-find "aspell")
  (setq ispell-program-name "aspell")
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US")))
 ((executable-find "hunspell")
  (setq ispell-program-name "hunspell")
  (setq ispell-extra-args '("-d en_US")))
 )

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "English")
 '(fringe-mode 0 nil (fringe))
 '(global-font-lock-mode t nil (font-lock))
 '(gnuserv-program (concat exec-directory "/gnuserv"))
 '(mouse-yank-at-point t)
 '(pc-select-meta-moves-sexps t)
 '(pc-select-selection-keys-only t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(toolbar-visible-p nil)
 '(visible-bell nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "black" :background "white" :size "14pt"))))
 '(blue ((t (:foreground "blue" :background "white"))))
 '(bold ((t (:background "white" :size "12" :bold t))))
 '(bold-italic ((t (:background "white" :size "12" :bold t :italic t))))
 '(border-glyph ((t (:background "white"))))
 '(cperl-here-face ((((type x) (class color)) (:foreground "green4" :background "white"))))
 '(cperl-pod-face ((((type x) (class color)) (:foreground "brown4" :background "white"))))
 '(cperl-pod-head-face ((((type x) (class color)) (:foreground "steelblue" :background "white"))))
 '(custom-button-face ((t (:background "white" :bold t))) t)
 '(custom-documentation-face ((t (:background "white"))) t)
 '(custom-face-tag-face ((t (:background "white" :underline t))) t)
 '(custom-group-tag-face ((((class color) (background light)) (:foreground "blue" :background "white" :underline t))) t)
 '(custom-group-tag-face-1 ((((class color) (background light)) (:foreground "red" :background "white" :underline t))) t)
 '(custom-saved-face ((t (:background "white" :underline t))) t)
 '(custom-variable-button-face ((t (:background "white" :bold t :underline t))) t)
 '(custom-variable-tag-face ((((class color) (background light)) (:foreground "blue" :background "white" :underline t))) t)
 '(font-lock-comment-face ((t (:foreground "blue4"))))
 '(font-lock-function-name-face ((t (:foreground "blue"))))
 '(font-lock-keyword-face ((t (:foreground "red4"))))
 '(font-lock-string-face ((t (:foreground "Green4"))))
 '(font-lock-type-face ((t (:foreground "steelblue"))))
 '(font-lock-variable-name-face ((t (:foreground "magenta4"))))
 '(gui-button-face ((t (:inverse-video t :foreground "black"))))
 '(menu ((t (:background "white" :foreground "black" :family "consolas"))))
 '(widget-field-face ((((class grayscale color) (background light)) (:background "white"))) t))

(if window-system ()
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:foreground "white" :background "black" :size "14pt"))))
   )
  (set-face-attribute
   'tabbar-unselected nil :background "white" :foreground "black"  )
  (set-face-attribute
   'tabbar-selected nil :background "black" :foreground "white" )
  (custom-set-variables '(tabbar-separator (quote (0.5))))
  
  (global-linum-mode 0)
  (menu-bar-mode nil)

   
  ;; adding spaces
  )

