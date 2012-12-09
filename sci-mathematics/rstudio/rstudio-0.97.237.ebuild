# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils pam versionator fdo-mime java-pkg-2

# TODO
# * work out server (see package/linux/debian-control/*)
# * package gin and gwt
# * use dict from tree, linguas
# * use java-pkg-2 eclass and/or java-ant-2.eclass
# * do src_test (use junit from tree?)
# * fix the about/help/menu and get rid of license
# * desktop flag -> qt4 flag?
# * more prefix love

GWTVER=2.5.0.rc1
GINVER=1.5

DESCRIPTION="IDE for the R language"
HOMEPAGE="http://www.rstudio.org"
SRC_URI="https://github.com/${PN}/${PN}/tarball/v${PV} -> ${P}.tar.gz
	https://s3.amazonaws.com/${PN}-buildtools/gin-${GINVER}.zip
	https://s3.amazonaws.com/${PN}-buildtools/gwt-${GWTVER}.zip
	https://s3.amazonaws.com/${PN}-dictionaries/core-dictionaries.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+desktop server test"

QTVER=4.8
RDEPEND=">=dev-lang/R-2.11.1
	>=dev-libs/boost-1.42
	dev-libs/mathjax
	dev-libs/openssl
	>=virtual/jre-1.5
	x11-libs/pango
	desktop? (	>=x11-libs/qt-core-${QTVER}
				>=x11-libs/qt-dbus-${QTVER}
				>=x11-libs/qt-gui-${QTVER}
				>=x11-libs/qt-webkit-${QTVER}
				>=x11-libs/qt-xmlpatterns-${QTVER} )
	server? ( virtual/pam )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-java/ant-core
	>=virtual/jdk-1.5
	virtual/pkgconfig"
#	test? ( dev-java/junit:4 )

REQUIRED_USE="!server? ( desktop ) !desktop? ( server )"

src_unpack() {
	unpack ${P}.tar.gz gwt-${GWTVER}.zip
	mv rstudio-rstudio-* ${P}
	cd "${S}"
	mkdir -p src/gwt/lib/{gin,gwt} dependencies/common/dictionaries || die
	mv ../gwt-${GWTVER} src/gwt/lib/gwt/${GWTVER}
	unzip -qd src/gwt/lib/gin/${GINVER} "${DISTDIR}"/gin-${GINVER}.zip || die
	unzip -qd dependencies/common/dictionaries "${DISTDIR}"/core-dictionaries.zip || die
}

src_prepare() {
	find . -name .gitignore -delete
	# And now we fix src/gwt/build.xml since java's user preference class is
	# braindead and insists on writing where it is not allowed.
	# much thanks to http://www.allaboutbalance.com/articles/disableprefs/
	epatch "${FILESDIR}"/${P}-prefs.patch
	# change the install path, as by default everything is dumped right under
	# the prefix. After fixing install paths, now fix the source so the
	# program can find the moved resources.
	epatch "${FILESDIR}"/${PN}-paths.patch
	# Some gcc hardening options were added, however since we add
	# "-Wl,--as-needed" we end up with "-Wl,--as-needed;-Wl,-z,relro" which
	# leads to linker errors about unknown options, if we make it so the
	# as-needed option is the last option on the line, everything is fine.
	epatch "${FILESDIR}"/${PN}-linker_flags.patch
	# Adding -DDISTRO_SHARE=... to append-flags breaks cmake so using
	# this sed hack for now. ~RMH
	sed -i \
		-e "s|DISTRO_SHARE|\"share/${PN}\"|g" \
		src/cpp/server/ServerOptions.cpp \
		src/cpp/session/SessionOptions.cpp || die
	# use mathjax from system
	ln -s "${EPREFIX}"/usr/share/mathjax dependencies/common/mathjax
	# make sure icons and mime stuff are with prefix
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		CMakeGlobals.txt src/cpp/desktop/CMakeLists.txt || die
}

src_configure() {
	export RSTUDIO_VERSION_MAJOR=$(get_version_component_range 1)
	export RSTUDIO_VERSION_MINOR=$(get_version_component_range 2)
	export RSTUDIO_VERSION_PATCH=$(get_version_component_range 3)
	local mycmakeargs=(	-DDISTRO_SHARE=share/${PN} )
	if use server; then
		if use desktop; then
			mycmakeargs+=(
				-DRSTUDIO_INSTALL_FREEDESKTOP=ON
				-DRSTUDIO_TARGET=All )
		else
			mycmakeargs+=( -DRSTUDIO_TARGET=Server )
		fi
	else
		mycmakeargs+=(
			-DRSTUDIO_INSTALL_FREEDESKTOP=ON
			-DRSTUDIO_TARGET=Desktop
		)
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	if use server; then
		dopamd src/cpp/server/extras/pam/rstudio
		newinitd "${FILESDIR}"/rstudio-rserver.initd rstudio-rserver
	fi
}

pkg_postinst() {
	use desktop && fdo-mime_mime_database_update
	if use server; then
		enewgroup rstudio-server
		enewuser rstudio-server -1 -1 -1 rstudio-server
	fi
}

pkg_postrm() {
	use desktop && fdo-mime_mime_database_update
}
