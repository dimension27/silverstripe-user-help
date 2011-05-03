# Simple Makefile for configuration of site specific settings

.PHONY : config
config:
	@script/configure.pl

force:
	@script/configure.pl

clean: 
	@for mungeFile in `cat config/configure-files.txt`; do rm $$mungeFile; done