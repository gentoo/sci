# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Compare BAM files from normal and tumor samples and report somatic SNPs"
HOMEPAGE="http://gmt.genome.wustl.edu"
SRC_URI="https://github.com/genome/somatic-sniper/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# git clone https://github.com/genome/somatic-sniper.git

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sys-libs/zlib
	sys-libs/ncurses:*
	sci-biology/samtools:0.1-legacy"
RDEPEND="${DEPEND}"

# contains bundled copy of samtools-0.1.6 but links using a static version
# cd /var/tmp/portage/sci-biology/somatic-sniper-1.0.4/work/somatic-sniper-1.0.4_build/build/src/exe/bam-somaticsniper && /usr/bin/cmake -E cmake_link_script CMakeFiles/bam-somaticsniper.dir/link.txt --verbose=1
# /usr/bin/x86_64-pc-linux-gnu-gcc  -Wall   -Wl,-O1 -Wl,--as-needed CMakeFiles/bam-somaticsniper.dir/main.c.o  -o ../../../../bin/bam-somaticsniper -rdynamic -lpthread -lpthread ../../lib/sniper/libsniper.a -lpthread -lm ../../../../vendor/samtools/libbam.a -lz

# contains build-common from git tree
