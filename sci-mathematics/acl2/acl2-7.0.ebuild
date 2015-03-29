# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Industrial strength theorem prover"
HOMEPAGE="http://www.cs.utexas.edu/users/moore/acl2/"
SRC_URI="https://github.com/acl2/acl2/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="books"

DEPEND="
	dev-lisp/sbcl:=
	books? ( dev-lang/perl )"
RDEPEND="${DEPEND}"

src_compile() {
	emake LISP="sbcl --noinform --noprint \
		--no-sysinit --no-userinit --disable-debugger"

	if use books; then
		echo
		einfo "Building certificates ..."
		einfo "(this may take hours to finish)"
		emake regression
	fi
}

src_install() {
	SAVED_NAME=saved_acl2h
	sed -e "s:${S}:/usr/share/acl2:g" -i ${SAVED_NAME} || die
	if use books; then
		sed -e "/5/a export ACL2_SYSTEM_BOOKS=/usr/share/acl2/books/" \
			-i ${SAVED_NAME} || die
	fi
	dobin ${SAVED_NAME}
	dosym ${SAVED_NAME} /usr/bin/saved_acl2

	insinto /usr/share/acl2
	doins TAGS ${SAVED_NAME}.core
	if use books; then
		doins -r books
	fi
}
