# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools multilib

MY_PV="${PV}"
MY_P="${PN}-${MY_PV/_p/-}"

DESCRIPTION="Portable Understructure for Numerical Computing"
HOMEPAGE="http://fetk.org/codes/punc/index.html"
SRC_URI="http://www.fetk.org/codes/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/blas
	dev-libs/maloc
	sci-libs/arpack
	sci-libs/superlu"

S="${WORKDIR}/${PN}"

src_prepare() {
	eautoreconf

	sed -e 's:punc/vf2c.h:maloc/vf2c.h:g' \
		-i src/cgcode/*.c \
		-i src/pmg/*.c
}

src_configure() {
	export FETK_INCLUDE="/usr/include"
	export FETK_LIBRARY="/usr/$(get_libdir)"

	econf

	sed -e "s|libdir = \${prefix}/lib/\${fetk_cpu_vendor_os}|libdir = \${prefix}/lib/|" \
	-i src/aaa_lib/Makefile || \
	die "failed to patch lib Makefile"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dohtml doc/index.html || die "failed to install html docs"
}

