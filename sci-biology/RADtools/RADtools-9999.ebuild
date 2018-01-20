# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils perl-module git-r3

DESCRIPTION="Tools for processing RAD Sequencing Illumina reads"
HOMEPAGE="https://www.wiki.ed.ac.uk/display/RADSequencing/Home"
EGIT_REPO_URI="https://github.com/johnomics/RADtools.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/perl-5.10
	dev-perl/Parallel-ForkManager"
RDEPEND="${DEPEND}"

src_install() {
	dobin RADMIDs RADmarkers RADpools RADtags
	dodoc CHANGELOG RADmanual.pdf RADmanual.tex README
	perl_set_version
	insinto "${VENDOR_LIB}"
	doins *.pm
}
