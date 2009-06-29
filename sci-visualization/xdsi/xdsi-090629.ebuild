# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils base

DESCRIPTION="A crude interface for running the XDS"
HOMEPAGE="http://strucbio.biologie.uni-konstanz.de/xdswiki/index.php/Xdsi"
SRC_URI="ftp://turn14.biologie.uni-konstanz.de/pub/${PN}/${PN}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="sci-chemistry/xds-bin[smp]
	sci-chemistry/xdsstat
	sci-visualization/xds-viewer
	sci-visualization/gnuplot
	sci-chemistry/pointless
	media-gfx/imagemagick
	app-text/xpdf
	dev-lang/tk"
DEPEND=""

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/gentoo.patch
	)

src_install() {
	dobin ${PN} || die
	insinto /usr/share/${PN}/templates
	doins templates/{*.INP,bohr*,fortran,pauli,info.png,*.pck,tablesf_xdsi} || die
	dodoc templates/*.pdf
}
