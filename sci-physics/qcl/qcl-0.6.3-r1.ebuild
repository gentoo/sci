# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils flag-o-matic

DESCRIPTION="Quantum Computation Language with an emulator of a quantum computer"
HOMEPAGE="http://tph.tuwien.ac.at/~oemer/qcl.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

SRC_URI="http://tph.tuwien.ac.at/~oemer/tgz/${P}.tgz
	doc? ( http://tph.tuwien.ac.at/~oemer/doc/structquprog.pdf
		http://tph.tuwien.ac.at/~oemer/doc/qcldoc.pdf
		http://tph.tuwien.ac.at/~oemer/doc/quprog.pdf )"
DEPEND="media-libs/plotutils
	sys-libs/ncurses
	sys-libs/readline"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_install() {
	emake \
		QCLDIR="${D}/usr/share/${PN}" \
		QCLBIN="${D}/usr/bin" install \
		|| die "emake install failed"
	dodoc README CHANGES
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/{structquprog,qcldoc,quprog}.pdf || die
	fi
}
