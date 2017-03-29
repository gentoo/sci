# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.txt"

inherit ruby-fakegem

DESCRIPTION="Classify assembled transcripts and fix frameshifts in ORFs"
HOMEPAGE="http://www.rubydoc.info/gems/full_lengther_next
	http://www.scbi.uma.es/site/scbi/downloads/313-full-lengthernext"
# https://rubygems.org/gems/full_lengther_next/versions/0.0.8
# http://www.rubydoc.info/gems/full_lengther_next
# https://www.omniref.com/ruby/gems/full_lengther_next/0.0.8/symbols/FullLengtherNext

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ruby/hoe-2.8.0
	>=dev-ruby/rdoc-3.10
	dev-ruby/bundler"
	# >=dev-ruby/newgem-1.5.3
RDEPEND="${DEPEND}
	sci-biology/bioruby
	>=sci-biology/bio-cd-hit-report-0.1.0
	>=sci-biology/scbi_blast-0.0.37
	>=sci-biology/scbi_fasta-0.1.7
	>=sci-biology/scbi_zcat-0.0.2
	>=sci-biology/scbi_mapreduce-0.0.29
	>=sci-biology/scbi_plot-0.0.6
	>=dev-ruby/xml-simple-1.0.12
	>=dev-ruby/gnuplot-2.3.0"
