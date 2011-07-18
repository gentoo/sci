# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.5:2.7 3:3.1:3.2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4"

inherit distutils

MY_P="${P/mdp/MDP}"
MY_P="${MY_P/_rc/RC}"

DESCRIPTION="Data processing framework in python"
HOMEPAGE="http://mdp-toolkit.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/mdp-toolkit/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=dev-python/numpy-1.1 >=sci-libs/scipy-0.5.2 )"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/src" "$(PYTHON)" -c "import mdp;mdp.test()"
	}
	python_execute_function testing
}
