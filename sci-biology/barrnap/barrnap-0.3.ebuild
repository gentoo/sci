# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="Predict Bacterial and Archaeal rRNA genes and output in GFF3 format"
HOMEPAGE="http://www.vicbioinformatics.com/software.barrnap.shtml"
SRC_URI="http://www.vicbioinformatics.com/"${P}".tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# contains bundled binaries of hmmer-3.1 (dev version)

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/nesoni"
