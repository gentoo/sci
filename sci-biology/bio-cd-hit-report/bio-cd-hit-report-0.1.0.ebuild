# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby library for reading CD-HIT cluster reports"
HOMEPAGE="https://rubygems.org/gems/bio-cd-hit-report"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ruby/bundler-1.3.1
	dev-ruby/jeweler
	dev-ruby/minitest:*
	dev-ruby/rdoc"
RDEPEND="${DEPEND}
	>=sci-biology/bioruby-1.4.3"
