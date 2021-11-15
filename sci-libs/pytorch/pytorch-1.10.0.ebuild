# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit cmake cuda distutils-r1 prefix

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/google/benchmark/archive/e991355c02b93fe17713efe04cbc2e278e00fdbd.tar.gz -> benchmark-e991355c02b93fe17713efe04cbc2e278e00fdbd.tar.gz
https://github.com/pytorch/cpuinfo/archive/63b25457.tar.gz -> cpuinfo-63b25457.tar.gz
https://github.com/NVlabs/cub/archive/d106ddb991a56c3df1b6d51b2409e36ba8181ce4.tar.gz -> cub-d106ddb991a56c3df1b6d51b2409e36ba8181ce4.tar.gz
https://github.com/pytorch/fbgemm/archive/7588d9d804826b428fc0e4fd418e9cc3f7a72e52.tar.gz -> fbgemm-7588d9d804826b428fc0e4fd418e9cc3f7a72e52.tar.gz
https://github.com/asmjit/asmjit/archive/d0d14ac774977d0060a351f66e35cb57ba0bf59c.tar.gz -> asmjit-d0d14ac774977d0060a351f66e35cb57ba0bf59c.tar.gz
https://github.com/pytorch/cpuinfo/archive/5916273f79a21551890fd3d56fc5375a78d1598d.tar.gz -> cpuinfo-5916273f79a21551890fd3d56fc5375a78d1598d.tar.gz
https://github.com/google/googletest/archive/0fc5466d.tar.gz -> googletest-0fc5466d.tar.gz
https://github.com/fmtlib/fmt/archive/cd4af11efc9c622896a3e4cb599fa28668ca3d05.tar.gz -> fmt-cd4af11efc9c622896a3e4cb599fa28668ca3d05.tar.gz
https://github.com/houseroad/foxi/archive/c278588e34e535f0bb8f00df3880d26928038cad.tar.gz -> foxi-c278588e34e535f0bb8f00df3880d26928038cad.tar.gz
https://github.com/Maratyszcza/FP16/archive/4dfe081cf6bcd15db339cf2680b9281b8451eeb3.tar.gz -> FP16-4dfe081cf6bcd15db339cf2680b9281b8451eeb3.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/b408327ac2a15ec3e43352421954f5b1967701d1.tar.gz -> FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1.tar.gz
https://github.com/google/gemmlowp/archive/3fb5c176.tar.gz -> gemmlowp-3fb5c176.tar.gz
https://github.com/facebookincubator/gloo/archive/c22a5cfba94edf8ea4f53a174d38aa0c629d070f.tar.gz -> gloo-c22a5cfba94edf8ea4f53a174d38aa0c629d070f.tar.gz
https://github.com/google/googletest/archive/e2239ee6043f73722e7aa812a459f54a28552929.tar.gz -> googletest-e2239ee6043f73722e7aa812a459f54a28552929.tar.gz
https://github.com/intel/ideep/archive/9ca27bbfd88fa1469cbf0467bd6f14cd1738fa40.tar.gz -> ideep-9ca27bbfd88fa1469cbf0467bd6f14cd1738fa40.tar.gz
https://github.com/intel/mkl-dnn/archive/5ef631a0.tar.gz -> mkl-dnn-5ef631a0.tar.gz
cuda? ( https://github.com/NVIDIA/nccl/archive/033d7995.tar.gz -> nccl-033d7995.tar.gz )
https://github.com/Maratyszcza/NNPACK/archive/c07e3a0400713d546e0dea2d5466dd22ea389c73.tar.gz -> NNPACK-c07e3a0400713d546e0dea2d5466dd22ea389c73.tar.gz
https://github.com/onnx/onnx/archive/a82c6a70.tar.gz -> onnx-a82c6a70.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/c153211418a7c57ce071d9ce2a41f8d1c85a878f.tar.gz -> onnx-tensorrt-c153211418a7c57ce071d9ce2a41f8d1c85a878f.tar.gz
https://github.com/onnx/onnx/archive/29e7aa7048809784465d06e897f043a4600642b2.tar.gz -> onnx-29e7aa7048809784465d06e897f043a4600642b2.tar.gz
https://github.com/google/benchmark/archive/e776aa02.tar.gz -> benchmark-e776aa02.tar.gz
https://github.com/google/benchmark/archive/5b7683f4.tar.gz -> benchmark-5b7683f4.tar.gz
https://github.com/google/googletest/archive/5ec7f0c4.tar.gz -> googletest-5ec7f0c4.tar.gz
https://github.com/Maratyszcza/psimd/archive/072586a71b55b7f8c584153d223e95687148a90.tar.gz -> psimd-072586a71b55b7f8c584153d223e95687148a90.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/a134dd5d4cee80cce15db81a72e7f929d71dd413.tar.gz -> pthreadpool-a134dd5d4cee80cce15db81a72e7f929d71dd413.tar.gz
https://github.com/Maratyszcza/PeachPy/archive/07d8fde8ac45d7705129475c0f94ed8925b93473.tar.gz -> PeachPy-07d8fde8ac45d7705129475c0f94ed8925b93473.tar.gz
https://github.com/pytorch/QNNPACK/archive/7d2a4e9931a82adc3814275b6219a03e24e36b4c.tar.gz -> QNNPACK-7d2a4e9931a82adc3814275b6219a03e24e36b4c.tar.gz
https://github.com/shibatch/sleef/archive/e0a003ee838b75d11763aa9c3ef17bf71a725bff.tar.gz -> sleef-e0a003ee838b75d11763aa9c3ef17bf71a725bff.tar.gz
https://github.com/pytorch/tensorpipe/archive/d2aa3485e8229c98891dfd604b514a39d45a5c99.tar.gz -> tensorpipe-d2aa3485e8229c98891dfd604b514a39d45a5c99.tar.gz
https://github.com/google/googletest/archive/2fe3bd99.tar.gz -> googletest-2fe3bd99.tar.gz
https://github.com/google/libnop/archive/aa95422e.tar.gz -> libnop-aa95422e.tar.gz
https://github.com/libuv/libuv/archive/48e04275332f5753427d21a52f17ec6206451f2c.tar.gz -> libuv-48e04275332f5753427d21a52f17ec6206451f2c.tar.gz
https://github.com/google/XNNPACK/archive/79cd5f9e18ad0925ac9a050b00ea5a36230072db.tar.gz -> XNNPACK-79cd5f9e18ad0925ac9a050b00ea5a36230072db.tar.gz
https://github.com/pytorch/kineto/archive/879a203d9bf554e95541679ddad6e0326f272dc1.tar.gz -> kineto-879a203d9bf554e95541679ddad6e0326f272dc1.tar.gz
https://github.com/driazati/breakpad/archive/7d188f679d4ae0a5bd06408a3047d69ef8eef848.tar.gz -> breakpad-7d188f679d4ae0a5bd06408a3047d69ef8eef848.tar.gz
https://github.com/mikey/linux-syscall-support/archive/e1e7b0ad8ee99a875b272c8e33e308472e897660.tar.gz -> lss-e1e7b0ad8ee99a875b272c8e33e308472e897660.tar.gz
"

# git clone git@github.com:pytorch/pytorch.git && cd pytorch
# git submodules update --init --recursive
# ${FILESDIR}/get_third_paries
# cat SRC_URI src_prepare

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="asan blas cuda +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkldnn mpi namedtensor +nnpack numa +observers opencl opencv +openmp +python +qnnpack redis rocm static test tools zeromq"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	?? ( cuda rocm )
"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	blas? ( virtual/blas )
	cuda? ( dev-libs/cudnn
		dev-cpp/eigen[cuda] )
	rocm? ( >=dev-util/hip-4.0.0-r1
			>=dev-libs/rccl-4
			>=sci-libs/rocThrust-4
			>=sci-libs/hipCUB-4
			>=sci-libs/rocPRIM-4
			>=sci-libs/miopen-4
			>=sci-libs/rocBLAS-4
			>=sci-libs/rocRAND-4
			>=sci-libs/hipSPARSE-4
			>=sci-libs/rocFFT-4
			>=dev-util/roctracer-4 )
	ffmpeg? ( media-video/ffmpeg )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog[gflags] )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mpi? ( virtual/mpi )
	opencl? ( dev-libs/clhpp virtual/opencl )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS}
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/protobuf-python:0/30
	)
	redis? ( dev-db/redis )
	zeromq? ( net-libs/zeromq )
	dev-cpp/eigen
	dev-libs/protobuf:0/30
	dev-libs/libuv
"

#ATen code generation
BDEPEND="dev-python/pyyaml"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-cpp/tbb
	app-arch/zstd
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	sys-fabric/libibverbs
	sys-process/numactl
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-skip-tests.patch
	"${FILESDIR}"/${PN}-1.6.0-global-dlopen.patch
	"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch
	"${FILESDIR}"/${PN}-1.7.1-no-rpath.patch
	"${FILESDIR}"/${PN}-1.7.1-torch_shm_manager.patch
	"${FILESDIR}"/${PN}-1.10.0-nonull.patch
)

src_prepare() {
	cmake_src_prepare
	eprefixify torch/__init__.py

	rmdir third_party/benchmark || die
	ln -sv "${WORKDIR}"/benchmark-e991355c02b93fe17713efe04cbc2e278e00fdbd third_party/benchmark || die
	rmdir third_party/cpuinfo || die
	ln -sv "${WORKDIR}"/cpuinfo-5916273f79a21551890fd3d56fc5375a78d1598d third_party/cpuinfo || die
	rmdir third_party/cub || die
	ln -sv "${WORKDIR}"/cub-d106ddb991a56c3df1b6d51b2409e36ba8181ce4 third_party/cub || die
	rmdir third_party/fbgemm || die
	ln -sv "${WORKDIR}"/FBGEMM-7588d9d804826b428fc0e4fd418e9cc3f7a72e52 third_party/fbgemm || die
	rmdir third_party/fbgemm/third_party/asmjit || die
	ln -sv "${WORKDIR}"/asmjit-d0d14ac774977d0060a351f66e35cb57ba0bf59c third_party/fbgemm/third_party/asmjit || die
	rmdir third_party/fbgemm/third_party/cpuinfo || die
	ln -sv "${WORKDIR}"/cpuinfo-d5e37adf1406cf899d7d9ec1d317c47506ccb970 third_party/fbgemm/third_party/cpuinfo || die
	rmdir third_party/fbgemm/third_party/googletest || die
	ln -sv "${WORKDIR}"/googletest-0fc5466dbb9e623029b1ada539717d10bd45e99e third_party/fbgemm/third_party/googletest || die
	rmdir third_party/fmt || die
	ln -sv "${WORKDIR}"/fmt-cd4af11efc9c622896a3e4cb599fa28668ca3d05 third_party/fmt || die
	rmdir third_party/foxi || die
	ln -sv "${WORKDIR}"/foxi-c278588e34e535f0bb8f00df3880d26928038cad third_party/foxi || die
	rmdir third_party/FP16 || die
	ln -sv "${WORKDIR}"/FP16-4dfe081cf6bcd15db339cf2680b9281b8451eeb3 third_party/FP16 || die
	rmdir third_party/FXdiv
	ln -sv "${WORKDIR}"/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1 third_party/FXdiv || die
	rmdir third_party/gemmlowp/gemmlowp || die
	ln -sv "${WORKDIR}"/gemmlowp-3fb5c176c17c765a3492cd2f0321b0dab712f350 third_party/gemmlowp/gemmlowp || die
	rmdir third_party/gloo || die
	ln -sv "${WORKDIR}"/gloo-c22a5cfba94edf8ea4f53a174d38aa0c629d070f third_party/gloo || die
	rmdir third_party/googletest || die
	ln -sv "${WORKDIR}"/googletest-e2239ee6043f73722e7aa812a459f54a28552929 third_party/googletest || die
	rmdir third_party/ideep || die
	ln -sv "${WORKDIR}"/ideep-9ca27bbfd88fa1469cbf0467bd6f14cd1738fa40 third_party/ideep || die
	rmdir third_party/ideep/mkl-dnn || die
	ln -sv "${WORKDIR}"/mkl-dnn-5ef631a030a6f73131c77892041042805a06064f third_party/ideep/mkl-dnn || die
	rmdir third_party/nccl/nccl || die
	ln -sv "${WORKDIR}"/nccl-033d799524fb97629af5ac2f609de367472b2696 third_party/nccl/nccl || die
	rmdir third_party/NNPACK || die
	ln -sv "${WORKDIR}"/NNPACK-c07e3a0400713d546e0dea2d5466dd22ea389c73 third_party/NNPACK || die
	rmdir third_party/onnx || die
	ln -sv "${WORKDIR}"/onnx-29e7aa7048809784465d06e897f043a4600642b2 third_party/onnx || die
	rmdir third_party/onnx-tensorrt || die
	ln -sv "${WORKDIR}"/onnx-tensorrt-c153211418a7c57ce071d9ce2a41f8d1c85a878f third_party/onnx-tensorrt || die
	rmdir third_party/onnx-tensorrt/third_party/onnx || die
	ln -sv "${WORKDIR}"/onnx-765f5ee823a67a866f4bd28a9860e81f3c811ce8 third_party/onnx-tensorrt/third_party/onnx || die
	rmdir third_party/onnx/third_party/benchmark || die
	ln -sv "${WORKDIR}"/benchmark-e776aa0275e293707b6a0901e0e8d8a8a3679508 third_party/onnx/third_party/benchmark || die
	rmdir third_party/psimd || die
	ln -sv "${WORKDIR}"/psimd-072586a71b55b7f8c584153d223e95687148a900 third_party/psimd || die
	rmdir third_party/pthreadpool || die
	ln -sv "${WORKDIR}"/pthreadpool-a134dd5d4cee80cce15db81a72e7f929d71dd413 third_party/pthreadpool || die
	rmdir third_party/python-peachpy || die
	ln -sv "${WORKDIR}"/PeachPy-07d8fde8ac45d7705129475c0f94ed8925b93473 third_party/python-peachpy || die
	rmdir third_party/QNNPACK || die
	ln -sv "${WORKDIR}"/QNNPACK-7d2a4e9931a82adc3814275b6219a03e24e36b4c third_party/QNNPACK || die
	rmdir third_party/sleef || die
	ln -sv "${WORKDIR}"/sleef-e0a003ee838b75d11763aa9c3ef17bf71a725bff third_party/sleef || die
	rmdir third_party/tensorpipe || die
	ln -sv "${WORKDIR}"/tensorpipe-d2aa3485e8229c98891dfd604b514a39d45a5c99 third_party/tensorpipe || die
	rmdir third_party/tensorpipe/third_party/googletest || die
	ln -sv "${WORKDIR}"/googletest-2fe3bd994b3189899d93f1d5a881e725e046fdc2 third_party/tensorpipe/third_party/googletest || die
	rmdir third_party/tensorpipe/third_party/libnop || die
	ln -sv "${WORKDIR}"/libnop-aa95422ea8c409e3f078d2ee7708a5f59a8b9fa2 third_party/tensorpipe/third_party/libnop || die
	rmdir third_party/tensorpipe/third_party/libuv || die
	ln -sv "${WORKDIR}"/libuv-48e04275332f5753427d21a52f17ec6206451f2c third_party/tensorpipe/third_party/libuv || die
	rmdir third_party/XNNPACK || die
	ln -sv "${WORKDIR}"/XNNPACK-79cd5f9e18ad0925ac9a050b00ea5a36230072db third_party/XNNPACK || die
	rmdir third_party/kineto || die
	ln -sv "${WORKDIR}"/kineto-879a203d9bf554e95541679ddad6e0326f272dc1 third_party/kineto || die
	rmdir third_party/breakpad || die
	ln -sv "${WORKDIR}"/breakpad-7d188f679d4ae0a5bd06408a3047d69ef8eef848 third_party/breakpad || die
	rmdir third_party/breakpad/src/third_party/lss || die
	ln -sv "${WORKDIR}"/linux-syscall-support-e1e7b0ad8ee99a875b272c8e33e308472e897660 third_party/breakpad/src/third_party/lss || die

	if use cuda; then
		cd third_party/nccl/nccl || die
		eapply "${FILESDIR}"/${PN}-1.6.0-nccl-nvccflags.patch
		cuda_src_prepare
		export CUDAHOSTCXX=$(cuda_gccdir)/g++
	fi

	if use rocm; then
		#Allow escaping sandbox
		addread /dev/kfd
		addread /dev/dri
		addwrite /dev/kfd
		addwrite /dev/dri

		ebegin "HIPifying cuda sources"
		tools/amd_build/build_amd.py
		eend $?

		export PYTORCH_ROCM_ARCH=$(rocminfo | egrep -o "gfx[0-9]+" | uniq | awk -vORS=';' "{print $1}" | sed 's/;$/\n/') || die
		sed -e "/set(roctracer_INCLUDE_DIRS/s,\${ROCTRACER_PATH}/include,${EPREFIX}/usr/include/roctracer," \
			-i cmake/public/LoadHIP.cmake || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWERROR=OFF
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
		-DUSE_ROCM=$(usex rocm ON OFF)
		-DUSE_FBGEMM=$(usex fbgemm ON OFF)
		-DUSE_FFMPEG=$(usex ffmpeg ON OFF)
		-DUSE_GFLAGS=$(usex gflags ON OFF)
		-DUSE_GLOG=$(usex glog ON OFF)
		-DUSE_LEVELDB=$(usex leveldb ON OFF)
		-DUSE_LITE_PROTO=OFF
		-DUSE_LMDB=$(usex lmdb ON OFF)
		-DUSE_MKLDNN=$(usex mkldnn ON OFF)
		-DUSE_MKLDNN_CBLAS=OFF
		-DUSE_NNPACK=$(usex nnpack ON OFF)
		-DUSE_NUMPY=$(usex python ON OFF)
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
		-DUSE_SYSTEM_PYBIND11=ON
		-DBUILD_NAMEDTENSOR=$(usex namedtensor ON OFF)
		-DBLAS=$(usex blas Generic Eigen)
		-DTP_BUILD_LIBUV=OFF
		-Wno-dev
	)

	cmake_src_configure

	if use python; then
		CMAKE_BUILD_DIR="${BUILD_DIR}" distutils-r1_src_configure
	fi

	# do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_compile() {
	cmake_src_compile

	if use python; then
		USE_SYSTEM_LIBS=ON CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_compile
	fi
}

src_install() {
	cmake_src_install

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

	rm -fv "${ED}/usr/${LIB}/libtbb.so"
	rm -rfv "${ED}/usr/${LIB}/cmake"

	if use python; then
		scanelf -r --fix "${BUILD_DIR}/caffe2/python"
		USE_SYSTEM_LIBS=ON CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		python_foreach_impl python_optimize
	fi

	find "${ED}/usr/${LIB}" -name "*.a" -exec rm -fv {} \;

	use test && rm -rfv "${ED}/usr/test" "${ED}"/usr/bin/test_{api,jit}

	# Remove the empty directories by CMake Python:
	find "${ED}" -type d -empty -delete || die
}
