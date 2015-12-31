# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils perl-module

DESCRIPTION="Genome Annotation Library (incl. fasta_tool)"
HOMEPAGE="http://www.sequenceontology.org/software/GAL.html"
SRC_URI="http://www.sequenceontology.org/software/GAL_Code/${PN}_${PV}.tar.gz"

LICENSE="( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-perl/TAP-Harness
	dev-perl/Module-Build"
RDEPEND="${DEPEND}"
