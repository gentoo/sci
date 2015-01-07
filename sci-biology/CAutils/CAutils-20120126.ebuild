# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Additional utilities for Celera assembler (wgs-assembler) from UMD"
HOMEPAGE="http://www.cbcb.umd.edu/research/CeleraAssembler.shtml"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/CAutils.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl"

# is partially included in amos-3.1.0
