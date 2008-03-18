# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils versionator elisp-common

DESCRIPTION="A language for scientific computing and rapid prototyping"
HOMEPAGE="http://yorick.sourceforge.net/ http://www.maumae.net/yorick/"
IUSE="emacs"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86"
SRC_URI="mirror://sourceforge/yorick/${P}.tgz"
DEPEND="emacs? ( virtual/emacs )"
S="${WORKDIR}/${PN}-$(get_version_component_range 1-2 )"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT=mirror

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch
}

src_compile() {
	make prefix=/usr ysite
	make config
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" \
		Y_BINDIR="${D}"/usr/bin \
		Y_DOCDIR="${D}"/usr/share/doc/${P} \
		Y_INCDIR="${D}"/usr/include/${PN} \
		install
	if use emacs; then
		mv emacs/yorick-auto.el emacs/64yorick-gentoo.el
		elisp-site-file-install emacs/yorick.el
		elisp-site-file-install emacs/64yorick-gentoo.el
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
