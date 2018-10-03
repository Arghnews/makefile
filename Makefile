# Set shell - want bash not sh or other
SHELL       := /bin/bash

# Compiler and Linker
CC          := g++

# The Target Binary Program
TARGET      := program

# The Directories, Source, Includes, Objects, Binary and Resources
# Ensure BUILDDIR is a temporary directory as it will be deleted by clean
SRCDIR      := src
INCDIR      := include
BUILDDIR    := obj
TARGETDIR   := bin
#RESDIR      := res
SRCEXT      := cpp
DEPEXT      := d
OBJEXT      := o

# Flags, Libraries and Includes
# Here the runtime library path where xxHash is built is the same directory
# as its source
CFLAGS      := -Wall -g -std=c++17 #-Wl,-rpath,./xxHash/
LIBDIR      := #-LxxHash
LIB         := #-lpthread -lxxhash #-fopenmp -lm -larmadillo
INC         := #-Icxx-prettyprint -I$(INCDIR) -IxxHash #-I/usr/local/include
INCDEP      := $(INC)

# ---------------------------------------------------------------------------------
# DO NOT EDIT BELOW THIS LINE
# ---------------------------------------------------------------------------------
SOURCES     := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS     := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))

# Default Make
all: resources prog

prog: $(TARGETDIR)/$(TARGET) 

# Remake
#remake: cleaner all

# Mirror contents of resources and target directories
# Only needed if want res directory contents to be moved to bin on building
resources: directories
	@#rsync --exclude=$(TARGET) --delete -a $(RESDIR)/$(TARGETDIR)

# Make the Directories
directories:
	@mkdir -p $(TARGETDIR)
	@mkdir -p $(BUILDDIR)
	@#mkdir -p $(RESDIR)

# Don't delete targetdir in case it's . for example 
clean:
	@$(RM) -rf $(BUILDDIR)
	@$(RM) -f $(TARGETDIR)/$(TARGET)

# Pull in dependency info for *existing* .o files
#-include $(OBJECTS:.$(OBJEXT)=.$(DEPEXT))

# Link
$(TARGETDIR)/$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGETDIR)/$(TARGET) $^ $(LIBDIR) $(LIB)

# Compile
$(BUILDDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<
	@$(CC) $(CFLAGS) $(INCDEP) -MM $(SRCDIR)/$*.$(SRCEXT) > $(BUILDDIR)/$*.$(DEPEXT)
	@cp -f $(BUILDDIR)/$*.$(DEPEXT) $(BUILDDIR)/$*.$(DEPEXT).tmp
	@sed -e 's|.*:|$(BUILDDIR)/$*.$(OBJEXT):|' < $(BUILDDIR)/$*.$(DEPEXT).tmp > $(BUILDDIR)/$*.$(DEPEXT)
	@sed -e 's/.*://' -e 's/\\$$//' < $(BUILDDIR)/$*.$(DEPEXT).tmp | fmt -1 | sed -e 's/^ *//' -e 's/$$/:/' >> $(BUILDDIR)/$*.$(DEPEXT)
	@rm -f $(BUILDDIR)/$*.$(DEPEXT).tmp

# Non-File Targets
.PHONY: all clean resources prog #remake

# Good starting tutorial
# 	https://gist.github.com/isaacs/62a2d1825d04437c6f08
# 	http://make.mad-scientist.net/papers/advanced-auto-dependency-generation
# Cheatsheet
# 	https://devhints.io/makefile
# Makefile this one is based off
# 	https://stackoverflow.com/a/27794283

# Changes from original on stack overflow
# - Changed inc to include - currently untested/unused
# - Put CFLAGS on to linking too, so can specify -Wl,-rpath type stuff
# - Made INCDEP same as INC - unsure on this
# - resouces target syncs the bin and the res directories on running
#   this could get annoying if want to edit a file in place and have it
#   there for next run, we'll see
# - Changed all to depend on phony target that depends on the executable
#   to stop linking every time make is run
# - Unsure how slow this is, particularly on a big project on a spinny disc
#   or (god-forbid) an NFS
# - Added shell set to bash
# remake doesn't work - I believe because of the order that make processes
# dependencies and runs commands. So remake should "clean" then build "all"
# however when running remake "clean" is run deleting the objects but then 
# "all" is run and still sees (in "make -d" debug output) the objects there
# and does not perform a rebuild. Unsure how to fix this

