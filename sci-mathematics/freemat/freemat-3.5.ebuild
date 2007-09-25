# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/freemat/freemat-3.4.ebuild,v 1.2 2007/08/26 13:01:30 bicatali Exp $

inherit eutils flag-o-matic autotools qt4

MY_PN=FreeMat
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Environment for rapid engineering and scientific prototyping and data processing"
HOMEPAGE="http://freemat.sourceforge.net/"
SRC_URI="mirror://sourceforge/freemat/${MY_P}.tar.gz"

IUSE="ncurses ffcall fftw umfpack arpack portaudio"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libpcre
	virtual/lapack
	dev-util/pkgconfig
	ncurses? ( >=sys-libs/ncurses-5.4 )
	umfpack? ( sci-libs/umfpack )
	arpack? ( sci-libs/arpack )
	fftw? ( >=sci-libs/fftw-3 )
	portaudio? ( media-libs/portaudio )"

RDEPEND="${DEPEND}
	ffcall? ( dev-libs/ffcall )"

S=${WORKDIR}/${MY_P}

src_compile() {
	# -O3 won't compile for freemat-3.2
	replace-flags "-O3" "-O2"
	econf $(use_with ncurses) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS ChangeLog
}

pkg_postint() {
	einfo "Initializing freemat data directory"
	FreeMat -i /usr/share/${MY_P}
}
