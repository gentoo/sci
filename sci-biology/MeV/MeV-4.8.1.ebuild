# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#MY_PV="${PV/./_/}"
MY_PV="4_8_1"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Multiple experiment Viewer for genomic data analysis"
HOMEPAGE="http://mev-tm4.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/project/mev-tm4/mev-tm4/MeV%204.8.1/MeV_4_8_1_r2727_linux.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"_"${MY_PV}"
