# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs

MYPN="lp_solve"
DESCRIPTION="Library for solving (mixed integer) linear programming problems"
HOMEPAGE="http://lpsolve.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MYPN}_${PV}_source.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples static-libs"
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MYPN}_${PV}"

PLIB=lpsolve55

src_prepare() {
	LPSOLVE_ARCH=ux32
	LPSOLVE_ARCH=ux64
	sed -i \
		"s|^c=.*$$|c=$(tc-getCC)|g" \
		's|^opts=.*$$|opts="${CFLAGS}"|g' \
		"s|-fpic|-fPIC|g" \
		"s|-ldl||g" \
		lp_solve/ccc ${PLIB}/ccc || die "sed failed"
}

src_compile() {
	for d in lp_solve ${PLIB}; do
		pushd $d &> /dev/null
		bash -x ccc
		popd &> /dev/null
	done
}

src_install() {
	dobin lp_solve/bin/${LPSOLVE_ARCH}/lp_solve || die
	insinto /usr/include/lpsolve
	doins declare.h fortify.h ini.h lp_*.h lpkit.h lpsolve.h ufortify.h yacc_read.h
	dolib.so lib${PLIB}.so
	if use static-libs; then
		dolib.a lib${PLIB}.a || die
	fi
	dosym lib${PLIB}.so /usr/$(get_libdir)/lib${PLIB}.so.1
}
