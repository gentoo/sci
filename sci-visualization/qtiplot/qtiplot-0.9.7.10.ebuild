# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/qtiplot/qtiplot-0.9.7.7-r1.ebuild,v 1.1 2009/09/18 18:40:01 bicatali Exp $

EAPI=2
inherit eutils qt4 fdo-mime python

DESCRIPTION="Qt based clone of the Origin plotting package"
HOMEPAGE="http://soft.proindependent.com/qtiplot.html"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python doc bindist"

LANGS="de es fr ja ru sv"
for l in ${LANGS}; do
	IUSE="${IUSE} linguas_${l}"
done

# qwtplot3d much modified from original upstream
CDEPEND=">=x11-libs/qwt-5.2
	x11-libs/qt-opengl:4
	x11-libs/qt-qt3support:4
	x11-libs/qt-assistant:4
	x11-libs/qt-svg:4
	x11-libs/gl2ps
	>=dev-cpp/muParser-1.30
	>=dev-libs/boost-1.35.0
	>=sci-libs/liborigin-20090406:2
	!bindist? ( sci-libs/gsl )
	bindist? ( <sci-libs/gsl-1.10 )"

DEPEND="${CDEPEND}
	dev-util/pkgconfig
	python? ( dev-python/sip )
	doc? ( app-text/docbook-sgml-utils
		   app-text/docbook-xml-dtd:4.2 )"

RDEPEND="${CDEPEND}
	python? ( >=dev-lang/python-2.5
		dev-python/PyQt4[X]
		dev-python/pygsl
		sci-libs/scipy )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-syslibs.patch
	epatch "${FILESDIR}"/${P}-docbuild.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch
	has_version ">=dev-python/sip-4.8" && epatch "${FILESDIR}"/${P}-sip.patch

	python_version
	sed -i \
		-e "s:doc/${PN}/manual:doc/${PF}/html:" \
		-e "s:local/${PN}:$(get_libdir)/python${PYVER}/site-packages:" \
		qtiplot/qtiplot.pro || die " sed for qtiplot/qtiplot.pro failed"

	if ! use python; then
		sed -i \
			-e '/^SCRIPTING_LANGS += Python/d' \
			-e '/sipcmd/d' \
			qtiplot/qtiplot.pro || die "sed for python option failed"
	fi
	sed -i \
		-e '/INSTALLS.*.*documentation/d' \
		-e '/manual/d' \
		qtiplot.pro qtiplot/qtiplot.pro || die "sed for doc failed"

	# the lib$$suff did not work in the fitRational*.pro files
	sed -i \
		-e "s|/usr/lib\$\${libsuff}|/usr/$(get_libdir)|g" \
		fitPlugins/*/*.pro \
		|| die "sed fitRational* failed"

	for l in ${LANGS}; do
		if ! use linguas_${l}; then
			sed -i \
				-e "s:translations/qtiplot_${l}.ts::" \
				-e "s:translations/qtiplot_${l}.qm::" \
				qtiplot/qtiplot.pro || die
		fi
	done
	chmod -x qtiplot/qti_wordlist.txt
}

src_configure() {
	eqmake4
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		#doxygen Doxyfile || die "api building failed"
		cd manual
		emake || die "html docbook building failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die 'emake install failed'
	newicon qtiplot_logo.png qtiplot.png
	make_desktop_entry qtiplot "QtiPlot Scientific Plotting" qtiplot
	if use doc; then
		insinto /usr/share/doc/${PF}/html
		doins -r manual/html/* || die "install manual failed"
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	if use doc; then
		elog "On the first start, do Help -> Choose Help Folder"
		elog "and select /usr/share/doc/${PF}/html"
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
