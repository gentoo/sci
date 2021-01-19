# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="Iterative Mapping and Assembly for Gap Elimination using paired-end Illumina"
HOMEPAGE="https://sourceforge.net/apps/mediawiki/image2"
SRC_URI="https://sourceforge.net/projects/image2/files/IMAGE_version${PV}_64bit.zip"

#http://genomebiology.com/2010/11/4/R41
LICENSE="CC-BY-2.0"
SLOT="0"
KEYWORDS="~amd64"

# contains bundled binaries:
# nucmer smalt_x86_64 ssaha2 ssaha2Build velvetg velveth
DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}_version2.4"

src_install() {
	perl_doexamples example/
	perl_domodule *.pl
}
