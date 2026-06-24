# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-any-r1 toolchain-funcs
DOCS_BUILDER="doxygen"
DOCS_DIR="build/docs"
DOCS_CONFIG_NAME="doxygen.cfg"
DOCS_DEPEND="
	media-gfx/graphviz
	virtual/latex-base
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/recommonmark[${PYTHON_USEDEP}]
		dev-python/myst-parser[${PYTHON_USEDEP}]
	')
"
inherit docs

# We cannot unbundle this because it has to be compiled with the clang/llvm
# that we are building here. Otherwise we run into problems running the compiler.
#from sycl/llvm/lib/SYCLLowerIR/CMakeLists.txt
VC_INTR_COMMIT="4fc83e12979096db72c129bd432238d5ca397e4d"

# This one can be unbundled I think
UMF_PV="1.1.0"
NIGHTLY_VER="nightly-${PV//./-}"
PV_YEAR=$(ver_cut 1)
PV_MONTH=$(ver_cut 2)
PV_DAY=$(ver_cut 3)

# From sycl/cmake/modules/FetchEmhash.cmake
EMHASH_COMMIT="5e131ba09a5290823fe71099d9c35eb5df5345b6"

DESCRIPTION="oneAPI Data Parallel C++ compiler"
HOMEPAGE="https://github.com/intel/llvm"
SRC_URI="
	https://github.com/intel/llvm/archive/refs/tags/${NIGHTLY_VER}.tar.gz -> ${P}.tar.gz
	https://github.com/intel/vc-intrinsics/archive/${VC_INTR_COMMIT}.tar.gz -> ${P}-vc-intrinsics-${VC_INTR_COMMIT}.tar.gz
	https://github.com/ktprime/emhash/archive/${EMHASH_COMMIT}.tar.gz -> ${P}-emhash-${EMHASH_COMMIT}.tar.gz
	https://github.com/oneapi-src/unified-memory-framework/archive/refs/tags/v${UMF_PV}.tar.gz -> ${P}-unified-memory-framework-${UMF_PV}.tar.gz
"
S="${WORKDIR}/llvm-${NIGHTLY_VER}"
CMAKE_USE_DIR="${S}/llvm"
BUILD_DIR="${S}/build"

LICENSE="Apache-2.0 MIT"
SLOT="0/6" # Based on libsycl.so
KEYWORDS="" # this is a nightly build and depends on not yet released latest spriv-headers

ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM AVR BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/(-)?}

IUSE="cuda hip test ${ALL_LLVM_TARGETS[*]}"
REQUIRED_USE="
	?? ( cuda hip )
	cuda? ( llvm_targets_NVPTX )
	hip? ( llvm_targets_AMDGPU )
"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"


DEPEND="
	dev-libs/boost:=
	>=dev-libs/level-zero-1.29.0:=
	dev-libs/opencl-icd-loader
	>=dev-util/opencl-headers-2025.06.13
	>dev-util/spirv-headers-1.4.350.1-r9999
	dev-util/spirv-tools
	media-libs/libva
	dev-build/libtool
	>=dev-cpp/parallel-hashmap-1.3.12
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	hip? ( dev-util/hip:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/DPC++-6.3.0-zstd.patch"
)


src_configure() {
	# Extracted from buildbot/configure.py
	local EXTERNAL_PROJECTS="sycl;llvm-spirv;opencl;xpti;xptifw;libdevice;sycl-jit"
	local offload_targets="level_zero"
	local mycmakeargs=(
		-DLLVM_ENABLE_ASSERTIONS=OFF
		-DLLVM_APPEND_VC_REV=OFF
		-DLLVM_TARGETS_TO_BUILD="SPIRV;${LLVM_TARGETS// /;}"
		-DLLVM_EXTERNAL_PROJECTS="${EXTERNAL_PROJECTS}"
		-DLLVM_EXTERNAL_SYCL_SOURCE_DIR="${S}/sycl"
		-DLLVM_EXTERNAL_SYCL_JIT_SOURCE_DIR="${S}/sycl-jit"
		-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR="${S}/llvm-spirv"
		-DLLVM_EXTERNAL_XPTI_SOURCE_DIR="${S}/xpti"
		-DXPTI_SOURCE_DIR="${S}/xpti"
		-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR="${S}/xptifw"
		-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR="${S}/libdevice"
		-DLLVM_ENABLE_PROJECTS="clang;${EXTERNAL_PROJECTS}"
		-DLLVM_BUILD_TOOLS=ON
		-DSYCL_ENABLE_EXTENSION_JIT=ON
		-DSYCL_ENABLE_WERROR=OFF
		-DSYCL_INCLUDE_TESTS="$(usex test)"
		-DCLANG_INCLUDE_TESTS="$(usex test)"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
		-DLLVM_SPIRV_INCLUDE_TESTS="$(usex test)"
		-DUR_BUILD_TESTS="$(usex test)"
		-DLLVM_ENABLE_DOXYGEN="$(usex doc)"
		-DLLVM_ENABLE_SPHINX="$(usex doc)"
		-DLLVM_USE_SPLIT_DWARF=OFF
		-DLLVM_BUILD_DOCS="$(usex doc)"
		-DSYCL_ENABLE_XPTI_TRACING=ON
		-DXPTI_ENABLE_WERROR=OFF
		-DSYCL_ENABLE_BACKENDS="level_zero;level_zero_v2;opencl;$(usev hip);$(usev cuda)"
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr"
		-DFETCHCONTENT_SOURCE_DIR_VC-INTRINSICS="${WORKDIR}/vc-intrinsics-${VC_INTR_COMMIT}"
		-DFETCHCONTENT_SOURCE_DIR_EMHASH="${WORKDIR}/emhash-${EMHASH_COMMIT}"
		-DFETCHCONTENT_SOURCE_DIR_UNIFIED-MEMORY-FRAMEWORK="${WORKDIR}/unified-memory-framework-${UMF_PV}"
		-DSYCL_COMPILER_VERSION="${PV//./}"
		-DDPCPP_VERSION_MAJOR="${PV_YEAR}"
		-DDPCPP_VERSION_MINOR="${PV_MONTH}"
		-DDPCPP_VERSION_PATCH="${PV_DAY}"
		# Needed because we're linking against static llvm
		-DLIBOMP_USE_STDCPPLIB=ON
		# Offload currently broken
		-DUR_BUILD_ADAPTER_OFFLOAD=OFF
		-DLLVM_ENABLE_RUNTIMES="openmp;compiler-rt"
		# Will not build spirv64-intel libomptarget library unless the tests are forced on
		-DLIBOMPTARGET_FORCE_LEVELZERO_TESTS=ON

		# The sycl part of the build system insists on installing during compiling
		# Install it to some temporary directory
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/install"
		-DCMAKE_INSTALL_MANDIR="${BUILD_DIR}/install/share/man"
		-DCMAKE_INSTALL_INFODIR="${BUILD_DIR}/install/share/info"
		-DCMAKE_INSTALL_DOCDIR="${BUILD_DIR}/install/share/doc/${PF}"
		-DUR_OFFLOAD_INSTALL_DIR="${BUILD_DIR}/install"
		-DUR_OFFLOAD_INCLUDE_DIR="${BUILD_DIR}/install/include"
		# Since its built here, it will try to use prev install's version of UMF
		-DUR_USE_EXTERNAL_UMF=OFF
		# we need to compile llvm as a static library because otherwise libsycl.so crashes at runtime
		# because it dlopen's the intel graphics compiler dynlib which pulls in its own llvm dynlib
		# If it weren't for that it also might crash because something is pulling in vulkan and mesa's
		# vulkan implementation also pulls in its slotted llvm dynlib.
		-DLLVM_BUILD_LLVM_DYLIB=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_USE_STATIC_ZSTD=OFF
	)
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		mycmakeargs+=(
			-DLLVM_ENABLE_LIBCXX=ON
		)
	else
		mycmakeargs+=(
			-DLLVM_ENABLE_LIBCXX=OFF
		)
	fi

	if use hip; then
		mycmakeargs+=(
			-DSYCL_BUILD_PI_HIP_PLATFORM=AMD
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS=ON
			-DLIBCLC_TARGETS_TO_BUILD=";amdgcn--;amdgcn--amdhsa"
		)
		offload_targets+=";amdgpu"
	fi

	if use cuda; then
		mycmakeargs+=(
			-DLIBCLC_GENERATE_REMANGLED_VARIANTS=ON
			-DLIBCLC_TARGETS_TO_BUILD=";nvptx64--;nvptx64--nvidiacl"
		)
		offload_targets+=";cuda"
	fi

	if use doc; then
		mycmakeargs+=( -DSPHINX_WARNINGS_AS_ERRORS=OFF )
	fi
	mycmakeargs+="-DLIBOMPTARGET_PLUGINS_TO_BUILD=${offload_targets}"
	cmake_src_configure
}

src_compile() {
	# Need offload before unified-runtime can be compiled
	# cmake_build runtimes/install
	# Build sycl (this also installs some stuff already)
	cmake_build deploy-sycl-toolchain

	use doc && cmake_build doxygen-sycl

	# Finish compiling
	cmake_src_compile
}

src_test() {
	cmake_build check
}

src_install() {
	# Finish installing in dummy dir before installing in actual image dir
	cmake_build install
	einstalldocs

	local LLVM_INTEL_DIR="/usr/lib/llvm/intel"
	dodir "${LLVM_INTEL_DIR}"

	# Copy our temporary directory to the image directory
	mv "${BUILD_DIR}/install"/* "${ED}/${LLVM_INTEL_DIR}" || die

	# Convienence symlinks
	dosym -r "${LLVM_INTEL_DIR}/bin/clang" "/usr/bin/icx"
	dosym -r "${LLVM_INTEL_DIR}/bin/clang++" "/usr/bin/icpx"

	# Copied from llvm ebuild, put env file last so we don't overwrite main llvm/clang
	newenvd - "60llvm-intel" <<-_EOF_
		PATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		MANPATH="${EPREFIX}${LLVM_INTEL_DIR}/share/man"
		LDPATH="${EPREFIX}${LLVM_INTEL_DIR}/lib:${EPREFIX}${LLVM_INTEL_DIR}/lib64"
	_EOF_
}
