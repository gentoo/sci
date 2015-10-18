# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Quantum Computation Language with an emulator of a quantum computer"
HOMEPAGE="http://tph.tuwien.ac.at/~oemer/qcl.html"
SRC_URI="
	http://tph.tuwien.ac.at/~oemer/tgz/${P}.tgz
	doc? (
		http://tph.tuwien.ac.at/~oemer/doc/structquprog.pdf
		http://tph.tuwien.ac.at/~oemer/doc/qcldoc.pdf
		http://tph.tuwien.ac.at/~oemer/doc/quprog.pdf
	)"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	media-libs/plotutils
	sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}"-0.6.3-gcc43.patch
	"${FILESDIR}/${P}"-makefile.patch
)

src_prepare() {
	epatch ${PATCHES[@]}
}

src_install() {
	emake \
		QCLDIR="${D}/usr/share/${PN}" \
		QCLBIN="${D}/usr/bin" install
	dodoc README CHANGES
	use doc && dodoc {structquprog,qcldoc,quprog}.pdf
}
