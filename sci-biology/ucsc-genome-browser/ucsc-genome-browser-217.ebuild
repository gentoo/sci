# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs flag-o-matic webapp

DESCRIPTION="The UCSC genome browser suite, also known as Jim Kent's library and GoldenPath"
HOMEPAGE="http://genome.ucsc.edu"
SRC_URI="http://hgdownload.cse.ucsc.edu/admin/jksrc.v${PV}.zip"

LICENSE="blat"
# webapp ebuilds do not set SLOT
KEYWORDS="~amd64 ~x86"
IUSE="-server"

DEPEND="app-arch/unzip
	virtual/mysql
	server? ( virtual/httpd-cgi )" # TODO: test with other webservers
RDEPEND="${DEPEND}"

S="${WORKDIR}/kent"

src_prepare() {
	use server && webapp_src_preinst
	sed -i -e 's/-Werror//' \
		-e "s/CC=gcc/CC=$(tc-getCC) ${CFLAGS}/" \
		src/inc/common.mk || die
	find -name makefile -or -name cgi_build_rules.mk \
		| xargs sed -i -e 's/-${USER}//g' -e 's/-$(USER)//g' || die
}

src_compile() {
	export MACHTYPE=${MACHTYPE/-*/} \
		BINDIR="${WORKDIR}/destdir/opt/${PN}/bin" \
		SCRIPTS="${WORKDIR}/destdir/opt/${PN}/cluster/scripts" \
		ENCODE_PIPELINE_BIN="${WORKDIR}/destdir/opt/${PN}/cluster/data/encode/pipeline/bin" \
		PATH="${BINDIR}:${PATH}" \
		STRIP="echo 'skipping strip' "

	export MYSQLLIBS="none" MYSQLINC="none" DOCUMENTROOT="none" CGI_BIN="none"

	# use mysql &&
	export MYSQLLIBS="${ROOT}usr/lib/mysql/libmysqlclient.a -lz -lssl" \
		MYSQLINC="${ROOT}usr/include/mysql"

	use server && export DOCUMENTROOT="${WORKDIR}/destdir/${MY_HTDOCSDIR}" \
		CGI_BIN="${WORKDIR}/destdir/${MY_HTDOCSDIR}/cgi-bin"

	mkdir -p "$BINDIR" "$SCRIPTS" "$ENCODE_PIPELINE_BIN" || die
	use server && mkdir -p "$CGI_BIN" "$DOCUMENTROOT"

	emake -C src clean || die
	emake -C src/lib || die
	emake -C src/jkOwnLib || die
	emake -C src/utils/stringify || die
	emake -j1 -C src/hg utils || die
	emake -j1 -C src utils || die
	emake -C src blatSuite userApps || die
	if use server; then
		emake -j1 -C src/hg || die
		emake -j1 -C src || die
	fi
}

src_install() {
	cp -a "${WORKDIR}"/destdir/* "${D}" || die
	# dolib.a src/lib/*.a src/hg/altSplice/lib/x86_64/libSpliceGraph.a
	echo "PATH=/opt/${PN}/bin" > "${S}/99${PN}"
	doenvd "${S}/99${PN}"
	# TODO
	use server && webapp_postinst_txt en src/product/README.QuickStart
	use server && webapp_src_install

	insinto "/opt/${PN}/include"
	doins src/inc/*.h
	insinto "/usr/share/${PN}"
	doins -r src/product
	keepdir "/usr/share/doc/${PF}"
	find -name 'README*' -or -name '*.doc' | grep -v test | cpio -padv "${D}/usr/share/doc/${PF}" || die
}
