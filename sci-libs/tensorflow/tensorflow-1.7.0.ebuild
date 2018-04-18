# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5,6} )

inherit python-r1 distutils-r1 eutils

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
DEPEND="
	dev-util/bazel
	dev-python/wheel
	dev-python/numpy
	dev-libs/protobuf-c
	dev-python/absl-py
	cuda? ( >=dev-util/nvidia-cuda-toolkit-7.0[profiler] >=dev-libs/cudnn-3 )
	mpi? ( virtual/mpi )"
	#opencl? ( virtual/opencl )"
RDEPEND="${DEPEND}"

# TODO: seems it also supports some MPI implementations
src_configure(){
	# there is no setup.py but there is configure
	# https://www.tensorflow.org/install/install_sources
	# https://www.tensorflow.org/install/install_linux#InstallingNativePip
	#
	# usage: configure.py [-h] [--workspace WORKSPACE]
	python_configure() {
		export PYTHON_BIN_PATH=${PYTHON}
		export PYTHON_LIB_PATH=${PYTHON_SITEDIR}
		export TF_NEED_JEMALLOC=1
		export TF_NEED_GCP=0
		export TF_NEED_HDFS=0
		export TF_NEED_S3=0
		export TF_NEED_KAFKA=0
		export TF_ENABLE_XLA=0
		export TF_NEED_GDR=0
		export TF_NEED_VERBS=0
		export TF_NEED_OPENCL=0
		if use cuda; then
			export TF_NEED_CUDA=1
		else
			export TF_NEED_CUDA=0
		fi
		if use mpi; then
			export TF_NEED_MPI=1
		else
			export TF_NEED_MPI=0
		fi
		export TF_NEED_OPENCL_SYCL=0
		export CC_OPT_FLAGS=${CFLAGS}
		export JAVA_HOME=$(java-config -O)
		# TODO: protect by a USE flag test --config=mkl
		./configure || die
	}
	python_foreach_impl python_configure
}

src_compile() {
	python_compile() {
		# huh, by default tensorflow links static libs? See BUILD file
		# set framework_shared_object=true somehow
		if use cuda; then
			local opt="--config=cuda"
		else
			local opt=""
		fi
		bazel build --config=opt ${opt} /tensorflow/tools/pip_package:build_pip_package || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg || die
		unzip -o -d tensorflow_pkg tensorflow_pkg/${P}-cp35-cp35m-linux_x86_64.whl || die
		python_domodule tensorflow_pkg/${P}.data/purelib/tensorflow
		bazel test || die
		bazel shutdown || die
	}
	python_foreach_impl python_compile
}

src_test() {
	python_foreach_impl python_test
}

src_install() {
	python_install() {
		# steal site-package path determination from sci-mathematics/z3
		local PYTHON_SITEDIR
		python_export PYTHON_SITEDIR
		cp -av tensorflow_pkg/"${P}".data/purelib/tensorflow/ "$PYTHON_SITEDIR" || die
		cp -av tensorflow_pkg/"${P}".dist-info "$PYTHON_SITEDIR" || die
		# mkdir -p "${D}/usr/$(get_libdir)/python3.6/site-packages" || die
		# cp -av tensorflow_pkg/"${P}".data/purelib/tensorflow/ "${ED}/usr/$(get_libdir)/python3.6/site-packages/" || die
		# cp -av tensorflow_pkg/"${P}".dist-info "${ED}/usr/$(get_libdir)/python3.6/site-packages/" || die
	}
	python_foreach_impl python_install
	einstalldocs
}
