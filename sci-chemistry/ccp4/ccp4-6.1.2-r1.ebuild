# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Protein X-ray crystallography toolkit -- meta package"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI=""

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X +balbes-db oasis4"

RDEPEND="
	sci-chemistry/ccp4-apps[X?,oasis4=]
	sci-chemistry/molrep
	sci-chemistry/mosflm
	sci-chemistry/mrbump[X?]
	sci-chemistry/pdb-extract
	sci-chemistry/refmac
	sci-chemistry/scala
	sci-chemistry/xia2
	balbes-db? ( sci-libs/balbes-db )
	oasis4? ( sci-chemistry/oasis )
	X? (
		sci-chemistry/ccp4i[oasis4=]
		sci-chemistry/imosflm
		sci-chemistry/rasmol
		)"
DEPEND=""
