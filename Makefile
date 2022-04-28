LDPARAMS = -melf_i386
ASPARAMS = --32
GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore

objects = output/loader.o output/kernel.o

output/%.o: sources/asm/%.s
	as $(ASPARAMS) -o $@ $<

output/%.o: sources/cpp/%.cpp
	g++ $(GPPPARAMS) -o $@ -c $<

esperos.iso: esperos.bin
	mkdir -p output/iso/boot/grub
	cp output/esperos.bin output/iso/boot/

	cp assets/grub.cfg output/iso/boot/grub
	grub-mkrescue --output=$@ output/iso

	rm -rf output/iso
	mv esperos.iso output

esperos.bin: sources/ld/linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)
	mv esperos.bin output

install: output/esperos.bin
	sudo cp $< /boot/esperos.bin

run: esperos.iso
	/usr/lib/virtualbox/VirtualBoxVM --startvm esperos &

clean_o:
	rm -f output/*.o

clean_bin:
	rm -f output/esperos.bin

clean_iso:
	rm -f output/esperos.iso

clean_all:
	rm -f output/*.*
