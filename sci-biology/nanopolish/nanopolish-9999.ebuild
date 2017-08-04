# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Signal-level analysis of Oxford Nanopore sequencing data"
HOMEPAGE="https://github.com/jts/nanopolish"
EGIT_REPO_URI="https://github.com/jts/nanopolish.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# HDF5 is not thread safe by default and nanopolish currently requires a threadsafe HDF5.
# This is one reason we download the compile it ourself (the main reason is to make it
# easier for most users). The other options cxx, fortran, mpi are not needed by nanopolish
# (we use the C bindings in nanopolish only).
# The bundled version of htslib in is 1.2.1 as of now although 1.5.1 already exists
DEPEND=">=sci-libs/hdf5-1.8.14[threads]
	>=dev-cpp/eigen-3.2.5
	sci-libs/htslib:0
	sci-libs/fast5"
RDEPEND="${DEPEND}
	sci-biology/biopython"

src_prepare(){
	default
	rm -rf hdf5* eigen htslib || die # TODO; zap also fast5
}

src_compile(){
	# >=gcc-4.8 but <gcc-7 is needed
	# https://github.com/jts/nanopolish/issues/145
	emake HDF5="noinstall" EIGEN="nofetch" HTS_LIB=-lhts HTS_INCLUDE=-I/usr/include/htslib EIGEN_INCLUDE=-I/usr/include/eigen3 # TODO: FAST5_INCLUDE=-I/usr/include/fast5
}

src_install(){
	rm -rf lib || die # zap libs eventually compiled from the bundled copies
	dobin nanopolish
	# add scripts/ subdirectory to PATH
}

src_test(){
	nanopolish_test || die
}
