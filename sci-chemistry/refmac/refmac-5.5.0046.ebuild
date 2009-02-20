# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fortran toolchain-funcs

DESCRIPTION="Macromolecular crystallographic refinement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~garib/refmac/"
SRC_URI="${HOMEPAGE}data/refmac_stable/refmac_${PV}.tar.gz"
LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
RDEPEND="virtual/lapack
	virtual/blas
	sci-libs/ccp4-libs"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gcc-4.3.patch
	epatch "${FILESDIR}"/${PV}-allow-dynamic-linking.patch
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

src_install() {
	for i in refmac libcheck makecif; do
		dobin ${i} || die
	done
	dosym refmac /usr/bin/refmac5 || die
	dodoc refmac_keywords.pdf || die
}
