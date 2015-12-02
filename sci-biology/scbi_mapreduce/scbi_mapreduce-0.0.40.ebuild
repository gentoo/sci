# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.txt"

inherit ruby-fakegem

DESCRIPTION="Run parallel and distributed computing jobs"
HOMEPAGE="https://rubygems.org/gems/scbi_mapreduce"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ruby/hoe-3.6
	>=dev-ruby/rdoc-4.0"
RDEPEND="${DEPEND}
	>=dev-ruby/eventmachine-0.12.0
	dev-ruby/json"
