# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Viewer and editor for GDS and OASIS integrated circuit layouts"
HOMEPAGE="http://www.klayout.de/"
SRC_URI="http://www.klayout.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ruby"

RDEPEND="x11-libs/qt-gui:4[qt3support]
	ruby? ( dev-lang/ruby )"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-configureonly.patch"

	# now we generate the stub build configuration file for the home-brew build system
	cp "${FILESDIR}/${P}-Makefile.conf.linux-gentoo" "${S}/config/Makefile.conf.linux-gentoo" || die
}

src_configure() {
	local rbinc rblib rbflags

	if use ruby ; then

		# get the location of the ruby.h header file
		rbinc=$(ruby -rrbconfig -e "puts Config::CONFIG['archdir'] || Config::CONFIG['rubyhdrdir']")

		# get the filename of libruby.so
		rblib=$(ruby -rrbconfig -e "puts Config::CONFIG['LIBRUBY']")

		rbflags="-rblib /usr/$(get_libdir)/${rblib} -rbinc ${rbinc}"

	fi

	./build.sh \
		-platform linux-gentoo \
		-bin bin \
		-qtbin /usr/bin \
		-qtinc /usr/include/qt4 \
		-qtlib /usr/$(get_libdir)/qt4 \
		${rbflags} || die "Configuration failed"
}

src_compile() {
	cd build.linux-gentoo
	tc-export CC CXX AR LD RANLIB
	export AR="${AR} -r"
	emake all || die "Build failed"
}

src_install() {
	cd build.linux-gentoo
	emake install || die "make install failed"

	cd ..
	dobin \
		bin/klayout \
		bin/strm2gds \
		bin/strm2oas \
		bin/strmclip \
		bin/strmcmp || die "Installation of binaries failed"

	insinto /usr/share/${PN}/testdata/gds
	doins testdata/gds/*.gds || die "Installation of gds testdata failed"
	insinto /usr/share/${PN}/testdata/oasis
	doins testdata/oasis/*.oas testdata/oasis/*.ot || die "Installation of oasis testdata failed"

	if use ruby; then
		insinto /usr/share/${PN}
		doins -r testdata/ruby || die "Installation of ruby testdata failed"
	fi
}
