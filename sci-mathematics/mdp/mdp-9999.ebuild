# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils git-2

MY_P="${P/mdp/MDP}"
MY_P="${MY_P/_rc/RC}"

DESCRIPTION="Modular data processing framework for python"
HOMEPAGE="http://mdp-toolkit.sourceforge.net/index.html"
EGIT_REPO_URI="git://github.com/mdp-toolkit/mdp-toolkit.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="|| ( >=dev-python/numpy-1.1 >=sci-libs/scipy-0.5.2 )"

S="${WORKDIR}/${MY_P}"

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/src" "$(PYTHON)" -c "import mdp;mdp.test()"
	}
	python_execute_function testing
}
