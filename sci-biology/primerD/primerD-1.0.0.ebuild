# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Design degenerate primers"
HOMEPAGE="https://mblab.wustl.edu/software.html"
#SRC_URI="https://mblab.wustl.edu/software/download/primerD.tar.gz -> primerD-1.0.tar.gz"
# ERROR: cannot verify mblab.wustl.edu's certificate, issued by ‘CN=InCommon RSA Server CA,OU=InCommon,O=Internet2,L=Ann Arbor,ST=MI,C=US’:
# Unable to locally verify the issuer's authority.
# To connect to mblab.wustl.edu insecurely, use `--no-check-certificate'.
RESTRICT="fetch"
SRC_URI="primerD.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
# make: *** No rule to make target '/usr/include/linux/new.h', needed by 'Main.o'.  Stop.
KEYWORDS=""

S="${WORKDIR}"/primerD

src_prepare(){
	default
	sed -i -e "s:CC=g++:CC=$(tc-getCXX):; s:-Wall -g:${CFLAGS}:" \
		-e "s:/usr/include/g++-3/stl_algobase.h:/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version )/bits/stl_algobase.h:g" \
		-e "s:/usr/include/g++-3/stl_relops.h:/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version )/bits/stl_relops.h:g" \
		-e "s:/usr/include/g++-3/stl_pair.h:/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version )/bits/stl_pair.h:g" \
		-e "s:/usr/include/g++-3/type_traits.h:/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version )/ext/type_traits.h:g" \
		-e "s:/usr/include/g++-3/stl_config.h:/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version )/pstl/pstl_config.h:g" \
		-e "s:/usr/include/g++-3/:/usr/lib/gcc/${CHOST}/$(gcc-fullversion)/include/g++-v$(gcc-major-version )/:g" \
		-e "s:/usr/include/_G_config.h:/usr/include/stdio.h:g" \
		-e "s:/usr/lib/gcc-lib/i386-redhat-linux/2.96/include/:/usr/include/linux/:g" \
		Makefile || die

}

src_install(){
	dodoc README
	dobin primerD
}
