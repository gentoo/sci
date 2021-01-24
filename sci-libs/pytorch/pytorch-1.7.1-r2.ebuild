# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake cuda distutils-r1 prefix

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/google/benchmark/archive/505be96a.tar.gz -> benchmark-505be96a.tar.gz
https://github.com/pytorch/cpuinfo/archive/63b25457.tar.gz -> cpuinfo-63b25457.tar.gz
https://github.com/NVlabs/cub/archive/d106ddb9.tar.gz -> cub-d106ddb9.tar.gz
https://github.com/pytorch/fbgemm/archive/1d710393.tar.gz -> fbgemm-1d710393.tar.gz
https://github.com/asmjit/asmjit/archive/9057aa30.tar.gz -> asmjit-9057aa30.tar.gz
https://github.com/pytorch/cpuinfo/archive/d5e37adf.tar.gz -> cpuinfo-d5e37adf.tar.gz
https://github.com/google/googletest/archive/0fc5466d.tar.gz -> googletest-0fc5466d.tar.gz
https://github.com/fmtlib/fmt/archive/cd4af11e.tar.gz -> fmt-cd4af11e.tar.gz
https://github.com/houseroad/foxi/archive/4aba696e.tar.gz -> foxi-4aba696e.tar.gz
https://github.com/Maratyszcza/FP16/archive/4dfe081c.tar.gz -> FP16-4dfe081c.tar.gz
https://github.com/Maratyszcza/FXdiv/archive/b408327a.tar.gz -> FXdiv-b408327a.tar.gz
https://github.com/google/gemmlowp/archive/3fb5c176.tar.gz -> gemmlowp-3fb5c176.tar.gz
https://github.com/facebookincubator/gloo/archive/3dc0328f.tar.gz -> gloo-3dc0328f.tar.gz
https://github.com/google/googletest/archive/2fe3bd99.tar.gz -> googletest-2fe3bd99.tar.gz
https://github.com/intel/ideep/archive/ba885200.tar.gz -> ideep-ba885200.tar.gz
https://github.com/intel/mkl-dnn/archive/5ef631a0.tar.gz -> mkl-dnn-5ef631a0.tar.gz
cuda? ( https://github.com/NVIDIA/nccl/archive/033d7995.tar.gz -> nccl-033d7995.tar.gz )
https://github.com/Maratyszcza/NNPACK/archive/24b55303.tar.gz -> NNPACK-24b55303.tar.gz
https://github.com/onnx/onnx/archive/a82c6a70.tar.gz -> onnx-a82c6a70.tar.gz
https://github.com/onnx/onnx-tensorrt/archive/c1532114.tar.gz -> onnx-tensorrt-c1532114.tar.gz
https://github.com/onnx/onnx/archive/765f5ee8.tar.gz -> onnx-765f5ee8.tar.gz
https://github.com/google/benchmark/archive/e776aa02.tar.gz -> benchmark-e776aa02.tar.gz
https://github.com/google/benchmark/archive/5b7683f4.tar.gz -> benchmark-5b7683f4.tar.gz
https://github.com/google/googletest/archive/5ec7f0c4.tar.gz -> googletest-5ec7f0c4.tar.gz
https://github.com/Maratyszcza/psimd/archive/072586a7.tar.gz -> psimd-072586a7.tar.gz
https://github.com/Maratyszcza/pthreadpool/archive/029c8862.tar.gz -> pthreadpool-029c8862.tar.gz
https://github.com/Maratyszcza/PeachPy/archive/07d8fde8.tar.gz -> PeachPy-07d8fde8.tar.gz
https://github.com/pytorch/QNNPACK/archive/7d2a4e99.tar.gz -> QNNPACK-7d2a4e99.tar.gz
https://github.com/shibatch/sleef/archive/7f523de6.tar.gz -> sleef-7f523de6.tar.gz
https://github.com/pytorch/tensorpipe/archive/95ff9319.tar.gz -> tensorpipe-95ff9319.tar.gz
https://github.com/google/googletest/archive/2fe3bd99.tar.gz -> googletest-2fe3bd99.tar.gz
https://github.com/google/libnop/archive/aa95422e.tar.gz -> libnop-aa95422e.tar.gz
https://github.com/libuv/libuv/archive/02a9e1be.tar.gz -> libuv-02a9e1be.tar.gz
https://github.com/google/XNNPACK/archive/1b354636.tar.gz -> XNNPACK-1b354636.tar.gz
	"

# git clone git@github.com:pytorch/pytorch.git && cd pytorch
# git submodules update --init --recursive
# ${FILESDIR}/get_third_paries
# cat SRC_URI src_prepare

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="asan blas cuda +fbgemm ffmpeg gflags glog +gloo leveldb lmdb mkldnn mpi namedtensor +nnpack numa +observers opencl opencv +openmp +python +qnnpack redis rocm static test tools zeromq"

REQUIRED_USE="
	^^ ( cuda rocm )
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
	glog? ( dev-cpp/glog )
	leveldb? ( dev-libs/leveldb )
	lmdb? ( dev-db/lmdb )
	mpi? ( virtual/mpi )
	opencl? ( dev-libs/clhpp virtual/opencl )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS}
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/protobuf-python:0/22
	)
	redis? ( dev-db/redis )
	zeromq? ( net-libs/zeromq )
	dev-cpp/eigen
	dev-libs/protobuf:0/22
	dev-libs/libuv
"

#ATen code generation
BDEPEND="dev-python/pyyaml"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-cpp/tbb
	app-arch/zstd
	dev-python/pybind11[${PYTHON_USEDEP}]
	sys-fabric/libibverbs
	sys-process/numactl
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-setup.patch
	"${FILESDIR}"/${PN}-1.6.0-skip-tests.patch
	"${FILESDIR}"/${PN}-1.6.0-global-dlopen.patch
	"${FILESDIR}"/0002-Don-t-build-libtorch-again-for-PyTorch-1.7.1.patch
	"${FILESDIR}"/0003-Change-path-to-caffe2-build-dir-made-by-libtorch.patch
	"${FILESDIR}"/0005-Change-library-directory-according-to-CMake-build.patch
	"${FILESDIR}"/${PN}-1.7.1-no-rpath.patch
	"${FILESDIR}"/${PN}-1.7.1-tensorpipe-unbundle-libuv.patch
	"${FILESDIR}"/${PN}-1.7.1-torch_shm_manager.patch
)

src_prepare() {
	cmake_src_prepare
	eprefixify torch/__init__.py
	eapply_user

	rmdir third_party/benchmark && ln -sv "${WORKDIR}"/benchmark-505be96ab23056580a3a2315abba048f4428b04e third_party/benchmark
	rmdir third_party/cpuinfo && ln -sv "${WORKDIR}"/cpuinfo-63b254577ed77a8004a9be6ac707f3dccc4e1fd9 third_party/cpuinfo
	rmdir third_party/cub && ln -sv "${WORKDIR}"/cub-d106ddb991a56c3df1b6d51b2409e36ba8181ce4 third_party/cub
	rmdir third_party/fbgemm && ln -sv "${WORKDIR}"/FBGEMM-1d710393d5b7588f5de3b83f51c22bbddf095229 third_party/fbgemm
	rmdir third_party/fbgemm/third_party/asmjit && ln -sv "${WORKDIR}"/asmjit-9057aa30b620f0662ff51e2230c126a345063064 third_party/fbgemm/third_party/asmjit
	rmdir third_party/fbgemm/third_party/cpuinfo && ln -sv "${WORKDIR}"/cpuinfo-d5e37adf1406cf899d7d9ec1d317c47506ccb970 third_party/fbgemm/third_party/cpuinfo
	rmdir third_party/fbgemm/third_party/googletest && ln -sv "${WORKDIR}"/googletest-0fc5466dbb9e623029b1ada539717d10bd45e99e third_party/fbgemm/third_party/googletest
	rmdir third_party/fmt && ln -sv "${WORKDIR}"/fmt-cd4af11efc9c622896a3e4cb599fa28668ca3d05 third_party/fmt
	rmdir third_party/foxi && ln -sv "${WORKDIR}"/foxi-4aba696ec8f31794fd42880346dc586486205e0a third_party/foxi
	rmdir third_party/FP16 && ln -sv "${WORKDIR}"/FP16-4dfe081cf6bcd15db339cf2680b9281b8451eeb3 third_party/FP16
	rmdir third_party/FXdiv && ln -sv "${WORKDIR}"/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1 third_party/FXdiv
	rmdir third_party/gemmlowp/gemmlowp && ln -sv "${WORKDIR}"/gemmlowp-3fb5c176c17c765a3492cd2f0321b0dab712f350 third_party/gemmlowp/gemmlowp
	rmdir third_party/gloo && ln -sv "${WORKDIR}"/gloo-3dc0328fe6a9d47bd47c0c6ca145a0d8a21845c6 third_party/gloo
	rmdir third_party/googletest && ln -sv "${WORKDIR}"/googletest-2fe3bd994b3189899d93f1d5a881e725e046fdc2 third_party/googletest
	rmdir third_party/ideep && ln -sv "${WORKDIR}"/ideep-ba885200dbbc1f144c7b58eba487378eb324f281 third_party/ideep
	rmdir third_party/ideep/mkl-dnn && ln -sv "${WORKDIR}"/mkl-dnn-5ef631a030a6f73131c77892041042805a06064f third_party/ideep/mkl-dnn
	rmdir third_party/nccl/nccl && ln -sv "${WORKDIR}"/nccl-033d799524fb97629af5ac2f609de367472b2696 third_party/nccl/nccl
	rmdir third_party/NNPACK && ln -sv "${WORKDIR}"/NNPACK-24b55303f5cf65d75844714513a0d1b1409809bd third_party/NNPACK
	rmdir third_party/onnx && ln -sv "${WORKDIR}"/onnx-a82c6a7010e2e332d8f74ad5b0c726fd47c85376 third_party/onnx
	rmdir third_party/onnx-tensorrt && ln -sv "${WORKDIR}"/onnx-tensorrt-c153211418a7c57ce071d9ce2a41f8d1c85a878f third_party/onnx-tensorrt
	rmdir third_party/onnx-tensorrt/third_party/onnx && ln -sv "${WORKDIR}"/onnx-765f5ee823a67a866f4bd28a9860e81f3c811ce8 third_party/onnx-tensorrt/third_party/onnx
	rmdir third_party/onnx-tensorrt/third_party/onnx/third_party/benchmark && ln -sv "${WORKDIR}"/benchmark-e776aa0275e293707b6a0901e0e8d8a8a3679508 third_party/onnx-tensorrt/third_party/onnx/third_party/benchmark
	rmdir third_party/onnx/third_party/benchmark && ln -sv "${WORKDIR}"/benchmark-e776aa0275e293707b6a0901e0e8d8a8a3679508 third_party/onnx/third_party/benchmark
	rmdir third_party/psimd && ln -sv "${WORKDIR}"/psimd-072586a71b55b7f8c584153d223e95687148a900 third_party/psimd
	rmdir third_party/pthreadpool && ln -sv "${WORKDIR}"/pthreadpool-029c88620802e1361ccf41d1970bd5b07fd6b7bb third_party/pthreadpool
	rmdir third_party/python-peachpy && ln -sv "${WORKDIR}"/PeachPy-07d8fde8ac45d7705129475c0f94ed8925b93473 third_party/python-peachpy
	rmdir third_party/QNNPACK && ln -sv "${WORKDIR}"/QNNPACK-7d2a4e9931a82adc3814275b6219a03e24e36b4c third_party/QNNPACK
	rmdir third_party/sleef && ln -sv "${WORKDIR}"/sleef-7f523de651585fe25cade462efccca647dcc8d02 third_party/sleef
	rmdir third_party/tensorpipe && ln -sv "${WORKDIR}"/tensorpipe-95ff9319161fcdb3c674d2bb63fac3e94095b343 third_party/tensorpipe
	rmdir third_party/tensorpipe/third_party/googletest && ln -sv "${WORKDIR}"/googletest-2fe3bd994b3189899d93f1d5a881e725e046fdc2 third_party/tensorpipe/third_party/googletest
	rmdir third_party/tensorpipe/third_party/libnop && ln -sv "${WORKDIR}"/libnop-aa95422ea8c409e3f078d2ee7708a5f59a8b9fa2 third_party/tensorpipe/third_party/libnop
	rmdir third_party/tensorpipe/third_party/libuv && ln -sv "${WORKDIR}"/libuv-02a9e1be252b623ee032a3137c0b0c94afbe6809 third_party/tensorpipe/third_party/libuv
	rmdir third_party/XNNPACK && ln -sv "${WORKDIR}"/XNNPACK-1b354636b5942826547055252f3b359b54acff95 third_party/XNNPACK

	if use cuda; then
		cd third_party/nccl/nccl || die
		eapply "${FILESDIR}"/${PN}-1.6.0-nccl-nvccflags.patch

		addpredict /dev/nvidiactl
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
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_compile
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
		CMAKE_BUILD_DIR=${BUILD_DIR} distutils-r1_src_install

		python_foreach_impl python_optimize
	fi

	find "${ED}/usr/${LIB}" -name "*.a" -exec rm -fv {} \;

	use test && rm -rfv "${ED}/usr/test" "${ED}"/usr/bin/test_{api,jit}

	# Remove the empty directories by CMake Python:
	find "${ED}" -type d -empty -delete || die
}
