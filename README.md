[![Melpa Status](http://melpa.org/packages/exec-path-from-shell-badge.svg)](http://melpa.milkbox.net/#/exec-path-from-shell)
[![Melpa Stable Status](http://stable.melpa.org/packages/exec-path-from-shell-badge.svg)](http://stable.melpa.org/#/exec-path-from-shell)
<a href="https://www.patreon.com/sanityinc"><img alt="Support me" src="https://img.shields.io/badge/Support%20Me-%F0%9F%92%97-ff69b4.svg"></a>

# exec-path-from-shell


A GNU Emacs library to ensure environment variables inside Emacs look
the same as in the user's shell.

## Motivation

Ever find that a command works in your shell, but not in Emacs?

This happens a lot on OS X, where an Emacs instance started from the GUI inherits a
default set of environment variables.

This library solves this problem by copying important environment
variables from the user's shell: it works by asking your shell to print out the
variables of interest, then copying them into the Emacs environment.

## Compatibility

If the path printed by evaluating `(getenv "SHELL")` in Emacs points at `bash`
or `zsh`, this should work fine.

At a minimum, this package assumes that your shell is at least UNIX-y: if
`(getenv "SHELL")` evaluates to something like `".../cmdproxy.exe"`, this
package probably isn't for you.

Further, if you use a non-POSIX-standard shell such as `tcsh` or `fish`, your
shell will be asked to execute `sh` as a subshell in order to print
out the variables in a format which can be reliably parsed. `sh` must
be a POSIX-compliant shell in this case.

Note that shell variables which have not been exported as environment
variables (e.g. using the "export" keyword) may not be visible to
`exec-path-from-shell'.

## Installation

Installable packages are available via MELPA:  do
`M-x package-install RET exec-path-from-shell RET`.

Alternatively, [download][]
the latest release or clone the repository, and install
`exec-path-from-shell.el` with `M-x package-install-file`.

## Usage

Add the following to your `init.el` (after calling `package-initialize`):

```el
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
```

This sets `$MANPATH`, `$PATH` and `exec-path` from your shell, but only on OS X
and Linux.

You can copy values of other environment variables by customizing
`exec-path-from-shell-variables` before invoking
`exec-path-from-shell-initialize`, or by calling
`exec-path-from-shell-copy-env`, e.g.:

```el
(exec-path-from-shell-copy-env "PYTHONPATH")
```

This function may also be called interactively.

### Setting up your shell startup files correctly

Note that your shell will inherit Emacs's environment variables when
it is run by `exec-path-from-shell` -- to avoid surprises your config
files should therefore set the environment variables to their exact
desired final values, i.e. don't do this:

```
export PATH=/usr/local/bin:$PATH
```

but instead do this:

```
export PATH=/usr/local/bin:/usr/bin:/bin
```

You should also set your environment variables so that they are
available to both interactive and non-interactive shells. In practical
terms, for most people this means setting them in `~/.profile`,
`~/.bash_profile`, `~/.zshenv` instead of `~/.bashrc` and
`~/.zshrc`. By default, `exec-path-from-shell` checks for this
mistake, at the cost of some execution time. If your config files are
set up properly, you can set `exec-path-from-shell-arguments`
appropriately (often to `nil`) before calling
`exec-path-from-shell-initialize` to avoid this overhead.


Further help
------------

* `C-h f exec-path-from-shell-initialize`
* `C-h f exec-path-from-shell-copy-env`


[download]: https://github.com/purcell/exec-path-from-shell/tags
