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
	make install-template
install-template:
	sh scripts/xcode-template/install-xcode-template.sh