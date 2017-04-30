# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="iRODs plugins for >=htslib-1.4"
HOMEPAGE="https://github.com/samtools/htslib-plugins"
SRC_URI="https://github.com/samtools/htslib-plugins/archive/201609.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=sci-libs/iRODS-3"
RDEPEND="${DEPEND}"
