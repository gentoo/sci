# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

<<<<<<< HEAD
inherit distutils-r1

DESCRIPTION="Normalization templates for Python Neuroimaging"
=======
inherit distutils-r1 eutils multilib flag-o-matic

DESCRIPTION="Neuroimaging tools for Python"
>>>>>>> 9280b26... sci-libs/nipy-templates: new package
HOMEPAGE="http://nipy.org/"
SRC_URI="http://nipy.org/data-packages/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
<<<<<<< HEAD
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

=======
KEYWORDS="amd64 x86 amd64-linux x86-linux"
IUSE=""

<<<<<<< HEAD
RDEPEND=""
DEPEND=""
>>>>>>> 9280b26... sci-libs/nipy-templates: new package
=======
>>>>>>> f54ccdd... sci-libs/nipy-templates: removed empty depend list
