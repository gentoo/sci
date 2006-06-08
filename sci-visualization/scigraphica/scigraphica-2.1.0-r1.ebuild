# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Scientific application for data analysis and technical graphics"
SRC_URI="mirror://sourceforge/scigraphica/${P}.tar.gz"
HOMEPAGE="http://scigraphica.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""
DEPEND=">=sci-libs/libscigraphica-2.1.0
	>=dev-python/pygtk-2.6.1-r1
	>=media-libs/imlib-1.9.7"

src_unpack() {

	unpack "${A}"
	cd "${S}"

	# fix arrayobject problems
	epatch "${FILESDIR}"/${P}-arrayobject.patch
	# fix versioning stuff
	epatch "${FILESDIR}"/${P}-versioning.patch
	# fix desktop entry and docs
	epatch "${FILESDIR}"/${P}-desktop.patch
	# fix intltoolization and switch to glib_gettext
	epatch "${FILESDIR}"/${P}-intl.patch

	sed -i \
		-e "s:/lib:/$(get_libdir):g" \
		configure.in || die "sed for configure.in failed"

	einfo "Running intltoolize --copy --force --automake"
	intltoolize --copy --force --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	make DESTDIR=${D} install || die "make install Failed"
	dodoc AUTHORS ChangeLog FAQ.compile \
		INSTALL NEWS README TODO
}

pkg_postinst() {
	ewarn "Please be sure to remove your old scigraphica"
	ewarn "configuration directory."
	ewarn "Otherwise scigraphica won't work."
}
