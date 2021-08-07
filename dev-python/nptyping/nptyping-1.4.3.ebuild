# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Type hints for NumPy"
HOMEPAGE="https://pypi.org/project/nptyping"

# Prefer GitHub. Upstream failed to push its source tarball to PyPI.
SRC_URI="https://github.com/ramonhagenaars/nptyping/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/typish-1.7.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

#FIXME: Enabling tests requires packaging additional packages (e.g., "xenon").
RESTRICT="test"
