# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN=${PN/pydap/Pydap}

MY_P=${P/pydap/Pydap}
MY_P=${MY_P/_rc/.rc.}

DESCRIPTION="Data Access Protocol client and server."
HOMEPAGE="http://pydap.org"

SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND="virtual/python
	>=dev-python/numpy-1.2.1
	>=dev-python/httplib2-0.4.0
	>=dev-python/genshi-0.5.1
	>=dev-python/paste-1.7.2
	>=dev-python/pastescript-1.7.2
	>=dev-python/pastedeploy-1.3.3
	>=dev-python/coards-0.2.2
	>=dev-python/arrayterator-1.0.1
	>=dev-python/cheetah-2.0_rc6"

S="$WORKDIR/$MY_P"

# From the requires.txt file in the egg.
#	numpy
#	httplib2>=0.4.0
#	Genshi
#	Paste
#	PasteScript
#	PasteDeploy
#
#	[test]
#	nose
#	wsgi_intercept
#
#	[docs]
#	Paver
#	Sphinx
#	Pygments
#	coards

