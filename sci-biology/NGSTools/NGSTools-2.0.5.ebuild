# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2 eutils

S="${PV/-/_}"

DESCRIPTION="Next Generation Sequencing Eclipse Plugin (CNV and indel discovery), aka NGSEP"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home"
SRC_URI="http://sourceforge.net/projects/ngsep/files/SourceCode/NGSTools_2.0.5.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-util/eclipse-sdk"
RDEPEND="${DEPEND}"
