source $::env(SCRIPTS_DIR)/load.tcl
load_design 6_final.odb 6_final.sdc

source $::env(UTILS_DIR)/write_segment_rc.tcl

# Set up RCX parameters to avoid any parasitics segment merging.
extract_parasitics -ext_model_file $::env(RCX_RULES) -max_res 0 -no_merge_via_res
fetch_segments_rc rcx

write_segment_rc_csv $::env(RESULTS_DIR)/6_segment_rc.csv rcx
