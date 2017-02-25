# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="http://www.g-octave.org/"
SRC_URI=""
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/g-octave.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="sys-apps/portage"

S="${WORKDIR}/${PN}"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	${PYTHON} scripts/run_tests.py || die
}

python_install_all() {
	doman ${PN}.1
	use doc && HTML_DOCS=( docs/_build/html/. )
	HTML_DOCS+=( ${PN}.html )
	distutils-r1_python_install_all
}
