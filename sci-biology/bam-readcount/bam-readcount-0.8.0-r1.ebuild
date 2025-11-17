# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Count DNA sequence reads in BAM files and other statistics calculations"
HOMEPAGE="https://github.com/genome/bam-readcount"
SRC_URI="https://github.com/genome/bam-readcount/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
