# =====================================================
# Master's Thesis: Threshold-Based Sampling ASIC with FOSS tools.
# Author: Moritz Tockner, Simon Dorrer
# Last Modified: 02.04.2025
# Description: This .tcl file reports the power per entities.
# =====================================================

# Suppress Warnings
suppress_message STA 1111

suppress_message ODB 176
suppress_message ODB 197
suppress_message ODB 198
suppress_message ODB 199
suppress_message ODB 200
suppress_message ODB 202

set results_dir $::env(RESULTS_DIR)
set platform_dir $::env(PLATFORM_DIR)
set project_name $::env(PROJECT_NAME)

read_lef ${platform_dir}/lef/sg13g2_stdcell.lef

set top_entity_name ${project_name}

set lib_path "${platform_dir}/lib"

# Check if directory exists
if {![file exists $lib_path]} {
    puts "Error: Liberty file directory not found at $lib_path"
    exit 1
}

# Get all .lib files from all paths, excluding ccsnoise files
set lib_files {}
foreach path $lib_path {
    if {[file exists $path]} {
        set files [glob -nocomplain ${path}/*.lib]
        foreach file $files {
            if {![string match "*ccsnoise*" $file]} {
                lappend lib_files $file
            }
        }
    } else {
        puts "Warning: Path not found: $path"
    }
}

if {[llength $lib_files] == 0} {
    puts "Error: No .lib files found in any of the specified paths"
    exit 1
}

# Read each liberty file
foreach lib_file $lib_files {
    if {[catch {read_liberty $lib_file} err]} {
        puts "Error reading $lib_file: $err"
        exit 1
    }
}

read_verilog ${results_dir}/6_final.v

link_design ${top_entity_name}

read_spef ${results_dir}/6_final.spef

read_sdc ${results_dir}/6_final.sdc
# read_vcd ${results_dir}/${top_entity_name}.vcd 

set_power_activity -input_port reset_n_i -activity 1 -duty 1
set_power_activity -input_port enable_i -activity 1 -duty 1
# default: all other pins change with 10% probability

set report_port_activity 0
if {$report_port_activity} {
    set inputs [all_inputs]
    foreach input $inputs {
        set full_name [get_full_name $input]
        append full_name " " [get_property $input activity]
        puts $full_name
    }

    set outputs [all_outputs]
    foreach output $outputs {
        set full_name [get_full_name $output]
        append full_name " " [get_property $output activity]
        puts $full_name
    }
}

puts "Power report:"

report_parasitic_annotation
report_power

puts "Hierarchical power report:"

proc report_power_per_module {odb_path} {
    # Init db to find module names and hierarchy
    set db [odb::dbDatabase_create] 
    odb::read_db $db $odb_path 

    set chip [odb::dbDatabase_getChip $db] 
    set block [odb::dbChip_getBlock $chip] 
    set top [odb::dbBlock_getTopModule $block] 

    set top_entity [odb::dbModule_getChildren $top]
    foreach child $top_entity {
        process_children [odb::dbModInst_getMaster $child]
    }

    set total_power [report_power_for_module ""]
    set top_entity_name [odb::dbModule_getHierarchicalName $top]
    puts "$top_entity_name:\t[format "%.2e" $total_power] mW"
}

proc process_children {mod} {
    set name [odb::dbModule_getHierarchicalName $mod] 

    set total_power 0
    set total_power [expr $total_power + [report_power_for_module $name]]

    set children [odb::dbModule_getChildren $mod]
    foreach c $children {
        process_children [odb::dbModInst_getMaster $c]
    }
    puts "$name:\t[format "%.2e" $total_power] mW"
}

proc report_power_for_module {module_name} {
    report_power -instances [get_cells -hierarchical *$module_name*] > tmp.rpt

    set total_power 0
    set fp [open tmp.rpt r]
    while {[gets $fp line] >= 0} {
        if {[regexp {^\s+\S+\s+\S+\s+\S+\s+(\S+)\s} $line -> current_power]} {
            if {[string is double -strict $current_power]} {
                set total_power [expr {$total_power + $current_power}]
            }
        }
    }
    close $fp
    file delete tmp.rpt

    return $total_power
}

set odb_files [glob -nocomplain ${results_dir}/6_final.odb]
set odb_path [lindex $odb_files 0]
report_power_per_module $odb_path