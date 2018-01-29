# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5,6} )

inherit distutils-r1 eutils

DESCRIPTION="Library for numerical computation using data flow graphs"
HOMEPAGE="https://www.tensorflow.org
	https://github.com/tensorflow/tensorflow"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="cuda mpi"

DEPEND="dev-util/bazel
	dev-python/wheel
	dev-python/numpy
	dev-libs/protobuf-c
	cuda? ( x11-drivers/nvidia-drivers dev-util/nvidia-cuda-toolkit )
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

# TODO: seems it also support some MPI implementation
