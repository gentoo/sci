# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit cmake python-any-r1
DOCS_BUILDER="doxygen"
DOCS_DIR="build/docs"
DOCS_CONFIG_NAME="doxygen.cfg"
DOCS_DEPEND="
	media-gfx/graphviz
	virtual/latex-base
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/myst_parser[${PYTHON_USEDEP}]
	')
"
inherit docs

# We cannot unbundle this because it has to be compiled with the clang/llvm
# that we are building here. Otherwise we run into problems running the compiler.
CPU_EMUL_PV="2022-08-22"
VC_INTR_PV="0.8.1" # Newer versions cause compile failure

DESCRIPTION="oneAPI Data Parallel C++ compiler"
HOMEPAGE="https://github.com/intel/llvm"
SRC_URI="
	https://github.com/intel/llvm/archive/refs/tags/${PV//./-}.tar.gz -> ${P}.tar.gz
	https://github.com/intel/vc-intrinsics/archive/refs/tags/v${VC_INTR_PV}.tar.gz -> ${P}-vc-intrinsics-${VC_INTR_PV}.tar.gz
	esimd_emulator? ( https://github.com/intel/cm-cpu-emulation/archive/refs/tags/v${CPU_EMUL_PV}.tar.gz -> ${P}-cm-cpu-emulation-${CPU_EMUL_PV}.tar.gz )
"
S="${WORKDIR}/llvm-${PV//./-}"
CMAKE_USE_DIR="${S}/llvm"
BUILD_DIR="${S}/build"

LICENSE="Apache-2.0 MIT"
SLOT="0/6" # Based on libsycl.so
KEYWORDS="~amd64"

ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}

IUSE="cuda hip test esimd_emulator ${ALL_LLVM_TARGETS[*]}"
REQUIRED_USE="
	?? ( cuda hip )
	cuda? ( llvm_targets_NVPTX )
	hip? ( llvm_targets_AMDGPU )
"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

DEPEND="
	dev-libs/boost:=
	dev-libs/level-zero:=
	dev-libs/opencl-icd-loader
	dev-util/opencl-headers
	dev-util/spirv-headers
	dev-util/spirv-tools
	media-libs/libva
	sys-devel/libtool
	esimd_emulator? ( dev-libs/libffi:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	hip? ( dev-util/hip:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-system-libs.patch"
)

src_configure() {
	# Extracted from buildbot/configure.py
	local mycmakeargs=(
		-DLLVM_ENABLE_ASSERTIONS=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_EXTERNAL_PROJECTS="sycl;llvm-spirv;opencl;libdevice;xpti;xptifw"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR="${S}/sycl"
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR="${S}/llvm-spirv"
		-DLLVM_EXTERNAL_XPTI_SOURCE_DIR="${S}/xpti"
		-DXPTI_SOURCE_DIR="${S}/xpti"
		-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR="${S}/xptifw"
		-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR="${S}/libdevice"
		-DLLVM_ENABLE_PROJECTS="clang;sycl;llvm-spirv;opencl;libdevice;xpti;xptifw"
		-DLLVM_BUILD_TOOLS=ON
		-DSYCL_ENABLE_WERROR=OFF
		-DSYCL_INCLUDE_TESTS="$(usex test)"
		-DCLANG_INCLUDE_TESTS="$(usex test)"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
		-DLLVM_SPIRV_INCLUDE_TESTS="$(usex test)"
		-DLLVM_ENABLE_DOXYGEN="$(usex doc)"
		-DLLVM_ENABLE_SPHINX="$(usex doc)"
		-DLLVM_BUILD_DOCS="$(usex doc)"
		-DSYCL_ENABLE_XPTI_TRACING=ON
		-DLLVM_ENABLE_LLD=OFF
		-DXPTI_ENABLE_WERROR=OFF
		-DSYCL_ENABLE_PLUGINS="level_zero;opencl;$(usev esimd_emulator);$(usev hip);$(usev cuda)"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr"
		-DBOOST_MP11_SOURCE_DIR="${ESYSROOT}/usr "
		-DLEVEL_ZERO_LIBRARY="${ESYSROOT}/usr/lib64/libze_loader.so"
		-DLEVEL_ZERO_INCLUDE_DIR="${ESYSROOT}/usr/include"
		-DLLVMGenXIntrinsics_SOURCE_DIR="${WORKDIR}/vc-intrinsics-${VC_INTR_PV}"
		-DSYCL_CLANG_EXTRA_FLAGS="${CXXFLAGS}"
		# The sycl part of the build system insists on installing during compiling
		# Install it to some temporary directory
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/install"
		-DCMAKE_INSTALL_MANDIR="${BUILD_DIR}/install/share/man"
		-DCMAKE_INSTALL_INFODIR="${BUILD_DIR}/install/share/info"
		-DCMAKE_INSTALL_DOCDIR="${BUILD_DIR}/install/share/doc/${PF}"
	)

	if use hip; then
		mycmakeargs+=(
			-DSYCL_BUILD_PI_HIP_PLATFORM=AMD
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS=ON
			-DLIBCLC_TARGETS_TO_BUILD=";amdgcn--;amdgcn--amdhsa"
		)
	fi

	if use cuda; then
		mycmakeargs+=(
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS=ON
			-DLIBCLC_TARGETS_TO_BUILD=";nvptx64--;nvptx64--nvidiacl"
		)
	fi

	if use esimd_emulator; then
		mycmakeargs+=(
			-DLibFFI_INCLUDE_DIR="${ESYSROOT}/usr/lib64/libffi/include"
			-DUSE_LOCAL_CM_EMU_SOURCE="${WORKDIR}/cm-cpu-emulation-${CPU_EMUL_PV}"
		)
	fi

	if use doc; then
		mycmakeargs+=( -DSPHINX_WARNINGS_AS_ERRORS=OFF )
	fi

	cmake_src_configure
}

src_compile() {
	# Build sycl (this also installs some stuff already)
	cmake_build deploy-sycl-toolchain

	use doc && cmake_build doxygen-sycl

	# Install all other files into the same temporary directory
	cmake_build install
}

src_test() {
	cmake_build check
}

src_install() {
	einstalldocs

	local LLVM_INTEL_DIR="/usr/lib/llvm/intel"
	dodir "${LLVM_INTEL_DIR}"

	# Copy our temporary directory to the image directory
	mv "${BUILD_DIR}/install"/* "${ED}/${LLVM_INTEL_DIR}" || die

	# Copied from llvm ebuild, put env file last so we don't overwrite main llvm/clang
	newenvd - "60llvm-intel" <<-_EOF_
		PATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		MANPATH="${EPREFIX}${LLVM_INTEL_DIR}/share/man"
		LDPATH="${EPREFIX}${LLVM_INTEL_DIR}/lib:${EPREFIX}${LLVM_INTEL_DIR}/lib64"
	_EOF_
}
