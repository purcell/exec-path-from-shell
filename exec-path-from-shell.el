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

(defun exec-path-from-shell-getenv (name)
  (with-temp-buffer
    (call-process (getenv "SHELL") nil (current-buffer) nil
                  "--login" "-i" "-c" (concat "echo __RESULT=$" name))
    (when (re-search-backward "__RESULT=\\(.*\\)" nil t)
      (match-string 1))))

;;;###autoload
(defun exec-path-from-shell-copy-env (name)
  "Set the environment variable with `NAME' to match the value seen in the user's shell."
  (interactive "sCopy value of which environment variable from shell? ")
  (setenv name (exec-path-from-shell-getenv name)))

;;;###autoload
(defun exec-path-from-shell-initialize ()
  "Set the PATH environment variable and `exec-path' to match that seen in the user's shell."
  (interactive)
  (let ((path-from-shell (exec-path-from-shell-getenv "PATH")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))


(provide 'exec-path-from-shell)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; mangle-whitespace: t
;; require-final-newline: t;; eval: (checkdoc-minor-mode 1)
;; End:

;;; exec-path-from-shell.el ends here
