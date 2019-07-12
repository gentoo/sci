# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1 git-r3

DESCRIPTION="Python VISA bindings for GPIB, RS232, and USB instruments"
HOMEPAGE="https://github.com/pyvisa/pyvisa-py"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git git://github.com/${PN}/${PN}.git"

LICENSE="MIT"
SLOT="0"
IUSE="test"

python_test() {
	esetup.py test
}
