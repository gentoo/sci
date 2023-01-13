# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python library for accessing 2bit files"
HOMEPAGE="https://github.com/dpryan79/py2bit"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dpryan79/py2bit"
else
	SRC_URI="https://github.com/dpryan79/py2bit/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="sci-libs/lib2bit"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

python_test() {
	epytest "py2bitTest/test.py"
}
