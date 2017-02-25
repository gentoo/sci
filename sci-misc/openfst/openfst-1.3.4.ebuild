# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib

DESCRIPTION="Finite State Transducer tools by Google et al"
HOMEPAGE="http://www.openfst.org"
SRC_URI="http://www.openfst.org/twiki/pub/FST/FstDownload/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}/kaldi.patch"
}

src_test() {
	einfo "make test can take a few hours on moderately modern systems"
	make test || die "check failed"
}
