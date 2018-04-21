# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Display alignments and GFF files, matrix dot plots (blixem, dotter, belvu)"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/seqtools"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/${PN}/PRODUCTION/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-libs/readline:*
	net-misc/curl:*
	dev-db/sqlite:*
	dev-libs/glib:2
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"
