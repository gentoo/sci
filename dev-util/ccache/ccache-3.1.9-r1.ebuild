# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ccache/ccache-3.1.8.ebuild,v 1.9 2012/12/17 17:51:11 ago Exp $

EAPI="4"

inherit multilib eutils

DESCRIPTION="fast compiler cache"
HOMEPAGE="http://ccache.samba.org/"
SRC_URI="http://samba.org/ftp/ccache/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="clang icc"

RDEPEND="sys-libs/zlib
	clang? ( sys-devel/clang )
	icc? ( dev-lang/icc )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_prepare() {
	# make sure we always use system zlib
	rm -rf zlib
	epatch "${FILESDIR}"/${PN}-3.1.7-no-perl.patch #421609
	sed \
		-e "/^LIBDIR=/s:lib:$(get_libdir):" \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		"${FILESDIR}"/ccache-config-2 > ccache-config || die
}

src_install() {
	default
	dodoc AUTHORS.txt MANUAL.txt NEWS.txt README.txt

	dobin ccache-config
}

pkg_postinst() {
	"${EROOT}"/usr/bin/ccache-config --install-links
	"${EROOT}"/usr/bin/ccache-config --install-links ${CHOST}
	use icc && "${EROOT}"/usr/bin/ccache-config --install-links icc
	use clang && "${EROOT}"/usr/bin/ccache-config --install-links clang

	# nuke broken symlinks from previous versions that shouldn't exist
	rm -f "${EROOT}/usr/$(get_libdir)/ccache/bin/${CHOST}-cc"
	[[ -d "${EROOT}/usr/$(get_libdir)/ccache.backup" ]] && \
		rm -rf "${EROOT}/usr/$(get_libdir)/ccache.backup"

	elog "To use ccache with **non-Portage** C compiling, add"
	elog "/usr/$(get_libdir)/ccache/bin to the beginning of your path, before /usr/bin."
	elog "Portage 2.0.46-r11+ will automatically take advantage of ccache with"
	elog "no additional steps.  If this is your first install of ccache, type"
	elog "something like this to set a maximum cache size of 2GB:"
	elog "# ccache -M 2G"
	elog
	elog "If you are upgrading from an older version than 3.x you should clear"
	elog "all of your caches like so:"
	elog "# CCACHE_DIR='${CCACHE_DIR:-${PORTAGE_TMPDIR}/ccache}' ccache -C"
}
