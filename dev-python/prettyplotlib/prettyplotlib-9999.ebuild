# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 git-r3

DESCRIPTION="Painlessly create beautiful matplotlib plots"
HOMEPAGE="http://blog.olgabotvinnik.com/prettyplotlib/"
EGIT_REPO_URI="https://github.com/olgabot/${PN}.git git://github.com/olgabot/${PN}.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	sci-libs/scipy[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.4.0[${PYTHON_USEDEP}]
	dev-python/brewer2mpl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
