# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

<<<<<<< HEAD
<<<<<<< HEAD
inherit distutils-r1

DESCRIPTION="Normalization templates for Python Neuroimaging"
=======
inherit distutils-r1 eutils multilib flag-o-matic

DESCRIPTION="Neuroimaging tools for Python"
>>>>>>> 9280b26... sci-libs/nipy-templates: new package
=======
inherit distutils-r1

DESCRIPTION="Normalization templates for Python Neuroimaging"
>>>>>>> 888a8fa... sci-libs/nipy-templates: removed unneeded eclasses, updated description
HOMEPAGE="http://nipy.org/"
SRC_URI="http://nipy.org/data-packages/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
<<<<<<< HEAD
<<<<<<< HEAD
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

=======
KEYWORDS="amd64 x86 amd64-linux x86-linux"
=======
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
>>>>>>> a173580... sci-libs/nipy-templates: no stable ebuilds in the overlay
IUSE=""

<<<<<<< HEAD
RDEPEND=""
DEPEND=""
>>>>>>> 9280b26... sci-libs/nipy-templates: new package
=======
>>>>>>> f54ccdd... sci-libs/nipy-templates: removed empty depend list
