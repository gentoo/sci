# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="Saves and loads to the cache a transformed versions of a source object."
HOMEPAGE="https://github.com/hgrecco/flexcache"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hgrecco/flexcache"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

DEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest
