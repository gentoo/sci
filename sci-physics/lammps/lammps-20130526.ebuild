# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_NEEDED="package-meam"

inherit eutils fortran-2

MY_P="${PN}-$(date -d "${PV}" +"%d%b%y")"

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="http://lammps.sandia.gov/"
SRC_URI="http://lammps.sandia.gov/tars/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples gzip lammps-memalign mpi package-dipole package-meam package-rigid"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

lmp_emake() {
	local LAMMPS_INCLUDEFLAGS="$(usex gzip '-DLAMMPS_GZIP' '')"
	LAMMPS_INCLUDEFLAGS+="$(usex ' -DLAMMPS_MEMALIGN' '')"

	# Note: The lammps makefile uses CC to indicate the C++ compiler.
	emake \
		ARCHIVE=$(tc-getAR) \
		CC=$(usex mpi "mpic++" "$(tc-getCXX)") \
		F90=$(usex mpi "mpif90" "$(tc-getFC)") \
		LINK=$(usex mpi "mpic++" "$(tc-getCXX)") \
		CCFLAGS="${CXXFLAGS}" \
		F90FLAGS="${FCFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		LMP_INC="${LAMMPS_INCLUDEFLAGS}" \
		MPI_INC=$(usex mpi '' "-I../STUBS") \
		MPI_PATH=$(usex mpi '' '-L../STUBS') \
		MPI_LIB=$(usex mpi '' '-lmpi_stubs') \
 		"$@"
}

src_compile() {
	# Compile stubs for serial version.
	use mpi || lmp_emake -C src stubs

	# Build optional packages.
	if use package-meam; then
		lmp_emake -C src yes-meam
		lmp_emake -j1 -C lib/meam -f Makefile.gfortran
	fi
	use package-dipole && emake -C src yes-dipole
	use package-rigid && emake -C src yes-rigid

	# Compile.
	lmp_emake -C src serial
}

src_install() {
	newbin "src/lmp_serial" "lmp"
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r examples
	fi
	dodoc README
	if use doc; then
		dodoc doc/Manual.pdf
		dohtml -r doc/*
	fi
}
