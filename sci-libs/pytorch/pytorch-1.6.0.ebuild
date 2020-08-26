# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 cmake-utils cuda

MPV=${PV/_p/a}

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/v${MPV}.tar.gz -> ${P}.tar.gz
https://github.com/google/benchmark/archive/505be96ab.tar.gz -> benchmark-505be96ab.tar.gz
https://github.com/pytorch/cpuinfo/archive/63b254577.tar.gz -> cpuinfo-63b254577.tar.gz
https://github.com/NVlabs/cub/archive/d106ddb99.tar.gz -> cub-d106ddb99.tar.gz
https://github.com/pytorch/fbgemm/archive/87c378172.tar.gz -> fbgemm-87c378172.tar.gz
https://github.com/fmtlib/fmt/archive/9bdd1596c.tar.gz -> fmt-9bdd1596c.tar.gz
https://github.com/houseroad/foxi/archive/8015abb72.tar.gz -> foxi-8015abb72.tar.gz
https://github.com/Maratyszcza/FP16/archive/4dfe081cf.tar.gz -> FP16-4dfe081cf.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/b408327ac.tar.gz -> FXdiv-b408327ac.tar.gz
https://github.com/google/gemmlowp/archive/3fb5c176c.tar.gz -> gemmlowp-3fb5c176c.tar.gz
https://github.com/facebookincubator/gloo/archive/3d08580f9.tar.gz -> gloo-3d08580f9.tar.gz
https://github.com/google/googletest/archive/2fe3bd994.tar.gz -> googletest-2fe3bd994.tar.gz
https://github.com/intel/ideep/archive/938cc6889.tar.gz -> ideep-938cc6889.tar.gz
cuda? ( https://github.com/NVIDIA/nccl/archive/5949d96f3.tar.gz -> nccl-5949d96f3.tar.gz )
https://github.com/Maratyszcza/NNPACK/archive/24b55303f.tar.gz -> NNPACK-24b55303f.tar.gz
https://github.com/onnx/onnx/archive/a82c6a701.tar.gz -> onnx-a82c6a701.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/c15321141.tar.gz -> onnx-tensorrt-c15321141.tar.gz
https://github.com/Maratyszcza/psimd/archive/072586a71.tar.gz -> psimd-072586a71.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/029c88620.tar.gz -> pthreadpool-029c88620.tar.gz
https://github.com/Maratyszcza/PeachPy/archive/07d8fde8a.tar.gz -> PeachPy-07d8fde8a.tar.gz
https://github.com/pytorch/QNNPACK/archive/7d2a4e993.tar.gz -> QNNPACK-7d2a4e993.tar.gz
https://github.com/shibatch/sleef/archive/7f523de65.tar.gz -> sleef-7f523de65.tar.gz
https://github.com/pytorch/tensorpipe/archive/3b8089c9c.tar.gz -> tensorpipe-3b8089c9c.tar.gz
https://github.com/google/XNNPACK/archive/1b354636b.tar.gz -> XNNPACK-1b354636b.tar.gz
https://github.com/asmjit/asmjit/archive/9057aa30.tar.gz -> asmjit-9057aa30.tar.gz
	"

# git clone git@github.com:pytorch/pytorch.git && cd pytorch
# src_uri() {
# join \
#   <(git config --file .gitmodules --get-regexp url | sed -r -e 's/^submodule.(.*).url (.*)/\1 \2/' -e 's,NNPACK_deps/,,' -e 's/third-party/third_party/' | sort) \
#   <(git submodule status | awk '{print $2 " " $1}' | sort) | \
# while read path url hash; do
#         [[ ${path} =~ (eigen|six|ios|neon2sse|protobuf|pybind11|enum34|tbb|zstd|fbjni) ]] && continue
#         u=${url%.git}
#         h=${hash#-}
#         h=${h:0:8}
#         echo "${u}/archive/${h}.tar.gz -> $(basename ${u})-${h}.tar.gz"
# done
# }
# src_uri

# git submodule update --init third_party/fbgemm && cd third_party/fbgemm
# src_uri | grep asmjit
# cd ../..

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="asan atlas cuda eigen +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkl mkldnn mpi namedtensor +nnpack numa +numpy +observers +openblas opencl opencv +openmp +python +qnnpack redis static test tools zeromq"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	numpy? ( python )
	^^ ( atlas eigen mkl openblas )
"

RDEPEND="
	dev-libs/protobuf
	dev-python/pyyaml[${PYTHON_USEDEP}]
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
	dev-libs/libuv
"
BDEPEND=""

DEPEND="${RDEPEND}
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
	"${FILESDIR}"/${PN}-1.6.0-setup.patch
	"${FILESDIR}"/${PN}-1.6.0-skip-tests.patch
	"${FILESDIR}"/${PN}-1.6.0-global-dlopen.patch
	"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.4.0.patch
	"${FILESDIR}"/0003-Change-path-to-caffe2-build-dir-made-by-libtorch.patch
	"${FILESDIR}"/0005-Change-library-directory-according-to-CMake-build.patch
)

src_unpack() {
	default

	[[ -d ${P} ]] || mv -v ${PN}-${MPV} ${P} || die
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
		eapply "${FILESDIR}"/${PN}-1.6.0-nccl-nvccflags.patch
		ln -s . nccl || die

		cuda_src_prepare
		export CUDAHOSTCXX=$(cuda_gccdir)/g++
	fi

	cd ../tensorpipe || die
	eapply "${FILESDIR}"/${PN}-1.6.0-tensorpipe-unbundle-libuv.patch
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
		CMAKE_BUILD_DIR="${BUILD_DIR}" distutils-r1_src_configure
	fi

	# do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
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

	find "${ED}/usr/${LIB}" -name "*.a" -exec rm -fv {} \;

	use test && rm -rfv "${ED}/usr/test" "${ED}"/usr/bin/test_{api,jit}

	# Remove the empty directories by CMake Python:
	find "${ED}" -type d -empty -delete || die
}
