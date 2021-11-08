[![Melpa Status](http://melpa.org/packages/exec-path-from-shell-badge.svg)](https://melpa.org/#/exec-path-from-shell)
[![Melpa Stable Status](http://stable.melpa.org/packages/exec-path-from-shell-badge.svg)](http://stable.melpa.org/#/exec-path-from-shell)
[![Build Status](https://github.com/purcell/exec-path-from-shell/workflows/CI/badge.svg)](https://github.com/purcell/exec-path-from-shell/actions)
<a href="https://www.patreon.com/sanityinc"><img alt="Support me" src="https://img.shields.io/badge/Support%20Me-%F0%9F%92%97-ff69b4.svg"></a>

# exec-path-from-shell


A GNU Emacs library to ensure environment variables inside Emacs look
the same as in the user's shell.

## Motivation

Ever find that a command works in your shell, but not in Emacs?

This happens a lot on OS X, where an Emacs instance launched as a GUI app inherits a
default minimal set of environment variables that are probably not the ones you see
in a terminal window. Similarly, if you start Emacs as a daemon from `systemd` or `launchd`,
it will run with a default set of environment variables.

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

This sets `$MANPATH`, `$PATH` and `exec-path` from your shell, but only
when executed in a GUI frame on OS X and Linux.

If you launch Emacs as a daemon from `systemd` or similar, you
might like to use the following snippet:

```el
(when (daemonp)
  (exec-path-from-shell-initialize))
```

You can copy values of other environment variables by customizing
`exec-path-from-shell-variables` before invoking
`exec-path-from-shell-initialize`, or by calling
`exec-path-from-shell-copy-env`, e.g.:

```el
(exec-path-from-shell-copy-env "PYTHONPATH")
```

This function may also be called interactively.

The author uses the following configuration snippet before calling `exec-path-from-shell-initialize`:

```el
(dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE" "NIX_SSL_CERT_FILE" "NIX_PATH"))
  (add-to-list 'exec-path-from-shell-variables var))
```

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

To be safe, `exec-path-from-shell` starts an interactive (and login)
shell by default, but this can be much slower than necessary.
Interactive shells often have fancy features enabled that are only
helpful when one interacts directly with the shell, and this can
frequently cause startup time to exceed 750ms.  This can be avoided:

* Follow best practice by setting your environment variables so that
  they are available to both interactive and non-interactive shells.
  In practical terms, for most people this means setting them in
  `~/.profile`, `~/.bash_profile`, `~/.zshenv` instead of `~/.bashrc`
  and `~/.zshrc`.
* Once a non-interactive shell sets your environment variables
  correctly, adjust `exec-path-from-shell-arguments` appropriately
  (often to `nil`) before calling `exec-path-from-shell-initialize` so
  that it will start a non-interactive shell.

To learn more about how popular shells load start-up files, read
[this helpful article](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html).

Making `exec-path-from-shell` faster
------------------------------------

If evaluation takes more than
`exec-path-from-shell-warn-duration-millis` (500ms by default) then
`exec-path-from-shell` will print a warning.

* Non-interactive shells start up faster. Follow the steps in the
  section above so that you can run your shell without `-i` and still
  get the right environment variable settings. When `"-i"` is then
  removed from `exec-path-from-shell-arguments`, this package becomes
  more efficient.
* Invoking the shell has a non-trivial overhead in any case. Don't
  call `exec-path-from-shell-copy-env` repeatedly, since each
  invocation starts a shell. Instead, set
  `exec-path-from-shell-variables` to the full list of vars you want,
  and call `exec-path-from-shell-initialize` once.

Further help
------------

* `C-h f exec-path-from-shell-initialize`
* `C-h f exec-path-from-shell-copy-env`


[download]: https://github.com/purcell/exec-path-from-shell/tags

<hr>


[💝 Support this project and my other Open Source work via Patreon](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)

[🐦 @sanityinc](https://twitter.com/sanityinc)
