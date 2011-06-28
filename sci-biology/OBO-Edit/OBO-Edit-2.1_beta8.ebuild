# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit rpm

DESCRIPTION="Java-based editor optimized for the OBO biological ontology file format"
HOMEPAGE="http://www.oboedit.org/"
#SRC_URI="http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/oboedit2.1beta8/oboedit_2_1_8_unix_install4j.sh"
SRC_URI="http://sourceforge.net/projects/geneontology/files/OBO-Edit%202%20%5BLatest%20versions%5D/oboedit2.1beta8/oboedit_2_1_8_linux_install4j.rpm"

LICENSE="OBO-Edit" # Artistic-like
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/rpm2targz"
RDEPEND="virtual/jre"

S="${WORKDIR}"/opt

src_install(){
	# sh "${DISTDIR}"/oboedit_2_1_8_unix_install4j.sh -q -overwrite --var-file="${FILESDIR}"/response.varfile --destination="${D}"/opt/OBO-Edit2
	find . -name firstrun -delete
	find . -name .svn -exec rm -rf '{}' \;

	insinto /opt/
	doins -r OBO-Edit2
	chmod 755 "${ED}"/opt/OBO-Edit2/*
}
