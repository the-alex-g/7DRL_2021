all: zip

clean:
	rm -rf build

zip:
	mkdir -p build/web
	godot -v --export "HTML5" ../build/web/index.html project/project.godot
	cd build/web; zip web.zip *
