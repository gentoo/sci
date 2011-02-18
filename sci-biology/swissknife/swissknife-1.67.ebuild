# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.38.ebuild,v 1.1 2009/05/19 12:22:20 tove Exp $

EAPI=2

inherit perl-module

DESCRIPTION="Perl library of modules to manipulate SwissProt flatfiles"
HOMEPAGE="http://swissknife.sourceforge.net/"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="ftp://ftp.ebi.ac.uk/pub/software/swissprot/Swissknife/Swissknife_1.67.tar.gz"

DEPEND="virtual/perl-Module-Build"
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.002"
	#dev-perl/Carp
	#dev-perl/Data-Dumper
	#dev-perl/Exporter"

SRC_TEST=no

S="${WORKDIR}"/Swissknife_1.67
