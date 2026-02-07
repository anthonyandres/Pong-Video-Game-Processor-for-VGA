
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name SVGP -dir "/home/student1/aaandres/Desktop/COE758 Labs/PROJECT2/SVGP/planAhead_run_1" -part xc3s500efg320-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/student1/aaandres/Desktop/COE758 Labs/PROJECT2/SVGP/pong_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/student1/aaandres/Desktop/COE758 Labs/PROJECT2/SVGP} {ipcore_dir} }
add_files [list {ipcore_dir/ROM.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "constraints.ucf" [current_fileset -constrset]
add_files [list {constraints.ucf}] -fileset [get_property constrset [current_run]]
open_netlist_design
