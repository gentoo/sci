# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="k-mer counter within reads for assemblies"
HOMEPAGE="http://www.cbcb.umd.edu/software/jellyfish"
SRC_URI="http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.11.tar.gz
	http://www.cbcb.umd.edu/software/jellyfish/jellyfish-manual-1.1.pdf"

# older version is hidden in trinityrnaseq_r20140413p1/trinity-plugins/jellyfish-1.1.11
# also was bundled in quorum-0.2.1 and MaSuRca-2.1.0
# also bundled in SEECER-0.1.3

LICENSE="GPL-3+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install(){
	default
	sed -e "s#jellyfish-${PV}#jellyfish#" -i "${D}"/usr/lib64/pkgconfig/jellyfish-1.1.pc || die
	mkdir -p "${D}/usr/include/${PN}" || die
	mv "${D}"/usr/include/"${P}"/"${PN}"/* "${D}/usr/include/${PN}/" || die
	rm -rf "${D}/usr/include/${P}"
}
