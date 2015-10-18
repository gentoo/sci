# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Provides a pure Python VXI-11 driver for controlling instruments over Ethernet"
HOMEPAGE="https://github.com/python-ivi/python-vxi11"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python-ivi/${PN}.git git://github.com/python-ivi/${PN}.git"
else
	SRC_URI="https://github.com/python-ivi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
