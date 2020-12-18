# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

MY_PN="gpib_ctypes"

DESCRIPTION="Cross-platform Python bindings for the NI GPIB and linux-gpib C interfaces"
HOMEPAGE="https://github.com/tivek/gpib_ctypes"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

distutils_enable_tests pytest
# exception: No module named 'sphinx.apidoc' even if sphinxcontrib-apidoc is installed
#distutils_enable_sphinx docs dev-python/sphinxcontrib-apidoc

python_prepare_all() {
	# do not depend on pytest-runner
	sed -i -e '/pytest-runner/d' setup.py || die

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	elog "You'll need a GPIB driver to use this package, either the proprietary sci-ni/ni_4882 from National Instruments or the open-source sci-libs/linux-gpib (which also includes it's own python bindings)"
}
