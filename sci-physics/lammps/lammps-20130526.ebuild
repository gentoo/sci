# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_NEEDED="package-meam"

inherit eutils fortran-2

LAMMPSDATE="26May13"

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="http://lammps.sandia.gov/"
SRC_URI="http://lammps.sandia.gov/tars/lammps-${LAMMPSDATE}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gzip lammps-memalign mpi package-dipole package-meam package-rigid"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${LAMMPSDATE}"

lmp_emake() {
	local LAMMPS_INCLUDEFLAGS=
	use gzip && LAMMPS_INCLUDEFLAGS+=" -DLAMMPS_GZIP"
	use lammps-memalign && LAMMPS_INCLUDEFLAGS+=" -DLAMMPS_MEMALIGN"

	# Note: The lammps makefile uses CC to indicate the C++ compiler.
	emake \
		ARCHIVE=$(tc-getAR) \
		CC=$(use mpi && echo mpic++ || echo $(tc-getCXX)) \
		F90=$(use mpi && echo mpif90 || echo $(tc-getFC)) \
		LINK=$(use mpi && echo mpic++ || echo $(tc-getCXX)) \
		CCFLAGS="${CXXFLAGS}" \
		F90FLAGS="${FCFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		LMP_INC="${LAMMPS_INCLUDEFLAGS}" \
		MPI_INC=$(use mpi || echo -I../STUBS) \
		MPI_PATH=$(use mpi || echo -L../STUBS) \
		MPI_LIB=$(use mpi || echo -lmpi_stubs) \
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
