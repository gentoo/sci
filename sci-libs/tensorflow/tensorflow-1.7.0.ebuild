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

# TensorFlow 1.7 may be the last time we support Cuda versions below 8.0.
# Starting with TensorFlow 1.8 release, 8.0 will be the minimum supported
# version.
# TensorFlow 1.7 may be the last time we support cuDNN versions below 6.0.
# Starting with TensorFlow 1.8 release, 6.0 will be the minimum supported
# version.
DEPEND="dev-util/bazel
	dev-python/wheel
	dev-python/numpy
	dev-libs/protobuf-c
	cuda? ( >=dev-util/nvidia-cuda-toolkit-7.0[profiler] >=dev-libs/cudnn-3 )
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

# TODO: seems it also supports some MPI implementation

src_configure(){
	# there is no setup.py but there is configure
	# https://www.tensorflow.org/install/install_sources
	# https://www.tensorflow.org/install/install_linux#InstallingNativePip
	#
	# usage: configure.py [-h] [--workspace WORKSPACE]
	./configure || die
}
