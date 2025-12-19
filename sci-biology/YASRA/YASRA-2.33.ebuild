# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Yet Another Short Read Assembler aligning to a reference using LASTZ"
HOMEPAGE="http://www.bx.psu.edu/miller_lab/"
SRC_URI="http://www.bx.psu.edu/miller_lab/dist/YASRA-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sci-biology/lastz"
