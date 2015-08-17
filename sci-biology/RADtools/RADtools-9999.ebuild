# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Tools for processing RAD Sequencing Illumina reads"
HOMEPAGE="https://www.wiki.ed.ac.uk/display/RADSequencing/Home"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="git://github.com/johnomics/RADtools.git"
	KEYWORDS=""
else
	SRC_URI="https://www.wiki.ed.ac.uk/download/attachments/68630442/RADtools_"${PV}".tar.gz
		https://www.wiki.ed.ac.uk/download/attachments/68630442/RADmanual.pdf"
	KEYWORDS="~amd64"
	S="${WORKDIR}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/perl-5.10
	dev-perl/Parallel-ForkManager"
RDEPEND="${DEPEND}"

src_install() {
	dobin RADMIDs RADmarkers RADpools RADtags
	mydoc="CHANGELOG RADmanual.pdf RADmanual.tex README"
	eval `perl '-V:installvendorlib'`
	vendor_lib_install_dir="${installvendorlib}"
	dodir ${vendor_lib_install_dir}
	insinto ${vendor_lib_install_dir}
	doins *.pm
}
