BUILDDIR = _build
TARGET   = i386-jos-elf
CONFIG_OPTIONS = -DCMAKE_INSTALL_PREFIX=/usr
CONFIG_OPTIONS += -DCMAKE_LINKER=$(TARGET)-ld

CMAKE = cmake

all : build

clean :
	rm -rf $(BUILDDIR)

config :
	mkdir -p $(BUILDDIR)
	cd $(BUILDDIR) && \
		$(CMAKE) -G "Unix Makefiles" $(CONFIG_OPTIONS) ../

build :
	cd $(BUILDDIR) && make VERBOSE=1

test :
	cd $(BUILDDIR) && make qemu

