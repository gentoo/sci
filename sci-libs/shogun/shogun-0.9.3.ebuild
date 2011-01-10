# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Large Scale Machine Learning Toolbox"
HOMEPAGE="http://www.shogun-toolbox.org/"
SRC_URI="http://shogun-toolbox.org/archives/shogun/releases/${PV:0:3}/sources/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="boost bz2 cplex doc glpk gzip hdf5 lapack lpsolve lzma lzo octave python R readline threads"

RDEPEND="virtual/lapack
	bzip2? ( app-arch/bzip2 )
	cplex? ( sci-mathematics/cplex-bin )
	glpk? ( sci-mathematics/glpk )
	gzip? ( app-arch/gzip )
	hdf5? ( sci-libs/hdf5 )
	glpk? ( sci-mathematics/lpsolve )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	octave? ( sci-mathematics/octave )
	python? ( dev-python/numpy )
	R? ( dev-lang/R )
	readline? ( sys-libs/readline )"

DEPEND="${RDEPEND}
	dev-libs/boost
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${P}/src"

src_configure() {
	# not an autotools configure (based on mplayer one)
	# disable svmlight based on debian comment
	./configure \
		--cc=$(tc-getCC) \
		--cxx=$(tc-getCXX) \
		--prefix=/usr \
		--datadir=/usr/share/${PN} \
		--mandir=/usr/share/man \
		--confdir=/etc \
		--libdir=/usr/$(get_libdir) \
		--disable-cpudetection \
		--disable-svm-light \
		$(use_enable doc doxygen) \
		$(use_enable boost boost-serialization) \
		$(use_enable glpk) \
		$(use_enable hdf5) \
		$(use_enable lapack) \
		$(use_enable readline) \
		$(use_enable threads hmm-parallel)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
