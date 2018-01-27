CFLAGS:=-std=c11 -O3 -Wall

theloop.2.rom: *.py *.gcl Images/*.rgb Makefile
	./theloop.py\
		Snake.gcl\
		Racer.gcl\
		Mandelbrot.gcl\
		Pictures.gcl\
		Credits.gcl\
		Screen.gcl\
		Main.gcl\
		Reset.gcl

run: gtemu theloop.2.rom
	./gtemu

test: gtemu theloop.2.rom
	# Check for hSync errors in first ~30 seconds of emulation
	./gtemu | head -999999 | grep \~

time: gtemu theloop.2.rom
	# Run emulation until first sound
	./gtemu | grep -m 1 'xout [^0]'

burn: theloop.2.rom
	minipro -p 'AT27C1024 @DIP40' -w theloop.2.rom -y -s

%.rgb: %.png
	# Uses ImageMagick
	convert "$<" "$@"

todo:
	@git ls-files | sed 's/ /\\ /g' | xargs grep -I -i -E '(todo|xxx)'

# vi: noexpandtab
