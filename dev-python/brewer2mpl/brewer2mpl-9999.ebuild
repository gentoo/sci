# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 git-r3

DESCRIPTION="Connect colorbrewer2.org color maps to Python and matplotlib"
HOMEPAGE="https://github.com/jiffyclub/brewer2mpl"
EGIT_REPO_URI="https://github.com/jiffyclub/${PN}.git git://github.com/jiffyclub/${PN}.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
