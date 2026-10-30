# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Quick access to bigBed files and access to and creation of bigWig files"
HOMEPAGE="https://github.com/deeptools/pyBigWig"
SRC_URI="https://github.com/deeptools/pyBigWig/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	net-misc/curl
	virtual/zlib:=
"
DEPEND="${RDEPEND}"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Require network access.
		pyBigWigTest/test.py::TestRemote
		pyBigWigTest/test.py::TestNumpy::testNumpyValues
	)
	local testdir="${BUILD_DIR}/install$(python_get_sitedir)/pyBigWigTest"
	cp "${S}"/pyBigWigTest/{test.bigBed,test.bw} "${testdir}" || die
	epytest pyBigWigTest/test.py
}
