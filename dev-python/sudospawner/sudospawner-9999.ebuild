# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1 readme.gentoo

DESCRIPTION="Enables JupyterHub to run without being root"
HOMEPAGE="http://jupyter.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	app-admin/sudo
	dev-python/jupyterhub[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

python_prepare_all() {
	DOC_CONTENTS="Add sudo access to the sudospawner script and tell JupyterHub to use\n
	SudoSpawner	by adding the following to your jupyterhub_config.py:\n
	c.JupyterHub.spawner_class='sudospawner.SudoSpawner'
"

	distutils-r1_python_prepare_all
}

python_install_all() {
	readme.gentoo_create_doc
	distutils-r1_python_install_all
}
