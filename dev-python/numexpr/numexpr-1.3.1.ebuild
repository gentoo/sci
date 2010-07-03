# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Fast numerical array expression evaluator for Python and NumPy."
HOMEPAGE="http://code.google.com/p/numexpr/ http://pypi.python.org/pypi/numexpr"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/numpy-1.3.1"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-0.6_rc3
	>=dev-util/scons-1.2.0-r1"

RESTRICT_PYTHON_ABIS="3.*"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" ${PN}/tests/test_${PN}.py
	}
	python_execute_function testing
}
