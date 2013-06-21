# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="nMOLDYN is an interactive analysis program for Molecular Dynamics simulations"
HOMEPAGE="http://dirac.cnrs-orleans.fr/plone/software/nmoldyn/"
SRC_URI="https://forge.epn-campus.eu/attachments/download/1161/${P}.zip"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/numpy
	sci-libs/mmtk
"
RDEPEND="${DEPEND}"
