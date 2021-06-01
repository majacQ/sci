# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson

DESCRIPTION="PacBio modified BAM file format"
HOMEPAGE="https://pbbam.readthedocs.io/en/latest/index.html"
EGIT_REPO_URI="https://github.com/PacificBiosciences/pbbam.git"

LICENSE="blasr"
SLOT="0"
KEYWORDS=""

BDEPEND="
	virtual/pkgconfig
	>=dev-cpp/gtest-1.8.1
	>=dev-lang/swig-3.0.5
"
DEPEND="
	sci-biology/pbcopper
	>=sci-libs/htslib-1.3.1:=
	>=dev-libs/boost-1.55:=[threads]
"
RDEPEND="${DEPEND}"
