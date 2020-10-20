# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 git-r3

DESCRIPTION="Python VISA bindings for GPIB, RS232, and USB instruments"
HOMEPAGE="https://github.com/pyvisa/pyvisa-py"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git git://github.com/${PN}/${PN}.git"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}"

distutils_enable_tests unittest
#python_test() {
#	esetup.py test
#}
