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
IUSE="package-meam package-dipole package-rigid"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${LAMMPSDATE}"

src_prepare() {
	epatch "${FILESDIR}/Makefile.gentoo-serial.patch"
}

src_compile() {
	emake -C src ARCHIVE=$(tc-getAR) CC=$(tc-getCXX) CCFLAGS="${CXXFLAGS}" LINKFLAGS="${LDFLAGS}" stubs
	use package-meam && {
		emake -C src ARCHIVE=$(tc-getAR) CC=$(tc-getCXX) CCFLAGS="${CXXFLAGS}" LINKFLAGS="${LDFLAGS}" yes-meam
		emake -C lib/meam -f Makefile.gfortran ARCHIVE=$(tc-getAR) F90=$(tc-getFC) F90FLAGS="${FCFLAGS}" LINKFLAGS="${LDFLAGS}"
	}
	use package-dipole && emake -C src ARCHIVE=$(tc-getAR) CC=$(tc-getCXX) CCFLAGS="${CXXFLAGS}" LINKFLAGS="${LDFLAGS}" yes-dipole
	use package-rigid && emake -C src ARCHIVE=$(tc-getAR) CC=$(tc-getCXX) CCFLAGS="${CXXFLAGS}" LINKFLAGS="${LDFLAGS}" yes-rigid
	emake -C src ARCHIVE=$(tc-getAR) CC=$(tc-getCXX) CCFLAGS="${CXXFLAGS}" LINKFLAGS="${LDFLAGS}" gentoo-serial
}

src_install() {
	newbin "$S/src/lmp_gentoo-serial" "lmp-serial"
}
