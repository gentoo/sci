# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="ACL2 industrial strength theorem prover"

HOMEPAGE="http://www.cs.utexas.edu/users/moore/acl2/"

SRC_URI="http://www.cs.utexas.edu/users/moore/acl2/v${PV/\./-}/distrib/acl2.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

#RESTRICT="strip"

DEPEND="dev-lisp/sbcl"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-sources"

src_prepare() {
	epatch "${FILESDIR}"/set-booksdir.patch
}

src_compile() {
	emake LISP="sbcl --noinform --noprint" || die "emake failed"
	cd books
	einfo
	einfo "Building certificates..."
	einfo "(this may take hours to finish)"
	sleep 5
	emake ACL2="${S}"/saved_acl2 || die
}

src_install() {
	sed -ie "s:${S}:/usr/share/acl2:g" saved_acl2
	insinto /usr/bin
	insopts -m0755
	doins saved_acl2

	insinto /usr/share/acl2
	doins TAGS || die
	insopts -m0755
	doins saved_acl2 || die
	doins saved_acl2.core || die

	dodir /usr/share/acl2/books
	cp -a books "${D}"/usr/share/acl2
	chmod --recursive a+rx "${D}"/usr/share/acl2/books

	dohtml doc/HTML/* || die

	doinfo doc/EMACS/* || die
}
