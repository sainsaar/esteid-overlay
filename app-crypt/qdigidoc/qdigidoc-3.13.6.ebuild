# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils eutils flag-o-matic versionator xdg-utils

DESCRIPTION="Digidoc client"
HOMEPAGE="https://github.com/open-eid/qdigidoc"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

# replace underscore for beta tarballs
MY_PV=$(replace_version_separator '_' '-')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

SRC_URI="https://github.com/open-eid/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

PATCHES=(
	"${FILESDIR}/sandbox-compat.patch"
)

RDEPEND="dev-libs/openssl:=
	>=dev-libs/opensc-0.14[pcsc-lite]
	>=dev-libs/libdigidocpp-3.13.2
	dev-libs/xerces-c[icu]
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5"

DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

DOCS="AUTHORS README.md"

# gentoo specific zlib internal macro names
append-cppflags "-DOF=_Z_OF"

src_prepare() {
	cmake-utils_src_prepare
	# https://github.com/open-eid/qdigidoc/wiki/DeveloperTips#building-in-sandboxed-environment
	cp ${FILESDIR}/TSL.qrc		${S}/client/TSL.qrc
	# https://sr.riik.ee/tsl/estonian-tsl.xml
	cp ${FILESDIR}/estonian-tsl.xml	${S}/client/EE.xml
	# https://ec.europa.eu/information_society/policy/esignature/trusted-list/tl-mp.xml
	cp ${FILESDIR}/tl-mp.xml	${S}/client/tl-mp.xml
	# https://id.eesti.ee/config.json
	cp ${FILESDIR}/config.json	${S}/common/config.json
	# https://id.eesti.ee/config.rsa
	cp ${FILESDIR}/config.rsa	${S}/common/config.rsa
	# https://id.eesti.ee/config.pub
	cp ${FILESDIR}/config.pub	${S}/common/config.pub
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
