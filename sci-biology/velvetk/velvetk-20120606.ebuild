# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Estimate the best k-mer size to use for your Velvet de novo assembly"
HOMEPAGE="http://www.vicbioinformatics.com/software.velvetk.shtml"
SRC_URI="http://www.vicbioinformatics.com/velvetk.pl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install(){
	dobin "${DISTDIR}"/velvetk.pl
}
