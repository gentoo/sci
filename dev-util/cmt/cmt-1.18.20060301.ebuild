# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit elisp-common toolchain-funcs versionator

CPV=($(get_version_components ${PV}))
CMT_PV=v${CPV[0]}r${CPV[1]}p${CPV[2]}

DESCRIPTION="Cross platform configuration management environment"
HOMEPAGE="http://www.cmtsite.org/"
SRC_URI="http://www.cmtsite.org/${CMT_PV}/CMT${CMT_PV}.tar.gz"

LICENSE="CeCILL-v2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java doc"

S=${WORKDIR}/CMT/${CMT_PV}
CMTDIR=/usr/share/${PN}/${CMT_PV}

src_compile() {
	cd ${S}/mgr
	./INSTALL
	source setup.sh
	make \
		cpp="$(tc-getCXX)" \
		cppflags="${CXXFLAGS}" \
		|| die "make failed"
}

src_install() {
	sed -i -e "s:${S}:${CMTDIR}:" mgr/setup.{sh,csh}
	dodir ${CMTDIR}
	cp -pPR mgr src "${D}"/${CMTDIR}
	exeinto /usr/bin
	newexe ${CMTCONFIG}/cmt.exe cmt

	echo "CMTROOT=${CMTDIR}" > 99cmt
	echo "CMTBIN=`uname`-`uname -m | sed -e 's# ##g'`" >> 99cmt
	echo "CMTCONFIG=`${CMTROOT}/mgr/cmt_system.sh`" >> 99cmt

	if use java; then
		echo "#!/bin/sh" > jcmt
		echo "java cmt_parser" >> jcmt
		doexe jcmt
		echo "CLASSPATH=${CLASSPATH}:${CMTDIR}/java/cmt.jar" >> 99cmt
	fi
	doenvd 99cmt
	dodoc doc/*.txt
	dohtml doc/{ChangeLog,ReleaseNotes}.html

	if use doc; then
		cd ${S}/mgr
		make gendoc
		cd ${S}/doc
		dohtml -r CMTDoc.html Images CMTFAQ.html
	fi
	if use emacs; then
		elisp-site-file-install \
			doc/cmt-mode.el ${FILESDIR}/80cmt-mode-gentoo.el
		insinto ${CMTDIR}/xemacs
		doins ${S}/doc/init.el
	fi
}

pkg_postinst () {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
