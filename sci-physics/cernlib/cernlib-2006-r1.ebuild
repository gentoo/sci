# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DEB_PV="${PV}.dfsg.2"
DEB_PR="2"
inherit cernlib
DEPEND="app-admin/eselect-blas"
KEYWORDS="~x86 ~amd64"

src_unpack() {
	cernlib_unpack
	cd "${S}"
	# temporary fix for threading support (might be supported by eselect)
	if eselect blas show | grep -q threaded-atlas; then
		einfo "Fixing threads linking for blas"
		sed -i \
			-e 's/$DEPS -lm/$DEPS -lm -lpthread/' \
			-e 's/$DEPS -l$1 -lm/$DEPS -l$1 -lm -lpthread/' \
			debian/add-ons/bin/cernlib.in || die "sed failed"
	fi

	# fix X11 library path
	sed -i \
		-e "s:L/usr/X11R6/lib:L/usr/$(get_libdir)/X11:g" \
		-e "s:XDIR=/usr/X11R6/lib:XDIR=/usr/$(get_libdir)/X11:g" \
		-e "s:XDIR64=/usr/X11R6/lib:XDIR64=/usr/$(get_libdir)/X11:g" \
		debian/add-ons/bin/cernlib.in || die "sed failed"

	# fix some default paths
	sed -i \
		-e "s:/usr/local:/usr:g" \
		-e "s:prefix)/lib:prefix)/$(get_libdir):" \
		-e 's:$(prefix)/etc:/etc:' \
		-e 's:$(prefix)/man:$(prefix)/share/man:' \
		debian/add-ons/cernlib.mk || die "sed failed"

	cernlib_patch
}
