# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Fast implementation of several recombination jet algorithms"
HOMEPAGE="http://www.lpthe.jussieu.fr/~salam/fastjet/"
SRC_URI="http://www.lpthe.jussieu.fr/~salam/fastjet/repo/${PF}.tar.gz"

LICENSE="GPL-2 QPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+allplugins +allcxxplugins cgal doc static-libs"

RDEPEND="cgal? ( sci-mathematics/cgal )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if use allplugins || use allcxxplugins; then
		echo
		elog "Will build all plugins since you have one of allplugins or allcxxplugins set."
		elog "The following plugins are available:"
		elog "  - siscone"
		elog "  - cdfcones"
		elog "  - pxcone"
		elog "  - d0runiicone"
		elog "  - nesteddefs"
		elog "  - trackjet"
		elog "  - atlascone"
		elog "  - cmsiterativecone"
		elog "  - eecambridge"
		elog "  - jade"
		echo
	fi
}

src_configure() {
	econf \
		$(use_enable allplugins) \
		$(use_enable allcxxplugins) \
		$(use_enable cgal) \
		$(use_enable static-libs static)
#		--enable-siscone \
#		--enable-cdfcones \
#		--enable-pxcone \
#		--enable-d0runiicone \
#		--enable-nesteddefs \
#		--enable-trackjet \
#		--enable-atlascone \
#		--enable-cmsiterativecone \
#		--enable-eecambridge \
#		--enable-jade
}

src_compile() {
	default_src_compile
	if use doc; then
		$(type -p doxygen) Doxyfile || die
	fi
}

src_install() {
	default_src_install
	nonfatal dodoc AUTHORS BUGS ChangeLog NEWS README
	if use doc; then
		dohtml html/*
	fi
	if ! use static-libs; then
		find "${D}" -name '*.la' -exec rm -f {}
	fi
}
