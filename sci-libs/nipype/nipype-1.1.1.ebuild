# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="http://nipy.sourceforge.net/nipype/"
SRC_URI="https://github.com/nipy/nipype/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	~dev-python/prov-1.5.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		${RDEPEND}
		)
	$(python_gen_cond_dep '
		dev-python/futures[${PYTHON_USEDEP}]
		dev-python/configparser[${PYTHON_USEDEP}]' python2_7)
	"
RDEPEND="
	>=dev-python/click-6.6[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/pydotplus[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	virtual/python-funcsigs[${PYTHON_USEDEP}]
	"

python_test() {
	py.test -v --cov nipype\
		--cov-config .coveragerc\
		--cov-report xml:cov.xml\
		-c nipype/pytest.ini\
		--doctest-modules nipype\
		|| die
}
