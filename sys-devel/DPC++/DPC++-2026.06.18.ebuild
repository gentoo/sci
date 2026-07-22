# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-any-r1 toolchain-funcs flag-o-matic
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
SLOT="0/9" # Based on libsycl.so
KEYWORDS="" # this is a nightly build and depends on not yet released latest spriv-headers

IUSE="cuda hip test jit debug"
REQUIRED_USE="
"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"


DEPEND="
	dev-libs/boost:=
	>=dev-libs/level-zero-1.29.0:=
	dev-libs/intel-compute-runtime
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
	"${FILESDIR}/DPC++-6.3.0-buildbot-configure.patch"
)


src_configure() {
	filter-lto
	local buildbot_flags=(
		--print-cmake-flags
		-s "${S}"
		-o "${BUILD_DIR}"
		--no-assertions
	)
	use doc && buildbot_flags+=( --docs )
	use cuda && buildbot_flags+=( --cuda )
	use hip && buildbot_flags+=( --hip )
	use jit || buildbot_flags+=( --disable-jit )

	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		buildbot_flags+=(
			--use-libcxx
		)
	fi

	local mycmakeargs=( $(python3 "${S}/buildbot/configure.py" "${buildbot_flags[@]}") )

	mycmakeargs+=(
		-DLLVM_APPEND_VC_REV=OFF
		-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="${ESYSROOT}/usr"
		-DCMAKE_DISABLE_FIND_PACKAGE_LLVMGenXIntrinsics=ON
		-DFETCHCONTENT_SOURCE_DIR_VC-INTRINSICS="${WORKDIR}/vc-intrinsics-${VC_INTR_COMMIT}"
		-DFETCHCONTENT_SOURCE_DIR_EMHASH="${WORKDIR}/emhash-${EMHASH_COMMIT}"
		-DFETCHCONTENT_SOURCE_DIR_UNIFIED-MEMORY-FRAMEWORK="${WORKDIR}/unified-memory-framework-${UMF_PV}"
		-DSYCL_COMPILER_VERSION="${PV//./}"
		-DDPCPP_VERSION_MAJOR="${PV_YEAR}"
		-DDPCPP_VERSION_MINOR="${PV_MONTH}"
		-DDPCPP_VERSION_PATCH="${PV_DAY}"
		-DUR_USE_EXTERNAL_UMF=OFF
		-DCMAKE_INSTALL_PREFIX="${BUILD_DIR}/install"
		-DCMAKE_INSTALL_MANDIR="${BUILD_DIR}/install/share/man"
		-DCMAKE_INSTALL_INFODIR="${BUILD_DIR}/install/share/info"
		-DCMAKE_INSTALL_DOCDIR="${BUILD_DIR}/install/share/doc/${PF}"
		-DLLVM_USE_SPLIT_DWARF=OFF
	)

	if use doc; then
		mycmakeargs+=( -DSPHINX_WARNINGS_AS_ERRORS=OFF )
	fi

	use debug || append-cppflags -DNDEBUG

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
	dosym -r "${LLVM_INTEL_DIR}/bin/clang++" "/usr/bin/dpc++"

	# Copied from llvm ebuild, put env file last so we don't overwrite main llvm/clang
	newenvd - "60llvm-intel" <<-_EOF_
		PATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		# we need to duplicate it in ROOTPATH for Portage to respect...
		ROOTPATH="${EPREFIX}${LLVM_INTEL_DIR}/bin"
		MANPATH="${EPREFIX}${LLVM_INTEL_DIR}/share/man"
		LDPATH="${EPREFIX}${LLVM_INTEL_DIR}/lib:${EPREFIX}${LLVM_INTEL_DIR}/lib64"
	_EOF_
}
