# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

LAMMPSDATE="12May13"

DESCRIPTION="Large-scale Atomic/Molecular Massively Parallel Simulator"
HOMEPAGE="http://lammps.sandia.gov/"
SRC_URI="http://lammps.sandia.gov/tars/lammps-${LAMMPSDATE}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lammps-gzip lammps-memalign package-meam package-dipole package-rigid"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${LAMMPSDATE}"

LAMMPS_INCLUDEFLAGS=""

src_prepare() {
	epatch "${FILESDIR}/Makefile.gentoo-serial.patch"

	use lammps-gzip && LAMMPS_INCLUDEFLAGS+=" -DLAMMPS_GZIP"
	use lammps-memalign && LAMMPS_INCLUDEFLAGS+=" -DLAMMPS_MEMALIGN"

	# Patch up the patch.
	sed -i \
		-e "s/ARCHIVE\s*=.*$/ARCHIVE = $(tc-getAR)/" \
		-e "s/CC\s*=.*$/CC = $(tc-getCXX)/" \
		-e "s/CCFLAGS\s*=.*$/CCFLAGS = ${CXXFLAGS}/" \
		-e "s/LINK\s*=.*$/LINK = $(tc-getCXX)/" \
		-e "s/LINKFLAGS\s*=.*$/LINKFLAGS = ${LDFLAGS}/" \
		-e "s/LMP_INC\s*=.*$/LMP_INC = ${LAMMPS_INCLUDEFLAGS}/" \
		"${S}/src/MAKE/Makefile.gentoo-serial"

	# Patch up other makefiles.
	use package-meam && sed -i \
		-e "s/ARCHIVE\s*=.*$/ARCHIVE = $(tc-getAR)/" \
		-e "s/F90\s*=.*$/F90 = $(tc-getFC)/" \
		-e "s/F90FLAGS\s*=.*$/F90FLAGS = ${FCFLAGS}/" \
		-e "s/LINK\s*=.*$/LINK = $(tc-getFC)/" \
		-e "s/LINKFLAGS\s*=.*$/LINKFLAGS = ${LDFLAGS}/" \
		"${S}/lib/meam/Makefile.gfortran"
}

src_compile() {
	emake -C src stubs
	use package-meam && {
		emake -C src yes-meam
		emake -j1 -C lib/meam -f Makefile.gfortran
	}
	use package-dipole && emake -C src yes-dipole
	use package-rigid && emake -C src yes-rigid
	emake -C src gentoo-serial
}

src_install() {
	newbin "$S/src/lmp_gentoo-serial" "lmp-serial"
}
