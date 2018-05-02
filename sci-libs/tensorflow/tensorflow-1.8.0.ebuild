# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5,6} )

inherit python-r1 distutils-r1 eutils versionator

DESCRIPTION="Library for numerical computation using data flow graphs"
HOMEPAGE="https://www.tensorflow.org
	https://github.com/tensorflow/tensorflow"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~gienah/snapshots/${P}-bazel-cache-repos.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda cxx mpi"

# To create the cache repo tar file, temporarilly remove the
# ${P}-bazel-cache-repos.tar.xz from SRC_URI and src_upack.  Then build
# it so that bazel will download the files:
# FEATURES="noclean -network-sandbox" emerge -av sci-libs/tensorflow
# cd /var/tmp/portage/sci-libs/${P}
# tar --owner=portage --group=portage -cJvf \
# /usr/portage/distfiles/${P}-bazel-cache-repos.tar.xz \
# homedir/.cache/bazel/_bazel_portage/cache/repos/v1

# TensorFlow 1.7 may be the last time we support Cuda versions below 8.0.
# Starting with TensorFlow 1.8 release, 8.0 will be the minimum supported
# version.
# TensorFlow 1.7 may be the last time we support cuDNN versions below 6.0.
# Starting with TensorFlow 1.8 release, 6.0 will be the minimum supported
# version.
# Possibly missing deps:
# 	dev-python/gast
DEPEND="
	cxx? ( dev-libs/protobuf )
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/astor[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-libs/jemalloc
	dev-libs/protobuf-c
	dev-util/bazel
	media-libs/giflib
	virtual/jpeg:0
	cuda? ( >=dev-util/nvidia-cuda-toolkit-8.0[profiler] >=dev-libs/cudnn-6 )
	mpi? ( virtual/mpi )"
	#opencl? ( virtual/opencl )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${P}.tar.gz
	pushd .. || die
	unpack distdir/${P}-bazel-cache-repos.tar.xz
	popd || die
}

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
	# F: fopen_wr
	# S: deny
	# P: /proc/self/setgroups
	# A: /proc/self/setgroups
	# R: /proc/7712/setgroups
	# C: unable to read /proc/1/cmdline
	addpredict /proc

	local opt=$(usex cuda "--config=cuda" "")
	local fs=""
	for i in ${CXXFLAGS}; do
		[[ -n "${fs}" ]] && fs+=" "
		fs+="--cxxopt=${i}"
	done
	for i in ${CPPFLAGS}; do
		[[ -n "${fs}" ]] && fs+=" "
		fs+="--copt=${i}"
		fs+="--cxxopt=${i}"
	done
	for i in ${LDFLAGS}; do
		[[ -n "${fs}" ]] && fs+=" "
		fs+="--linkopt=${i}"
	done
	einfo ">>> Compiling ${PN} C"$(usex cxx " and C++" "")
	einfo "	bazel build \\"
	einfo "	  --config=opt ${opt} \\"
	einfo "	  ${fs} \\"
	einfo "	  //tensorflow:libtensorflow.so \\"
	einfo "   //tensorflow:libtensorflow_framework.so \\"
	einfo "	  "$(usex cxx "//tensorflow:libtensorflow_cc.so" "")
	bazel build \
		  --config=opt ${opt} \
		  ${fs} \
		  //tensorflow:libtensorflow.so \
		  //tensorflow:libtensorflow_framework.so \
		  $(usex cxx "//tensorflow:libtensorflow_cc.so" "") || die

	python_compile() {
		einfo ">>> Compiling ${PN} ${MULTIBUILD_VARIANT}"
		einfo "	bazel build \\"
		einfo "	  --config=opt ${opt} \\"
		einfo "	  ${fs} \\"
		einfo "   //tensorflow/tools/pip_package:build_pip_package"
		bazel build \
			  --config=opt ${opt} \
			  ${fs} \
			  //tensorflow/tools/pip_package:build_pip_package || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg || die
		unzip -o -d ${PN}_pkg_${MULTIBUILD_VARIANT} ${PN}_pkg/${P}-*.whl || die
		rm -f ${PN}_pkg_${MULTIBUILD_VARIANT}/lib${PN}_framework.so || die
	}
	python_foreach_impl python_compile
	bazel shutdown || die
}

src_test() {
	python_foreach_impl python_test
}

src_install() {
	local SO1=$(get_major_version)
	local SOVER=$(version_format_string '$1.$2')
	local tl="${PN} ${PN}_framework"
	dodir /usr/include/${PN}/${PN}/c
	insinto /usr/include/${PN}/${PN}/c
	doins ${PN}/c/c_api.h
	if use cxx; then
		for i in $(find ${PN}/cc ${PN}/core third_party/eigen3 -type f \
						\( -name \*.h -o \
						-wholename third_party/eigen3/Eigen/\* \) -print); do
			dodir $(dirname /usr/include/${PN}/${i})
			insinto $(dirname /usr/include/${PN}/${i})
			doins ${i}
		done
		tl+=" ${PN}_cc"
	fi
	for i in ${tl}; do
		dolib.so bazel-bin/${PN}/lib${i}.so
		dosym "lib${i}.so" \
			  "/usr/$(get_libdir)/lib${i}.so.${SO1}" \
			|| die "Could not create /usr/$(get_libdir)/lib${i}.so.${SO1} symlink"
		dosym "lib${i}.so" \
			  "/usr/$(get_libdir)/lib${i}.so.${SOVER}" \
			|| die "Could not create /usr/$(get_libdir)/lib${i}.so.${SOVER} symlink"
	done
	python_install() {
		python_domodule ${PN}_pkg_${MULTIBUILD_VARIANT}/${P}.data/purelib/${PN}
		dosym "../../../lib${PN}_framework.so" \
			  "$(python_get_sitedir)/${PN}/lib${PN}_framework.so" \
			|| die "Could not create $(python_get_sitedir)/lib${PN}_framework.so symlink for python module"
	}
	python_foreach_impl python_install
	einstalldocs
}
