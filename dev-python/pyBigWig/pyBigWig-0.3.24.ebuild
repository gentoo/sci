# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1

DESCRIPTION="quick access to and creation of bigWig files"
HOMEPAGE="https://github.com/deeptools/pyBigWig"
SRC_URI="https://github.com/deeptools/pyBigWig/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REPEND="
	virtual/zlib:0=
	sci-biology/libBigWig
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	local pysite="${BUILD_DIR}"/install/${EPREFIX}/usr/lib/${EPYTHON}/site-packages
	ln -s "${S}"/pyBigWigTest/test.bigBed "${pysite}"/pyBigWigTest || die
	ln -s "${S}"/pyBigWigTest/test.bw "${pysite}"/pyBigWigTest || die
	epytest pyBigWigTest/test.py
}
