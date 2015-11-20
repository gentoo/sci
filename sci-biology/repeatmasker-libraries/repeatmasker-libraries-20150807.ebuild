# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A special version of RepBase used by RepeatMasker"
HOMEPAGE="http://repeatmasker.org/"
SRC_URI="repeatmaskerlibraries-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/Libraries"

RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please register at http://www.girinst.org/ and go to"
	einfo '"Repbase Update - RepeatMasker edition" link'
	einfo 'which should take you to http://www.girinst.org/server/RepBase).'
	einfo "Download repeatmaskerlibraries-${PV}.tar.gz and place it in '${DISTDIR}"
	einfo "Older releases can be found at http://www.girinst.org/server/archive"
}

src_install() {
	insinto /usr/share/repeatmasker/Libraries
	doins "${S}"/RepeatMaskerLib.embl
	dodoc README
	dohtml README.html
}
