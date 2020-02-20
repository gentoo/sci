# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 cmake-utils cuda

MPV=${PV/_p/a}

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/v${MPV}.tar.gz -> ${P}.tar.gz
https://github.com/facebookincubator/gloo/archive/ca528e32.tar.gz -> gloo-ca528e32.tar.gz
https://github.com/google/benchmark/archive/505be96a.tar.gz -> benchmark-505be96a.tar.gz
https://github.com/google/gemmlowp/archive/3fb5c176.tar.gz -> gemmlowp-3fb5c176.tar.gz
https://github.com/google/googletest/archive/2fe3bd99.tar.gz -> googletest-2fe3bd99.tar.gz
https://github.com/houseroad/foxi/archive/8f74bc4d.tar.gz -> foxi-8f74bc4d.tar.gz
https://github.com/intel/ideep/archive/78eafa5d.tar.gz -> ideep-78eafa5d.tar.gz
https://github.com/Maratyszcza/FP16/archive/febbb1c1.tar.gz -> FP16-febbb1c1.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/b742d114.tar.gz -> FXdiv-b742d114.tar.gz
https://github.com/Maratyszcza/NNPACK/archive/c039579a.tar.gz -> NNPACK-c039579a.tar.gz
https://github.com/Maratyszcza/PeachPy/archive/07d8fde8.tar.gz -> PeachPy-07d8fde8.tar.gz
https://github.com/Maratyszcza/psimd/archive/90a938f3.tar.gz -> psimd-90a938f3.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/13da0b4c.tar.gz -> pthreadpool-13da0b4c.tar.gz
cuda? ( https://github.com/NVIDIA/nccl/archive/7c72dee6.tar.gz -> nccl-7c72dee6.tar.gz )
https://github.com/NVlabs/cub/archive/285aeeba.tar.gz -> cub-285aeeba.tar.gz
https://github.com/onnx/onnx/archive/2891e145.tar.gz -> onnx-2891e145.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/cb3d8066.tar.gz -> onnx-tensorrt-cb3d8066.tar.gz
https://github.com/pytorch/cpuinfo/archive/89fe1695.tar.gz -> cpuinfo-89fe1695.tar.gz
https://github.com/pytorch/fbgemm/archive/82d259da.tar.gz -> fbgemm-82d259da.tar.gz
https://github.com/pytorch/QNNPACK/archive/7d2a4e99.tar.gz -> QNNPACK-7d2a4e99.tar.gz
https://github.com/shibatch/sleef/archive/7f523de6.tar.gz -> sleef-7f523de6.tar.gz
https://github.com/asmjit/asmjit/archive/17556b2d.tar.gz -> asmjit-17556b2d.tar.gz
	"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="asan atlas cuda eigen +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkl mkldnn mpi namedtensor +nnpack numa +numpy +observers +openblas opencl opencv +openmp +python +qnnpack redis static tbb test tools zeromq"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	numpy? ( python )
	^^ ( atlas eigen mkl openblas )
"

DEPEND="
	dev-libs/protobuf
	dev-python/pyyaml[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	atlas? ( sci-libs/atlas )
	cuda? ( dev-libs/cudnn
		dev-cpp/eigen[cuda] )
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
	python? ( ${PYTHON_DEPS}
		dev-python/pybind11[${PYTHON_USEDEP}]
	)
	redis? ( dev-db/redis )
	zeromq? ( net-libs/zeromq )
	eigen? ( dev-cpp/eigen )
"
RDEPEND="${DEPEND}"
BDEPEND=""

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-cpp/tbb
	app-arch/zstd
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	sys-fabric/libibverbs
	sys-process/numactl
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-setup.patch
	"${FILESDIR}"/${PN}-1.4.0-sleef.patch
	"${FILESDIR}"/${PN}-1.4.0-skip-tests.patch
	"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.4.0.patch
	"${FILESDIR}"/0003-Change-path-to-caffe2-build-dir-made-by-libtorch.patch
	"${FILESDIR}"/0005-Change-library-directory-according-to-CMake-build.patch
)

src_unpack() {
	default

	mv -v ${PN}-${MPV} ${P} || die
}

src_prepare() {
	cmake-utils_src_prepare

	mv -v third_party/miniz-* ../ || die
	rm -r third_party || die
	ln -s .. third_party || die
	cd .. || die
	for d in *; do
		case ${d} in
			${PN}* | miniz-*) continue ;;
			PeachPy-*) mv -v ${d} python-peachpy || die ;;
			*) mv -v ${d} ${d%-*} || die ;;
		esac
	done

	mv -v FBGEMM fbgemm || die
	cd fbgemm || die
	rm -r third_party || die
	ln -s .. third_party || die

	cd ../onnx || die
	rm -r third_party || die
	ln -s .. third_party || die

	if use cuda; then
		cd ../nccl || die
		eapply "${FILESDIR}"/${PN}-1.4.0-nccl-nvccflags.patch
		ln -s . nccl || die

		cuda_src_prepare
		export CUDAHOSTCXX=$(cuda_gccdir)/g++
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

	local mycmakeargs=(
		-DTORCH_BUILD_VERSION=${PV}
		-DTORCH_INSTALL_LIB_DIR=$(get_libdir)
		-DBUILD_BINARY=$(usex tools ON OFF)
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DBUILD_TEST=$(usex test ON OFF)
		-DUSE_ASAN=$(usex asan ON OFF)
		-DUSE_CUDA=$(usex cuda ON OFF)
		-DUSE_NCCL=$(usex cuda ON OFF)
		-DUSE_SYSTEM_NCCL=OFF
		-DUSE_ROCM=OFF
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
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DBUILD_NAMEDTENSOR=$(usex namedtensor ON OFF)
		-DBLAS=${blas}
	)

	cmake-utils_src_configure

	if use python; then
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use python; then
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_compile
	fi
}

src_install() {
	cmake-utils_src_install

	local LIB=$(get_libdir)
	if [[ ${LIB} != lib ]]; then
		mv -fv "${ED}"/usr/lib/*.so "${ED}"/usr/${LIB}/ || die
	fi

	rm -rfv "${ED}/torch"
	rm -rfv "${ED}/var"
	rm -rfv "${ED}/usr/lib"

	rm -fv "${ED}/usr/include/*.{h,hpp}"
	rm -rfv "${ED}/usr/include/asmjit"
	rm -rfv "${ED}/usr/include/c10d"
	rm -rfv "${ED}/usr/include/fbgemm"
	rm -rfv "${ED}/usr/include/fp16"
	rm -rfv "${ED}/usr/include/gloo"
	rm -rfv "${ED}/usr/include/include"
	rm -rfv "${ED}/usr/include/var"

	cp -rv "${WORKDIR}/${P}/third_party/pybind11/include/pybind11" "${ED}/usr/include/"

	rm -fv "${ED}/usr/lib64/libtbb.so"
	rm -rfv "${ED}/usr/lib64/cmake"

	if use python; then
		install_shm_manager() {
			TORCH_BIN_DIR="${ED}/usr/lib64/${EPYTHON}/site-packages/torch/bin"

			mkdir -pv ${TORCH_BIN_DIR}
			cp -v "${ED}/usr/bin/torch_shm_manager" "${TORCH_BIN_DIR}"
		}

		python_foreach_impl install_shm_manager

		scanelf -r --fix "${BUILD_DIR}/caffe2/python"
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		python_foreach_impl python_optimize
	fi

	find "${ED}/usr/lib64" -name "*.a" -exec rm -fv {} \;

	use test && rm -rfv "${ED}/usr/test" "${ED}"/usr/bin/test_{api,jit}

	# Remove the empty directories by CMake Python:
	find "${ED}" -type d -empty -delete || die
}
