SOURCE=./SCADs
TARGET=./STLs
OPENSCAD:=openscad -D variant=0 -D linear=1

# List of the basic file names we need to process
BASE_FILES:=$(basename $(notdir $(wildcard $(SOURCE)/*.scad)))
# Remove the ones that shouldn't be made directly
REMOVE_FILES:=frame-vertex configuration functions metric OpenScadFont sae \
	thicksheet ybrac-t x-lm8uu-holder
BASE_FILES:=$(filter-out $(REMOVE_FILES),$(BASE_FILES))

# Construct the set of output files to make from the base filenames
TARGETS:=$(addsuffix .stl,$(addprefix $(TARGET)/,$(BASE_FILES)))
# and add in the extras that we wouldn't otherwise make
TARGETS+=$(TARGET)/y-motor-bracket.stl \
	$(TARGET)/frame-vertex-without-foot.stl \
	$(TARGET)/frame-vertex-with-foot.stl

parts: $(TARGET) $(TARGETS)
help:
	@echo Options:
	@echo make: Builds all the parts
	@echo make clean: deletes the stl directory with the output files

$(TARGET):
	mkdir -p $(TARGET)

$(TARGET)/%.stl: $(SOURCE)/%.scad
	$(OPENSCAD) -o $@ $< 2>/dev/null

$(TARGET)/frame-vertex-with-foot.stl: $(SOURCE)/vertex.scad
	$(OPENSCAD) -D basefoot=true -o $@ $< 2>/dev/null

$(TARGET)/frame-vertex-without-foot.stl: $(SOURCE)/vertex.scad
	$(OPENSCAD) -D basefoot=false -o $@ $< 2>/dev/null

$(TARGET)/y-motor-bracket.stl: $(SOURCE)/ybrac-t.scad
	$(OPENSCAD) -o $@ $< 2>/dev/null


#$(PARTS) : $(TARGET)
#	@echo "Processing $@"
#	$(OPENSCAD) -s $(TARGET)/$@.stl $@.scad
clean:
	rm -rf $(TARGET)/*.stl
