# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Portage incorrectly claims "DISTUTILS_USE_SETUPTOOLS value is probably
# incorrect" for this package. It isn't. This package imports from neither
# "distutils", "packaging", "pkg_resources", nor "setuptools" at runtime.
PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Collection of perceptually uniform colormaps"
HOMEPAGE="https://holoviz.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/param-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/pyct-0.4.4[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest
