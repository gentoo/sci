# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Provides a pure Python VXI-11 driver for controlling instruments over Ethernet"
HOMEPAGE="https://github.com/python-ivi/python-vxi11"
EGIT_REPO_URI="https://github.com/python-ivi/${PN}.git git://github.com/python-ivi/${PN}.git"

LICENSE="MIT"
SLOT="0"