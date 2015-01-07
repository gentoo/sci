# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Close gaps using BWA-identified reads and reassemble using Phrap, Newbler, Velvet, compare by cross_match"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas-gapfill"
SRC_URI="https://www.hgsc.bcm.edu/sites/default/files/software/ATLAS_GapFill_V2_2/ATLAS_GapFill_V2.2_release.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# is there an ebuild for newbler?
DEPEND="dev-lang/perl
	(sys-cluster/torque || sys/cluster/openpbs)
	sci-biology/phrap
	sci-biology/bwa
	sci-biology/velvet"
RDEPEND="${DEPEND}"
