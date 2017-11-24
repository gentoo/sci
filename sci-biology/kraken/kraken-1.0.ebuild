# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module

DESCRIPTION="Detect sequencing project contaminants by mapping reads to taxonomic groups"
HOMEPAGE="http://ccb.jhu.edu/software/kraken
	http://genomebiology.com/2014/15/3/R46"
SRC_URI="https://github.com/DerrickWood/kraken/archive/v1.0.tar.gz -> ${P}.tar.gz
	http://ccb.jhu.edu/software/kraken/MANUAL.html -> ${P}_MANUAL.html"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	net-misc/wget"

src_prepare(){
	sed -e 's/^CXX = /CXX ?= /' -e 's/^CXXFLAGS = /CXXFLAGS ?= /' -i src/Makefile || die
	echo "exit 0" >> install_kraken.sh || die
}

src_compile(){
	./install_kraken.sh destdir || die
}

src_install(){
	dohtml "${DISTDIR}"/${P}_MANUAL.html
	perl_set_version
	insinto ${VENDOR_LIB}/${PN}
	doins destdir/*.pm
	insinto /usr/share/${PN}/util
	doins destdir/*.pl
	chmod -R a+rx "${D}"/"${EPREFIX}"/usr/share/${PN}/util
	rm -f destdir/krakenlib.pm
	dobin destdir/*
}

pkg_postinst(){
	ewarn "Kraken may optionally need <=sci-biology/jellyfish-2 if you want to build your own dbs"
	ewarn "Kraken needs high network bandwidth for its huge downloads, be sure to read"
	ewarn "http://ccb.jhu.edu/software/kraken and prepare at least 160GB of disk space"
	ewarn "Consider placing the db files in ramfs (needs root permissions) taking >75GB RAM"
	ewarn "Results can be visualized with http://sourceforge.net/p/krona/home/krona"
}
