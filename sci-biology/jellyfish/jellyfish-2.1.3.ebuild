# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="k-mer counter within reads for assemblies"
HOMEPAGE="http://www.genome.umd.edu/jellyfish.html"
SRC_URI="ftp://ftp.genome.umd.edu/pub/${PN}/${P}.tar.gz
	ftp://ftp.genome.umd.edu/pub/jellyfish/JellyfishUserGuide.pdf"

# older version is hidden in trinityrnaseq_r20140413p1/trinity-plugins/jellyfish-1.1.11

LICENSE="GPL-3+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install(){
	default
	# beware the filename say 2.0 instead of 2.1. does it matter?
	sed -e "s#jellyfish-${PV}#jellyfish#" -i "${D}"/usr/lib64/pkgconfig/jellyfish-2.0.pc || die
	mkdir -p "${D}/usr/include/${PN}" || die
	mv "${D}"/usr/include/"${P}"/"${PN}"/* "${D}/usr/include/${PN}/" || die
	rm -rf "${D}/usr/include/${P}"
}
