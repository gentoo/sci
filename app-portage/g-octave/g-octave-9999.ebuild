# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*:2.6"

inherit distutils git

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="http://www.g-octave.org/"
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/g-octave.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND=">=dev-python/docutils-0.6
	doc? ( >=dev-python/sphinx-1.0 )"
RDEPEND="sys-apps/portage"

S="${WORKDIR}/${PN}"

PYTHON_MODNAME="g_octave"

src_compile() {
	distutils_src_compile
	if use doc; then
		emake -C docs html
	fi
}

src_install() {
	distutils_src_install
	dohtml ${PN}.html
	doman ${PN}.1
	if use doc; then
		mv docs/_build/{html,sphinx}
		dohtml -r docs/_build/sphinx
	fi
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" \
			scripts/run_tests.py || die 'test failed.'
	}
	python_execute_function testing
}
