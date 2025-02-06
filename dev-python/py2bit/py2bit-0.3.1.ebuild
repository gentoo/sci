# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python library for accessing 2bit files"
HOMEPAGE="https://github.com/dpryan79/py2bit"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/deeptools/py2bit"
else
	SRC_URI="https://github.com/deeptools/py2bit/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="sci-libs/lib2bit"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.3.1-gcc14.patch" )

distutils_enable_tests pytest

python_test() {
	epytest "py2bitTest/test.py"
}
