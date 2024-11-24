onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/PCF
add wave -noupdate /testbench/IMRead
add wave -noupdate /testbench/InstrF
add wave -noupdate /testbench/IMRdy
add wave -noupdate /testbench/MAddr
add wave -noupdate /testbench/MData
add wave -noupdate /testbench/MRdy
add wave -noupdate /testbench/dut/valid_array
add wave -noupdate /testbench/dut/tag_array
add wave -noupdate /testbench/dut/data_array
add wave -noupdate /testbench/dut/hit
add wave -noupdate /testbench/dut/tag_in
add wave -noupdate /testbench/dut/index
add wave -noupdate /testbench/MRead
add wave -noupdate /testbench/index
add wave -noupdate /testbench/dut/clk
add wave -noupdate /testbench/dut/reset
add wave -noupdate /testbench/dut/A
add wave -noupdate /testbench/dut/RD
add wave -noupdate /testbench/dut/RE
add wave -noupdate /testbench/dut/RDY
add wave -noupdate /testbench/dut/MAddr
add wave -noupdate /testbench/dut/MData
add wave -noupdate /testbench/dut/MRead
add wave -noupdate /testbench/dut/MRdy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {242 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 97
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {968 ps}
