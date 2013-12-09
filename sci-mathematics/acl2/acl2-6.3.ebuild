# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="ACL2 industrial strength theorem prover"
HOMEPAGE="http://www.cs.utexas.edu/users/moore/acl2/"
SRC_URI="http://www.cs.utexas.edu/users/moore/${PN}/v${PV/\./-}/distrib/${PN}.tar.gz -> ${P}.tar.gz
	 books? ( https://acl2-books.googlecode.com/files/books-${PV}.tar.gz
		workshops? ( http://acl2-books.googlecode.com/files/workshops-${PV}.tar.gz ) )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="books workshops html"
REQUIRED_USE="workshops? ( books )"

DEPEND="dev-lisp/sbcl
	books? ( dev-lang/perl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-sources"

src_unpack() {
	unpack ${A}
	if use books; then
		mv "${WORKDIR}/books" ${S}/
		use workshops && mv "${WORKDIR}/workshops" "${S}/books/"
	fi
}

src_compile() {
	emake LISP="sbcl --noinform --noprint" || die "emake failed"

	if use books; then
		einfo
		einfo "Building certificates ..."
		einfo "(this may take hours to finish)"
		emake regression || die "verify books failed"
	fi
}

src_install() {
	sed -e "s:${S}:/usr/share/acl2:g" -i saved_acl2 || die
	if use books; then
		sed -e "/5/a export ACL2_SYSTEM_BOOKS=/usr/share/acl2/books/" \
			-i saved_acl2 || die
	fi
	dobin saved_acl2

	insinto /usr/share/acl2
	insopts -m0644
	doins TAGS saved_acl2.core || die
	if use books; then
		doins -r books
	fi

	if use html; then
		dohtml -r doc/HTML || die
	fi
	doinfo doc/EMACS/* || die
}
