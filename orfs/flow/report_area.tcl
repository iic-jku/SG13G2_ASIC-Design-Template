# =====================================================
# Master's Thesis: Threshold-Based Sampling ASIC with FOSS tools.
# Author: Jakob Winkler, Simon Dorrer
# Last Modified: 02.04.2025
# Description: This .tcl file loads the .odb file and reports the area per entities.
# =====================================================

set odb_file $::env(ODB_FILE)
set db [odb::dbDatabase_create] 
odb::read_db $db $odb_file

set chip [odb::dbDatabase_getChip $db] 
set block [odb::dbChip_getBlock $chip] 
set top [odb::dbBlock_getTopModule $block] 

# process hierarchy 
proc process_children {mod} { 
    # name 
    set name [odb::dbModule_getHierarchicalName $mod] 

    # area 
    set insts [odb::dbModule_getInsts $mod] 
    set area 0 
    foreach i $insts { 
        set box [odb::dbInst_getBBox $i] 
        set dx [odb::dbBox_getDX $box] 
        set dy [odb::dbBox_getDY $box] 
        set area [expr $area + ($dx * $dy)] 
    }

    # children 
    set children [odb::dbModule_getChildren $mod]
    foreach c $children {
        set c_area [process_children [odb::dbModInst_getMaster $c]]
        set area [expr $area + $c_area]
    }

    set printable_area [expr $area / 1e6]
    puts "$name:\t$printable_area um2"
    return $area
}

process_children $top 