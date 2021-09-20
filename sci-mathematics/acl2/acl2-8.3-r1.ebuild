# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common

DESCRIPTION="Industrial strength theorem prover"
HOMEPAGE="https://www.cs.utexas.edu/users/moore/acl2/"
SRC_URI="https://github.com/acl2/acl2/archive/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="books doc emacs"

BDEPEND="
	dev-lisp/sbcl
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="
	dev-lisp/sbcl:=
	books? ( dev-lang/perl )
	doc? ( dev-lang/perl )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-use_make_variable.patch )

src_prepare() {
	find . -type f -name "*.bak" -delete
	find . -type f -name "*.orig" -delete
	# Remove sparc binary inadvertently included in upstream
	rm books/workshops/2003/schmaltz-al-sammane-et-al/support/acl2link || die
	default
}

src_compile() {
	emake LISP="sbcl --noinform --noprint \
		--no-sysinit --no-userinit --disable-debugger"

	if use books; then
		emake "ACL2=${S}/saved_acl2" basic
	fi

	if use doc; then
		emake "ACL2=${S}/saved_acl2" DOC
	fi

	if use emacs; then
		elisp-compile emacs/*.el
	fi
}

src_install() {
	local SAVED_NAME=saved_acl2
	sed -e "s:${S}:/usr/share/acl2:g" -i ${SAVED_NAME} || die
	dobin ${SAVED_NAME}

	insinto /usr/share/acl2
	doins ${SAVED_NAME}.core
	if use books; then
		sed -e "/5/a export ACL2_SYSTEM_BOOKS=/usr/share/acl2/books/" \
			-i ${SAVED_NAME} || die
		doins -r books
	fi

	DOCS=( books/README.md )
	if use doc; then
		HTML_DOCS=( doc/HTML/. )
	fi
	einstalldocs

	if use emacs; then
		elisp-install ${PN} emacs/*{.el,elc}
		doins TAGS
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
