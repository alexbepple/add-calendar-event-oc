release := xcodebuild -project addEvent.xcodeproj -alltargets -configuration Release

default: clean build

.PHONY : clean build

clean:
	$(release) clean

build:
	$(release)

