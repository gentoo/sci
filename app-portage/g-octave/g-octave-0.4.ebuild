# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="*:2.6"

DB_COMMIT="cd6b664df376d50455efc19ad23a1463484f81f7"
DB_COMMIT_ID="cd6b664"
DB_DIR="rafaelmartins-${PN}-db-${DB_COMMIT_ID}"

inherit distutils

DESCRIPTION="A tool that generates and installs ebuilds for Octave-Forge"
HOMEPAGE="http://www.g-octave.org/"

SRC_URI="http://www.g-octave.org/releases/${P}.tar.gz
	http://github.com/rafaelmartins/${PN}-db/tarball/${DB_COMMIT} -> ${PF}-db.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="doc? ( >=dev-python/sphinx-1.0 )"
RDEPEND="sys-apps/portage"

PYTHON_MODNAME="g_octave"

src_prepare() {
	distutils_src_prepare
	sed -i -e 's/^has_fetch.*$/has_fetch = False/' scripts/g-octave \
		|| die 'failed to patch the g-octave main script'
}

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

pkg_postinst() {
	distutils_pkg_postinst
	elog
	elog 'To be able to use g-octave with the shipped package database, please'
	elog 'edit your configuration file, clean your db directory and run:'
	elog "    emerge --config =${PF}"
	elog
	elog "If you are upgrading from =${PN}-0.3, please read this:"
	elog 'http://doc.g-octave.org/0.4/upgrading/#from-0-3-to-0-4'
	elog
	elog 'Please install the package manager that you want to use before run g-octave'
	elog
}

pkg_config() {
	local db="$(g-octave --config db)"
	mkdir -p "${db}"
	einfo "Extracting g-octave database files to: ${db}"
	tar -xzf "${DISTDIR}/${PF}-db.tar.gz" -C "${db}" || die 'tar failed.'
	rm -rf "${db}"/{patches,octave-forge,info.json,timestamp}
	mv -f "${db}/${DB_DIR}"/* ${db} || die 'mv failed.'
	rm -rf "${db}/${DB_DIR}"
}
