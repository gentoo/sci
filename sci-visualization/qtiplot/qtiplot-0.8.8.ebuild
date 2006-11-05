# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/qtiplot/qtiplot-0.8.5.ebuild,v 1.1 2006/05/26 14:58:54 cryos Exp $

inherit eutils multilib qt3

DESCRIPTION="Qt based clone of the Origin plotting package"
HOMEPAGE="http://soft.proindependent.com/qtiplot.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="python doc"

LANGUAGES="de es fr ru sv"
for LANG in ${LANGUAGES}; do
	IUSE="${IUSE} linguas_${LANG}"
done

SRC_URI="http://soft.proindependent.com/src/${P}.tar.bz2
	doc? ( http://soft.proindependent.com/doc/manual-en.zip
		linguas_es? ( http://soft.proindependent.com/doc/manual-es.zip ) )"

DEPEND="$(qt_min_version 3.3)
	=x11-libs/qwt-5*
	>=x11-libs/qwtplot3d-0.2.6
	>=sci-libs/gsl-1.6
	>=sys-libs/zlib-1.2.3
	sci-libs/liborigin
	dev-cpp/muParser
	python? ( =dev-lang/python-2.4* dev-python/PyQt dev-python/sip )"

pkg_setup() {
	if ! built_with_use x11-libs/qwt qt3; then
		eerror "qwt must be emerged with the USE flag qt3"
		die "This package needs qwt with USE=qt3"
	fi
}

src_unpack() {
	local TRANSLATIONS
	unpack ${A}
	cd "${S}"
	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" | sed -e 's|3rdparty/qwt||' > "${PN}.pro"
	cd qtiplot
	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" \
		| sed -e '/^[[:space:]#]*win32:/d' -e 's/^\([[:space:]]*\)unix:/\1/' \
		> "${PN}.pro"
	epatch "${FILESDIR}/${P}-qmake.patch" || die "epatch qtiplot.pro failed"
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" ${PN}.pro || die "sed failed."
	use python || sed -i -e 's/^#\(SCRIPTING_LANGS += Python\)/\1' "${PN}.pro"
	TRANSLATIONS=""
	for LANG in ${LANGUAGES}; do
		use "linguas_${LANG}" && TRANSLATIONS="${TRANSLATIONS} translations/qtiplot_${LANG}.ts"
	done
	sed -i -e "s|^\\(TRANSLATIONS =\\)|\\1${TRANSLATIONS}|" "${PN}.pro"
	cd src
	mv parser.h parser.h.orig
	tr -d '\r' <parser.h.orig >parser.h
	epatch "${FILESDIR}/${P}-parser.patch" || die "epatch parser.h failed"
	mv muParserScripting.h muParserScripting.h.orig
	tr -d '\r' <muParserScripting.h.orig >muParserScripting.h
	epatch "${FILESDIR}/${P}-muparserscripting.patch" || die "epatch muParserScripting.h failed"
	cd ../../fitPlugins/fitRational0
	mv fitRational0.pro fitRational0.pro.orig
	tr -d '\r' < fitRational0.pro.orig \
		| sed -e '/^[[:space:]#]*win32:/d' -e 's/^\([[:space:]]*\)unix:/\1/' \
		> fitRational0.pro
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' fitRational0.pro
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" fitRational0.pro
	cd ../fitRational1
	mv fitRational1.pro fitRational1.pro.orig
	tr -d '\r' < fitRational1.pro.orig \
		| sed -e '/^[[:space:]#]*win32:/d' -e 's/^\([[:space:]]*\)unix:/\1/' \
		> fitRational1.pro
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' fitRational1.pro
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" fitRational1.pro
}

src_compile() {
	${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake "${PN}.pro" || die 'qmake failed.'
	emake || die 'emake failed.'
}

src_install() {
	make_desktop_entry qtiplot qtiplot qtiplot Graphics
	dobin qtiplot/qtiplot || die 'Binary installation failed'
	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins -r "${WORKDIR}/manual-en"
		use linguas_es && doins -r "${WORKDIR}/manual-es"
	fi
}
