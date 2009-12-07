# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Frobby is a software system and project for computations with monomial ideals"
HOMEPAGE="http://www.broune.com/frobby/"
SRC_URI="http://www.broune.com/frobby/frobby_v0.8.2.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="dev-libs/gmp[-nocxx]
		doc? ( virtual/latex-base )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/frobby_v0.8.2"

src_prepare() {
	cd "${S}"
	# Fixing latex call in doc creation
	epatch "${FILESDIR}/frobby-0.8.2-doc.patch"
	# Patches contributed by Dan Grayson
	epatch "${FILESDIR}/patch-0.8.2"
}

src_compile() {
	emake || die "compile failed"
	emake library || die "making libfrobby failed"
	if use doc; then
		#those latex loops dont parallelize well
		emake -j1 doc || die "failed creating documentation"
	fi
}

src_install() {
	dobin bin/frobby
	dolib.a bin/libfrobby.a
	insinto /usr/include
	doins src/frobby.h
	dodir /usr/include/frobby
	insinto /usr/include/frobby
	doins src/stdinc.h
	if use doc; then
		dodoc bin/manual.pdf
		dodoc bin/manual.pdf
	fi
}
