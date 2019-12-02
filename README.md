# [Gentoo Science](https://wiki.gentoo.org/wiki/Project:Science/Overlay) Overlay
[![Build Status](https://travis-ci.org/gentoo/sci.svg?branch=master)](https://travis-ci.org/gentoo/sci)

This is a Gentoo Linux [ebuild repository](https://wiki.gentoo.org/wiki/Ebuild_repository) which provides numerous scientific software packages.

## Install

As per the current [Portage specifications](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html), ebuild repositories (a.k.a. overlays) should be managed via file collections under `/etc/portage/repos.conf/`.
To enable our overlay without the need for additional software, simply run (as root):

```
wget https://gitweb.gentoo.org/proj/sci.git/plain/metadata/science.conf -O /etc/portage/repos.conf/science
```

To start using the overlay you now only need to get the ebuilds, via `emerge --sync`.

### BLAS and LAPACK

[The BLAS and LAPACK switching framework](https://wiki.gentoo.org/wiki/Blas-lapack-switch)
in ::gentoo has been implemented. The Science overlay will no longer
carry blas and lapack ebuilds.

### Uninstall

To uninstall the overlay run (again, as root):

```
rm /etc/portage/repos.conf/science
rm /var/db/repos/science -rf
```

## Support

You can ask for help on [Freenode IRC](https://www.gentoo.org/get-involved/irc-channels/) in `#gentoo-science`.
Alternatively you can report bugs on the [GitHub issues page](https://github.com/gentoo/sci/issues).

## Contribute

Please fork! We will merge! See [our contributing guide](https://github.com/gentoo/sci/blob/master/CONTRIBUTING.md).
