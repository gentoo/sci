# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="k-mer counter within reads for assemblies"
HOMEPAGE="http://www.genome.umd.edu/jellyfish.html"
SRC_URI="ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.1.3.tar.gz
	ftp://ftp.genome.umd.edu/pub/jellyfish/JellyfishUserGuide.pdf"

# older version is hidden in trinityrnaseq_r20140413p1/trinity-plugins/jellyfish-1.1.11

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install(){
	default
	sed -e 's#jellyfish-2.1.3#jellyfish#' -i "${D}"/usr/lib64/pkgconfig/jellyfish-2.0.pc || die
	mkdir -p "${D}/usr/include/${PN}" || die
	mv "${D}"/usr/include/"${P}"/"${PN}"/* "${D}/usr/include/${PN}/" || die
	rm -rf "${D}/usr/include/${P}"
}
