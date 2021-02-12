# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Fast and easy statistical learning on NeuroImaging data"
HOMEPAGE="http://nilearn.github.io/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nilearn/nilearn"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+plot test"

# Tests attempt to download external data.
RESTRICT="test"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		)
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	plot? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"

# (Temporarily) commented out, since Gentoo sci-libs/scikit-learn decided it
# is a mess to maintain system joblib usage
#PATCHES=( "${FILESDIR}/0.4.1-bundled_joblib_test.patch" )

python_prepare_all() {
	# upstream is reluctant to *not* depend on bundled scikit-learn:
	# https://github.com/nilearn/nilearn/pull/1398
	# (Temporarily) commented out, since Gentoo sci-libs/scikit-learn decided it
	# is a mess to maintain system joblib usage
	#local f
	#for f in nilearn/{*/*/,*/,}*.py; do
	#	sed -r \
	#		-e '/^from/s/(sklearn|\.|)\.externals\.joblib/joblib/' \
	#		-e 's/from (sklearn|\.|)\.externals import/import/' \
	#	-i $f || die
	#done

	distutils-r1_python_prepare_all
}

python_test() {
	echo "backend: Agg" > matplotlibrc
	#MPLCONFIGDIR=. nosetests -v || die
	MPLCONFIGDIR=. pytest -vv || die
}
