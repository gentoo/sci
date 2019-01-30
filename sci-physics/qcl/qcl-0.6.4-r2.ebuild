# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Quantum Computation Language with an emulator of a quantum computer"
HOMEPAGE="http://tph.tuwien.ac.at/~oemer/qcl.html"
SRC_URI="
	http://tph.tuwien.ac.at/~oemer/tgz/${P}.tgz
	doc? (
		http://tph.tuwien.ac.at/~oemer/doc/structquprog.pdf
		http://tph.tuwien.ac.at/~oemer/doc/qcldoc.pdf
		http://tph.tuwien.ac.at/~oemer/doc/quprog.pdf
		https://dev.gentoo.org/~bircoph/distfiles/0211100.pdf -> ccquprog.pdf
	)"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc plotutils readline"

BDEPEND="
	sys-devel/bison
	sys-devel/flex"
DEPEND="
	plotutils? ( media-libs/plotutils[X,png] )
	readline? (
		sys-libs/ncurses:0=
		sys-libs/readline:0=
	)"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}"-0.6.3-gcc43.patch
	"${FILESDIR}/${P}"-Makefile.patch
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
		QCLDIR="${D}/usr/lib/${PN}" \
		QCLBIN="${D}/usr/bin" \
		install
	dodoc CHANGES README
	use doc && dodoc "${DISTDIR}/"{ccquprog,structquprog,qcldoc,quprog}.pdf
}
