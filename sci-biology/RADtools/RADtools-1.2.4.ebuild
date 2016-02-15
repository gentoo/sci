# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-module

DESCRIPTION="Tools for processing RAD Sequencing Illumina reads"
HOMEPAGE="https://www.wiki.ed.ac.uk/display/RADSequencing/Home"
SRC_URI="
	https://www.wiki.ed.ac.uk/download/attachments/68630442/RADtools_${PV}.tar.gz
	https://www.wiki.ed.ac.uk/download/attachments/68630442/RADmanual.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/perl-5.10
	dev-perl/Parallel-ForkManager"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	dobin RADMIDs RADmarkers RADpools RADtags
	mydoc="CHANGELOG RADmanual.pdf RADmanual.tex README"
	eval `perl '-V:installvendorlib'` || die
	vendor_lib_install_dir="${installvendorlib}"
	insinto ${vendor_lib_install_dir}
	doins *.pm
}
