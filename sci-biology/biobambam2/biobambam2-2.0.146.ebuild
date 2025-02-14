# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

release_data="20191030105216"

DESCRIPTION="Tools for bam file processing (libmaus2)"
HOMEPAGE="https://gitlab.com/german.tischler/biobambam2"
SRC_URI="https://gitlab.com/german.tischler/${PN}/-/archive/${PV}-release-${release_data}/${P}-release-${release_data}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/libmaus2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-release-${release_data}"

src_configure(){
	econf --with-libmaus2="${EPREFIX}"
}
