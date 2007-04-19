# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools qt4

MY_PN=FreeMat
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Environment for rapid engineering and scientific prototyping and data processing"
HOMEPAGE="http://freemat.sourceforge.net/"
SRC_URI="mirror://sourceforge/freemat/${MY_P}.tar.gz"

IUSE="ncurses ffcall fftw umfpack arpack"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libpcre
	virtual/lapack
	ncurses? ( >=sys-libs/ncurses-5.4 )
	umfpack? ( sci-libs/umfpack )
	arpack? ( sci-libs/arpack )
	fftw? ( >=sci-libs/fftw-3 )"

RDEPEND="${DEPEND}
	ffcall? ( dev-libs/ffcall )"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf $(use_with ncurses) || "econf failed"
	emake || "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS ChangeLog
}

pkg_postint() {
	einfo "Initializing freemat data directory"
	FreeMat -i /usr/share/${MY_P}
}
