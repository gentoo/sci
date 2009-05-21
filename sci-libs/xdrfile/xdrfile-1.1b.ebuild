# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-4.0.5.ebuild,v 1.1 2009/05/14 16:17:39 alexxy Exp $

EAPI="2"

inherit autotools multilib

DESCRIPTION="A small C-library for reading and writing gromacs trr and xtc files"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI="ftp://ftp.gromacs.org/pub/contrib/${P%b}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="dmalloc"

DEPEND="dmalloc? ( dev-libs/dmalloc )"

RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--bindir=/usr/bin \
		--libdir=/usr/$(get_libdir) \
		--docdir=/usr/share/doc/"${PF}" \
		$(use_with dmalloc)
}

src_install() {
	emake DESTDIR="${D}" install || die "Installing Single Precision failed"
	dodoc AUTHORS INSTALL README NEWS
}

