LDPARAMS = -melf_i386
ASPARAMS = --32
GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore

objects = output/loader.o output/kernel.o

output/%.o: src/asm/%.s
	as $(ASPARAMS) -o $@ $<

output/%.o: src/cpp/%.cpp
	g++ $(GPPPARAMS) -o $@ -c $<

esperos.bin: src/ld/linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)
	mv esperos.bin output

install: output/esperos.bin
	sudo cp $< /boot/esperos.bin

esperos.iso: output/esperos.bin
	mkdir -p output/iso/boot/grub
	cp $< output/iso/boot/

	echo 'set timeout=0' > output/iso/boot/grub/grub.cfg
	echo 'set default=0' >> output/iso/boot/grub/grub.cfg
	echo '' >> output/iso/boot/grub/grub.cfg
	echo 'menuentry "Esperos" {' >> output/iso/boot/grub/grub.cfg
	echo '	multiboot /boot/esperos.bin' >> output/iso/boot/grub/grub.cfg
	echo '	boot' >> output/iso/boot/grub/grub.cfg
	echo '}' >> output/iso/boot/grub/grub.cfg

	grub-mkrescue --output=$@ output/iso
	rm -rf output/iso
	mv esperos.iso output

run: esperos.iso
	/usr/lib/virtualbox/VirtualBoxVM --startvm esperos &
