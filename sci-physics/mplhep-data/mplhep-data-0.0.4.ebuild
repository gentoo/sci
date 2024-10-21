EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Data/font package for mplhep."
HOMEPAGE="
	https://mplhep.readthedocs.io
	https://github.com/scikit-hep/mplhep_data
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
