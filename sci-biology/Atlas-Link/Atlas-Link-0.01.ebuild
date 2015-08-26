# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Links and orients genome sequence contigs using mate-pair information or superscaffolds .agp files"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas-link"
SRC_URI="https://www.hgsc.bcm.edu/sites/default/files/software/Atlas_Link/Atlas-link.tar.gz"

LICENSE="HGSC-BCM"
SLOT="0"
KEYWORDS=""
IUSE=""

# https://github.com/gitpan/Algorithm-ClusterPoints
DEPEND="dev-lang/perl
	dev-perl/Graph
	dev-perl/Algorithm-ClusterPoints
	dev-perl/XML-DOM
	dev-perl/Statistics-Descriptive"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/Atlas-link
