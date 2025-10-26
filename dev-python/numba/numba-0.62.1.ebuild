# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 flag-o-matic

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="https://numba.pydata.org/"
SRC_URI="https://github.com/numba/numba/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	>=dev-python/llvmlite-0.45[$PYTHON_USEDEP]
	dev-python/numpy[$PYTHON_USEDEP]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	filter-lto
	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# non-matching __file__ attribute between .py and .pyc (want site-packages, have build dir)
		numba/tests/test_copy_propagate.py::test_will_propagate
		numba/tests/test_copy_propagate.py::test_wont_propagate
		numba/tests/test_parfors.py::test_call_hoisting_outcall
		numba/tests/test_remove_dead.py::test_will_propagate
		numba/tests/test_tracing.py::test
		# numba.core.errors.TypingError: Failed in nopython mode pipeline (step: nopython frontend)
		numba/tests/test_array_analysis.py::TestArrayAnalysis::test_base_cases
		numba/tests/test_caching.py::TestCFuncCache::test_caching
		numba/tests/test_cfunc.py::TestCFunc::test_errors
		numba/tests/test_conditions_as_predicates.py::TestConditionsAsPredicates::test_reflected_list
		numba/tests/test_conditions_as_predicates.py::TestConditionsAsPredicates::test_reflected_set
		numba/tests/test_debug.py::TestParforsDebug::test_unsupported_prange_warns
		numba/tests/test_dictobject.py::TestDictObject::test_007_collision_checks
		numba/tests/test_exceptions.py::TestRaising::test_assert_statement_nopython
		numba/tests/test_function_type.py::TestExceptionInFunctionType::test_exception_ignored_in_cfunc
		numba/tests/test_overlap.py::TestArrayOverlap
		numba/tests/test_remove_dead.py::TestSSADeadBranchPrune::test_issue_6541
		numba/tests/test_runtests.py::TestCase::test_gitdiff
		numba/tests/test_sysinfo.py::TestSysInfo::test_has_no_error
		# AssertionError: 50 not less than 50
		numba/tests/test_record_dtype.py::TestRecordDtype::test_record_arg_transform
		numba/tests/test_record_dtype.py::TestRecordDtypeWithDispatcher::test_record_arg_transform
		numba/tests/test_record_dtype.py::TestRecordDtypeWithStructArrays::test_record_arg_transform
		numba/tests/test_record_dtype.py::TestRecordDtypeWithStructArraysAndDispatcher::test_record_arg_transform
	)

	local PY_BUILD_DIR=$(${EPYTHON} -c "import sysconfig; print('lib.' + sysconfig.get_platform() +
		'-cpython-' + sysconfig.get_python_version().replace('.', ''))") || die
	cd "${BUILD_DIR}/build${#DISTUTILS_WHEELS}/${PY_BUILD_DIR}" || die
	NUMBA_ENABLE_CUDASIM=1 epytest --pyargs numba.runtests -- numba.tests
}
