# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Industrial strength theorem prover"
HOMEPAGE="http://www.cs.utexas.edu/users/moore/acl2/"
SRC_URI="http://www.cs.utexas.edu/users/moore/${PN}/v${PV/\./-}/distrib/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lisp/sbcl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-sources"

src_compile() {
	emake LISP="sbcl --noinform --noprint" || die "emake failed"
	cd books
	einfo
	einfo "Building certificates..."
	einfo "(this may take hours to finish)"
	emake
}

src_install() {
	sed -ie "s:${S}:${EPREFIX}/usr/share/acl2:g" saved_acl2 || die
	dobin saved_acl2

	insinto /usr/share/acl2
	doins TAGS
#	insopts -m0755
	doins saved_acl2
	doins saved_acl2.core


	insinto /usr/share/acl2/
	doins -r books

	dohtml -r doc/HTML/*

	doinfo doc/EMACS/*
}
