# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils mercurial

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="http://g-octave.rafaelmartins.eng.br/"
EHG_REPO_URI="http://g-octave.rafaelmartins.eng.br/hg/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="svn test"

CDEPEND="( >=dev-lang/python-2.6 <dev-lang/python-3 )"
DEPEND="${CDEPEND}
	>=dev-python/docutils-0.6"
RDEPEND="${CDEPEND}
	svn? ( dev-python/pysvn )
	|| ( >=sys-apps/portage-2.1.7[-python3] <sys-apps/portage-2.1.7 )"

S="${WORKDIR}/hg"

PYTHON_MODNAME="g_octave"

src_prepare() {
	distutils_src_prepare
	if ! use svn; then
		rm -rf g_octave/svn/ || die 'failed to remove the Subversion stuff.'
		sed -i -e '/g_octave.svn/d' -e '/pysvn/d' setup.py \
			|| die 'failed to remove the SVN stuff from setup.py'
	fi
}

src_install() {
	distutils_src_install
	dohtml ${PN}.html
	doman ${PN}.1
}

src_test() {
	PYTHONPATH=. scripts/run_tests.py || die "test failed."
}
