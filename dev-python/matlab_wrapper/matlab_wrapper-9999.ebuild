# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="MATLAB wrapper for Python"
HOMEPAGE="https://github.com/mrkrd/matlab_wrapper"
EGIT_REPO_URI="https://github.com/mrkrd/${PN}.git git://github.com/mrkrd/${PN}.git"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
