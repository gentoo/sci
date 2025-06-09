# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="https://nipype.readthedocs.io/"
SRC_URI="https://github.com/nipy/nipype/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# Tests fail with numpy import error:
# https://github.com/nipy/nipype/issues/3626
RESTRICT="test"

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

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/looseversion[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pydot[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.4-no_etelemetry.patch"
)

src_prepare() {
	# Remove etelemetry
	# Doing this separately since the file is affected by another patch.
	sed -i '/"etelemetry/d' nipype/info.py requirements.txt || die

	# Mark failing tests
	sed -i \
		-e "/def test_no_et(tmp_path):/i@pytest.mark.skip('Known to fail by upstream: https://github.com/nipy/nipype/issues/3196#issuecomment-606003186')" \
		nipype/tests/test_nipype.py || die
	sed -i \
		-e "/def test_fslversion():/i@pytest.mark.skip('Known to fail by upstream: https://github.com/nipy/nipype/issues/3196#issuecomment-605997462')" \
		nipype/interfaces/fsl/tests/test_base.py || die
	default
}

python_install_all() {
	distutils-r1_python_install_all
	doenvd "${FILESDIR}/98nipype"
}

# Reported upstream:
# https://github.com/nipy/nipype/issues/3540
EPYTEST_DESELECT=(
	nipype/interfaces/tests/test_io.py::test_s3datagrabber_communication
)

python_test() {
	# Setting environment variable to disable etelemetry version check:
	# https://github.com/nipy/nipype/issues/3196#issuecomment-605980044
	NIPYPE_NO_ET=1 epytest
	# Upstream test configuration fails
		#-c nipype/pytest.ini\
		#--doctest-modules nipype\
		#--cov nipype\
		#--cov-config .coveragerc\
		#--cov-report xml:cov.xml\
}

pkg_postinst() {
	echo
	einfo "Please run the following commands if you"
	einfo "intend to use nipype from an existing shell:"
	einfo "source /etc/profile"
	echo
}
