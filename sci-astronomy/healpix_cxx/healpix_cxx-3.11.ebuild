# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils toolchain-funcs

MYP="Healpix_${PV}"
MYPP="2013Apr24"

DESCRIPTION="Hierarchical Equal Area isoLatitude Pixelization of a sphere - C++"
HOMEPAGE="http://healpix.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}/${MYP}_${MYPP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="openmp static-libs"

RDEPEND="
	>=sci-libs/cfitsio-3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}/src/cxx/autotools"

DOCS=( ../CHANGES ../../../READ_Copyrights_Licenses.txt )

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCXX)$ == *g++* ]] && ! tc-has-openmp; then
			ewarn "You are using a g++ without OpenMP capabilities"
			die "Need an OpenMP capable compiler"
		fi
	fi
}

src_prepare() {
	# respect user flags
	sed -i -e '/^AX_CHECK_COMPILE_FLAG/d' configure.ac || die
	# why was static-libtool-libs forced?
	use static-libs || sed -i -e '/-static-libtool-libs/d' Makefile.am
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable openmp)
	)
	autotools-utils_src_configure
}
