;;; Tabbar.el --- Display a tab bar in the header line

;; Copyright (C) 2003, 2004, 2005 David Ponce

;; Author: David Ponce <david@dponce.com>
;; Maintainer: David Ponce <david@dponce.com>
;; Created: 25 February 2003
;; Keywords: convenience
;; Revision: $Id: tabbar.el,v 1.7 2010/11/22 23:30 m00natic Exp $

(defconst tabbar-version "2.0")

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This library provides the Tabbar global minor mode to display a tab
;; bar in the header line of Emacs 21 and later versions.  You can use
;; the mouse to click on a tab and select it.  Also, three buttons are
;; displayed on the left side of the tab bar in this order: the
;; "home", "scroll left", and "scroll right" buttons.  The "home"
;; button is a general purpose button used to change something on the
;; tab bar.  The scroll left and scroll right buttons are used to
;; scroll tabs horizontally.  Tabs can be divided up into groups to
;; maintain several sets of tabs at the same time (see also the
;; chapter "Core" below for more details on tab grouping).  Only one
;; group is displayed on the tab bar, and the "home" button, for
;; example, can be used to navigate through the different groups, to
;; show different tab bars.
;;
;; In a graphic environment, using the mouse is probably the preferred
;; way to work with the tab bar.  However, you can also use the tab
;; bar when Emacs is running on a terminal, so it is possible to use
;; commands to press special buttons, or to navigate cyclically
;; through tabs.
;;
;; These commands, and default keyboard shortcuts, are provided:
;;
;; `tabbar-mode'
;;     Toggle the Tabbar global minor mode.  When enabled a tab bar is
;;     displayed in the header line.
;;
;; `tabbar-local-mode'         (C-c <C-f10>)
;;     Toggle the Tabbar-Local minor mode.  Provided the global minor
;;     mode is turned on, the tab bar becomes local in the current
;;     buffer when the local minor mode is enabled.  This permits to
;;     see the tab bar in a buffer where the header line is already
;;     used by another mode (like `Info-mode' for example).
;;
;; `tabbar-mwheel-mode'
;;     Toggle the Tabbar-Mwheel global minor mode.  When enabled you
;;     can use the mouse wheel to navigate through tabs of groups.
;;
;; `tabbar-press-home'         (C-c <C-home>)
;; `tabbar-press-scroll-left'  (C-c <C-prior>)
;; `tabbar-press-scroll-right' (C-c <C-next>)
;;     Simulate a mouse-1 click on respectively the "home", "scroll
;;     left", and "scroll right" buttons.  A numeric prefix argument
;;     value of 2, or 3, respectively simulates a mouse-2, or mouse-3
;;     click.
;;
;; `tabbar-backward'           (C-c <C-left>)
;; `tabbar-forward'            (C-c <C-right>)
;;     Are the basic commands to navigate cyclically through tabs or
;;     groups of tabs.  The cycle is controlled by the
;;     `tabbar-cycle-scope' option.  The default is to navigate
;;     through all tabs across all existing groups of tabs.  You can
;;     change the default behavior to navigate only through the tabs
;;     visible on the tab bar, or through groups of tabs only.  Or use
;;     the more specialized commands below.
;;
;; `tabbar-backward-tab'
;; `tabbar-forward-tab'
;;     Navigate through the tabs visible on the tab bar.
;;
;; `tabbar-backward-group'     (C-c <C-up>)
;; `tabbar-forward-group'      (C-c <C-down>)
;;     Navigate through existing groups of tabs.
;;
;;
;; Core
;; ----
;;
;; The content of the tab bar is represented by an internal data
;; structure: a tab set.  A tab set is a collection (group) of tabs,
;; identified by an unique name.  In a tab set, at any time, one and
;; only one tab is designated as selected within the tab set.
;;
;; A tab is a simple data structure giving the value of the tab, and a
;; reference to its tab set container.  A tab value can be any Lisp
;; object.  Each tab object is guaranteed to be unique.
;;
;; A tab set is displayed on the tab bar through a "view" defined by
;; the index of the leftmost tab shown.  Thus, it is possible to
;; scroll the tab bar horizontally by changing the start index of the
;; tab set view.
;;
;; The visual representation of a tab bar is a list of valid
;; `header-line-format' template elements, one for each special
;; button, and for each tab found into a tab set "view".  When the
;; visual representation of a tab is required, the function specified
;; in the variable `tabbar-tab-label-function' is called to obtain it.
;; The visual representation of a special button is obtained by
;; calling the function specified in `tabbar-button-label-function',
;; which is passed a button name among `home', `scroll-left', or
;; `scroll-right'.  There are also options and faces to customize the
;; appearance of buttons and tabs (see the code for more details).
;;
;; When the mouse is over a tab, the function specified in
;; `tabbar-help-on-tab-function' is called, which is passed the tab
;; and should return a help string to display.  When a tab is
;; selected, the function specified in `tabbar-select-tab-function' is
;; called, which is passed the tab and the event received.
;;
;; Similarly, to control the behavior of the special buttons, the
;; following variables are available, for respectively the `home',
;; `scroll-left' and `scroll-right' value of `<button>':
;;
;; `tabbar-<button>-function'
;;    Function called when <button> is selected.  The function is
;;    passed the mouse event received.
;;
;; `tabbar-<button>-help-function'
;;    Function called with no arguments to obtain a help string
;;    displayed when the mouse is over <button>.
;;
;; To increase performance, each tab set automatically maintains its
;; visual representation in a cache.  As far as possible, the cache is
;; used to display the tab set, and refreshed only when necessary.
;;
;; Several tab sets can be maintained at the same time.  Only one is
;; displayed on the tab bar, it is obtained by calling the function
;; specified in the variable `tabbar-current-tabset-function'.
;;
;; A special tab set is maintained, that contains the list of the
;; currently selected tabs in the existing tab sets.  This tab set is
;; useful to show the existing tab sets in a tab bar, and switch
;; between them easily.  The function `tabbar-get-tabsets-tabset'
;; returns this special tab set.
;;
;;
;; Buffer tabs
;; -----------
;;
;; The default tab bar implementation provided displays buffers in
;; dedicated tabs.  Selecting a tab, switch (mouse-1), or pop
;; (mouse-2), to the buffer it contains.
;;
;; The list of buffers put in tabs is provided by the function
;; specified in the variable `tabbar-buffer-list-function'.  The
;; default function: `tabbar-buffer-list', excludes buffers whose name
;; starts with a space, when they are not visiting a file.
;;
;; Buffers are organized in groups, each one represented by a tab set.
;; A buffer can have no group, or belong to more than one group.  The
;; function specified by the variable `tabbar-buffer-groups-function'
;; is called for each buffer to obtain the groups it belongs to.  The
;; default function provided: `tabbar-buffer-groups' organizes buffers
;; depending on their major mode (see that function for details).
;;
;; The "home" button toggles display of buffer groups on the tab bar,
;; allowing to easily show another buffer group by clicking on the
;; associated tab.
;;
;; Known problems:
;;
;; Bug item #858306 at <http://sf.net/tracker/?group_id=79309>:
;; tabbar-mode crashes GNU Emacs 21.3 on MS-Windows 98/95.
;;

;;; History:
;;

;;; Code:

;;; Options
;;
(defgroup tabbar nil
  "Display a tab bar in the header line."
  :group 'convenience)

(defcustom tabbar-cycle-scope nil
  "*Specify the scope of cyclic navigation through tabs.
The following scopes are possible:

- `tabs'
    Navigate through visible tabs only.
- `groups'
    Navigate through tab groups only.
- default
    Navigate through visible tabs, then through tab groups."
  :group 'tabbar
  :type '(choice :tag "Cycle through..."
                 (const :tag "Visible Tabs Only" tabs)
                 (const :tag "Tab Groups Only" groups)
                 (const :tag "Visible Tabs then Tab Groups" nil)))

(defcustom tabbar-auto-scroll-flag t
  "*Non-nil means to automatically scroll the tab bar.
That is, when a tab is selected outside of the tab bar visible area,
the tab bar is scrolled horizontally so the selected tab becomes
visible."
  :group 'tabbar
  :type 'boolean)

(defvar tabbar-inhibit-functions '(tabbar-default-inhibit-function)
  "List of functions to be called before displaying the tab bar.
Those functions are called one by one, with no arguments, until one of
them returns a non-nil value, and thus, prevents to display the tab
bar.")

(defvar tabbar-current-tabset-function nil
  "Function called with no argument to obtain the current tab set.
This is the tab set displayed on the tab bar.")

(defvar tabbar-tab-label-function nil
  "Function that obtains a tab label displayed on the tab bar.
The function is passed a tab and should return a string.")

(defvar tabbar-select-tab-function nil
  "Function that select a tab.
The function is passed a mouse event and a tab, and should make it the
selected tab.")

(defvar tabbar-help-on-tab-function nil
  "Function to obtain a help string for a tab.
The help string is displayed when the mouse is onto the button.  The
function is passed the tab and should return a help string or nil for
none.")

(defvar tabbar-button-label-function nil
  "Function that obtains a button label displayed on the tab bar.
The function is passed a button name should return a propertized
string to display.")

(defvar tabbar-home-function nil
  "Function called when clicking on the tab bar home button.
The function is passed the mouse event received.")

(defvar tabbar-home-help-function nil
  "Function to obtain a help string for the tab bar home button.
The help string is displayed when the mouse is onto the button.
The function is called with no arguments.")

(defvar tabbar-scroll-left-function 'tabbar-scroll-left
  "Function that scrolls tabs on left.
The function is passed the mouse event received when clicking on the
scroll left button.  It should scroll the current tab set.")

(defvar tabbar-scroll-left-help-function 'tabbar-scroll-left-help
  "Function to obtain a help string for the scroll left button.
The help string is displayed when the mouse is onto the button.
The function is called with no arguments.")

(defvar tabbar-scroll-right-function 'tabbar-scroll-right
  "Function that scrolls tabs on right.
The function is passed the mouse event received when clicking on the
scroll right button.  It should scroll the current tab set.")

(defvar tabbar-scroll-right-help-function 'tabbar-scroll-right-help
  "Function to obtain a help string for the scroll right button.
The help string is displayed when the mouse is onto the button.
The function is called with no arguments.")

;;; Misc.
;;
(eval-and-compile
  (defalias 'tabbar-display-update
    (if (fboundp 'force-window-update)
        #'(lambda () (force-window-update (selected-window)))
      'force-mode-line-update)))

(defsubst tabbar-click-p (event)
  "Return non-nil if EVENT is a mouse click event."
  (memq 'click (event-modifiers event)))

(defun tabbar-shorten (str width)
  "Return a shortened string from STR that fits in the given display WIDTH.
WIDTH is specified in terms of character display width in the current
buffer; see also `char-width'.  If STR display width is greater than
WIDTH, STR is truncated and an ellipsis string \"...\" is inserted at
end or in the middle of the returned string, depending on available
room."
  (let* ((n  (length str))
         (sw (string-width str))
         (el "...")
         (ew (string-width el))
         (w  0)
         (i  0))
    (cond
     ;; STR fit in WIDTH, return it.
     ((<= sw width)
      str)
     ;; There isn't enough room for the ellipsis, STR is just
     ;; truncated to fit in WIDTH.
     ((<= width ew)
      (while (< w width)
        (setq w (+ w (char-width (aref str i)))
              i (1+ i)))
      (substring str 0 i))
     ;; There isn't enough room to insert the ellipsis in the middle
     ;; of the truncated string, so put the ellipsis at end.
     ((zerop (setq sw (/ (- width ew) 2)))
      (setq width (- width ew))
      (while (< w width)
        (setq w (+ w (char-width (aref str i)))
              i (1+ i)))
      (concat (substring str 0 i) el))
     ;; Put the ellipsis in the middle of the truncated string.
     (t
      (while (< w sw)
        (setq w (+ w (char-width (aref str i)))
              i (1+ i)))
      (setq w (+ w ew))
      (while (< w width)
        (setq n (1- n)
              w (+ w (char-width (aref str n)))))
      (concat (substring str 0 i) el (substring str n)))
     )))

;;; Tab and tab set
;;
(defsubst tabbar-make-tab (object tabset)
  "Return a new tab with value OBJECT.
TABSET is the tab set the tab belongs to."
  (cons object tabset))

(defsubst tabbar-tab-value (tab)
  "Return the value of tab TAB."
  (car tab))

(defsubst tabbar-tab-tabset (tab)
  "Return the tab set TAB belongs to."
  (cdr tab))

(defvar tabbar-tabsets nil
  "The tab sets store.")

(defvar tabbar-tabsets-tabset nil
  "The special tab set of existing tab sets.")

(defvar tabbar-current-tabset nil
  "The tab set currently displayed on the tab bar.")
(make-variable-buffer-local 'tabbar-current-tabset)

(defvar tabbar-init-hook nil
  "Hook run after tab bar data has been initialized.
You should use this hook to initialize dependent data.")

(defsubst tabbar-init-tabsets-store ()
  "Initialize the tab set store."
  (setq tabbar-tabsets (make-vector 31 0)
        tabbar-tabsets-tabset (make-symbol "tabbar-tabsets-tabset"))
  (put tabbar-tabsets-tabset 'start 0)
  (run-hooks 'tabbar-init-hook))

(defvar tabbar-quit-hook nil
  "Hook run after tab bar data has been freed.
You should use this hook to reset dependent data.")

(defsubst tabbar-free-tabsets-store ()
  "Free the tab set store."
  (setq tabbar-tabsets nil
        tabbar-tabsets-tabset nil)
  (run-hooks 'tabbar-quit-hook))

;; Define an "hygienic" function free of side effect between its local
;; variables and those of the callee.
(eval-and-compile
  (defalias 'tabbar-map-tabsets
    (let ((function (make-symbol "function"))
          (result   (make-symbol "result"))
          (tabset   (make-symbol "tabset")))
      `(lambda (,function)
         "Apply FUNCTION to each tab set, and make a list of the results.
The result is a list just as long as the number of existing tab sets."
         (let (,result)
           (if tabbar-tabsets
	       (mapatoms
		#'(lambda (,tabset)
		    (push (funcall ,function ,tabset) ,result))
		tabbar-tabsets))
           ,result)))))

(defun tabbar-make-tabset (name &rest objects)
  "Make a new tab set whose name is the string NAME.
It is initialized with tabs build from the list of OBJECTS."
  (let* ((tabset (intern name tabbar-tabsets))
         (tabs (mapcar #'(lambda (object)
                           (tabbar-make-tab object tabset))
                       objects)))
    (set tabset tabs)
    (put tabset 'select (car tabs))
    (put tabset 'start 0)
    tabset))

(defsubst tabbar-get-tabset (name)
  "Return the tab set whose name is the string NAME.
Return nil if not found."
  (intern-soft name tabbar-tabsets))

(defsubst tabbar-delete-tabset (tabset)
  "Delete the tab set TABSET.
That is, remove it from the tab sets store."
  (unintern tabset tabbar-tabsets))

(defsubst tabbar-tabs (tabset)
  "Return the list of tabs in TABSET."
  (symbol-value tabset))

(defsubst tabbar-tab-values (tabset)
  "Return the list of tab values in TABSET."
  (mapcar 'tabbar-tab-value (tabbar-tabs tabset)))

(defsubst tabbar-get-tab (object tabset)
  "Search for a tab with value OBJECT in TABSET.
Return the tab found, or nil if not found."
  (assoc object (tabbar-tabs tabset)))

(defsubst tabbar-member (tab tabset)
  "Return non-nil if TAB is in TABSET."
  (or (eq (tabbar-tab-tabset tab) tabset)
      (memq tab (tabbar-tabs tabset))))

(defsubst tabbar-template (tabset)
  "Return the cached visual representation of TABSET.
That is, a `header-line-format' template, or nil if the cache is
empty."
  (get tabset 'template))

(defsubst tabbar-set-template (tabset template)
  "Set the cached visual representation of TABSET to TEMPLATE.
TEMPLATE must be a valid `header-line-format' template, or nil to
cleanup the cache."
  (put tabset 'template template))

(defsubst tabbar-selected-tab (tabset)
  "Return the tab selected in TABSET."
  (get tabset 'select))

(defsubst tabbar-selected-value (tabset)
  "Return the value of the tab selected in TABSET."
  (tabbar-tab-value (tabbar-selected-tab tabset)))

(defsubst tabbar-selected-p (tab tabset)
  "Return non-nil if TAB is the selected tab in TABSET."
  (eq tab (tabbar-selected-tab tabset)))

(defvar tabbar--track-selected nil)

(defsubst tabbar-select-tab (tab tabset)
  "Make TAB the selected tab in TABSET.
Does nothing if TAB is not found in TABSET.
Return TAB if selected, nil if not."
  (when (tabbar-member tab tabset)
    (unless (tabbar-selected-p tab tabset)
      (tabbar-set-template tabset nil)
      (setq tabbar--track-selected tabbar-auto-scroll-flag))
    (put tabset 'select tab)))

(defsubst tabbar-select-tab-value (object tabset)
  "Make the tab with value OBJECT, the selected tab in TABSET.
Does nothing if a tab with value OBJECT is not found in TABSET.
Return the tab selected, or nil if nothing was selected."
  (tabbar-select-tab (tabbar-get-tab object tabset) tabset))

(defsubst tabbar-start (tabset)
  "Return the index of the first visible tab in TABSET."
  (get tabset 'start))

(defsubst tabbar-view (tabset)
  "Return the list of visible tabs in TABSET.
That is, the sub-list of tabs starting at the first visible one."
  (nthcdr (tabbar-start tabset) (tabbar-tabs tabset)))

(defun tabbar-add-tab (tabset object &optional append)
  "Add to TABSET a tab with value OBJECT if there isn't one there yet.
If the tab is added, it is added at the beginning of the tab list,
unless the optional argument APPEND is non-nil, in which case it is
added at the end."
  (let ((tabs (tabbar-tabs tabset)))
    (if (tabbar-get-tab object tabset)
        tabs
      (let ((tab (tabbar-make-tab object tabset)))
        (tabbar-set-template tabset nil)
        (set tabset (if append
                        (append tabs (list tab))
                      (cons tab tabs)))))))

(defun tabbar-delete-tab (tab)
  "Remove TAB from its tab set."
  (let* ((tabset (tabbar-tab-tabset tab))
         (tabs   (tabbar-tabs tabset))
         (sel    (eq tab (tabbar-selected-tab tabset)))
         (next   (and sel (cdr (memq tab tabs)))))
    (tabbar-set-template tabset nil)
    (setq tabs (delq tab tabs))
    ;; When the selected tab is deleted, select the next one, if
    ;; available, or the last one otherwise.
    (and sel (tabbar-select-tab (car (or next (last tabs))) tabset))
    (set tabset tabs)))

(defun tabbar-scroll (tabset count)
  "Scroll the visible tabs in TABSET of COUNT units.
If COUNT is positive move the view on right.  If COUNT is negative,
move the view on left."
  (let ((start (min (max 0 (+ (tabbar-start tabset) count))
                    (1- (length (tabbar-tabs tabset))))))
    (when (/= start (tabbar-start tabset))
      (tabbar-set-template tabset nil)
      (put tabset 'start start))))

(defun tabbar-tab-next (tabset tab &optional before)
  "Search in TABSET for the tab after TAB.
If optional argument BEFORE is non-nil, search for the tab before
TAB.  Return the tab found, or nil otherwise."
  (let* (last (tabs (tabbar-tabs tabset)))
    (while (and tabs (not (eq tab (car tabs))))
      (setq last (car tabs)
            tabs (cdr tabs)))
    (and tabs (if before last (nth 1 tabs)))))

(defun tabbar-current-tabset (&optional update)
  "Return the tab set currently displayed on the tab bar.
If optional argument UPDATE is non-nil, call the user defined function
`tabbar-current-tabset-function' to obtain it.  Otherwise return the
current cached copy."
  (and update tabbar-current-tabset-function
       (setq tabbar-current-tabset
             (funcall tabbar-current-tabset-function)))
  tabbar-current-tabset)

(defun tabbar-get-tabsets-tabset ()
  "Return the tab set of selected tabs in existing tab sets."
  (set tabbar-tabsets-tabset (tabbar-map-tabsets 'tabbar-selected-tab))
  (tabbar-scroll tabbar-tabsets-tabset 0)
  (tabbar-set-template tabbar-tabsets-tabset nil)
  tabbar-tabsets-tabset)

;;; Faces
;;
(defface tabbar-default
  '(
    ;;(((class color grayscale) (background light))
    ;; :inherit variable-pitch
    ;; :height 0.8
    ;; :foreground "gray50"
    ;; :background "grey75"
    ;; )
    (((class color grayscale) (background dark))
     :inherit variable-pitch
     :height 0.8
     :foreground "grey75"
     :background "gray50"
     )
    (((class mono) (background light))
     :inherit variable-pitch
     :height 0.8
     :foreground "black"
     :background "white"
     )
    (((class mono) (background dark))
     :inherit variable-pitch
     :height 0.8
     :foreground "white"
     :background "black"
     )
    (t
     :inherit variable-pitch
     :height 0.8
     :foreground "gray50"
     :background "gray75"
     ))
  "Default face used in the tab bar."
  :group 'tabbar)

(defface tabbar-unselected
  '((t
     :inherit tabbar-default
     :box (:line-width 1 :color "white" :style released-button)
     ))
  "Face used for unselected tabs."
  :group 'tabbar)

(defface tabbar-selected
  '((t
     :inherit tabbar-default
     :box (:line-width 1 :color "white" :style pressed-button)
     :foreground "blue"
     ))
  "Face used for the selected tab."
  :group 'tabbar)

(defface tabbar-highlight
  '((t
     :underline t
     ))
  "Face used to highlight a tab during mouse-overs."
  :group 'tabbar)

(defface tabbar-separator
  '((t
     :inherit tabbar-default
     ))
  "Face used for separators between tabs."
  :group 'tabbar)

(defface tabbar-button
  '((t
     :inherit tabbar-default
     :box (:line-width 1 :color "white" :style released-button)
     ))
  "Face used for tab bar buttons."
  :group 'tabbar)

(defface tabbar-button-highlight
  '((t
     :inherit tabbar-default
     ))
  "Face used to highlight a button during mouse-overs."
  :group 'tabbar)

(defcustom tabbar-background-color nil
  "*Background color of the tab bar.
By default, use the background color specified for the
`tabbar-default' face (or inherited from another face), or the
background color of the `default' face otherwise."
  :group 'tabbar
  :type '(choice (const :tag "Default" nil)
                 (color)))

(defsubst tabbar-background-color ()
  "Return the background color of the tab bar."
  (or tabbar-background-color
      (let* ((face 'tabbar-default)
             (color (face-background face)))
        (while (null color)
          (or (facep (setq face (face-attribute face :inherit)))
              (setq face 'default))
          (setq color (face-background face)))
        color)))

;;; Buttons and separator look and feel
;;
(defconst tabbar-button-widget
  '(cons
    (cons :tag "Enabled"
          (string)
          (repeat :tag "Image"
                  :extra-offset 2
                  (restricted-sexp :tag "Spec"
                                   :match-alternatives (listp))))
    (cons :tag "Disabled"
          (string)
          (repeat :tag "Image"
                  :extra-offset 2
                  (restricted-sexp :tag "Spec"
                                   :match-alternatives (listp))))
    )
  "Widget for editing a tab bar button.
A button is specified as a pair (ENABLED-BUTTON . DISABLED-BUTTON),
where ENABLED-BUTTON and DISABLED-BUTTON specify the value used when
the button is respectively enabled and disabled.  Each button value is
a pair (STRING . IMAGE) where STRING is a string value, and IMAGE a
list of image specifications.
If IMAGE is non-nil, try to use that image, else use STRING.
If only the ENABLED-BUTTON image is provided, a DISABLED-BUTTON image
is derived from it.")

;;; Home button
;;
(defvar tabbar-home-button-value nil
  "Value of the home button.")

(defconst tabbar-home-button-enabled-image
  '((:type pbm :data "\
P2 13 13 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0
6 0 255 255 255 255 255 255 255 255 255 255 9 130 9 255 255 255 255
255 255 255 255 255 255 26 130 26 255 255 255 255 255 255 255 0 9 26
41 130 41 26 9 0 255 255 255 255 5 145 140 135 130 125 120 115 5 255
255 255 255 0 9 26 41 130 41 26 9 0 255 255 255 255 255 255 255 26 130
26 255 255 255 255 255 255 255 255 255 255 9 130 9 255 255 255 255 255
255 255 255 255 255 0 6 0 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255
"))
  "Default image for the enabled home button.")

(defconst tabbar-home-button-disabled-image
  '((:type pbm :data "\
P2 13 13 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 0 0 1 2 3 2 1 0 0 255 255 255 255 0 132 128 123 119 114 110
106 0 255 255 255 255 0 0 1 2 3 2 1 0 0 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 255
"))
  "Default image for the disabled home button.")

(defcustom tabbar-home-button
  (cons (cons "[o]" tabbar-home-button-enabled-image)
        (cons "[x]" tabbar-home-button-disabled-image))
  "The home button.
The variable `tabbar-button-widget' gives details on this widget."
  :group 'tabbar
  :type tabbar-button-widget
  :set '(lambda (variable value)
          (custom-set-default variable value)
          ;; Schedule refresh of button value.
          (setq tabbar-home-button-value nil)))

;;; Scroll left button
;;
(defvar tabbar-scroll-left-button-value nil
  "Value of the scroll left button.")

(defconst tabbar-scroll-left-button-enabled-image
  '((:type pbm :data "\
P2 13 13 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255 128 16 48 255 255 255 255 255 255 255
255 144 28 86 128 0 255 255 255 255 255 255 160 44 92 159 135 113 0
255 255 255 255 160 44 97 165 144 129 120 117 0 255 255 176 44 98 175
174 146 127 126 127 128 0 255 255 0 160 184 156 143 136 134 135 137
138 0 255 255 176 32 67 144 146 144 145 146 148 149 0 255 255 255 255
160 42 75 140 154 158 159 160 0 255 255 255 255 255 255 160 40 74 154
170 171 0 255 255 255 255 255 255 255 255 160 41 82 163 0 255 255 255
255 255 255 255 255 255 255 160 32 48 255 255 255 255 255 255 255 255
255 255 255 255 255 255
"))
  "Default image for the enabled scroll left button.
A disabled button image will be automatically build from it.")

(defcustom tabbar-scroll-left-button
  (cons (cons " <" tabbar-scroll-left-button-enabled-image)
        (cons " =" nil))
  "The scroll left button.
The variable `tabbar-button-widget' gives details on this widget."
  :group 'tabbar
  :type tabbar-button-widget
  :set '(lambda (variable value)
          (custom-set-default variable value)
          ;; Schedule refresh of button value.
          (setq tabbar-scroll-left-button-value nil)))

;;; Scroll right button
;;
(defvar tabbar-scroll-right-button-value nil
  "Value of the scroll right button.")

(defconst tabbar-scroll-right-button-enabled-image
  '((:type pbm :data "\
P2 13 13 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
48 32 160 255 255 255 255 255 255 255 255 255 255 44 161 71 32 160 255
255 255 255 255 255 255 255 36 157 163 145 62 32 160 255 255 255 255
255 255 30 128 133 137 142 124 50 32 160 255 255 255 255 29 120 121
124 126 126 124 105 42 32 176 255 255 31 126 127 128 128 128 128 126
124 89 32 255 255 33 134 135 136 137 137 138 119 49 32 176 255 255 34
143 144 145 146 128 54 32 160 255 255 255 255 36 152 153 134 57 32 160
255 255 255 255 255 255 38 141 60 32 160 255 255 255 255 255 255 255
255 48 32 160 255 255 255 255 255 255 255 255 255 255 255 255 255 255
255 255 255 255 255 255 255 255
"))
  "Default image for the enabled scroll right button.
A disabled button image will be automatically build from it.")

(defcustom tabbar-scroll-right-button
  (cons (cons " >" tabbar-scroll-right-button-enabled-image)
        (cons " =" nil))
  "The scroll right button.
The variable `tabbar-button-widget' gives details on this widget."
  :group 'tabbar
  :type tabbar-button-widget
  :set '(lambda (variable value)
          (custom-set-default variable value)
          ;; Schedule refresh of button value.
          (setq tabbar-scroll-right-button-value nil)))

;;; Separator
;;
(defconst tabbar-separator-widget
  '(cons (choice (string)
                 (number :tag "Space width" 0.2))
         (repeat :tag "Image"
                 :extra-offset 2
                 (restricted-sexp :tag "Spec"
                                  :match-alternatives (listp))))
  "Widget for editing a tab bar separator.
A separator is specified as a pair (STRING-OR-WIDTH . IMAGE) where
STRING-OR-WIDTH is a string value or a space width, and IMAGE a list
of image specifications.
If IMAGE is non-nil, try to use that image, else use STRING-OR-WIDTH.
The value (\"\"), or (0) hide separators.")

(defvar tabbar-separator-value nil
  "Value of the separator used between tabs.")

(defcustom tabbar-separator (list 0.2)
  "Separator used between tabs.
The variable `tabbar-separator-widget' gives details on this widget."
  :group 'tabbar
  :type tabbar-separator-widget
  :set '(lambda (variable value)
          (custom-set-default variable value)
          ;; Schedule refresh of separator value.
          (setq tabbar-separator-value nil)))

;;; Images
;;
(defcustom tabbar-use-images t
  "*Non-nil means to try to use images in tab bar.
That is for buttons and separators."
  :group 'tabbar
  :type 'boolean
  :set '(lambda (variable value)
          (custom-set-default variable value)
          ;; Schedule refresh of all buttons and separator values.
          (setq tabbar-separator-value nil
                tabbar-home-button-value nil
                tabbar-scroll-left-button-value nil
                tabbar-scroll-right-button-value nil)))

(defsubst tabbar-find-image (specs)
  "Find an image, choosing one of a list of image specifications.
SPECS is a list of image specifications.  See also `find-image'."
  (when (and tabbar-use-images (display-images-p))
    (condition-case nil
        (find-image specs)
      (error nil))))

(defsubst tabbar-disable-image (image)
  "From IMAGE, return a new image which looks disabled."
  (setq image (copy-sequence image))
  (setcdr image (plist-put (cdr image) :conversion 'disabled))
  image)

(defsubst tabbar-normalize-image (image &optional margin)
  "Make IMAGE centered and transparent.
If optional MARGIN is non-nil, it must be a number of pixels to add as
an extra margin around the image."
  (let ((plist (cdr image)))
    (or (plist-get plist :ascent)
        (setq plist (plist-put plist :ascent 'center)))
    (or (plist-get plist :mask)
        (setq plist (plist-put plist :mask '(heuristic t))))
    (or (not (natnump margin))
        (plist-get plist :margin)
        (plist-put plist :margin margin))
    (setcdr image plist))
  image)

;;; Button keymaps and callbacks
;;
(defun tabbar-make-mouse-keymap (callback)
  "Return a keymap that call CALLBACK on mouse events.
CALLBACK is passed the received mouse event."
  (let ((keymap (make-sparse-keymap)))
    ;; Pass mouse-1, mouse-2 and mouse-3 events to CALLBACK.
    (define-key keymap [header-line down-mouse-1] 'ignore)
    (define-key keymap [header-line mouse-1] callback)
    (define-key keymap [header-line down-mouse-2] 'ignore)
    (define-key keymap [header-line mouse-2] callback)
    (define-key keymap [header-line down-mouse-3] 'ignore)
    (define-key keymap [header-line mouse-3] callback)
    keymap))

(defsubst tabbar-make-mouse-event (&optional type)
  "Return a mouse click event.
Optional argument TYPE is a mouse-click event or one of the
symbols `mouse-1', `mouse-2' or `mouse-3'.
The default is `mouse-1'."
  (if (tabbar-click-p type)
      type
    (list (or (memq type '(mouse-2 mouse-3)) 'mouse-1)
          (or (event-start nil) ;; Emacs 21.4
              (list (selected-window) (point) '(0 . 0) 0)))))

;;; Buttons
;;
(defconst tabbar-default-button-keymap
  (tabbar-make-mouse-keymap 'tabbar-select-button-callback)
  "Default keymap of a button.")

(defun tabbar-help-on-button (window object position)
  "Return a help string or nil for none, for the button under the mouse.
WINDOW is the window in which the help was found (unused).
OBJECT is the button label under the mouse.
POSITION is the position in that label.
Call `tabbar-NAME-help-function' where NAME is the button name
associated to OBJECT."
  (let* ((name (get-text-property position 'tabbar-button object))
         (funvar (and name
                      (intern-soft (format "tabbar-%s-help-function"
                                           name)))))
    (and (symbol-value funvar)
         (funcall (symbol-value funvar)))))

(defsubst tabbar-click-on-button (name &optional type)
  "Handle a mouse click event on button NAME.
Call `tabbar-select-NAME-function' with the received, or simulated
mouse click event.
Optional argument TYPE is a mouse click event type (see the function
`tabbar-make-mouse-event' for details)."
  (let ((funvar (intern-soft (format "tabbar-%s-function" name))))
    (when (symbol-value funvar)
      (funcall (symbol-value funvar) (tabbar-make-mouse-event type))
      (tabbar-display-update))))

(defun tabbar-select-button-callback (event)
  "Handle a mouse EVENT on a button.
Pass mouse click events on a button to `tabbar-click-on-button'."
  (interactive "@e")
  (when (tabbar-click-p event)
    (let ((target (posn-string (event-start event))))
      (tabbar-click-on-button
       (get-text-property (cdr target) 'tabbar-button (car target))
       event))))

(defun tabbar-make-button-keymap (name)
  "Return a keymap to handle mouse click events on button NAME."
  (if (fboundp 'posn-string)
      tabbar-default-button-keymap
    (let ((event (make-symbol "event")))
      (tabbar-make-mouse-keymap
       `(lambda (,event)
          (interactive "@e")
          (and (tabbar-click-p ,event)
               (tabbar-click-on-button ',name ,event)))))))

;;; Button callbacks
;;
(defun tabbar-scroll-left (event)
  "On mouse EVENT, scroll current tab set on left."
  (when (eq (event-basic-type event) 'mouse-1)
    (tabbar-scroll (tabbar-current-tabset) -1)))

(defun tabbar-scroll-left-help ()
  "Help string shown when mouse is over the scroll left button."
  "mouse-1: scroll tabs left.")

(defun tabbar-scroll-right (event)
  "On mouse EVENT, scroll current tab set on right."
  (when (eq (event-basic-type event) 'mouse-1)
    (tabbar-scroll (tabbar-current-tabset) 1)))

(defun tabbar-scroll-right-help ()
  "Help string shown when mouse is over the scroll right button."
  "mouse-1: scroll tabs right.")

;;; Tabs
;;
(defconst tabbar-default-tab-keymap
  (tabbar-make-mouse-keymap 'tabbar-select-tab-callback)
  "Default keymap of a tab.")

(defun tabbar-help-on-tab (window object position)
  "Return a help string or nil for none, for the tab under the mouse.
WINDOW is the window in which the help was found (unused).
OBJECT is the tab label under the mouse.
POSITION is the position in that label.
Call `tabbar-help-on-tab-function' with the associated tab."
  (when tabbar-help-on-tab-function
    (let ((tab (get-text-property position 'tabbar-tab object)))
      (funcall tabbar-help-on-tab-function tab))))

(defsubst tabbar-click-on-tab (tab &optional type)
  "Handle a mouse click event on tab TAB.
Call `tabbar-select-tab-function' with the received, or simulated
mouse click event, and TAB.
Optional argument TYPE is a mouse click event type (see the function
`tabbar-make-mouse-event' for details)."
  (when tabbar-select-tab-function
    (funcall tabbar-select-tab-function
             (tabbar-make-mouse-event type) tab)
    (tabbar-display-update)))

(defun tabbar-select-tab-callback (event)
  "Handle a mouse EVENT on a tab.
Pass mouse click events on a tab to `tabbar-click-on-tab'."
  (interactive "@e")
  (when (tabbar-click-p event)
    (let ((target (posn-string (event-start event))))
      (tabbar-click-on-tab
       (get-text-property (cdr target) 'tabbar-tab (car target))
       event))