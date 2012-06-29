# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="http://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A} && mv ${PN}-MathJax-* ${P}
}

src_install() {
	find . -name .gitignore -delete
	dodoc README*
	use doc && dohtml -r docs/html/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r test/*
	fi
	rm -rf test docs LICENSE README*
	#local installdir=/var/www/${PN}
	local installdir=/usr/share/${PN}
	insinto ${installdir}
	doins -r *
	# web server config file - should we really do this?
	cat > MathJax.conf <<-EOF
		Alias /MathJax/ ${EPREFIX}${installdir}/
		Alias /mathjax/ ${EPREFIX}${installdir}/

		<Directory ${EPREFIX}${installdir}>
			Options None
			AllowOverride None
			Order allow,deny
			Allow from all
		</Directory>
	EOF
	insinto /etc/httpd/conf.d
	doins MathJax.conf
}
