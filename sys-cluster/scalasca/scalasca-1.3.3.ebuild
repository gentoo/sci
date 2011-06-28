# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils fortran-2 toolchain-funcs

DESCRIPTION="Scalable Performance Analysis of Large-Scale Applications"
HOMEPAGE="http://www.scalasca.org"
SRC_URI="http://www2.fz-juelich.de/zam/datapool/scalasca/${P}.tar.gz"

LICENSE="scalasca"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples fortran mpi openmp qt4"

DEPEND="mpi? ( virtual/mpi )
	qt4? ( x11-libs/qt-core:4
		x11-libs/qt-gui:4 )"

RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "s:\(^PLATCC[[:space:]]*=\).*:\1 $(tc-getCC):" \
		-e "s:\(^PFLAG[[:space:]]*=\).*:\1:" \
		-e "s:\(^AFLAG[[:space:]]*=\).*:\1:" \
		-e "s:\(^OPTFLAGS[[:space:]]*=\).*:\1:" \
		-e "s:\(^CC[[:space:]]*=\).*:\1 $(tc-getCC):" \
		-e "s:\(^CFLAGS[[:space:]]*=\).*:\1 ${CFLAGS}:" \
		-e "s:\(^CXX[[:space:]]*=\).*:\1 $(tc-getCXX):" \
		-e "s:\(^CXXFLAGS[[:space:]]*=\).*:\1 ${CXXFLAGS}:" \
		-e "s:\(^F77[[:space:]]*=\).*:\1 $(tc-getFC):" \
		-e "s:\(^F90[[:space:]]*=\).*:\1 $(tc-getFC):" \
		-e "s:\(^FFLAGS[[:space:]]*=\).*:\1 ${FCFLAGS}:" \
		-e "s:\(^LDFLAGS[[:space:]]*=\).*:\1 ${LDFLAGS}:" \
		-e "s:\(^ECXX[[:space:]]*=\).*:\1 $(tc-getCXX):" \
		-e "s:\(^ECXX_AR[[:space:]]*=\).*:\1 $(tc-getAR):" \
		-e "s:\(^SZLIB_OPTFLAGS[[:space:]]*=\).*:\1:" \
		-i mf/Makefile.defs.* \
		|| die "sed of flags failed"

	sed -e "s:DOCDIR =.*:DOCDIR = \${PREFIX}/share/doc/${PF}:" \
	    -i mf/common.defs \
		|| die "sed DOCDIR failed"
}

src_configure() {
	local myconf

	#configure is not a real (autotools) configure

	#only --disable-XXX is supported by configure
	use openmp || myconf="${myconf} --disable-omp"
	use fortran || myconf="${myconf} --disable-fortran"
	use mpi || myconf="${myconf} --disable-mpi"
	use qt4 || myconf="${myconf} --disable-gui"

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
