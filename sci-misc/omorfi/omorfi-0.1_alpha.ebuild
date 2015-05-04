# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}-${PV/_alpha/-alpha}"

DESCRIPTION="Open morphology for Finnish language"
HOMEPAGE="http://gna.org/projects/omorfi"
SRC_URI="http://download.gna.org/omorfi/${MY_P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=sci-misc/kotus-sanalista-1
	dev-java/saxon
	sci-misc/sfst"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die "configure failed"
	emake -j1 || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog README README.fi THANKS || die "docs missing"
}
