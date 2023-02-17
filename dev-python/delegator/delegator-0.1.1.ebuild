# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Subprocesses for Humans 2.0."
HOMEPAGE="https://github.com/amitt001/delegator.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}.py/${PN}.py-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pexpect[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}.py-${PV}"
