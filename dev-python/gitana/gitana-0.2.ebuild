# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1 eutils

DESCRIPTION="SQL-based Git Repository Inspector"
HOMEPAGE="https://github.com/SOM-Research/Gitana"
SRC_URI="https://github.com/SOM-Research/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~x86"

# problem with https://github.com/SOM-Research/Gitana/issues/5
# wait for release of git-python version 2.0.9 and update as soon as possible

DEPEND="dev-python/git-python:0[${PYTHON_USEDEP}]
	dev-python/mysql-connector-python:0[${PYTHON_USEDEP}]
	dev-python/networkx:0[${PYTHON_USEDEP}]
	dev-python/pillow:0[tk,${PYTHON_USEDEP}]
	dev-python/PyGithub:0[${PYTHON_USEDEP}]
	dev-python/python-bugzilla:0[${PYTHON_USEDEP}]
	dev-python/simplejson:0[${PYTHON_USEDEP}]
	>=dev-vcs/git-1.9.4
	>=virtual/mysql-5.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Gitana-${PV}"

# fixes python compiler issues
# fixes tk full-qualified import issues
# fixes path handling
# adds additional text fields in GUI
# fixes multi-thread handling
PATCHES=(
	"${FILESDIR}/${PV}/case_study.py.patch"
	"${FILESDIR}/${PV}/db2json_gui.py.patch"
	"${FILESDIR}/${PV}/git2db.py.patch"
	"${FILESDIR}/${PV}/git2db_gui.py.patch"
	"${FILESDIR}/${PV}/gitana.py.patch"
	"${FILESDIR}/${PV}/gitana_gui.py.patch"
	"${FILESDIR}/${PV}/gitquerier_gitpython.py.patch"
	"${FILESDIR}/${PV}/init_dbschema.py.patch"
	"${FILESDIR}/${PV}/updatedb_gui.py.patch"
	"${FILESDIR}/${PV}/updatedb.py.patch"
)

src_prepare() {
	cp "${FILESDIR}/${PV}/init.py" "${S}/__init__.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/init__.py' to '${S}/__init.py'"
	cp "${FILESDIR}/${PV}/setup.py" "${S}/setup.py" \
		|| die "Could not copy '${FILESDIR}/${PV}/setup.py' to '${S}/setup.py'"
	# patches are applied by distutils-r1.eclass
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
	# install config file
	dodir /etc/
	local MY_SITEDIR=$(python_get_sitedir)
	local MY_FILE="${MY_SITEDIR}/${PN}/config_db.py"
	local MY_CONF="/etc/gitana_db.conf"
	mv "${ED}${MY_FILE}" "${ED}${MY_CONF}" \
		|| die "Could not move '${ED}${MY_FILE}' to '${ED}${MY_CONF}"
	dosym "${MY_CONF}" "${MY_FILE}"
	ewarn "Please edit ${EPREFIX}/etc/gitana_db.conf" \
		" with settings for your MySQL server."
}
