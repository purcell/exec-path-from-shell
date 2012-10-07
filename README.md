exec-path-from-shell
=====================

A GNU Emacs library to setup environment variables from the user's shell.

Motivation
----------

On OS X, an Emacs instance started from the graphical user interface will have a
different environment than a shell in a terminal window, because OS X does not
run a shell during the login.  Obviously this will lead to unexpected results
when calling external utilities like `make` from Emacs.

This library works around this problem by copying important environment
variables from the user's shell.

Installation
------------

ELPA packages are available on Marmalade and MELPA.  Alternatively, [download][]
the latest release or clone the repository, and install
`exec-path-from-shell.el` with `M-x package-install-from-file`.

Usage
-----

Add the following to your `init.el`:

```scheme
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
```

This sets `$MANPATH`, `$PATH` and `exec-path` from your shell, but only on OS X.

You can copy values of other environment variables by customizing
`exec-path-from-shell-variables` before invoking
`exec-path-from-shell-initialize`, or by calling
`exec-path-from-shell-copy-env`, e.g.:

```scheme
(exec-path-from-shell-copy-env "PYTHONPATH")
```

This function may also be called interactively.

Further help
------------

* `C-h f exec-path-from-shell-initialize`
* `C-h f exec-path-from-shell-copy-env`

License
-------

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
Street, Fifth Floor, Boston, MA 02110-1301, USA.

[download]: https://github.com/purcell/exec-path-from-shell/tags
