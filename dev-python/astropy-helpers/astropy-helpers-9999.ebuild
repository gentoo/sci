# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1 git-r3

DESCRIPTION="Helpers for Astropy and Affiliated packages"
HOMEPAGE="https://github.com/astropy/astropy-helpers"
EGIT_REPO_URI="https://github.com/astropy/${PN}.git"

LICENSE="BSD"
SLOT="0"
IUSE=""

python_prepare_all() {
	sed -e '/import ah_bootstrap/d' -i setup.py || die "Removing ah_bootstrap failed"
	distutils-r1_python_prepare_all
}
