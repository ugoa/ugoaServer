(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(font-use-system-font t)
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
; (custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;  '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; show line numbers
(global-linum-mode t)

;; 关闭启动画面
(setq inhibit-startup-message t)

;; 允许emacs和外部其他程序的粘贴  
(setq x-select-enable-clipboard t)

;; 设置home键指向buffer开头，end键指向buffer结尾
(global-set-key [home] 'beginning-of-buffer)  
(global-set-key [end] 'end-of-buffer)  

;; 设置打开文件的缺省路径  
(setq default-directory "~/WorkZone/")  

;; 改变 Emacs 固执的要你回答 yes 的行为。按 y 或空格键表示 yes，n 表示 no
(fset 'yes-or-no-p 'y-or-n-p)  

;; tab键为2个字符宽度 
(setq default-tab-width 2)

;; 光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。  
(setq mouse-avoidance-mode 'animate)  

;; 用space代替tab输入.
(setq-default indent-tabs-mode nil)

(define-key global-map (kbd "RET") 'newline-and-indent)
;; Use Enter to get a new line and autoindent instead of C-j for ruby
(add-hook 'ruby-mode-hook (lambda () (local-set-key [(return)] 'reindent-then-newline-and-indent)))
(add-hook 'ruby-mode-hook (lambda () (setq comment-column 48) ))

;; Auto-complete plugin config
(add-to-list 'load-path "~/.emacs.d/auto_complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto_complete/ac-dict")
(ac-config-default)

;; color-theme plugin config
(add-to-list 'load-path "~/.emacs.d/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-deep-blue)

;; set frame size when emacs starts
;(setq initial-frame-alist '((top . 0) (left . 0) (width . 90) (height . 38)))
(setq initial-frame-alist '((width . 90) (height . 40)))
(setq default-frame-alist '((width . 90) (height . 40)))

;; set gotoline shortkey
(global-set-key [(control c) (control g)] 'goto-line)

;; 允许使用C-z作为命令前缀  
(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)
(global-set-key "\C-z\C-z" 'undo)

;; 允许使用C-.作为命令前缀
(define-prefix-command 'ctl-dot-map)
(global-set-key (kbd "C-.") 'ctl-dot-map)
(global-set-key (kbd "C-. C-.") 'repeat)

;; 用C-c i快速打开~/.emacs文件。  
(defun open-init-file ( )  
  (interactive)  
  (find-file "~/.emacs"))
(global-set-key "\C-ci" 'open-init-file)  

;; 系统剪贴板快捷键（C-c C-c复制，C-c C-v粘贴
(global-set-key "\C-c\C-c" 'clipboard-kill-ring-save)
(global-set-key "\C-c\C-v" 'clipboard-yank)

;; 命令和文件补全时不区分大小写
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

;;toggle off auto-save mode
(setq auto-save-mode nil)
;;don't keep tmp #filename# files
(setq auto-save-default nil)
;; 不产生备份文件
(setq make-backup-files nil)

;; 删除选中的部分
(delete-selection-mode 1)

;; yasnippet configs
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas/global-mode 1)

;; 滚轮改变字体大小for windows
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; 滚轮改变字体大小 for linux
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

;; 智能注释
(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)

;; 拷贝代码时自动格式化
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode
                     lisp-mode
                     clojure-mode
                     scheme-mode
                     haskell-mode
                     ruby-mode
                     rspec-mode
                     python-mode
                     c-mode
                     c++-mode
                     objc-mode
                     latex-mode
                     js-mode
                     plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))

;; 填入大中小括号，双单引号的匹配
;; 详细格式可以参照C-h f skeleton-pair-alist  
(setq skeleton-pair-alist  
      '((?\" _ "\"" >)
        (?\' _ "\'" >)
        (?\( _ ")" >)
        (?\[ _ "]" >)
        (?\{ _ "}" >)))

(setq skeleton-pair t)

;; 绑定全局键值
;; 也可以绑定单独到某个mode，比如cc-mode (define-key cc-mode-map (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "(")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "{")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[")  'skeleton-pair-insert-maybe)

;; 一键运行任何脚本
(defun run-current-file ()
  "Execute or compile the current file.
For example, if the current buffer is the file x.pl,
then it'll call “perl x.pl” in a shell.
The file can be php, perl, python, ruby, javascript, bash, ocaml, java.
File suffix is used to determine what program to run."
  (interactive)
  (let (extention-alist fname suffix progName cmdStr)
    (setq extention-alist ; a keyed list of file suffix to comand-line program to run
          '(
            ("lisp" . "clisp")
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("rb" . "/home/david/.rvm/bin/ruby")
            ("js" . "js")
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("java" . "javac")
            )
          )
    (setq fname (buffer-file-name))
    (setq suffix (file-name-extension fname))
    (setq progName (cdr (assoc suffix extention-alist)))
    (setq cmdStr (concat progName " \""   fname "\""))

    (if (string-equal suffix "el")
        (load-file fname)
      (if progName                    ; is not nil
          (progn
            (message "Running...")
            (shell-command cmdStr))
        (message "No recognized program file suffix for this file.")
        ) )))
(global-set-key (kbd "<f5>") 'run-current-file)

;; 保持一行的长度小于80个字符
(setq whitespace-line-count 80
      whitespace-style '(lines))

(setq whitespace-style '(trailing space-before-tab
                                  indentation space-after-tab))

;; 在标题栏显示buffer的名字
(setq frame-title-format "emacs@%b")

;; 避免行尾空白符
(setq whitespace-style '(trailing space-before-tab
                                  indentation space-after-tab))

;; 防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动
(setq scroll-margin 3
      scroll-conservatively 10000)

;; 默认进入text-mode，而不是没有什么功能的fundamental-mode
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; 将默认水平分割改为垂直分割
(setq split-height-threshold nil)
(setq split-width-threshold 0)

; show env var named path
(getenv "PATH")
; example of setting env var named “path”
; by prepending new paths to existing paths
(setenv "PATH"
        (concat
         (getenv "PATH") ; inherited from OS
        )
)

;; windows下透明, also work for linux, haha!
(setq alpha-list '((100 100) (95 65) (85 55) (75 45) (65 35)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))                ;; head value will set to
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))
    )
 )
(global-set-key [(f9)] 'loop-alpha)

;; 自动关键词缩进, 比如'end' in ruby only, work with emacs 24
;; (setq-default electric-indent-mode t)
; (add-hook 'ruby-mode-hook
;           (lambda ()
;             (set (make-local-variable 'electric-indent-chars)
;                  (append '(?d) electric-indent-chars))))

(global-set-key "\C-cr" (quote eval-buffer))

;; 使用%来匹配括号跳转, 类似于vi
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;; go-to-char,快速到达指定的字符，前缀C-c a， 类似于vi的f命令
(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
   Typing `wy-go-to-char-key' again will move forwad to the next Nth
   occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
                     char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))
(define-key global-map (kbd "C-c a") 'wy-go-to-char)

;; tabbar.el配置
(require 'tabbar)
(tabbar-mode)
(global-set-key (kbd "") 'tabbar-backward-group)
(global-set-key (kbd "") 'tabbar-forward-group)
(global-set-key (kbd "") 'tabbar-backward)
(global-set-key (kbd "") 'tabbar-forward)
;;;; 设置tabbar外观
;; 设置默认主题: 字体, 背景和前景颜色，大小
(set-face-attribute 'tabbar-default nil
                    :family "Vera Sans YuanTi Mono"
                    :background "gray80"
                    :foreground "gray30"
                    :height 1.0
                    )
;; 设置左边按钮外观：外框框边大小和颜色
(set-face-attribute 'tabbar-button nil
                    :inherit 'tabbar-default
                    :box '(:line-width 1 :color "gray30")
                    )
;; 设置当前tab外观：颜色，字体，外框大小和颜色
(set-face-attribute 'tabbar-selected nil
                    :inherit 'tabbar-default
                    :foreground "DarkGreen"
                    :background "LightGoldenrod"
                    :box '(:line-width 2 :color "DarkGoldenrod")
                    ;; :overline "black"
                    ;; :underline "black"
                    :weight 'bold
                    )
;; 设置非当前tab外观：外框大小和颜色
(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :box '(:line-width 2 :color "gray70")
                    )

;; ;; rails with emacs
;; (add-to-list 'load-path "~/.emacs.d/rails-reloaded")
;; (setq load-path (cons (expand-file-name "~/.emacs.d/rails-reloaded") load-path))
;; (require 'rails-autoload)

;; ecb和cedet的配置，主要用于rails
(load-file "~/.emacs.d/cedet/common/cedet.el")
;; Enable EDE (Project Management) features
(global-ede-mode 1)
;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)

;;  rinari for rails
(add-to-list 'load-path "~/.emacs.d/elpa/rinari-2.1")
(add-to-list 'load-path "~/.emacs.d/elpa/ruby-compilation-0.7")
(add-to-list 'load-path "~/.emacs.d/elpa/jump-2.0")
(add-to-list 'load-path "~/.emacs.d/elpa/findr-0.7")
(add-to-list 'load-path "~/.emacs.d/elpa/inflections-1.0")
(require 'rinari)

(add-to-list 'load-path "~/.emacs.d/ecb")
(require 'ecb)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; 全屏
(defun my-fullscreen ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
(global-set-key [f11] 'my-fullscreen)

;; 最大化
(defun my-maximized ()
  (interactive)
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message
   nil 0 nil "_NET_WM_STATE" 32
   '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
;启动时最大化
(my-maximized)


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

;; emacs 包管理程序
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

