# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Convert matplotlib figures into native Pgfplots (TikZ) figures"
HOMEPAGE="https://github.com/nschloe/matplotlib2tikz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pillow-3.0.0[${PYTHON_USEDEP}]
	dev-texlive/texlive-pictures"
DEPEND="${RDEPEND}"
	#test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
