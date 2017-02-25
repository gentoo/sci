# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Close gaps using BWA-identified reads and reassemble"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas-gapfill"
SRC_URI="
	https://www.hgsc.bcm.edu/sites/default/files/software/ATLAS_GapFill_V2_2/ATLAS_GapFill_V2.2_release.tar.bz2
	https://www.hgsc.bcm.edu/sites/default/files/software/ATLAS_GapFill_V2_2/README -> ATLAS_GapFill_V2_2.README"

LICENSE="ATLAS"
SLOT="0"
KEYWORDS=""
IUSE=""

# is there an ebuild for newbler so we could add it to DEPEND?
RDEPEND="
	dev-lang/perl
	sci-biology/phrap
	sci-biology/bwa
	sci-biology/velvet"
DEPEND=""
