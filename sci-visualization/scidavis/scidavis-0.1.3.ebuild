# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
QT4_BUILT_WITH_USE_CHECK="qt3support"
inherit eutils multilib qt4

DESCRIPTION="Scientific Data Analysis and Visualization"
HOMEPAGE="http://scidavis.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="python"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

CDEPEND="$(qt4_min_version 4.3)
	>=x11-libs/qwt-5.0
	>=x11-libs/qwtplot3d-0.2.7
	>=dev-cpp/muParser-1.28
	>=sci-libs/liborigin-20080225"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	python? ( >=dev-python/sip-4.7 )"

RDEPEND="${CDEPEND}
	python? ( >=dev-lang/python-2.5
		>=dev-python/PyQt4-4.3
		dev-python/pygsl
		sci-libs/scipy )"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT=mirror

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-profile.patch
	epatch "${FILESDIR}"/${P}-fitplugins.patch

	sed -e "s:doc/${PN}:doc/${PF}:" \
		-i ${PN}/${PN}.pro || die " sed for ${PN}/${PN}.pro failed"

	if ! use python; then
		sed -e '/^include( python.pri )$/d' \
			-i qtiplot/qtiplot.pro \
			|| die "sed for python option failed"
	fi

	# the lib$$suff did not work in the fitRational*.pro files
	sed -e "s|/usr/lib\$\${libsuff}|/usr/$(get_libdir)|g" \
		-i fitPlugins/fit*/fitRational*.pro \
		|| die "sed fitRational* failed"
}

src_compile() {
	eqmake4 || die "eqmake4 failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die 'emake install failed'
}
