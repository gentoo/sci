# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [ ${PV} == "9999" ] ; then
	_SCM=mercurial
	EHG_REPO_URI="http://bitbucket.org/gentryx/libgeodecomp"
	SRC_URI=""
	KEYWORDS=""
	CMAKE_USE_DIR="${S}"
else
	SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
	S="${WORKDIR}/${P}"
fi

inherit cmake-utils cuda ${_SCM}

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="http://www.libgeodecomp.org"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="cuda doc hpx mpi opencl opencv qt4 scotch threads visit"

RDEPEND="
	>=dev-libs/boost-1.48
	=dev-libs/libflatarray-9999
	cuda? ( dev-util/nvidia-cuda-toolkit )
	hpx? ( =sys-cluster/hpx-9999 )
	mpi? ( virtual/mpi )
	opencl? ( virtual/opencl )
	opencv? ( media-libs/opencv )
	qt4? ( dev-qt/qtgui:4 )
	scotch? ( sci-libs/scotch )
	visit? ( sci-visualization/visit )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	rm -rf {lib,src}/libflatarray || die
}

src_configure() {
	local mycmakeargs=(
		-DWITH_BOOST_SERIALIZATION=true
		$(cmake-utils_use_with cuda CUDA)
		$(cmake-utils_use_with hpx HPX)
		$(cmake-utils_use_with mpi BOOST_MPI)
		$(cmake-utils_use_with mpi MPI)
		$(cmake-utils_use_with opencl OPENCL)
		$(cmake-utils_use_with opencv OPENCV)
		$(cmake-utils_use_with qt4 QT)
		$(cmake-utils_use_with scotch SCOTCH)
		$(cmake-utils_use_with threads THREADS)
		$(cmake-utils_use_with visit VISIT)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doc
}

src_install() {
	DOCS=( README )
	use doc && HTML_DOCS=( doc/html/* )
	cmake-utils_src_install
}

src_test() {
	cmake-utils_src_make test
}
