# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Python extension written in C for quick access to and creation of bigWig files"
HOMEPAGE="https://github.com/dpryan79/pyBigWig"
SRC_URI="https://github.com/dpryan79/pyBigWig/archive/0.3.4.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-biology/libBigWig"
RDEPEND="${DEPEND}"
