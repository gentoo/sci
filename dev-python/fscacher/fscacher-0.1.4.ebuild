# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Cache results of operations on heavy file trees"
HOMEPAGE="https://github.com/con/fscacher"
SRC_URI="https://github.com/con/fscacher/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.4-coverage.patch"
)

distutils_enable_tests pytest
