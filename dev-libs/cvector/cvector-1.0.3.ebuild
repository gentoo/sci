# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base toolchain-funcs

MY_PN=CVector
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An ANSI C implementation of dynamic arrays to provide a crude approximation to the C++ vector class"
HOMEPAGE="http://cvector.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${MY_P}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PV}-LDFLAGS.patch
	)

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		all || die "compilation failed"
}

src_test() {
	emake tests || die "test failed"
}

src_install() {
	dobin bin/* || die "no bins"
	dolib.a lib/.libs/*.a || die "failed with lib installation"

	insinto /usr/include
	doins *.h || die "failed with includes"

	dodoc README_CVector.txt
}
