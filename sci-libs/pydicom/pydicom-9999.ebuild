# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 git-r3

DESCRIPTION="A pure python package for parsing DICOM files"
HOMEPAGE="http://www.pydicom.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/darcymason/pydicom"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${S}/source"
