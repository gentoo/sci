# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp-common eutils multilib versionator

DESCRIPTION="Language for scientific computing and rapid prototyping"
HOMEPAGE="http://yorick.sourceforge.net/"
SRC_URI="mirror://sourceforge/yorick/${P}.tgz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_configure() {
	:
}

src_compile() {
	# makefiles are not robust. (not interested in fixing)
	emake prefix=/usr ysite Y_HOME=/usr/$(get_libdir)/yorick
	emake config
	emake -j1
}

src_install() {
	emake \
		INSTALL_ROOT="${D}" \
		Y_BINDIR="${D}"/usr/bin \
		Y_DOCDIR="${D}"/usr/share/doc/${PF} \
		Y_INCDIR="${D}"/usr/include/${PN} \
		install

	if use emacs; then
		mv emacs/yorick-auto.el emacs/64yorick-gentoo.el
		elisp-install ${PN} emacs/yorick.el || die
		elisp-site-file-install emacs/64yorick-gentoo.el || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
