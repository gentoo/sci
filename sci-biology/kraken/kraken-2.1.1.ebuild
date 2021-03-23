# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="Detect sequencing project contaminants by mapping reads to taxonomic groups"
HOMEPAGE="https://ccb.jhu.edu/software/kraken2/"
SRC_URI="https://github.com/DerrickWood/kraken2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"

# TODO: somehow avoid the file conflict with kraken-1
DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/ncbi-tools++
	dev-lang/perl
	net-misc/wget
	!sci-biology/kraken:1
"

S="${WORKDIR}/${PN}2-${PV}"

src_prepare(){
	default
	sed -e 's/^CXX = /CXX ?= /' -e 's/^CXXFLAGS = /CXXFLAGS ?= /' -i src/Makefile || die
	echo "exit 0" >> install_kraken2.sh || die
}

src_compile(){
	./install_kraken2.sh destdir || die
}

src_install(){
	dodoc -r docs
	perl_set_version
	perl_domodule destdir/*.pm
	dosym ../../"${VENDOR_LIB//${EPREFIX/}}/krakenlib.pm" /usr/bin/krakenlib.pm
	insinto /usr/share/${PN}/util
	doins destdir/*.pl
	chmod -R a+rx "${ED}/usr/share/${PN}/util"
	rm -f destdir/krakenlib.pm
	dobin destdir/*
}

pkg_postinst(){
	ewarn "Kraken may optionally need <=sci-biology/jellyfish-2 if you want to build your own dbs"
	ewarn "Kraken needs high network bandwidth for its huge downloads, be sure to read"
	ewarn "https://ccb.jhu.edu/software/kraken and prepare at least 160GB of disk space"
	ewarn "Consider placing the db files in ramfs (needs root permissions) taking >75GB RAM"
	ewarn "Results can be visualized with https://sourceforge.net/p/krona/home/krona"
}
