# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Count DNA sequence reads in BAM files and other statistics calculations"
HOMEPAGE="https://github.com/genome/bam-readcount"
SRC_URI="https://github.com/genome/bam-readcount/archive/v0.8.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
