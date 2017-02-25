# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 git-r3

DESCRIPTION="Python bindings for ArrayFire"
HOMEPAGE="http://www.arrayfire.com"
EGIT_REPO_URI="https://github.com/arrayfire/${PN}.git git://github.com/arrayfire/${PN}.git"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=sci-libs/arrayfire-3.0.0
	"
DEPEND="${RDEPEND}"
