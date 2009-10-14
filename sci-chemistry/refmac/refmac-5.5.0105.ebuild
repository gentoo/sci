# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fortran base toolchain-funcs versionator

DESCRIPTION="Macromolecular crystallographic refinement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~garib/refmac/"
SRC_URI="${HOMEPAGE}data/refmac_stable/refmac_${PV}.tar.gz
	test? ( http://dev.gentooexperimental.org/~jlec/distfiles/test-framework.tar.gz )"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="mirror"

RDEPEND="virtual/lapack
	virtual/blas
	sci-libs/ccp4-libs"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/$(get_version_component_range 1-2 ${PV})-allow-dynamic-linking.patch
	)

src_prepare() {
	base_src_prepare
	use test && epatch "${FILESDIR}"/test.log.patch
}

src_compile() {
	emake \
		FC=$(tc-getFC) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		COPTIM="${CFLAGS}" \
		FOPTIM="${FFLAGS:- -O2}" \
		VERSION="" \
		XFFLAGS="-fno-second-underscore" \
		LLIBCCP="-lccp4f -lccp4c -lccif -lmmdb -lstdc++" \
		LLIBLAPACK="-llapack -lblas" \
		|| die
}

src_test() {
	einfo "Starting tests ..."
	export PATH="${WORKDIR}/test-framework/scripts:${S}:${PATH}"
	export CCP4_TEST="${WORKDIR}"/test-framework
	export CCP4_SCR="${T}"
	ln -sf refmac "${S}"/refmac5
	sed '/^ANISOU/d' -i ${CCP4_TEST}/data/pdb/1vr7.pdb
	ccp4-run-thorough-tests -v test_refmac5 || die
}

src_install() {
	for i in refmac libcheck makecif; do
		dobin ${i} || die
	done
	dosym refmac /usr/bin/refmac5 || die
	dodoc refmac_keywords.pdf bugs_and_features.pdf || die
}
