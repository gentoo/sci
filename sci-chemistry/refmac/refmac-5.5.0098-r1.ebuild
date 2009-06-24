# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran base toolchain-funcs versionator

DESCRIPTION="Macromolecular crystallographic refinement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~garib/refmac/"
SRC_URI="${HOMEPAGE}data/refmac_stable/refmac_${PV}.tar.gz
	test? ( http://dev.gentooexperimental.org/~jlec/distfiles/test-framework.tar.gz )"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="virtual/lapack
	virtual/blas
	sci-libs/ccp4-libs"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/$(get_version_component_range 1-2 ${PV})-allow-dynamic-linking.patch
	)

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
	export PATH="${S}:${PATH}"
	export CCP4_TEST="${WORKDIR}"/test-framework
	cd ${CCP4_TEST}
	sed 's:refmac5:refmac:g' -i refmac5/test_refmac5.py
	python refmac5/test_refmac5.py || die "damn"
}

src_install() {
	for i in refmac libcheck makecif; do
		dobin ${i} || die
	done
	dosym refmac /usr/bin/refmac5 || die
	dodoc refmac_keywords.pdf bugs_and_features.pdf || die
}
