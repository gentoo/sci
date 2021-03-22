# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Check, fix, merge, sort and extract GFF3 files"
HOMEPAGE="https://github.com/NAL-i5K/GFF3toolkit
	https://gff3toolkit.readthedocs.io"
SRC_URI="https://github.com/NAL-i5K/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

DEPEND="!minimal? ( sci-biology/ncbi-tools++ )"
RDEPEND="${DEPEND}"
BDEPEND=""
