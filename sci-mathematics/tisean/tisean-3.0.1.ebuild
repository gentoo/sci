# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

MY_P="Tisean_${PV}"

DESCRIPTION="Time series alanalytics with theory of nonliner deterministic dynamical systems"
HOMEPAGE="
	https://github.com/heggus/Tisean
	http://www.mpipks-dresden.mpg.de/%7Etisean/Tisean_3.0.1/index.html"
SRC_URI="http://www.mpipks-dresden.mpg.de/~tisean/TISEAN_3.0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	tc-export FC CC
	epatch \
		"${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}"/${P}-backport.patch
}

src_configure() {
	econf \
		--prefix="${ED}/usr"
}

src_install() {
	dodir /usr/bin
	default
}

pkg_postinst() {
	optfeature "plotting support" sci-visualization/gnuplot
}
