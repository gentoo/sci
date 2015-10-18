# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-r3

DESCRIPTION="Python library to read PDB, GRO or Gromacs XTC files"
HOMEPAGE="http://code.google.com/p/pmx"
EGIT_REPO_URI="https://code.google.com/p/${PN}.git"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

DEPEND="
	sci-chemistry/gromacs
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}"
