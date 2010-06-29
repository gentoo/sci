# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="${P/mdp/MDP}"
MY_P="${MY_P/_rc/RC}"

DESCRIPTION="Data processing framework in python"
HOMEPAGE="http://mdp-toolkit.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/mdp-toolkit/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=dev-python/numpy-1.1 >=sci-libs/scipy-0.5.2 )"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_P}"

src_test() {
	PYTHONPATH="${S}/src" "${python}" -c "import mdp;mdp.test()" || die "tests failed"
}
