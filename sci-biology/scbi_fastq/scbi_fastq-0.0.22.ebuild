# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Read/write FASTQ files"
HOMEPAGE="https://rubygems.org/gems/scbi_fastq"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ruby/bundler-1.7
	>=dev-ruby/rake-10.0"
RDEPEND="${DEPEND}
	>=sci-biology/scbi_zcat-0.0.2"
