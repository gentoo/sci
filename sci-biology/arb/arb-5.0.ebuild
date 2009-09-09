# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.2 2009/03/15 17:58:50 maekke Exp $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Tools for DNA/RNA sequence database handling and data analysis, phylogenetic analysis"
HOMEPAGE="http://www.arb-home.de/"
SRC_URI="http://download.arb-home.de/release/arb_${PV}/arbsrc.tgz -> ${P}.tgz"
MY_TAG=6182

LICENSE="arb"
SLOT="0"
IUSE="+opengl"
KEYWORDS="~amd64 ~x86"

DEPEND="app-text/sablotron
	www-client/lynx
	x11-libs/openmotif
	x11-libs/libXpm
	media-libs/tiff
	opengl? ( media-libs/glew
		virtual/glut
		media-libs/mesa[motif] )"
RDEPEND="${DEPEND}
	sci-visualization/gnuplot"
# to check:
#     - libmotif3
#     - gnuplot
#     - gv
#     - xfig
#     - xterm
#     - treetool
#       libpng

S="${WORKDIR}/arbsrc_${MY_TAG}"

src_prepare() {
	sed -i -e 's/getline/arb_getline/' READSEQ/ureadseq.c || die
	sed -i \
		-e 's/all: checks/all:/' \
		-e "s/GCC:=.*/GCC=$(tc-getCC) ${CFLAGS}/" \
		-e "s/GPP:=.*/GPP=$(tc-getCXX) ${CFLAGS}/" \
		"${S}/Makefile" || die
	cp config.makefile.template config.makefile
	sed -i -e '/^[ \t]*read/ d' -e 's/SHELL_ANS=0/SHELL_ANS=1/' "${S}/arb_install.sh" || die
	use amd64 && sed -i -e 's/ARB_64 := 0/ARB_64 := 1/' config.makefile
	use opengl || sed -i -e 's/OPENGL := 1/OPENGL := 0/' config.makefile
	emake ARBHOME="${S}" links || die
	(cd INCLUDE/GL; for i in ../../GL/glAW/*.h; do ln -s $i; done) || die
}

src_compile() {
	emake ARBHOME="${S}" PATH="${PATH}:${S}/bin" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/lib" tarfile || die
}

src_install() {
	ARBHOME="${D}/opt/arb" "${S}/arb_install.sh" || die
	cat <<EOF > "${S}/99${PN}"
ARBHOME=/opt/arb
PATH=/opt/arb/bin
LD_LIBRARY_PATH=/opt/arb/lib
EOF
	doenvd "${S}/99${PN}" || die
}
