#!/usr/bin/env bash
set -e

EPREFIX=${1}

#Link to the workaroud we reproduce in this section : https://wiki.gentoo.org/wiki/User_talk:Houseofsuns#Migration_to_science_overlay_from_main_tree
#Efforts to more permanently address the issue: https://github.com/gentoo/sci/issues/805
echo ""
echo "Setting Up Eselect for Gentoo Science:"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
cp "sci-lapack" "${EPREFIX}/etc/portage/package.mask/"
emerge --oneshot --verbose dev-util/cmake >> /dev/null
emerge --oneshot --verbose app-admin/eselect::science >> /dev/null
FEATURES="-preserve-libs":$FEATURES emerge --oneshot --verbose sci-libs/blas-reference::science
eselect blas set reference
FEATURES="-preserve-libs":$FEATURES emerge --oneshot --verbose sci-libs/cblas-reference::science
eselect cblas set reference
FEATURES="-preserve-libs":$FEATURES emerge --oneshot --verbose sci-libs/lapack-reference::science
eselect lapack set reference
FEATURES="-preserve-libs":$FEATURES emerge --oneshot --verbose --exclude sci-libs/blas-reference --exclude sci-libs/cblas-reference --exclude sci-libs/lapack-reference `eix --only-names --installed --in-overlay science`

emerge -1qv @preserved-rebuild
