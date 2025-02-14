# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Modules to convert numbers to words."
HOMEPAGE="https://github.com/savoirfairelinux/num2words"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]"

BDEPEND="
	test? ( dev-python/delegator[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
