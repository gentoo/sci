# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="ACL2 industrial strength theorem prover"
HOMEPAGE="http://www.cs.utexas.edu/users/moore/acl2/"
SRC_URI="http://www.cs.utexas.edu/users/moore/acl2/v${PV/\./-}/distrib/acl2.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lisp/sbcl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-sources"

src_compile() {
	emake LISP="sbcl --noinform --noprint" || die "emake failed"
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

pkg_postinst() {
	local BOOKSDIR="/usr/share/acl2/books"
	cd "${BOOKSDIR}"
	einfo
	einfo "Building certificates in ${BOOKSDIR} ..."
	einfo "(this may take hours to finish)"
	sleep 5
	emake || die
}
