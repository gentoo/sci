# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave-forge/octave-forge-2005.06.13.ebuild,v 1.3 2005/08/21 18:56:45 ribosome Exp $

inherit eutils

DESCRIPTION="A collection of custom scripts, functions and extensions for GNU Octave"
HOMEPAGE="http://octave.sourceforge.net/"
SRC_URI="mirror://sourceforge/octave/${P}.tar.gz"

LICENSE="as-is"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
SLOT="0"
IUSE="ginac qhull"

DEPEND="=sci-mathematics/octave-2.1.69*
		>=sys-apps/sed-4
		sys-libs/libtermcap-compat
		!amd64? ( ginac? ( sci-mathematics/ginac ) )
		qhull? ( >=media-libs/qhull-3.1-r1 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-mex.patch
	epatch ${FILESDIR}/${PN}-randmtzig.patch

	# make it compile when X isn't installed. The source file there really
	# doesn't need X at all.
	# 02 Feb 2005, Robin H. Johnson <robbat2@gentoo.org>
	sed -e '/#include <X11/d' -i ${S}/main/audio/aurecord.cc
}

src_compile() {
	econf --enable-shared || die "econf failed"

	# this must be done before the *PATH variables are changed
	cd extra/graceplot && make grace_octave_path.m
	cd ${S}

	# The *PATH variables need to be changed, or they will
	# cause Portage access violations. They cannot be easily set just using
	# arguments passed to ./configure (at least, they can not easily be set
	# correctly)
	echo -en "Modifying paths..."
	for path in M O X ALTM ALTO; do
		sed -i "s|^\(${path}PATH = \)|\1${D}|" Makeconf || \
			die "failed to modify ${path}PATH"
	done
	echo -e "done.\n"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	# strip the fudged install paths
	sed -i "s|${D}||g" ${D}/usr/bin/mex || die "sed failed"

	dodoc AUTHORS COPYING* ChangeLog INDEX RELEASE-NOTES TODO
}

pkg_postinst() {
	einfo "If you do not have GiNaC and Qhull installed, octave-forge did not"
	einfo "compile itself with support for the geometry and symbolic math"
	einfo "extensions. If you would like these features, please emerge ginac"
	einfo "and/or qhull and then re-emerge octave-forge. Alternately, you can"
	einfo "specify USE='ginac qhull' and re-emerge octave-forge; in that case"
	einfo "the ebuild will automatically install the additional packages."
}

