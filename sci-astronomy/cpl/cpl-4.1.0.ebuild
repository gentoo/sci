# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ESO common pipeline library for astronomical data reduction"
HOMEPAGE="http://www.eso.org/sci/data-processing/software/cpl/"
SRC_URI="ftp://ftp.eso.org/pub/${PN}/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#todo: enable Gasgano support.
IUSE="doc"

# The qfits library is not used any more
RDEPEND="=sci-libs/cfitsio-2.510*"
DEPEND="${RDEPEND}"

src_compile() {
	econf \
		--with-cfitsio="/usr" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {

	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS NEWS TODO BUGS ChangeLog
	use doc && dohtml html/*
}

pkg_postinst() {
	elog "Help us to improve the ebuild"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=224227"
}
