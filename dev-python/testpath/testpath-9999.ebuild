# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Test utilities for code working with files and commands"
HOMEPAGE="http://jupyter.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"
else
	SRC_URI="https://github.com/jupyter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${P}"-setup.py.patch)
