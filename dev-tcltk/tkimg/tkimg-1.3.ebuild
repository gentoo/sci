# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

MY_P="${PN}${PV}"
DESCRIPTION="Adds a lot of image formats to Tcl/Tk"
HOMEPAGE="http://sourceforge.net/projects/tkimg/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/tk
	media-libs/libpng
	media-libs/tiff"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4.patch
	epatch "${FILESDIR}"/${P}-syslibs.patch
	epatch "${FILESDIR}"/${P}-makedeps.patch
	epatch "${FILESDIR}"/${P}-warnings.patch
	rm -f $(find . -name configure)
	for i in $(find -type d); do
		cd "${S}"/${i}
		[ -f configure.in ] && eautoreconf
	done
}

src_install() {
	emake \
		DESTDIR="${D}" \
		INSTALL_ROOT="${D}" \
		install || die "emake install failed"
	dodoc ChangeLog README Reorganization.Notes.txt changes ANNOUNCE
	insinto /usr/share/doc/${PF}/demo
	doins -r demo/*
	doman doc/man/*
	use doc && dohtml doc/html
}
