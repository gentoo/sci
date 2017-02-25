# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp-common versionator

XTOM_VERSION=1r1p4

PV1=$(get_version_component_range 1-2 )
PV2=$(get_version_component_range 3 )
PV1=$(replace_version_separator 1 'r' ${PV1} )
PV2=${PV1}p${PV2}

DESCRIPTION="System for computational discrete algebra"
HOMEPAGE="http://www.gap-system.org/"
SRC_URI="
	ftp://ftp.gap-system.org/pub/gap/gap44/tar.bz2/${PN}${PV2}.tar.bz2
	xtom? ( ftp://ftp.gap-system.org/pub/gap/gap44/tar.bz2/xtom${XTOM_VERSION}.tar.bz2 )"

SLOT="0"
IUSE="emacs vim-syntax xtom"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	emacs? ( virtual/emacs )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}${PV1}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" compile
}

src_test() {
	emake teststandard
}

src_install() {
	dodoc README description*
	insinto /usr/share/${PN}
	doins -r doc grp lib pkg prim small trans tst sysinfo.gap
	source sysinfo.gap
	exeinto /usr/libexec/${PN}
	doexe bin/${GAParch}/gap
	sed -e "s|@gapdir@|/usr/share/${PN}|" \
		-e "s|@target@-@CC@|/usr/libexec/${PN}|" \
		-e "s|@EXEEXT@||" \
		-e 's|$GAP_DIR/bin/||' \
		gap.shi > gap || doe
	dobin gap

	if use emacs ; then
		elisp-site-file-install etc/emacs/gap-mode.el
		elisp-site-file-install etc/emacs/gap-process.el
		elisp-site-file-install "${FILESDIR}"/64gap-gentoo.el
		dodoc etc/emacs/gap-mode.doc
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins etc/gap.vim
		insinto /usr/share/vim/vimfiles/indent
		newins etc/gap_indent.vim gap.vim
		insinto /usr/share/vim/vimfiles/plugin
		newins etc/debug.vim debug_gap.vim
		dodoc etc/README.vim-utils etc/debugvim.txt
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
