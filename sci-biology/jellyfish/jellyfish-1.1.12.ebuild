# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic

DESCRIPTION="k-mer counter within reads for assemblies"
HOMEPAGE="http://www.cbcb.umd.edu/software/jellyfish"
SRC_URI="https://github.com/gmarcais/Jellyfish/releases/download/v${PV}/${P}.tar.gz"

# older version is hidden in trinityrnaseq_r20140413p1/trinity-plugins/jellyfish-1.1.11
# also was bundled in quorum-0.2.1 and MaSuRca-2.1.0
# also bundled in SEECER-0.1.3

LICENSE="GPL-3+ BSD"
SLOT="1"
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
	default
	# install the binary under jellyfish1 name like Debian/Ubuntu to avoid name clash with jellyfish2 and allow simultaneous installs
	mv "${ED}"/usr/bin/jellyfish "${ED}"/usr/bin/jellyfish1 || die
	sed -e "s#jellyfish-${PV}#jellyfish1#" -i "${ED}/usr/$(get_libdir)"/pkgconfig/jellyfish-1.1.pc || die
	find "${ED}"/usr/include/"${P}"/"${PN}" -type f | while read f; do
		sed -e "s#include <jellyfish/#include <jellyfish${SLOT}/#" -i $f || die
	done
	mkdir -p "${ED}/usr/include/${PN}${SLOT}" || die
	mv "${ED}"/usr/include/"${P}"/"${PN}"/* "${ED}/usr/include/${PN}${SLOT}/" || die
	rm -r "${ED}/usr/include/${P}" || die
	mv "${ED}"/usr/share/man/man1/jellyfish.1 "${ED}"/usr/share/man/man1/jellyfish"${SLOT}".1 || die
	newdoc doc/jellyfish.pdf jellyfish"${SLOT}".pdf
}
