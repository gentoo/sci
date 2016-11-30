# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} ) # https://github.com/Ensembl/Bio-DB-HTS/issues/30

inherit python-r1

DESCRIPTION="K-mer Analysis Toolkit (histogram, filter, compare sets, plot)"
HOMEPAGE="https://github.com/TGAC/KAT"
SRC_URI="https://github.com/TGAC/KAT/releases/download/Release-${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/boost:0
	dev-python/matplotlib
	sci-visualization/gnuplot"
RDEPEND="${DEPEND}"
# contains bundled modified version of jellyfish-2.2 which should install under different filenames

src_configure(){
	econf PYTHON_VERSION="${PYTHON_SINGLE_TARGET}"
}
