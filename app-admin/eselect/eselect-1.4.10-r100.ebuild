# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils bash-completion-r1

DESCRIPTION="Gentoo's multi-purpose configuration and management tool"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Eselect"
SRC_URI="http://dev.gentoo.org/~ulm/eselect/${P}.tar.xz"

LICENSE="GPL-2+ || ( GPL-2+ CC-BY-SA-3.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs vim-syntax"

RDEPEND="
	!app-eselect/eselect-blas
	!app-eselect/eselect-lapack
	|| (
		sys-apps/coreutils
		sys-freebsd/freebsd-bin
		app-misc/realpath
	)"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	doc? ( dev-python/docutils )"
RDEPEND="!app-admin/eselect-news
	${RDEPEND}
	sys-apps/file
	sys-libs/ncurses"

PDEPEND="emacs? ( app-emacs/eselect-mode )
	vim-syntax? ( app-vim/eselect-syntax )"

PATCHES=( "${FILESDIR}"/${P}-alternatives.patch )

src_prepare() {
	default
	AT_M4DIR="." eautoreconf
}

src_compile() {
	default
	use doc && emake html
}

src_install() {
	default
	newbashcomp misc/${PN}.bashcomp ${PN}
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
	use doc && dohtml *.html doc/*

	# needed by news module
	keepdir /var/lib/gentoo/news
	if use prefix; then
		sed -i \
			"s:ALTERNATIVESDIR_ROOTLESS=\"${EPREFIX}:ALTERNATIVESDIR_ROOTLESS=\":" \
			"${ED}"/usr/share/eselect/libs/alternatives-common.bash || die
	else
		fowners root:portage /var/lib/gentoo/news
		fperms g+w /var/lib/gentoo/news
	fi
}

pkg_postinst() {
	# fowners in src_install doesn't work for the portage group:
	# merging changes the group back to root
	if ! use prefix; then
		chgrp portage "${EROOT}/var/lib/gentoo/news" \
			&& chmod g+w "${EROOT}/var/lib/gentoo/news"
	fi
}
