# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 optfeature

DESCRIPTION="Pymol ScrIpt COllection"
HOMEPAGE="https://github.com/speleo3/pymol-psico/"
SRC_URI="https://github.com/speleo3/pymol-psico/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2"

S="${WORKDIR}/pymol-psico-${PV}"

RDEPEND="
	sci-chemistry/pymol[${PYTHON_USEDEP}]
"

pkg_post_inst() {
	optfeature sci-libs/mmtk "Normal modes via mmtk"
}
