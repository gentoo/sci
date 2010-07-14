# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*:2.6"

inherit distutils git

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="http://g-octave.rafaelmartins.eng.br/"
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/g-octave.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="svn test"

DEPEND=">=dev-python/docutils-0.6"
RDEPEND="sys-apps/portage
	svn? ( dev-python/pysvn )"

S="${WORKDIR}/${PN}"

PYTHON_MODNAME="g_octave"

src_prepare() {
	if ! use svn; then
		rm -rf g_octave/svn/ || die 'failed to remove the Subversion stuff.'
		sed -i -e '/g_octave.svn/d' -e '/pysvn/d' setup.py \
			|| die 'failed to remove the SVN stuff from setup.py'
	fi
	distutils_src_prepare
}

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
