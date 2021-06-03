# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
HOMEPAGE="http://www.cs.cmu.edu/~ckingsf/software/sailfish/"
SRC_URI="https://github.com/kingsfordgroup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-no-boost-static.patch )

DEPEND="dev-libs/boost:0
		dev-libs/jemalloc
		dev-cpp/tbb"
RDEPEND="${DEPEND}"
# a C++-11 compliant compiler is needs, aka >=gcc-4.7

# TODO: disable
# [  7%] Performing download step (verify and extract) for 'libdivsufsort'
#i
# contains bundled RapMap
# contains bundled libdivsufsort-master
# contains bundled libgff
# contains bundled jellyfish-2.2.3
# contains bundled sparsehash-sparsehash-2.0.2

src_install() {
	cmake-utils_src_install
	rm -r "${ED}"/usr/tests || die
}
