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
;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;  '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; show line numbers
(global-linum-mode t)

;; disable the startup screen
(setq inhibit-startup-message t)

;; 允许emacs和外部其他程序的粘贴  
(setq x-select-enable-clipboard t)

;;设置home键指向buffer开头，end键指向buffer结尾
(global-set-key [home] 'beginning-of-buffer)  
(global-set-key [end] 'end-of-buffer)  

;;设置打开文件的缺省路径  
(setq default-directory "~/WorkZone/")  

;; 改变 Emacs 固执的要你回答 yes 的行为。按 y 或空格键表示 yes，n 表示 no
(fset 'yes-or-no-p 'y-or-n-p)  

;;tab键为2个字符宽度 
(setq default-tab-width 2)

;;光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。  
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
(setq initial-frame-alist '((width . 166) (height . 46)))
(setq default-frame-alist '((width . 166) (height . 46)))

;;set gotoline shortkey
(global-set-key [(control c) (control g)] 'goto-line)

;;允许使用C-z作为命令前缀  
(define-prefix-command 'ctl-z-map)
(global-set-key (kbd "C-z") 'ctl-z-map)  

;;用C-z i快速打开~/.emacs文件。  
(defun open-init-file ( )  
  (interactive)  
  (find-file "~/.emacs"))
(global-set-key "\C-ci" 'open-init-file)  

;;系统剪贴板快捷键（C-c C-c复制，C-c C-v粘贴
(global-set-key "\C-c\C-c" 'clipboard-kill-ring-save)
(global-set-key "\C-c\C-v" 'clipboard-yank)

;;toggle off auto-save mode
(setq auto-save-mode nil)

;; 命令和文件补全时不区分大小写
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

;;toggle off auto-save mode
(setq auto-save-mode nil)
;;don't keep tmp #filename# files
(setq auto-save-default nil)
;;don't make backup file
(setq auto-save-mode nil)

;; 删除选中的部分
(delete-selection-mode 1)