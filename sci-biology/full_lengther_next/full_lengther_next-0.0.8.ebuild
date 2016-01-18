# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.txt"

inherit ruby-fakegem

DESCRIPTION="Classify assembled transcripts and fix frameshifts in ORFs"
HOMEPAGE="http://www.scbi.uma.es/site/scbi/downloads/313-full-lengthernext"
# https://rubygems.org/gems/full_lengther_next/versions/0.0.8
# http://www.rubydoc.info/gems/full_lengther_next/0.0.8/frames
# https://www.omniref.com/ruby/gems/full_lengther_next/0.0.8/symbols/FullLengtherNext

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ruby/hoe-2.8.0"
RDEPEND="${DEPEND}
	>=sci-biology/scbi_blast-0.0.37
	>=sci-biology/scbi_fasta-0.1.7
	>=sci-biology/scbi_mapreduce-0.0.29
	>=sci-biology/scbi_plot-0.0.6
	>=dev-ruby/xml-simple-1.0.12"
