# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Display short reads alignment, identify the genetic variation and associate with reference annotation"
HOMEPAGE="http://bioinformatics.zj.cn/magicviewer"
SRC_URI="http://59.79.168.90/soft/MagicViewer_1.2.1_x86_64_linux.tar.gz
		http://59.79.168.90/soft/MagicViewer_1.2.1_x86_32_linux.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND="${DEPEND}
		>=virtual/jre-1.6"

# TODO: install either contents from
#          MagicViewer_1.2.1_x86_32_linux/ subdir or MagicViewer_1.2.1_x86_64_linux/

