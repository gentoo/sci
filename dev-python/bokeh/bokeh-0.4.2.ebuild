# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Statistical and interactive HTML plots for Python"
HOMEPAGE="http://bokeh.pydata.org/"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	>=dev-python/chaco-4.4[$(python_gen_usedep 'python2_7')]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/gevent-0.13.8[$(python_gen_usedep 'python2_7')]
	>=dev-python/gevent-websocket-0.3.6[$(python_gen_usedep 'python2_7')]
	>=dev-python/greenlet-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.23[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-0.18[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.11[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/pystache-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013b[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.7.6[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/traits-4.4[$(python_gen_usedep 'python2_7')]
	>=dev-python/werkzeug-0.9.1[${PYTHON_USEDEP}]
	>=virtual/python-argparse-1[${PYTHON_USEDEP}]
"

# testing server: needs websocket not in portage yet
#			>=dev-python/websocket[${PYTHON_USEDEP}]
DEPEND="${RDEPEND}
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/colorama-0.2.7[${PYTHON_USEDEP}]
	)
"
python_test() {
	cd "${BUILD_DIR}"/lib || die
	# exclude server tests for now
	nosetests -v \
		-e multiuser_auth_test \
		-e wsmanager_test \
		-e usermodel_test \
		|| die
}
