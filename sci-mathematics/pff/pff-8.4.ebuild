# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Library for reasoning about floating point numbers in coq"
HOMEPAGE="http://lipforge.ens-lyon.fr/www/pff/"
SRC_URI="http://lipforge.ens-lyon.fr/frs/download.php/165/Float${PV}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sci-mathematics/coq"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Float${PV}"

src_prepare() {
	sed -i Makefile \
		-e "s|\`\$(COQC) -where\`/user-contrib|\$(DSTROOT)/\`\$(COQC) -where\`/user-contrib|g" \
		-e "s|VOFILESINC=\$(filter \$(wildcard \./\*),\$(VOFILES))|VOFILESINC:=\$(filter-out ,\$(VOFILES))|g"
}

src_compile(){
	default
}

src_install(){
	emake install DSTROOT="${D}"
}
