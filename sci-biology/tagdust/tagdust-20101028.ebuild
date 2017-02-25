# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Trim multimers of various primers/adapter from Illumina datasets"
HOMEPAGE="http://genome.gsc.riken.jp/osc/english/dataresource"
SRC_URI="http://genome.gsc.riken.jp/osc/english/software/src/tagdust.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/tagdust

src_prepare(){
	sed -e "s/^CFLAGS/#CFLAGS/" -e "s#/usr/local/bin#\$(DESTDIR)/usr/bin#" \
		-e "s#/usr/share/man/#\$(DESTDIR)/usr/share/man/#" -i Makefile
}

src_install(){
	doman tagdust.1
	dobin tagdust
	insinto /usr/share/tagdust/Illumina
	doins "test/"solexa*.fa
	insinto /usr/share/tagdust
	doins "test/"protocol.txt README
}
