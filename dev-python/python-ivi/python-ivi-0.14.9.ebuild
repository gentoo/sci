# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Python-based interpretation of the Interchangeable Virtual Instrument standard"
HOMEPAGE="https://github.com/python-ivi/python-ivi"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git git://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	|| (
		dev-python/python-vxi11[${PYTHON_USEDEP}]
		sci-libs/linux-gpib
	)
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
