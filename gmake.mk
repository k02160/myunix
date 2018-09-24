include mk/target.mk

all :
	$(MAKE) -C tools $@
	$(MAKE) -C initcode  $@
	$(MAKE) -C bootblock $@
	$(MAKE) -C bootblockother $@
	$(MAKE) -C kernel $@
	$(MAKE) -C usr $@
	$(MAKE) -C tests $@

clean :
	$(MAKE) -C tools $@
	$(MAKE) -C initcode  $@
	$(MAKE) -C bootblock $@
	$(MAKE) -C bootblockother $@
	$(MAKE) -C kernel $@
	$(MAKE) -C usr $@
	$(MAKE) -C tests $@

qemu :
	$(MAKE) -C tests $@

.EXPORT_ALL_VARIABLES :

