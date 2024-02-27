EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1 pypi

DESCRIPTION="Labels for various aspects of a system architecture like CPU, etc."
HOMEPAGE="https://archspec.readthedocs.io/en/latest/index.html"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

