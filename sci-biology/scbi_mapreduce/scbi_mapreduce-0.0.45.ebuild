# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Run parallel and distributed computing jobs"
HOMEPAGE="https://rubygems.org/gems/scbi_mapreduce"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ruby/hoe-3.6
	>=dev-ruby/rdoc-4.0"
RDEPEND="${DEPEND}
	>=dev-ruby/eventmachine-0.12.0
	dev-ruby/json"
