# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

DISTUTILS_OPTIONAL=1

inherit distutils-r1 cmake-utils git-r3 python-r1

DESCRIPTION="An open source machine learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

EGIT_REPO_URI="https://github.com/${PN}/${PN}"
EGIT_BRANCH="v${PV}"
EGIT_SUBMODULES=(
	'*'
	'-third_party/protobuf'
	'-third_party/ios-cmake'
	'-third_party/gflags'
	'-third_party/glog'
)

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="asan atlas cuda doc eigen +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkl +mkldnn mpi namedtensor +nnpack numa +numpy +observers openblas opencl opencv +openmp +python +qnnpack redis rocm static tbb test tools zeromq"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	numpy? ( python )
	atlas? ( !eigen !mkl !openblas )
	eigen? ( !atlas !mkl !openblas )
	mkl? ( !atlas !eigen !openblas )
	openblas? ( !atlas !eigen !mkl )
	rocm? ( !mkldnn !cuda )
"

DEPEND="
	dev-libs/protobuf
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/typing[${PYTHON_USEDEP}]
	sys-devel/clang:*
	atlas? ( sci-libs/atlas )
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	doc? ( dev-python/pytorch-sphinx-theme[${PYTHON_USEDEP}] )
	ffmpeg? ( virtual/ffmpeg )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mkl? ( sci-libs/mkl )
	mpi? ( virtual/mpi )
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	openblas? ( sci-libs/openblas )
	opencl? ( dev-libs/clhpp virtual/opencl )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS} )
	redis? ( dev-db/redis )
	rocm? (
		dev-util/amd-rocm-meta
		dev-util/rocm-cmake
		dev-libs/rccl
		sci-libs/miopen
		dev-libs/roct-thunk-interface
	)
	zeromq? ( net-libs/zeromq )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/0001-Use-FHS-compliant-paths-from-GNUInstallDirs-module-1.4.0.patch"
	"${FILESDIR}/0002-Don-t-build-libtorch-again-for-PyTorch-1.4.0.patch"
	"${FILESDIR}/0003-Change-path-to-caffe2-build-dir-made-by-libtorch.patch"
	"${FILESDIR}/0004-Don-t-fill-rpath-of-Caffe2-library-for-system-wide-i.patch"
	"${FILESDIR}/0005-Change-library-directory-according-to-CMake-build.patch"
	"${FILESDIR}/0006-Change-torch_path-part-for-cpp-extensions.patch"
	"${FILESDIR}/0007-Add-necessary-include-directory-for-ATen-CPU-tests.patch"
	"${FILESDIR}/0008-Fix-include-directory-variable-of-rocThrust-1.4.0.patch"
	"${FILESDIR}/0009-Prefer-lib64-for-some-ROCm-packages-1.4.0.patch"
	"${FILESDIR}/0010-Remove-conversion-ambiguity-in-ternary-operators.patch"
	"${FILESDIR}/0011-Prevent-finding-pybind11-system-wide-installation.patch"
	"${FILESDIR}/0012-Special-path-for-roctracer.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	if use rocm; then
		${EPYTHON} "${S}/tools/amd_build/build_amd.py"
	fi
}

src_configure() {
	local blas="Eigen"

	if use atlas; then
		blas="ATLAS"
	elif use mkl; then
		blas="MKL"
	elif use openblas; then
		blas="OpenBLAS"
	fi

	if use rocm; then
		export HCC_PATH="${HCC_HOME}"
		export ROCBLAS_PATH="/usr"
		export ROCFFT_PATH="/usr"
		export HIPSPARSE_PATH="/usr"
		export HIPRAND_PATH="/usr"
		export ROCRAND_PATH="/usr"
		export MIOPEN_PATH="/usr"
		export RCCL_PATH="/usr"
		export ROCPRIM_PATH="/usr"
		export HIPCUB_PATH="/usr"
		export ROCTHRUST_PATH="/usr"
		export ROCTRACER_PATH="/usr"
	fi

	local mycmakeargs=(
		-DTORCH_BUILD_VERSION=${PV}
		-DTORCH_INSTALL_LIB_DIR=lib64
		-DBUILD_BINARY=$(usex tools ON OFF)
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_DOCS=$(usex doc ON OFF)
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_ASAN=$(usex asan ON OFF)
		-DUSE_CUDA=$(usex cuda ON OFF)
		-DUSE_ROCM=$(usex rocm ON OFF)
		-DUSE_FBGEMM=$(usex fbgemm ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DUSE_GFLAGS=$(usex gflags ON OFF)
		-DUSE_GLOG=$(usex glog ON OFF)
		-DUSE_LEVELDB=$(usex leveldb ON OFF)
		-DUSE_LITE_PROTO=OFF
		-DUSE_LMDB=$(usex lmdb ON OFF)
		-DCAFFE2_USE_MKL=$(usex mkl ON OFF)
		-DUSE_MKLDNN=$(usex mkldnn ON OFF)
		-DUSE_MKLDNN_CBLAS=OFF
		-DUSE_NCCL=OFF
		-DUSE_NNPACK=$(usex nnpack ON OFF)
		-DUSE_NUMPY=$(usex numpy ON OFF)
		-DUSE_NUMA=$(usex numa ON OFF)
		-DUSE_OBSERVERS=$(usex observers ON OFF)
		-DUSE_OPENCL=$(usex opencl ON OFF)
		-DUSE_OPENCV=$(usex opencv ON OFF)
		-DUSE_OPENMP=$(usex openmp ON OFF)
		-DUSE_TBB=OFF
		-DUSE_PROF=OFF
		-DUSE_QNNPACK=$(usex qnnpack ON OFF)
		-DUSE_REDIS=$(usex redis ON OFF)
		-DUSE_ROCKSDB=OFF
		-DUSE_ZMQ=$(usex zeromq ON OFF)
		-DUSE_MPI=$(usex mpi ON OFF)
		-DUSE_GLOO=$(usex gloo ON OFF)
		-DBUILD_NAMEDTENSOR=$(usex namedtensor ON OFF)
		-DBLAS=${blas}
		-DBUILDING_SYSTEM_WIDE=ON # to remove insecure DT_RUNPATH header
	)

	local CC="clang"
	local CXX="clang++"

	cmake-utils_src_configure

	if use python; then
		distutils-r1_src_configure
	fi
}

src_install() {
	cmake-utils_src_install

	local multilib_failing_files=(
		libtorch.so
		libtbb.so
		libcaffe2_observers.so
		libc10.so
		libc10d.a
		libgloo.a
		libshm.so
		libsleef.a
		libcaffe2_detectron_ops.so
		libtorch_python.so
	)

	for file in ${multilib_failing_files[@]}; do
		mv -f "${D}/usr/lib/$file" "${D}/usr/lib64"
	done

	rm -rfv "${D}/torch"
	rm -rfv "${D}/var"
	rm -rfv "${D}/usr/lib"

	rm -fv "${D}/usr/include/*.{h,hpp}"
	rm -rfv "${D}/usr/include/asmjit"
	rm -rfv "${D}/usr/include/c10d"
	rm -rfv "${D}/usr/include/fbgemm"
	rm -rfv "${D}/usr/include/fp16"
	rm -rfv "${D}/usr/include/gloo"
	rm -rfv "${D}/usr/include/include"
	rm -rfv "${D}/usr/include/var"

	if use rocm; then
		rm -rfv "${D}/usr/include/hip"
	fi

	cp -rv "${WORKDIR}/${P}/third_party/pybind11/include/pybind11" "${D}/usr/include/"

	rm -fv "${D}/usr/lib64/libtbb.so"
	rm -rfv "${D}/usr/lib64/cmake"

	rm -rfv "${D}/usr/share/doc/mkldnn"

	if use python; then
		install_shm_manager() {
			TORCH_BIN_DIR="${D}/usr/lib64/${EPYTHON}/site-packages/torch/bin"

			mkdir -pv ${TORCH_BIN_DIR}
			cp -v "${D}/usr/bin/torch_shm_manager" "${TORCH_BIN_DIR}"
		}

		python_foreach_impl install_shm_manager

		remove_tests() {
			find "${D}" -name "*test*" -exec rm -rfv {} \;
		}

		scanelf -r --fix "${BUILD_DIR}/caffe2/python"
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		if use test; then
			python_foreach_impl remove_tests
		fi

		python_foreach_impl python_optimize
	fi

	find "${D}/usr/lib64" -name "*.a" -exec rm -fv {} \;

	if use test; then
		rm -rfv "${D}/usr/test"
		rm -fv "${D}/usr/bin/test_api"
		rm -fv "${D}/usr/bin/test_jit"
	fi
}
