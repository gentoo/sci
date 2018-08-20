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

### BLAS and LAPACK Migration

There is a long-standing BLAS and LAPACK stack incompatibility between the Science Overlay and the Base Gentoo Overlay.
A fix [is being considered](https://github.com/gentoo/sci/issues/805), bit is still not scheduled for implementation.
In the mean time, the most automated and up-to-date solution (building on [the original one](https://wiki.gentoo.org/wiki/User_talk:Houseofsuns)) is to run (as root, and after having installed the overlay):

```
cd ${EPREFIX}/var/lib/overlays/science/scripts
./lapack-migration.sh
```

### Uninstall

To uninstall the overlay run (again, as root):

```
rm /etc/portage/repos.conf/science
rm -rf /var/lib/overlays/science
```

## Support

You can ask for help on [Freenode IRC](https://www.gentoo.org/get-involved/irc-channels/) in `#gentoo-science`.
Alternatively you can report bugs on the [GitHub issues page](https://github.com/gentoo/sci/issues).

## Contribute

Please fork! We will merge! See [our contributing guide](https://github.com/gentoo/sci/blob/master/CONTRIBUTING.md).
