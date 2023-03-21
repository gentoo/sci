# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Merge various gene prediction into one (unsupervised learning system)"
HOMEPAGE="https://sourceforge.net/projects/glean-gene/"
SRC_URI="https://downloads.sourceforge.net/project/glean-gene/GLEAN/glean-${PV//./-}/glean-${PV//./-}.tar.gz"

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
	perl_domodule -r lib/Glean
}
