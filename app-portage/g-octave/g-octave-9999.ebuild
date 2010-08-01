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
IUSE="test"

DEPEND=">=dev-python/docutils-0.6"
RDEPEND="sys-apps/portage"

S="${WORKDIR}/${PN}"

PYTHON_MODNAME="g_octave"

src_install() {
	distutils_src_install
	dohtml ${PN}.html
	doman ${PN}.1
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" \
			scripts/run_tests.py || die 'test failed.'
	}
	python_execute_function testing
}
