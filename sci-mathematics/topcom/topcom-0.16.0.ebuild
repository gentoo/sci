# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A package for computing Triangulations Of Point Configurations and Oriented Matroids."
SRC_URI="http://www.uni-bayreuth.de/departments/wirtschaftsmathematik/rambau/Software/TOPCOM-0.16.0.tar.gz
	doc? ( http://www.rambau.wm.uni-bayreuth.de/TOPCOM/TOPCOM-manual.html )"
HOMEPAGE="http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc examples"

DEPEND=">=dev-libs/gmp-4.1-r1
	>=sci-libs/cddlib-094f"

S="${WORKDIR}"/TOPCOM-${PV}

src_unpack () {
	unpack ${A}
	cd "${S}"
	rm -r external
## Patch:  Do not compile cddlib and gmp
	epatch "${FILESDIR}"/${PN}-${PV}-no-external.diff
## Patch: dd_clear_global_constants() from internal cddlib needs to be inserted
	epatch "${FILESDIR}"/${PN}-${PV}-LPinterface.diff

## Remove all references to directory ../external
	cd "${S}"
	sed -e 's#../external/lib#/usr/lib#g' -i src/Makefile.in || \
			die "sed failed on src/Makefile.in"
	sed -e 's#../external/lib#/usr/lib#g' -e 's#../external/include#/usr/include#g' -i src-reg/Makefile.in || \
			die "sed failed on src-reg/Makefile.in"

## Replace csh by bash:
		sed -e 's#csh #bash #g' -i configure || \
			die "sed failed on configure"
}

src_install () {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README || die

	use doc && dohtml "${DISTDIR}"/TOPCOM-manual.html

	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -R "${S}"/examples/* "${D}"/usr/share/doc/${PF}/examples
	fi
}
