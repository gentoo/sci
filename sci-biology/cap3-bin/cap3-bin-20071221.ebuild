# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="CAP3 is for small-scale assembly of EST sequences with or without quality value"
HOMEPAGE="http://seq.cs.iastate.edu"
# These exist currently and contain version 20071221:
# http://seq.cs.iastate.edu/CAP3/cap3.linux.tar
# http://seq.cs.iastate.edu/CAP3/cap3.linux.i686_xeon64.tar
# http://seq.cs.iastate.edu/CAP3/cap3.linux.opteron64.tar

# The /pub/ directory is gone although contained same version of binaries but for some different platforms:
# http://seq.cs.iastate.edu/pub/CAP3/cap3.linux.tar
# http://seq.cs.iastate.edu/pub/CAP3/cap3.linux.i686_xeon64.tar
# http://seq.cs.iastate.edu/pub/CAP3/cap3.linux.opteron64.tar
# http://seq.cs.iastate.edu/pub/CAP3/cap3.linux.itanium.tar
# http://seq.cs.iastate.edu/pub/CAP3/cap3.linux.powerpc32.tar
# http://seq.cs.iastate.edu/pub/CAP3/cap3.linux.powerpc64.tar
SRC_URI="x86? ( http://seq.cs.iastate.edu/CAP3/cap3.linux.tar )
		amd64? ( http://seq.cs.iastate.edu/CAP3/cap3.linux.i686_xeon64.tar )"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	cd "${WORKDIR}/CAP3" || die
	dobin cap3 formcon || die
	dodoc README || die
	newdoc doc cap3.txt || die
	# other examples
	# http://seq.cs.iastate.edu/pub/CAP3/data.tar
	dodir /usr/share/cap3/examples || die
	insinto /usr/share/cap3 || die
	doins -r example || die
}
