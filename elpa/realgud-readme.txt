A modular GNU Emacs front-end for interacting with external debuggers.

Quick start: https://github.com/realgud/realgud/

See URL `https://github.com/realgud/realgud/wiki/Features' for features, and
URL `https://github.com/realgud/realgud/wiki/Debuggers-Supported' for
debuggers we can handle.

Once upon a time in an Emacs far far away and a programming-style
deservedly banished, there was a monolithic Cathederal-like
debugger front-end called gub.  This interfaced with a number of
debuggers, many now dead.  Is there anyone still alive that
remembers sdb from UNIX/32V circa 1980?

This isn't that.  Here we make use of more modern programming
practices, more numerous and smaller files, unit tests, and better
use of Emacs primitives, e.g. buffer marks, buffer-local variables,
structures, rings, hash tables.  Although there is still much to be
desired, this code is more scalable and suitable as a common base for
an Emacs front-end to modern debuggers.

Oh, and because global variables are largely banned, we can support
several simultaneous debug sessions.

If you don't see your favorite debugger, see URL
`https://github.com/realgud/realgud/wiki/How-to-add-a-new-debugger/'
for how you can add your own.

The debugger is run out of a comint process buffer, or you can use
a `realgud-track-mode' inside an existing comint shell, shell, or
eshell buffer.

To install you will need a couple of other Emacs packages
installed.  If you install via melpa (`package-install') or
`el-get', these will be pulled in automatically.  See the
installation instructions URL
`https://github.com/realgud/realgud/wiki/How-to-Install' for all
the ways to to install and more details on installation.
