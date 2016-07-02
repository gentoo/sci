# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="The PacBio long read aligner"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
#SRC_URI="https://github.com/PacificBiosciences/blasr/tarball/${PV} -> ${P}.tar.gz"
SRC_URI=""
EGIT_REPO_URI="https://github.com/PacificBiosciences/blasr.git"

LICENSE="blasr"
SLOT="0"
IUSE="hdf5"
KEYWORDS=""

DEPEND="hdf5? ( >=sci-libs/hdf5-1.8.12[cxx] )" # needs H5Cpp.h
RDEPEND=""

S="${WORKDIR}/blasr-9999"

src_configure(){
	if use hdf5; then \
		python ./configure.py --shared --sub --no-pbbam HDF5_INCLUDE="${EPREFIX}"/usr/include HDF5_LIB="${EPREFIX}"/usr/lib64 || die
	else
		python ./configure.py --shared --sub --no-pbbam || die
	fi
}

src_install() {
	dodir /usr/bin
	emake install ASSEMBLY_HOME="${ED}/usr"
}
