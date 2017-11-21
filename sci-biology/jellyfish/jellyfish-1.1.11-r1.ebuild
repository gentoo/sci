# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic

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
IUSE="cpu_flags_x86_sse"

DEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare(){
	#  --with-sse              enable SSE
	#  --with-half             enable half float (16 bits)
	#  --with-int128           enable int128
	local myconf
	use cpu_flags_x86_sse && myconf+=( --with-sse )
	econf econf ${myconf[@]}
	eapply_user
}

src_install(){
	# install the binary under jellyfish1 name like Debian/Ubuntu to avoid name clash with jellyfish2 and allow simultaneous installs
	mv bin/jellyfish bin/jellyfish1 || die
	default
	sed -e "s#jellyfish-${PV}#jellyfish#" -i "${ED}/usr/$(get_libdir)"/pkgconfig/jellyfish-1.1.pc || die
	mkdir -p "${ED}/usr/include/${PN}" || die
	mv "${ED}"/usr/include/"${P}"/"${PN}"/* "${ED}/usr/include/${PN}/" || die
	rm -r "${ED}/usr/include/${P}" || die
}
