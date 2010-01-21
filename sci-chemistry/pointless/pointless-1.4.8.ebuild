# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs multilib

DESCRIPTION="Scores crystallographic Laue and space groups"
HOMEPAGE="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/pointless.html"
SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/${P}.tar.gz
	test? ( http://dev.gentooexperimental.org/~jlec/distfiles/test-framework.tar.gz )"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	sci-chemistry/ccp4-apps
	>=sci-libs/ccp4-libs-6.1.1-r5
	sci-libs/cctbx"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PV}-gcc4.4.patch
	)

src_compile() {
	emake  \
		-f Makefile.make \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		CLIB="${EPREFIX}/usr/$(get_libdir)" \
		CCTBX_sources=${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_sources \
		CCTBX_VERSION=2009 \
		ICCP4=-I${EPREFIX}/usr/include/ccp4 \
		ICLPR="-I${EPREFIX}/usr/include -I${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_sources -I${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_build/include" \
		LTBX="-L${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_build/lib -lcctbx" \
		LCCP4="$(gcc-config -L | awk -F: '{for(i=1; i<=NF; i++) printf " -L%s", $i}') -L${EPREFIX}/usr/$(get_libdir) -lgfortran -lgfortranbegin -lccp4c -lccp4f -lm" \
		|| die
#		LCCP4="-L/usr/$(get_libdir) -lccp4c -lccp4f -lm" \
}

src_test() {
	einfo "Starting tests ..."
	export PATH="${WORKDIR}/test-framework/scripts:"${S}":${PATH}"
	export CCP4_TEST="${WORKDIR}"/test-framework
	export CCP4_SCR="${T}"
	ccp4-run-thorough-tests -v test_pointless || die
}

src_install() {
	dobin pointless othercell || die
}
