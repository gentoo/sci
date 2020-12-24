# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="http://nipy.sourceforge.net/nipype/"
SRC_URI="https://github.com/nipy/nipype/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/prov[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		${RDEPEND}
		)
"
# Dependency disabled as upstream test configuration which requires it fails
#dev-python/pytest-xdist[${PYTHON_USEDEP}]

RDEPEND="
	>=dev-python/click-6.6[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/pydotplus[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
"
#etelemetry and neurdflib

src_prepare() {
	sed -i \
		-e "/def test_no_et(tmp_path):/i@pytest.mark.skip('Known to fail by upstream: https://github.com/nipy/nipype/issues/3196#issuecomment-606003186')" \
		nipype/tests/test_nipype.py || die
	sed -i \
		-e "/def test_fslversion():/i@pytest.mark.skip('Known to fail by upstream: https://github.com/nipy/nipype/issues/3196#issuecomment-605997462')" \
		nipype/interfaces/fsl/tests/test_base.py || die
	default
}

python_test() {
	NIPYPE_NO_ET=1 pytest -vv\
		|| die
	# Upstream test configuration fails
		#-c nipype/pytest.ini\
		#--doctest-modules nipype\
		#--cov nipype\
		#--cov-config .coveragerc\
		#--cov-report xml:cov.xml\
}
