# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 git-r3

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="http://nipy.sourceforge.net/nipype/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nipype"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/prov[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-2.0.1[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
	$(python_gen_cond_dep 'dev-python/configparser[${PYTHON_USEDEP}]' python2_7)
	"
RDEPEND="
	>=dev-python/click-6.6[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pydotplus[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	>=dev-python/traits-4.6.0[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	distutils-r1_python_prepare_all
	EXISTING_REQUIRE="setup_requires=\['future', 'configparser'\]"
	CORRECTED_REQUIRE="setup_requires=\['future'\]"
	sed \
		-e "s/${EXISTING_REQUIRE}/${CORRECTED_REQUIRE}/g" \
		-i setup.py \
		|| die "sed setup.py"
}

python_test() {
	nosetests -v || die
}
