# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

<<<<<<< HEAD
inherit distutils-r1

DESCRIPTION="Demo Data for Python Neuroimaging"
=======
inherit distutils-r1 eutils multilib flag-o-matic

DESCRIPTION="Neuroimaging tools for Python"
>>>>>>> 6e709b8... sci-libs/nipy-data: new package
HOMEPAGE="http://nipy.org/"
SRC_URI="http://nipy.org/data-packages/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
<<<<<<< HEAD
<<<<<<< HEAD
=======

RDEPEND=""
DEPEND=""
>>>>>>> 6e709b8... sci-libs/nipy-data: new package
=======
>>>>>>> 9277826... sci-libs/nipy-data: removed empty dependency list
