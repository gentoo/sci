# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit cmake-utils git-2 python-single-r1

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
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtopengl
	dev-qt/qttest
	dev-qt/qtwebkit
	cuda? ( dev-util/nvidia-cuda-toolkit )
	mpi? ( virtual/mpi )
	sql? ( dev-qt/qtsql )
	python? ( ${PYTHON_DEPS} )
	webkit? ( dev-qt/qtwebkit )"
DEPEND="${RDEPEND}
	dev-python/sip
	sys-devel/bison
	virtual/yacc"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-libsvm.patch
	)

pkg_setup() {
	use python && python-single-r1_pkg_setup
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
