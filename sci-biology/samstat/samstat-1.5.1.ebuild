# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Statistics of BAM/SAM files"
HOMEPAGE="http://samstat.sourceforge.net" # no https
SRC_URI="https://sourceforge.net/projects/samstat/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-biology/samtools:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )
