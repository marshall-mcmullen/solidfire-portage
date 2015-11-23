# Copyright 2011, Solidfire, Inc., All rights reserved.
#

MKDIR=mkdir
CP=cp
AR=ar
RANLIB=ranlib
CC=gcc

DEBUG_FLAGS = -g
OPTIMIZATION_FLAGS = -O2

CFLAGS=$(DEBUG_FLAGS) $(OPTIMIZATION_FLAGS)

DESTDIR = /usr/local

# Link Libraries and Options
LDLIBSOPTIONS=

%.o: %.c
	@$(RM) $(@:.o=.d)
	$(CC) -c $(CFLAGS) -MMD -MP -MF $(@:.o=.d) $(CPPFLAGS) -o $@ $<

LIBSKEIN=libskein.a

OBJS =            \
	skein_debug.o \
	skein.o       \
	skein_block.o \
	$(END_OF_LIST)

HDRS =            \
	SHA3api_ref.h \
	brg_endian.h  \
	brg_types.h   \
	skein.h       \
	skein_debug.h \
	skein_iv.h    \
	skein_port.h  \
	$(END_OF_LIST)

libskein.a: $(OBJS)
	$(RM) $(LIBSKEIN)
	$(AR) -rv $(LIBSKEIN) $(OBJS) 
	$(RANLIB) $(LIBSKEIN)

.PHONY: clean install

install: libskein.a
	$(MKDIR) -p $(LIBDIR) && $(CP) -f $(LIBSKEIN) $(LIBDIR)
	$(MKDIR) -p $(INCDIR) && $(CP) -f $(HDRS) $(INCDIR)

clean:
	-$(RM) -f $(LIBSKEIN) $(OBJS) $(OBJS:.o=.d) *.deb description-pak

ifneq ($(MAKECMDGOALS),clean)
-include $(OBJS:.o=.d)
endif
