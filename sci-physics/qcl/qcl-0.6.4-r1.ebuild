# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
IUSE="doc plotutils readline"

REPEND="
	plotutils? ( media-libs/plotutils[X,png] )
	readline? (
		sys-libs/ncurses:0=
		sys-libs/readline:0=
	)"
DEPEND="${DEPEND}
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}/${PN}"-0.6.3-gcc43.patch
	"${FILESDIR}/${P}"-makefile_v2.patch
)

src_configure() {
	# there is no configure, Makefile must be modified
	if ! use plotutils; then
		sed -i 's/^PL/#PL/' Makefile || die
	fi
	if ! use readline; then
		sed -i 's/^RL/#RL/' Makefile || die
	fi
}

src_install() {
	emake \
		QCLDIR="${D}/usr/share/${PN}" \
		QCLBIN="${D}/usr/bin" \
		install
	dodoc CHANGES README
	use doc && dodoc "${DISTDIR}/"{structquprog,qcldoc,quprog}.pdf
}
