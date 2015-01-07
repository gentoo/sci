# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Close gaps using BWA-identified reads and reassemble using Phrap, Newbler, Velvet, compare by cross_match"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas-gapfill"
SRC_URI="https://www.hgsc.bcm.edu/sites/default/files/software/ATLAS_GapFill_V2_2/ATLAS_GapFill_V2.2_release.tar.bz2
	https://www.hgsc.bcm.edu/sites/default/files/software/ATLAS_GapFill_V2_2/README -> ATLAS_GapFill_V2_2.README"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

# is there an ebuild for newbler so we could add it to DEPEND?
DEPEND="dev-lang/perl
	sys-cluster/torque || ( sys-cluster/openpbs )
	sci-biology/phrap
	sci-biology/bwa
	sci-biology/velvet"
RDEPEND="${DEPEND}"
