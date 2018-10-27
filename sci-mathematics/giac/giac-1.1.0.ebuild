# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A free C++ CAS (Computer Algebra System) library and its interfaces"
HOMEPAGE="http://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="http://www-fourier.ujf-grenoble.fr/~parisse/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples fltk"

AUTOTOOLS_IN_SOURCE_BUILD=true
inherit autotools-utils flag-o-matic pax-utils

RDEPEND=">=dev-libs/gmp-3
		>=sys-libs/readline-4.2
		fltk? ( >=x11-libs/fltk-1.1.9 )
		dev-libs/mpfr
		sci-libs/gsl
		>=sci-mathematics/pari-2.3
		>=dev-libs/ntl-5.2"

src_prepare(){
	sed -e "s:\$(prefix)/share:\$(DESTDIR)\$(prefix)/share:g" \
		-e "s:config.h \$(includedir)/giac:config.h \$(DESTDIR)\$(includedir)/giac:g" \
		-e "s:\$(DESTDIR)\$(DESTDIR):\$(DESTDIR):g"	\
		-e "s:\$(DESTDIR)/\$(DESTDIR):\$(DESTDIR):g" \
		-i `find -name Makefile\*` || die
	if use !fltk; then
		sed -e "s: gl2ps\.[chlo]*::g" -i src/Makefile.* || die
	fi
}

src_configure(){
	if use fltk
	then
		append-cppflags -I$(fltk-config --includedir)
		append-lfs-flags
		append-libs $(fltk-config --ldflags | sed -e 's/\(-L\S*\)\s.*/\1/') || die
	fi
	local myeconfargs=(
		$(use_enable fltk gui)
	)
	autotools-utils_src_configure
}

src_install() {
	emake install DESTDIR="${D}"
	dobin src/aide
	rm "${D}"/usr/bin/*cas_help || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if use !fltk; then
		rm "${D}"/usr/bin/x* || die
	elif host-is-pax; then
		pax-mark -m "${D}"/usr/bin/x*
	fi
	if use !doc; then
		rm -R "${D}"/usr/share/doc "${D}"/usr/share/giac/doc/ || die
	else
		for LANG in el en es fr pt; do
			if echo ${LINGUAS} | grep -v "$LANG" &> /dev/null; then
				rm -R "${D}"/usr/share/giac/doc/"$LANG"
			else
				ln "${D}"/usr/share/giac/doc/aide_cas "${D}"/usr/share/giac/doc/"$LANG"/aide_cas || die
			fi
		done
	fi
	if use !examples; then
		rm -R "${D}"/usr/share/giac/examples || die
	fi
}
