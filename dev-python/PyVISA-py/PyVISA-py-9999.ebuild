# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 git-r3

DESCRIPTION="Python VISA bindings for GPIB, RS232, and USB instruments"
HOMEPAGE="https://pyvisa-py.readthedocs.io"
EGIT_REPO_URI="https://github.com/hgrecco/${PN}.git git://github.com/${hgrecco}/${PN}.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/PyVISA-1.8[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
