# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Statistics of BAM/SAM files"
HOMEPAGE="http://samstat.sourceforge.net"
SRC_URI="http://sourceforge.net/projects/samstat/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-biology/samtools"
RDEPEND="${DEPEND}"
