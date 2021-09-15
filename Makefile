release:
	swift build --configuration release
	cp -f .build/release/swiftuigen swiftuigen
