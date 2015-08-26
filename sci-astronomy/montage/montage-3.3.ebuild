# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

MYP=Montage_v${PV}

DESCRIPTION="Astronomical image mosaic engine"
HOMEPAGE="http://montage.ipac.caltech.edu/"
SRC_URI="http://montage.ipac.caltech.edu/download/${MYP}.tar.gz
	doc? ( http://montage.ipac.caltech.edu/docs/docs.tar.gz -> ${PN}-docs.tar.gz )"

LICENSE="Montage"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

IUSE="doc mpi"

# unfortunate upstream patching, cfitsio, wcstools, jpeg
# see docs/ExternalLibraries

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc48.patch
	use doc && mv "${WORKDIR}"/docs/* docs/
	tc-export CC AR

	find . -name Makefile\* | xargs sed -i \
		-e "/^CC.*=/s:\(gcc\|cc\):$(tc-getCC):g" \
		-e "/^CFLAGS.*=/s:-g:${CFLAGS}:g" \
		-e "s:ar q:$(tc-getAR) q:g"  || die

	if use mpi; then
		sed -i \
			-e 's:# MPICC:MPICC:' \
			-e 's:# BINS:BINS:' \
			Montage/Makefile || die
	fi
}

src_install () {
	dobin bin/*
	dodoc README ChangeHistory
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r docs/*
	fi
}
