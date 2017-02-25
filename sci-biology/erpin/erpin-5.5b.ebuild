# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

ERPIN_BATCH_V=1.4

DESCRIPTION="Easy RNA Profile IdentificatioN, an RNA motif search program"
HOMEPAGE="http://tagc.univ-mrs.fr/erpin/"
SRC_URI="
	http://rna.igmors.u-psud.fr/download/Erpin/erpin${PV}.serv.tar.gz
	http://rna.igmors.u-psud.fr/download/Erpin/ErpinBatch.${ERPIN_BATCH_V}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="!sys-cluster/maui" # file collision
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
	rm -f erpin${PV}.serv/{bin,lib}/* || die
	rm -f ErpinBatch.${ERPIN_BATCH_V}/erpin* || die
	find -name '*.mk' | xargs sed -i \
		-e 's/strip $@/echo skipping strip $@/' \
		-e '/CFLAGS =/ d' \
		-e "s/CC = .*/CC = $(tc-getCC)/" \
		-e "s: -o : ${LDFLAGS} -o :g" \
		-e "s:ar :$(tc-getAR) :g" || die
	sed -i 's/cc -O2/$(tc-getCC) ${CFLAGS}/' erpin${PV}.serv/sum/sum.mk || die
}

src_compile() {
	emake -C erpin${PV}.serv -f erpin.mk
}

src_install() {
	dobin erpin${PV}.serv/bin/*
	insinto /usr/share/${PN}
	doins -r erpin${PV}.serv/scripts ErpinBatch.${ERPIN_BATCH_V}
	exeinto /usr/share/${PN}
	newexe "${FILESDIR}/erpincommand-${PV}.pl" erpincommand
	dodoc erpin${PV}.serv/doc/doc*.pdf
}
