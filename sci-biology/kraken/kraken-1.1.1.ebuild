# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Detect sequencing project contaminants by mapping reads to taxonomic groups"
HOMEPAGE="https://ccb.jhu.edu/software/kraken"
SRC_URI="https://github.com/DerrickWood/kraken/archive/v1.0.tar.gz -> ${P}.tar.gz
	https://ccb.jhu.edu/software/kraken/MANUAL.html -> ${P}_MANUAL.html"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	net-misc/wget
	sci-biology/jellyfish:1
"

S="${WORKDIR}/${PN}-1.0"

src_prepare(){
	default
	sed -e 's/^CXX = /CXX ?= /' -e 's/^CXXFLAGS = /CXXFLAGS ?= /' -i src/Makefile || die
	echo "exit 0" >> install_kraken.sh || die
}

src_compile(){
	./install_kraken.sh destdir || die
}

src_install(){
	dodoc "${DISTDIR}"/${P}_MANUAL.html
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
	ewarn "https://ccb.jhu.edu/software/kraken and prepare at least 160GB of disk space"
	ewarn "Consider placing the db files in ramfs (needs root permissions) taking >75GB RAM"
	ewarn "Results can be visualized with https://sourceforge.net/p/krona/home/krona"
}
