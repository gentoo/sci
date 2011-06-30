# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit elisp-common eutils versionator

DESCRIPTION="Language for scientific computing and rapid prototyping"
HOMEPAGE="http://yorick.sourceforge.net/"
IUSE="emacs"
SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SRC_URI="mirror://sourceforge/yorick/${P}.tgz"
DEPEND="x11-proto/xproto
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2 )"

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch
}

src_configure() {
	:
}

src_compile() {
	# makefiles are not robust. (not interested in fixing)
	make prefix=/usr ysite Y_HOME=/usr/$(get_libdir)/yorick
	make config
	emake -j1 || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" \
		Y_BINDIR="${D}"/usr/bin \
		Y_DOCDIR="${D}"/usr/share/doc/${PF} \
		Y_INCDIR="${D}"/usr/include/${PN} \
		install || die "emake install failed"

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
