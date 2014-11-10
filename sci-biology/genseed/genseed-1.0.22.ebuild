# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Seed-driven progressive assembly program using legacy NCBI blast, CAP3, and optionally cross_match"
HOMEPAGE="http://www.coccidia.icb.usp.br/genseed/"
SRC_URI="http://www.coccidia.icb.usp.br/genseed/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

	# I am not sure whether we want to introduce yet another USE variable "phrap"
	# This tools optionally uses cross_match if vector masking is required
	# (sci-biology/phrap but it will be installed only by users having that licence.
DEPEND="
	sci-biology/cap3-bin
	dev-lang/perl
	sci-biology/ncbi-tools"
RDEPEND=""

S="${WORKDIR}"

src_install() {
	newbin ${PN}.pl ${PN}
}
