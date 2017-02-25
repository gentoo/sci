# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Toolkit for building and manipulating hidden Markov models"
HOMEPAGE="http://htk.eng.cam.ac.uk/"
SRC_URI="
	http://htk.eng.cam.ac.uk/ftp/software/HTK-3.4.1.tar.gz -> HTK-3.4.1.tar.gz
	hdecode? (
		http://htk.eng.cam.ac.uk/ftp/software/hdecode/HDecode-3.4.1.tar.gz -> HDecode-3.4.1.tar.gz
	)"
HDECODE_HOME="http://htk.eng.cam.ac.uk/extensions/index.shtml"

LICENSE="HTKCambridge hdecode? ( HDecodeCambridge )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-hlmtools -hslab -htkbook -hdecode"

RESTRICT="fetch"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	elog "Please download"
	elog "  - HTK-3.4.1.tar.gz"
	elog "from ${HOMEPAGE}"
	if use hdecode; then
		elog "  - HDecode-3.4.1.tar.gz"
		elog "from ${HDECODE_HOME}"
	fi
	elog "and place them in ${DISTDIR}"
}

src_prepare() {
	epatch "${FILESDIR}/include_make_destdir.patch"
}

src_configure() {
	econf \
		$(use_enable hlmtools) \
		$(use_enable hslab) \
		$(use_enable htkbook) \
		$(use_enable hdecode)
}

src_compile() {
	if use hlmtools || use hdecode; then
		emake -j1
	else
		default
	fi
}
