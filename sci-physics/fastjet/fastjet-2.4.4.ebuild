# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="Fast implementation of several longitudinal invariant sequential
recombination jet algorithms"
HOMEPAGE="http://www.lpthe.jussieu.fr/~salam/fastjet/"
SRC_URI="http://www.lpthe.jussieu.fr/~salam/fastjet/repo/${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+allplugins +allcxxplugins cgal"

DEPEND="cgal? ( sci-mathematics/cgal )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use allplugins || use allcxxplugins; then
		elog
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
		elog
	fi
}

src_configure() {
	econf \
		$(use_enable allplugins) \
		$(use_enable allcxxplugins) \
		$(use_enable cgal) \
		--enable-siscone \
		--enable-cdfcones \
		--enable-pxcone \
		--enable-d0runiicone \
		--enable-nesteddefs \
		--enable-trackjet \
		--enable-atlascone \
		--enable-cmsiterativecone \
		--enable-eecambridge \
		--enable-jade
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
