# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils distutils-r1 git-r3

DESCRIPTION="Simple SQL analysis of python records"
HOMEPAGE="http://orbeckst.github.com/RecSQL/"
EGIT_REPO_URI="
	git://github.com/orbeckst/${PN}.git
	https://github.com/orbeckst/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
