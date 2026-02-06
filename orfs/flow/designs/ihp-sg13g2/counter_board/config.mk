export DESIGN_NAME = counter_board
export PLATFORM    = ihp-sg13g2

export VERILOG_FILES  = $(FLOW_HOME)/../../verilog/rtl/$(DESIGN_NAME).v
export SDC_FILE       = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/constraint.sdc
export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NAME)/io.tcl

export USE_FILL = 1

export PLACE_DENSITY ?= 0.88
#export CORE_UTILIZATION = 60
export TNS_END_PERCENT = 100

export DIE_AREA    = 0 0 100 100
export CORE_AREA   = 20 20 80 80

# Suppress errors due to empty cells
export GDS_ALLOW_EMPTY=$(DESIGN_NAME)_DEF_FILL