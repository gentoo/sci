# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
	sed -e "s#jellyfish-${PV}#jellyfish#" -i "${ED}/usr/$(get_libdir)"/pkgconfig/jellyfish-2.0.pc || die
	mkdir -p "${ED}/usr/include/${PN}" || die
	mv "${ED}"/usr/include/"${P}"/"${PN}"/* "${ED}/usr/include/${PN}/" || die
	rm -rf "${ED}/usr/include/${P}"
}
