# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils multilib qt4

DESCRIPTION="Qt based clone of the Origin plotting package"
HOMEPAGE="http://soft.proindependent.com/qtiplot.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="python doc"

LANGUAGES="de es fr ja ru sv"

for LANG in ${LANGUAGES}; do
	IUSE="${IUSE} linguas_${LANG}"
done

SRC_URI="http://soft.proindependent.com/src/${P}.tar.bz2
	doc? ( http://soft.proindependent.com/doc/manual-en.tar.bz2
		linguas_es? ( http://soft.proindependent.com/doc/manual-es.zip ) )"

RDEPEND="$(qt4_min_version 4.2)
	>=x11-libs/qwt-5.0.2
	x11-libs/qwtplot3d
	sci-libs/gsl
	>=dev-cpp/muParser-1.28
	python? ( >=dev-lang/python-2.4
		>=dev-python/PyQt4-4.2
		dev-python/pygsl
		sci-libs/scipy )"

DEPEND="${RDEPEND}
	python? ( >=dev-python/sip-4.5.2 )
	doc? ( lingias_es? ( app-arch/unzip ) )"

pkg_setup() {
	if ! built_with_use x11-libs/qt qt3support; then
		eerror "qt-4 must be emerged with the USE flag qt3support"
		die "This package needs qt-4 with USE=qt3support"
	fi
}

src_unpack() {
	local TRANSLATIONS
	unpack ${A}
	cd "${S}"
	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" > "${PN}.pro"
	cd qtiplot
	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" \
		| sed -e '/^[[:space:]#]*win32:/d' -e '/^[[:space:]#]*mac:/d' \
		-e 's/^\([[:space:]]*\)unix:/\1/' \
		> "${PN}.pro"
	epatch "${FILESDIR}/${P}-qmake.patch" || die "epatch qtiplot.pro failed"
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' "${PN}.pro" || die "sed failed."
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" "${PN}.pro" || die "sed failed."
	use python && sed -i -e 's/^#\(SCRIPTING_LANGS += Python\)/\1/' "${PN}.pro"
	TRANSLATIONS=""
	for LANG in ${LANGUAGES}; do
		use "linguas_${LANG}" && TRANSLATIONS="${TRANSLATIONS} translations/qtiplot_${LANG}.ts"
	done
	sed -i -e "s|^\\(TRANSLATIONS =\\)|\\1${TRANSLATIONS}|" "${PN}.pro"
	cd ../fitPlugins/fitRational0
	mv fitRational0.pro fitRational0.pro.orig
	tr -d '\r' < fitRational0.pro.orig \
		| sed -e '/^[[:space:]#]*win32:/d' -e '/^[[:space:]#]*mac:/d' \
		-e 's/^\([[:space:]]*\)unix:/\1/' \
		> fitRational0.pro
	epatch "${FILESDIR}/${P}-fitRational0.patch" \
		|| die "epatch fitRational0.pro failed"
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' fitRational0.pro
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" fitRational0.pro
	cd ../fitRational1
	mv fitRational1.pro fitRational1.pro.orig
	tr -d '\r' < fitRational1.pro.orig \
		| sed -e '/^[[:space:]#]*win32:/d' -e '/^[[:space:]#]*mac:/d' \
		-e 's/^\([[:space:]]*\)unix:/\1/' \
		> fitRational1.pro
	epatch "${FILESDIR}/${P}-fitRational1.patch" \
		|| die "epatch fitRational1.pro failed"
	sed -i -e 's|/usr/lib$${libsuff}|_LIBDIR_|' fitRational1.pro
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" fitRational1.pro
}

src_compile() {
	qmake "${PN}.pro" || die 'qmake failed.'
	emake || die 'emake failed.'
}

src_install() {
	local PYTHONLIB
	make_desktop_entry qtiplot qtiplot qtiplot Graphics
	emake INSTALL_ROOT="${D}" install || die 'emake install failed'
	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins -r "${WORKDIR}/manual-en"
		use linguas_es && doins -r "${WORKDIR}/manual-es"
	fi
	if use python; then
		insinto /etc
		doins qtiplot/qtiplotrc.py
		PYTHONLIB=`python -c "from distutils import sysconfig; print sysconfig.get_python_lib()"`
		insinto "${PYTHONLIB}"
		doins qtiUtil.py
	fi
}
