# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mosaik/mosaik-1.0.1388.ebuild,v 1.1 2010/04/11 17:29:40 weaver Exp $

EAPI="2"

DESCRIPTION="A reference-guided aligner for next-generation sequencing technologies"
HOMEPAGE="http://code.google.com/p/mosaik-aligner/"
SRC_URI="http://mosaik-aligner.googlecode.com/files/Mosaik-${PV}-source.tar.bz2
	http://code.google.com/p/mosaik-aligner/downloads/detail?name=Mosaik%201.0%20Documentation.pdf -> Mosaik-1.0-Documentation.pdf"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/swig"
RDEPEND=""

S="${WORKDIR}/mosaik-aligner"

src_prepare() {
	sed -i 's/-static//' src/includes/linux.inc || die
}

src_compile() {
	emake -C src || die
	emake -C MosaikTools/c++ || die
	export PERL_CORE_DIR=/usr/lib64/perl5/5.12.4/x86_64-linux/CORE
	emake -C MosaikTools/perl PERL_CORE_DIR=/usr/lib64/perl5/5.12.4/x86_64-linux/CORE || die "Please use gcc-4.3.6 while not 4.5.3 if the latter exits at MosaikAlignment.cpp"
}

src_install() {
	dobin bin/* || die

	insinto /usr/share/${PN}
	doins -r MosaikTools || die

	dodoc README "${DISTDIR}"/Mosaik-1.0-Documentation.pdf
}
