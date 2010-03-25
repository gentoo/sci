# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fortran

DESCRIPTION="Scalable Performance Analysis of Large-Scale Applications"
HOMEPAGE="http://www.fz-juelich.de/jsc/scalasca/"
SRC_URI="http://www.fz-juelich.de/jsc/datapool/scalasca/${P}.tar.gz"

LICENSE="scalasca"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples fortran mpi openmp"

DEPEND="mpi? ( virtual/mpi )
	x11-libs/qt-core:4
	x11-libs/qt-gui:4"

RDEPEND="${DEPEND}"

FORTRAN="g77 gfortran ifc"

pkg_setup() {
	use fortran && fortran_pkg_setup
}

src_prepare() {
	sed -e "s:CFLAGS   =.*:CFLAGS   = ${CFLAGS}:" \
	    -e "s:CXXFLAGS =.*:CXXFLAGS = ${CXXFLAGS}:" \
		-i mf/Makefile.defs.linux-gomp mf/Makefile.defs.linux-gnu \
		|| die "sed CFLAGS,CXXFLAGS failed"

	sed -e "s:DOCDIR =.*:DOCDIR = \${PREFIX}/share/doc/${PF}:" \
	    -i mf/common.defs \
		|| die "sed DOCDIR failed"
}

src_configure() {
	local myconf

	use openmp || myconf="${myconf} --disable-omp"
	use mpi || myconf="${myconf} --disable-mpi"

	./configure --prefix=/usr ${myconf} --compiler=gnu || die "configure failed"
}

src_compile() {
	#multi job build is broken
	emake -j1 || die "emake failed"
}

src_install() {
	#no DESTDIR support
	emake install PREFIX="${D}"/usr || die "Installing failed"

	#examples are always installed in /usr
	cd "${D}"/usr
	if use examples; then
		insinto "/usr/share/${PN}"
		doins -r example
	fi
	rm -rf example
}
