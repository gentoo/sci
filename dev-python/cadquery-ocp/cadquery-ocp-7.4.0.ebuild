# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

# The "cmake" eclass is intentionally omitted here despite cmake being run.
# That eclass expects a "${S}/CMakeLists.txt" file during src_prepare(),
# whereas this package uniquely generates one "${BUILD_DIR}/OCP/CMakeLists.txt"
# file for each active Python version.
inherit llvm multiprocessing python-r1

DESCRIPTION="Python wrapper for OCCT generated using pywrap"
HOMEPAGE="https://github.com/CadQuery/OCP"
SRC_URI="https://github.com/CadQuery/OCP/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# This version requirement derives from "${BUILD_DIR}/OCP/CMakeLists.txt".
BDEPEND=">=dev-util/cmake-3.16"
RDEPEND="~sci-libs/opencascade-${PV}[tbb,vtk]"
DEPEND="${RDEPEND}
	>=dev-python/cadquery-pywrap-${PV}[${PYTHON_USEDEP}]
"

MY_PN=OCP
MY_P="${MY_PN}-${PV}"

S="${WORKDIR}/${MY_P}"
BUILD_DIR="${S}"

# Ensure the path returned by get_llvm_prefix() contains clang.
llvm_check_deps() {
	has_version -r "sys-devel/clang:${LLVM_SLOT}"
}

# OCP currently requires manual configuration, compilation, and installation
# inspired by the conda-specific "build-bindings-job.yml" file.
src_prepare() {
	default

	# Most recently installed version of Clang.
	local _CLANG_VERSION="$(CPP=clang clang-fullversion)"

	# Most recently installed version (excluding trailing patch) of VTK.
	local _VTK_VERSION="$(best_version -r sci-libs/vtk)"
	_VTK_VERSION="$(ver_cut 1-2 "${_VTK_VERSION##sci-libs/vtk}")"

	# Absolute dirname of the most recently installed Clang include directory,
	# mimicing similar logic in the "dev-python/shiboken2" ebuild. See also:
	#     https://bugs.gentoo.org/619490
	local _CLANG_INCLUDE_DIR="${EPREFIX}/usr/lib/clang/${_CLANG_VERSION}/include"

	# Absolute filename of the most recently installed Clang shared library.
	local _CLANG_LIB_FILE="$(get_llvm_prefix)/lib64/libclang.so"

	# Absolute dirname of OCCT's top-level directory. This redefines the
	# standard ${CASROOT} environment variable, which is not guaranteed to be
	# exported or exported with a sane value to this ebuild.
	local _OCCT_DIR="${EPREFIX}/usr/lib64/opencascade-${PV}/ros"

	# Absolute dirname of OCCT's include and shared library directories.
	local _OCCT_INCLUDE_DIR="${_OCCT_DIR}/include/opencascade"
	local _OCCT_LIB_DIR="${_OCCT_DIR}/lib64"

	# Absolute dirname of VTK's include directory,
	local _VTK_INCLUDE_DIR="${EPREFIX}/usr/include/vtk-${_VTK_VERSION}"

	# Ensure the above paths exist as a crude sanity test.
	test -d "${_CLANG_INCLUDE_DIR}" || die "${_CLANG_INCLUDE_DIR} not found."
	test -f "${_CLANG_LIB_FILE}"    || die "${_CLANG_LIB_FILE} not found."
	test -d "${_OCCT_INCLUDE_DIR}"  || die "${_OCCT_INCLUDE_DIR} not found."
	test -d "${_OCCT_LIB_DIR}"      || die "${_OCCT_LIB_DIR} not found."
	test -d "${_VTK_INCLUDE_DIR}"   || die "${_VTK_INCLUDE_DIR} not found."

	# "dev-python/clang-python" atom targeting this Clang version.
	local _CLANG_PYTHON_ATOM="dev-python/clang-python-${_CLANG_VERSION}"

	# Ensure "dev-python/clang-python" targets this Clang version.
	has_version -r "=${_CLANG_PYTHON_ATOM}" ||
		die "${_CLANG_PYTHON_ATOM} not installed."

	# Remove all vendored subdirectories.
	rm -rf conda opencascade pywrap || die

	# Inject a symlink to OCCT's include directory.
	ln -s "${_OCCT_INCLUDE_DIR}" opencascade || die

	python_copy_sources
	cadquery-ocp_src_prepare() {
		cd "${BUILD_DIR}" || die

		# Generate OCCT bindings in the "${BUILD_DIR}/OCP/" subdirectory.
		${EPYTHON} -m bindgen \
			--verbose \
			--njobs $(get_nproc) \
			--libclang "${_CLANG_LIB_FILE}" \
			--include "${_CLANG_INCLUDE_DIR}" \
			--include "${_VTK_INCLUDE_DIR}" \
			all ocp.toml || die

		# Remove the source "FindOpenCascade.cmake" after generating bindings,
		# which copied that file to the target "OCP/FindOpenCascade.cmake".
		rm FindOpenCascade.cmake || die

		#FIXME: Submit an upstream issue. This is frankly awful.
		# Replace all hardcoded paths in "OCP/FindOpenCascade.cmake" with
		# standard OCCT paths derived above. That file is both fundamentally
		# broken and useless, as the ${CASROOT} environment variable and
		# "/usr/lib64/cmake/opencascade-${PV}/OpenCASCADEConfig.cmake" file
		# already reliably identify all requisite OpenCASCADE paths. Failure to
		# patch this file results in src_configure() failures resembling:
		#     -- Could NOT find OPENCASCADE (missing: OPENCASCADE_LIBRARIES)
		sed -i \
			-e 's~$ENV{CONDA_PREFIX}/include/opencascade\b~'${_OCCT_INCLUDE_DIR}'~' \
			-e 's~$ENV{CONDA_PREFIX}/lib\b~'${_OCCT_LIB_DIR}'~' \
			-e 's~$ENV{CONDA_PREFIX}/Library/\(lib\|include/opencascade\)~~' \
			OCP/FindOpenCascade.cmake || die
	}
	python_foreach_impl cadquery-ocp_src_prepare
}

src_configure() {
	cadquery-ocp_src_configure() {
		cd "${BUILD_DIR}" || die
		cmake \
			-Wno-dev \
			-S OCP/ \
			-B OCP.binary_tree/ \
			-G Ninja \
			-D CMAKE_BUILD_TYPE=Gentoo \
			-D PYTHON_EXECUTABLE="${PYTHON}" \
			|| die
	}
	python_foreach_impl cadquery-ocp_src_configure
}

src_compile() {
	cadquery-ocp_src_compile() {
		cd "${BUILD_DIR}" || die
		cmake --build OCP.binary_tree/ -- -j $(get_nproc) || die
	}
	python_foreach_impl cadquery-ocp_src_compile
}

src_test() {
	cadquery-ocp_src_test() {
		cd "${BUILD_DIR}" || die
		PYTHONPATH=OCP.binary_tree/ ${EPYTHON} -c \
			'from OCP.gp import gp_Vec, gp_Ax1, gp_Ax3, gp_Pnt, gp_Dir, gp_Trsf, gp_GTrsf, gp, gp_XYZ'
	}
	python_foreach_impl cadquery-ocp_src_test
}

src_install() {
	python_moduleinto .
	cadquery-ocp_src_install() {
		cd "${BUILD_DIR}" || die
		python_domodule OCP.binary_tree/OCP*.so
	}
	python_foreach_impl cadquery-ocp_src_install
}
