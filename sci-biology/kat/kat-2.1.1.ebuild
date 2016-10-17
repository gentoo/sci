# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} ) # requires python >= 3.1

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
# contains bundled modified version of jellyfish-2.2.
