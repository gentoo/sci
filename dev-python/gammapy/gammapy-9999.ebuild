# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1 eutils

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gammapy/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A Python package for gamma-ray astronomy"
HOMEPAGE="https://github.com/gammapy/gammapy"

LICENSE="BSD"
SLOT="0"
IUSE="doc"
DOCS=( README.rst )

RDEPEND="
	>=dev-python/astropy-0.4[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e '/import ah_bootstrap/d' -i setup.py || die "Removing ah_bootstrap failed"
}

python_compile_all() {
	if use doc; then
		python_export_best
		VARTEXFONTS="${T}"/fonts \
			MPLCONFIGDIR="${BUILD_DIR}" \
			PYTHONPATH="${BUILD_DIR}"/lib \
			esetup.py build_sphinx
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}" || die
	"${EPYTHON}" -c "import ${PN}, sys;r = ${PN}.test(verbose=True);sys.exit(r)" \
		|| die "tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	elog ""
	optfeature "Numerical Methods" sci-libs/scipy
	optfeature "Plotting" dev-python/matplotlib
	optfeature "Plotting Astronomical Images" dev-python/aplpy
	optfeature "Read/write CVS files" dev-python/pandas
	optfeature "Image Processing" sci-libs/scikits_image
	optfeature "Conversion helper functions" dev-python/rootpy

	# In science overlay:
	optfeature "Image photometry" dev-python/photutils
	optfeature "Image Utility Functions" dev-python/imageutils

	# Not packaged: Gammalib, ctools, sherpa, imfun, uncertainties, reproject
}
