# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="psico"

inherit distutils git-2

DESCRIPTION="Pymol ScrIpt COllection"
HOMEPAGE="https://github.com/speleo3/pymol-psico/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/speleo3/pymol-psico.git"

SLOT="0"
KEYWORDS=""
LICENSE="BSD-2"
IUSE="minimal"

RDEPEND="
	dev-python/numpy
	sci-biology/biopython
	sci-libs/mmtk
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
