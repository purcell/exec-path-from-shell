;;; exec-path-from-shell.el --- Make Emacs use the $PATH set up by the user's shell

;; Copyright (C) 2012 Steve Purcell

;; Author: Steve Purcell <steve@sanityinc.com>
;; Keywords: environment
;; URL: https://github.com/purcell/exec-path-from-shell
;; Version: DEV

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; On OS X (and perhaps elsewhere) the $PATH environment variable and
;; `exec-path' used by a windowed Emacs instance will usually be the
;; system-wide default path, rather than that seen in a terminal
;; window.

;; This library allows the user to set Emacs' `exec-path' and $PATH
;; from the shell path, so that `shell-command', `compile' and the
;; like work as expected.

;; Installation:

;; ELPA packages are available on Marmalade and Melpa. Alternatively, place
;; this file on a directory in your `load-path', and explicitly require it.

;; Usage:
;;
;;     (require 'exec-path-from-shell) ;; if not using the ELPA package
;;     (exec-path-from-shell-initialize)
;;
;; If you use your Emacs config on other platforms, you can instead
;; make initialization conditional as follows:
;;
;;     (when (memq window-system '(mac ns))
;;       (exec-path-from-shell-initialize))
;;
;; To copy the values of other environment variables, you can use
;; `exec-path-from-shell-copy-env', e.g.
;;
;;     (exec-path-from-shell-copy-env "PYTHONPATH")

;;; Code:

(defgroup exec-path-from-shell nil
  "Make Emacs use shell-defined values for $PATH etc."
  :prefix "exec-path-from-shell-"
  :group 'environment)

(defcustom exec-path-from-shell-variables
  '("PATH" "MANPATH")
  "List of environment variables which are copied from the shell."
  :group 'exec-path-from-shell)

(defun exec-path-from-shell-getenv (name)
  "Get the environment variable NAME from the user's shell.

Execute $SHELL as interactive login shell, have it output the
variable of NAME and return this output as string."
  (with-temp-buffer
    (call-process (getenv "SHELL") nil (current-buffer) nil
                  "--login" "-i" "-c" (concat "echo __RESULT=$" name))
    (when (re-search-backward "__RESULT=\\(.*\\)" nil t)
      (match-string 1))))

;;;###autoload
(defun exec-path-from-shell-copy-env (name)
  "Set the environment variable $NAME from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  Return the value
of the environment variable."
  (interactive "sCopy value of which environment variable from shell? ")
  (prog1
      (setenv name (exec-path-from-shell-getenv name))
    (when (string-equal "PATH" name)
      (setq eshell-path-env (getenv "PATH")
            exec-path (split-string (getenv "PATH") path-separator)))))

;;;###autoload
(defun exec-path-from-shell-initialize ()
  "Initialize environment from the user's shell.

The values of all the environment variables named in
`exec-path-from-shell-variables' are set from the corresponding
values used in the user's shell."
  (interactive)
  (mapc 'exec-path-from-shell-copy-env exec-path-from-shell-variables))


(provide 'exec-path-from-shell)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; mangle-whitespace: t
;; require-final-newline: t
;; eval: (checkdoc-minor-mode 1)
;; End:

;;; exec-path-from-shell.el ends here
