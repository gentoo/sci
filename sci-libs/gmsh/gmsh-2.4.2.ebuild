# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

inherit cmake-utils flag-o-matic toolchain-funcs

DESCRIPTION="A three-dimensional finite element mesh generator with built-in pre- and post-processing facilities."
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="blas chaco cgns doc examples jpeg med metis mpi opencascade png zlib X"

RDEPEND="X? ( x11-libs/fltk:1.1 )
		blas? ( virtual/blas virtual/lapack sci-libs/fftw:3.0 )
		cgns? ( sci-libs/cgnslib )
		jpeg? ( media-libs/jpeg )
		med? ( >=sci-libs/med-2.3.4 )
		opencascade? ( sci-libs/opencascade )
		png? ( media-libs/libpng )
		zlib? ( sys-libs/zlib )
		mpi? ( sys-cluster/openmpi[cxx] )"

DEPEND="${RDEPEND}
		dev-util/cmake
		doc? ( virtual/latex-base )"

pkg_setup() {
	ewarn "Put the F77 variable in env files to select your fortran compiler"
	ewarn "example for gfortran:"
	ewarn "echo \"F77=gfortran\" >> /etc/portage/env/sci-libs/gmsh"
}

src_unpack() {
	unpack ${A}
	mv ${P}-source ${P}
}

src_configure() {
	local mycmakeargs=""

	use blas && mycmakeargs="${mycmakeargs}
						-DCMAKE_Fortran_COMPILER=$(tc-getF77)"

	mycmakeargs="${mycmakeargs} $(cmake-utils_use_enable blas BLAS_LAPACK)
								$(cmake-utils_use_enable cgns CGNS)
								$(cmake-utils_use_enable chaco CHACO)
								$(cmake-utils_use_enable X FLTK)
								$(cmake-utils_use_enable X FL_TREE)
								$(cmake-utils_use_enable X GRAPHICS)
								$(cmake-utils_use_enable med MED)
								$(cmake-utils_use_enable metis METIS)
								$(cmake-utils_use_enable opencascade OCC)"

#    I'm not sure if this is needed, but it seems to help in some circumstances
#    see http://bugs.gentoo.org/show_bug.cgi?id=195980#c18
	append-ldflags -ldl -lmpi

	cmake-utils_src_configure ${mycmakeargs} \
		|| die "cmake configuration failed"
}

src_install() {
	cmake-utils_src_install

	cd "${WORKDIR}"/"${PF}"

	if use doc ; then
	    cd ${CMAKE_BUILD_DIR}
		emake pdf || die "failed to build documentation"
	    cd "${WORKDIR}"/"${PF}"
		dodoc doc/*.txt doc/texinfo/gmsh.pdf
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r demos tutorial || die "failed to install examples"
	fi
}
