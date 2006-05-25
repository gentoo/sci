# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A language for scientific computing and rapid prototyping"
HOMEPAGE="http://yorick-mb.sourceforge.net/"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86"
IUSE="X"
MY_P=${PN}-mb-${PV}
RESTRICT="nomirror"
SRC_URI="mirror://sourceforge/yorick-mb/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}
DEPEND="X? ( virtual/x11 )"

src_compile() {
	econf $(use_with X x ) || die "econf failed"
	make O_FLAGS="${CFLAGS}" optimize || die "setting flags failed"
	emake || die "emake failed"
}

src_install() {
	./install-sh 0 "${D}"/usr
	make DESTDIR="${D}" install || die "install failed"
	dodoc README ANNOUNCE Changes
	doman yorick.1 gist.1
}
