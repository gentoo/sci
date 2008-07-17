shared: DIRNAME $(SHOBJ)
	$(LINK_CXX) $(PICFLAG) -shared -Wl,-soname,lib`cat DIRNAME`.so -o lib`cat DIRNAME`.so $(SHOBJ) $(GMP_LIBDIR) $(GMP_LIB)
	ln -s lib`cat DIRNAME`.so libntl.so
