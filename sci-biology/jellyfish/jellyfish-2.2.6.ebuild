# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic autotools

DESCRIPTION="k-mer counter within reads for assemblies"
HOMEPAGE="http://www.genome.umd.edu/jellyfish.html"
SRC_URI="https://github.com/gmarcais/Jellyfish/releases/download/v${PV}/${P}.tar.gz
	ftp://ftp.genome.umd.edu/pub/jellyfish/JellyfishUserGuide.pdf"

# older version is hidden in trinityrnaseq_r20140413p1/trinity-plugins/jellyfish-1.1.11

LICENSE="GPL-3+ BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare(){
	eautoreconf
	default
}

# TODO: enable compilation of Bindings to Ruby, Python and Perl
# '--enable-ruby-binding', '--enable-python-binding' or '--enable-perl-binding',  '--enable-swig'
src_configure(){
	#  --with-sse              enable SSE
	#  --with-half             enable half float (16 bits)
	#  --with-int128           enable int128
	local myconf
	use cpu_flags_x86_sse && myconf+=( --with-sse )
	econf econf ${myconf[@]}
}

src_install(){
	default
	sed -e "s#jellyfish-${PV}#jellyfish#" -i "${ED}/usr/$(get_libdir)"/pkgconfig/jellyfish-2.0.pc || die
	mkdir -p "${ED}/usr/include/${PN}" || die
	mv "${ED}"/usr/include/"${P}"/"${PN}"/* "${ED}/usr/include/${PN}/" || die
	rm -r "${ED}/usr/include/${P}" || die
}
