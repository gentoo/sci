# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

MY_P="${P/simpy/SimPy}"

DESCRIPTION="Process and event simulation."
HOMEPAGE="http://simpy.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-lang/python[tk]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install

	if use doc ; then
		dodoc SimPyDocs
		dodoc SimPyModels
		# Took the following from 'dodoc' in order to not compress
		# the pdf file.  'dodoc' always compresses.
		dir="${D}usr/share/doc/${PF}/${DOCDESTTREE}"
		if [ ! -d "${dir}" ] ; then
		        install -d "${dir}"
		fi
		for dname in `find SimPyDocs SimPyModels -type d`
		do
			install -d "${dir}/${dname}"
			install -m0644 "${dname}"/* "${dir}/${dname}"
		done
	fi
}
