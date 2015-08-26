# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Barcode, MID tag and adapter sequence removal"
HOMEPAGE="https://sourceforge.net/p/flexbar/wiki/Manual"
SRC_URI="http://sourceforge.net/projects/flexbar/files/2.4/flexbar_v2.4_src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="dev-cpp/tbb
	>=sci-biology/seqan-1.4.1"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"/"${PN}"_v"${PV}"_src
