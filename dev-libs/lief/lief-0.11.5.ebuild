# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_10 pypy3 )

# Upstream has two alternate approaches to building its Python API:
# 1. A working "CMakeList.txt" only supporting a single Python target.
# 2. A non-working "setup.py" supporting multiple Python targets but internally
#    invoking CMake in mostly non-configurable (and thus broken) ways.
# We choose working.
#
# Note that "cmake-multilib" *MUST* be inherited before "python-single-r1".
inherit cmake-multilib python-single-r1

DESCRIPTION="Library to instrument executable formats"
HOMEPAGE="https://lief.quarkslab.com"
SRC_URI="https://github.com/lief-project/LIEF/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Python is not multilib yet
IUSE="c examples +python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} !abi_x86_32 !abi_x86_x32 )"

# See "cmake/LIEFDependencies.cmake" for C and C++ dependencies.
BDEPEND="
	python? (
		$(python_gen_cond_dep '
			>=dev-python/setuptools-31.0.0[${PYTHON_USEDEP}]
		')
	)
"
#FIXME: Add after bumping to the next stable release:
#	>=dev-libs/spdlog-1.8.5[${MULTILIB_USEDEP}]
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

# LIEF tests are non-trivial (if not infeasible) to run in the general case.
# For example, "tests/CMakeLists.txt" implies all USE flags must be enabled:
#     if (NOT LIEF_ELF OR NOT LIEF_PE OR NOT LIEF_MACHO)
#       message(FATAL_ERROR "Tests require all LIEF's modules activated" )
#     endif()
RESTRICT="test"

S="${WORKDIR}/LIEF-${PV}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

#FIXME: Unvender currently vendored dependencies in "third-party/". Ideally,
#upstream should add one "LIEF_EXTERNAL_${LIBNAME}" CMake option governing each
#vendored dependency resembling the existing "LIEF_EXTERNAL_SPDLOG" option.
#Note that LIEF patches the vendored "Boost leaf" and "utfcpp" dependencies.
src_prepare() {
	# Respect "multilib"-based lib dirnames.
	sed -i -e 's~\bDESTINATION lib\(64\)\{0,1\}\b~DESTINATION ${CMAKE_INSTALL_LIBDIR}~' \
		CMakeLists.txt || die

	# Respect "python"-based installation of Python bindings. Upstream
	# currently fails to install these bindings, resulting in Gentoo "RUNPATH"
	# QA notices at installation time. See also:
	#    https://github.com/lief-project/LIEF/issues/599#issuecomment-889654343
	cat <<- EOF >> api/python/CMakeLists.txt || die
		if(LIEF_INSTALL_PYTHON)
		  install(
		    TARGETS pyLIEF
		    DESTINATION "$(python_get_sitedir)"
		    COMPONENT libraries
		  )
		endif()
	EOF

	cmake_src_prepare
}

multilib_src_configure() {
	# See also:
	# * "cmake/LIEFDependencies.cmake" for a dependency list.
	# * "cmake/LIEFOptions.cmake" for option descriptions.
	local mycmakeargs=(
		-DLIEF_COVERAGE=OFF
		-DLIEF_DISABLE_FROZEN=OFF
		-DLIEF_EXTRA_WARNINGS=OFF
		-DLIEF_FORCE32=OFF  # Defer to "cmake-multilib" for ABI management.
		-DLIEF_PROFILING=OFF
		-DLIEF_SUPPORT_CXX14=ON
		-DLIEF_USE_CCACHE=OFF  # Defer to Portage itself for "ccache" support.

		# Disabling LIEF's format options causes build failures. See also:
		#    https://github.com/lief-project/LIEF/issues/599
		-DLIEF_ELF=ON
		-DLIEF_PE=ON
		-DLIEF_MACHO=ON
		-DLIEF_ART=ON
		-DLIEF_DEX=ON
		-DLIEF_OAT=ON
		-DLIEF_VDEX=ON

		-DBUILD_SHARED_LIBS="$(usex static-libs OFF ON)"
		-DLIEF_C_API="$(usex c ON OFF)"
		-DLIEF_EXAMPLES="$(usex examples ON OFF)"
		-DLIEF_FORCE_API_EXPORTS="$(usex python ON OFF)"  # See "setup.py".
		-DLIEF_PYTHON_API="$(usex python ON OFF)"
		-DLIEF_INSTALL_PYTHON="$(usex python ON OFF)"

		#FIXME: Add USE flags governing most or all of these options.
		-DLIEF_ENABLE_JSON=OFF
		-DLIEF_DOC=OFF
		-DLIEF_FUZZING=OFF
		-DLIEF_INSTALL_COMPILED_EXAMPLES=OFF
		-DLIEF_LOGGING=OFF
		-DLIEF_LOGGING_DEBUG=OFF
		-DLIEF_TESTS=OFF
		-DLIEF_ASAN=OFF
		-DLIEF_LSAN=OFF
		-DLIEF_TSAN=OFF
		-DLIEF_USAN=OFF
	)
	use python && mycmakeargs+=( -DPYTHON_EXECUTABLE="${PYTHON}" )

	cmake_src_configure
}
