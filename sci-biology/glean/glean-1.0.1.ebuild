# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Merge various gene prediction into one (unsupervised learning system)"
HOMEPAGE="http://sourceforge.net/projects/glean-gene"
SRC_URI="http://downloads.sourceforge.net/project/glean-gene/GLEAN/glean-1-0-1/glean-1-0-1.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"
IUSE="graphviz"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/perl-Storable
	virtual/perl-Getopt-Long
	virtual/perl-Data-Dumper
	dev-perl/Module-Pluggable
	dev-perl/Algorithm-Diff
	dev-perl/YAML
	sci-biology/bioperl
	graphviz? ( dev-perl/GraphViz )"
# FindBin

S="${WORKDIR}"/glean-gene

src_install(){
	dobin bin/*
	dodoc README
	perl_set_version
	insinto ${VENDOR_LIB}
	doins -r lib/Glean
}
