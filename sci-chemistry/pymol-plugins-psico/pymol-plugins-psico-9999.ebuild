# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Pymol ScrIpt COllection"
HOMEPAGE="https://github.com/speleo3/pymol-psico/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/speleo3/pymol-psico.git"

SLOT="0"
KEYWORDS=""
LICENSE="BSD-2"
IUSE="minimal"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	!minimal? (
		media-libs/qhull
		media-video/mplayer
		sci-biology/stride
		sci-chemistry/dssp
		sci-chemistry/mm-align
		sci-chemistry/pdbmat
		sci-chemistry/theseus
		sci-chemistry/tm-align
		sci-mathematics/diagrtb
	)"

pkg_post_inst() {
	optfeature sci-libs/mmtk "Normal modes via mmtk"
}
