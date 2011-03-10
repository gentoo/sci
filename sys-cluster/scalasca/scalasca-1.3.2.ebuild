# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Scalable Performance Analysis of Large-Scale Applications"
HOMEPAGE="http://www.fz-juelich.de/jsc/scalasca/"
SRC_URI="http://www2.fz-juelich.de/zam/datapool/scalasca/${P}.tar.gz"

LICENSE="scalasca"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples fortran mpi openmp"

DEPEND="mpi? ( virtual/mpi )
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s:CFLAGS   =.*:CFLAGS   = ${CFLAGS}:" \
	    -e "s:CXXFLAGS =.*:CXXFLAGS = ${CXXFLAGS}:" \
	    -e "s:SZLIB_OPTFLAGS =.*:SZLIB_OPTFLAGS =:" \
		-i mf/Makefile.defs.linux-gomp mf/Makefile.defs.linux-gnu \
		|| die "sed CFLAGS,CXXFLAGS failed"

	sed -e "s:DOCDIR =.*:DOCDIR = \${PREFIX}/share/doc/${PF}:" \
	    -i mf/common.defs \
		|| die "sed DOCDIR failed"
}

src_configure() {
	local myconf

	#configure is not a real (autotools) configure

	#only --disable-(omp/mpi) is supported by configure
	use openmp || myconf="${myconf} --disable-omp"
	use mpi || myconf="${myconf} --disable-mpi"

	./configure --prefix="${EPREFIX}"/usr ${myconf} || die "configure failed"
}

src_compile() {
	#multi job build is broken
	emake -j1 || die "emake failed"
}

src_install() {
	#no DESTDIR support
	emake install PREFIX="${ED}"/usr || die "Installing failed"

	#examples are always installed in /usr
	cd "${ED}"/usr
	if use examples; then
		insinto "/usr/share/${PN}"
		doins -r example
	fi
	rm -rf example
}
