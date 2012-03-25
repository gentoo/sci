# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="python? 2"

inherit cmake-utils git-2 python

DESCRIPTION="Biochemical Algorithms Library"
HOMEPAGE="http://www.ball-project.org/"
SRC_URI=""
EGIT_REPO_URI="http://ball-git.bioinf.uni-sb.de/BALL.git"

SLOT="0"
LICENSE="LGPL-2 GPL-3"
KEYWORDS=""
IUSE="cuda mpi +python sql +threads +webkit"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost
	media-libs/glew
	sci-libs/fftw:3.0[threads?]
	sci-libs/gsl
	sci-libs/libsvm
	sci-mathematics/lpsolve
	virtual/opengl
	x11-libs/libX11
	x11-libs/qt-core
	x11-libs/qt-gui
	x11-libs/qt-opengl
	x11-libs/qt-test
	x11-libs/qt-webkit
	cuda? ( dev-util/nvidia-cuda-toolkit )
	mpi? ( virtual/mpi )
	sql? ( x11-libs/qt-sql )
	webkit? ( x11-libs/qt-webkit )"
DEPEND="${RDEPEND}
	dev-python/sip
	sys-devel/bison
	virtual/yacc"

src_prepare() {
	sed \
		-e '/INSTALL_DIRECTORY/s:"lib":${CMAKE_INSTALL_LIBDIR}:g' \
		-i CMakeLists.txt || die
	base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use threads FFTW_THREADS)
		$(cmake-utils_use cuda MT_ENABLE_CUDA)
		$(cmake-utils_use mpi MT_ENABLE_MPI)
		$(cmake-utils_use sql BALL_HAS_QTSQL)
		$(cmake-utils_use_use webkit USE_QTWEBKIT)
		$(cmake-utils_use python BALL_PYTHON_SUPPORT)
	)
	cmake-utils_src_configure
}
