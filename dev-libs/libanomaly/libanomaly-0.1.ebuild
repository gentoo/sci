# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Provides implementations of features common to most anomaly detectors"
HOMEPAGE="http://www.cs.ucsb.edu/~seclab/projects/libanomaly/index.html"
SRC_URI="http://www.cs.ucsb.edu/~seclab/projects/libanomaly/downloads/${P}.tar.gz
		doc? ( http://www.cs.ucsb.edu/~seclab/projects/libanomaly/downloads/${PN}-docs.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}/${P}-gcc4_compat.patch"
}

src_install(){
	emake install DESTDIR="${D}" || die "emake install failed"

	if use doc; then
		dohtml -r "${WORKDIR}"/libAnomaly/doc/html/*
	fi
}
