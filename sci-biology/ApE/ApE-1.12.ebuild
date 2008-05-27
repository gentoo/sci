# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ApE - A Plasmid Editor"
HOMEPAGE="http://www.biology.utah.edu/jorgensen/wayned/ape/"
SRC_URI="http://www.biology.utah.edu/jorgensen/wayned/ape/Download/ApE_linux_current.zip"

LICENSE="ApE"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/tcl"

src_compile() {
	echo
	einfo "Nothing to compile."
	echo
}


src_install() {

cat >> ${T}/ApE << EOF
#!/bin/bash
exec tclsh /usr/share/${P}/AppMain.tcl
EOF

exeinto /usr/bin
doexe ${T}/ApE
insinto "/usr/share/${P}"
doins -r ${WORKDIR}/ApE\ Linux/*
}
