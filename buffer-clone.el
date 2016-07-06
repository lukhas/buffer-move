;;; buffer-clone.el --- easily clone buffers

;; Copyright (C) 2004-2014  Lucas Bonnet <lucas@rincevent.net>
;; Copyright (C) 2014  Mathis Hofer <mathis@fsfe.org>
;; Copyright (C) 2014-2015  Geyslan G. Bem <geyslan@gmail.com>
;; Copyright (C) 2016  Ta Quang Trung <taquangtrungvn@yahoo.com>

;; Authors: Lucas Bonnet <lucas@rincevent.net>
;;          Geyslan G. Bem <geyslan@gmail.com>
;;          Mathis Hofer <mathis@fsfe.org>
;;          Ta Quang Trung <taquangtrungvn@yahoo.com>
;; Keywords: lisp,convenience
;; Version: 0.1.0
;; URL : 

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;;; Commentary:

;; This file is for lazy people wanting to clone buffers without
;; typing C-x b on each window. This is useful when you have :

;; +--------------+-------------+
;; |              |             |
;; |    #emacs    |    #gnus    |
;; |              |             |
;; +--------------+-------------+
;; |                            |
;; |           .emacs           |
;; |                            |
;; +----------------------------+

;; and you want to have :

;; +--------------+-------------+
;; |              |             |
;; |    #emacs    |   #emacs    |
;; |              |             |
;; +--------------+-------------+
;; |                            |
;; |           .emacs           |
;; |                            |
;; +----------------------------+

;; With buffer-clone, just go in #emacs, do buf-clone-right

;; To use it, simply put a (require 'buffer-clone) in your ~/.emacs and
;; define some keybindings. For example, i use :

;; (global-set-key (kbd "<C-S-up>")     'buf-clone-up)
;; (global-set-key (kbd "<C-S-down>")   'buf-clone-down)
;; (global-set-key (kbd "<C-S-left>")   'buf-clone-left)
;; (global-set-key (kbd "<C-S-right>")  'buf-clone-right)

;;; Code:


(require 'windmove)


(defconst buffer-clone-version "0.1.0"
  "Version of buffer-clone.el")

(defgroup buffer-clone nil
  "Clone buffers without typing C-x b on each window"
  :group 'tools)

(defun buf-clone-to (direction)
  "Helper function to clone the current buffer to the window in the given
   direction (with must be 'up, 'down', 'left or 'right). An error is
   thrown, if no window exists in this direction."
  (let* ((other-window (windmove-find-other-window direction))
         (buf-this-buf (window-buffer (selected-window))))
    (if (null other-window)
        (error "No window in this direction")
      (if (window-dedicated-p other-window)
	  (error "The window in this direction is dedicated"))
      (if (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-window)))
	  (error "The window in this direction is the Minibuf"))

      ;; switch other window to buffer of the current window (clonning)
      (set-window-buffer other-window buf-this-buf)

      ;; select other window
      (select-window other-window))))

;;;###autoload
(defun buf-clone-up ()
  "Clone the current buffer to the above window.
   If there is no split, ie now window above the current one, an
   error is signaled."
  ;;  "Switches between the current buffer, and the buffer above the
  ;;  split, if possible."
  (interactive)
  (buf-clone-to 'up))

;;;###autoload
(defun buf-clone-down ()
  "Clone the current buffer to the under window.
   If there is no split, ie now window under the current one, an
   error is signaled."
  (interactive)
  (buf-clone-to 'down))

;;;###autoload
(defun buf-clone-left ()
  "Clone the current buffer to the left window.
   If there is no split, ie now window on the left of the current
   one, an error is signaled."
  (interactive)
  (buf-clone-to 'left))

;;;###autoload
(defun buf-clone-right ()
  "Clone the current buffer to the right window.
   If there is no split, ie now window on the right of the current
   one, an error is signaled."
  (interactive)
  (buf-clone-to 'right))

;;;###autoload
(defun buf-clone ()
  "Begin cloning the current buffer to different windows.

Use the arrow keys to clone in the desired direction.  Pressing
any other key exits this function."
  (interactive)
  (let ((map (make-sparse-keymap)))
    (dolist (x '(("<up>" . buf-clone-up)
                 ("<left>" . buf-clone-left)
                 ("<down>" . buf-clone-down)
                 ("<right>" . buf-clone-right)))
      (define-key map (read-kbd-macro (car x)) (cdr x)))
    (set-transient-map map t)))

(provide 'buffer-clone)
;;; buffer-clone.el ends here
