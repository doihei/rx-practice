#
## Usage:
#	 make test
#
#
xcodegen:
	mint run XcodeGen xcodegen
bootstrap:
	brew bundle
	mint bootstrap
	bundle config set path 'vendor/bundle'
	bundle install
	mint run XcodeGen xcodegen
	./scripts/carthage_xc12.sh bootstrap --platform iOS --cache-builds
install-template:
	sh scripts/xcode-template/install-xcode-template.sh
install-library:
	mint run XcodeGen xcodegen
	./scripts/carthage_xc12.sh bootstrap --platform iOS --cache-builds
update-carthage:
	./scripts/carthage_xc12.sh update --platform iOS --cache-builds