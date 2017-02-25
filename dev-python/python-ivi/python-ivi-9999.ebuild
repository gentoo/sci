# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Python-based interpretation of the Interchangeable Virtual Instrument standard"
HOMEPAGE="https://github.com/python-ivi/python-ivi"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git git://github.com/${PN}/${PN}.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	|| (
		dev-python/python-vxi11[${PYTHON_USEDEP}]
		sci-libs/linux-gpib
	)
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
