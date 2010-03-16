# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A package for computing Triangulations Of Point Configurations and Oriented Matroids."
SRC_URI="http://www.uni-bayreuth.de/departments/wirtschaftsmathematik/rambau/Software/TOPCOM-$PV.tar.gz
	doc? ( http://www.rambau.wm.uni-bayreuth.de/TOPCOM/TOPCOM-manual.html )"
HOMEPAGE="http://www.rambau.wm.uni-bayreuth.de/TOPCOM/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc examples"

DEPEND=">=dev-libs/gmp-4.1-r1
	>=sci-libs/cddlib-094f"

S="${WORKDIR}"/TOPCOM-${PV}

# src_unpack () {
## TODO: Don't unpack GMP und CDD at all.
#	unpack ${A} || die "unpack failed"
#   The following can be used in tests whether
#   internal copies are used or not
#	cd "${S}"
#	rm -r external
# }

src_prepare () {
## Patch:  Don't compile GMP and CDD
	epatch "${FILESDIR}"/${PN}-${PV}-no-external.diff

## Remove all references to directory ../external
	sed -e 's#../external/lib#/usr/lib#g' -i src/Makefile.in || \
			die "sed failed on src/Makefile.in"
	sed -e 's#../external/lib#/usr/lib#g' -e 's#../external/include#/usr/include#g' -i src-reg/Makefile.in || \
			die "sed failed on src-reg/Makefile.in"

## Replace csh by bash:
		sed -e "s#csh #${SHELL} #g" -i configure || \
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
