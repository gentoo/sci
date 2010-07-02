# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

MY_PV="1278015626"
INFO_REV="1"
#PATCHES_REV="1"

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="http://g-octave.rafaelmartins.eng.br/"

SRC_URI="http://g-octave.rafaelmartins.eng.br/distfiles/releases/${P}.tar.gz
	http://g-octave.rafaelmartins.eng.br/distfiles/db/octave-forge-${MY_PV}.db.tar.gz
	http://g-octave.rafaelmartins.eng.br/distfiles/db/info-${MY_PV}-${INFO_REV}.json"
	#http://g-octave.rafaelmartins.eng.br/distfiles/db/patches-${MY_PV}-${PATCHES_REV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="svn test"

DEPEND="( >=dev-lang/python-2.6 <dev-lang/python-3 )"
RDEPEND="${DEPEND}
	svn? ( dev-python/pysvn )
	|| ( >=sys-apps/portage-2.1.7[-python3] <sys-apps/portage-2.1.7 )"

PYTHON_MODNAME="g_octave"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	distutils_src_prepare
	sed -i -e 's/^has_fetch.*$/has_fetch = False/' scripts/g-octave \
		|| die 'failed to patch the g-octave main script'
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

pkg_postinst() {
	distutils_pkg_postinst
	elog
	elog 'To be able to use g-octave with the shipped package database, please'
	elog 'edit your configuration file, clean your db directory and run:'
	elog "    emerge --config =${PF}"
	elog
}

pkg_config() {
	local db="$(g-octave --config db)"
	mkdir -p "${db}"
	elog "Copying g-octave database files to: ${db}"
	cp "${DISTDIR}/octave-forge-${MY_PV}.db.tar.gz" "${db}/" \
		|| die "failed to copy octave-forge-${MY_PV}.db.tar.gz"
	cp "${DISTDIR}/info-${MY_PV}-${INFO_REV}.json" "${db}/" \
		|| die "failed to copy info-${MY_PV}-${INFO_REV}.json"
	#cp "${DISTDIR}/patches-${MY_P}-${PATCHES_REV}.tar.gz" "${db}/" \
	#	|| die "failed to copy patches-${MY_P}-${PATCHES_REV}.tar.gz"
}
