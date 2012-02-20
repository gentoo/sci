# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils
[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="A simple library for making your data dimensionful"
HOMEPAGE="https://github.com/caseywstark/dimensionful"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="git://github.com/caseywstark/dimensionful.git"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-python/sympy"

src_test() {
	testing() {
		local t
		for t in test/test_*.py; do
			PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)"  "$(PYTHON)" "${t}" || die
		done
	}
	python_execute_function testing
}
