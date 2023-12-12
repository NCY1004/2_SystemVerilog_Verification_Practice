verdiSetPrefEnv -bUndockNewCreatedWindow "on"
simSetSimulator "-vcssv" -exec \
           "/home/stone/System_Verilog_Study/2_Verfication_Projects/0_DFLIP_FLOP/simv" \
           -args "+ntb_random_seed=1"
debImport "-dbdir" \
          "/home/stone/System_Verilog_Study/2_Verfication_Projects/0_DFLIP_FLOP/simv.daidir"
debLoadSimResult \
           /home/stone/System_Verilog_Study/2_Verfication_Projects/0_DFLIP_FLOP/novas.fsdb
wvCreateWindow
wvResizeWindow -win $_nWave2 62 229 960 332
srcHBSelect "tb.vif" -win $_nTrace1
srcHBSelect "tb.dut" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {tb}
wvSetPosition -win $_nWave2 {("tb" 0)}
wvSetPosition -win $_nWave2 {("tb/vif(dff_if)" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {vif(dff_if)}
wvAddSignal -win $_nWave2 "/tb/vif/clk" "/tb/vif/rst" "/tb/vif/din" \
           "/tb/vif/dout"
wvSetPosition -win $_nWave2 {("tb/vif(dff_if)" 0)}
wvSetPosition -win $_nWave2 {("tb/vif(dff_if)" 4)}
wvSetPosition -win $_nWave2 {("tb/vif(dff_if)" 4)}
wvSetPosition -win $_nWave2 {("tb" 0)}
wvSetPosition -win $_nWave2 {("tb/vif(dff_if)" 4)}
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("tb" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvRenameGroup -win $_nWave2 {G2} {dut}
wvAddSignal -win $_nWave2 "/tb/dut/clk" "/tb/dut/rst" "/tb/dut/din" \
           "/tb/dut/dout"
wvSetPosition -win $_nWave2 {("dut" 0)}
wvSetPosition -win $_nWave2 {("dut" 4)}
wvSetPosition -win $_nWave2 {("dut" 4)}
wvResizeWindow -win $_nWave2 62 19 1848 1016
wvSetCursor -win $_nWave2 181.917362 -snap {("dut" 2)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 475.900785 -snap {("dut" 1)}
wvSetCursor -win $_nWave2 167.683162 -snap {("vif(dff_if)" 3)}
wvSetCursor -win $_nWave2 465.520398 -snap {("vif(dff_if)" 4)}
wvSetCursor -win $_nWave2 552.555944 -snap {("dut" 0)}
wvSetCursor -win $_nWave2 705.866264 -snap {("dut" 2)}
wvSetCursor -win $_nWave2 797.692758 -snap {("dut" 2)}
wvSetCursor -win $_nWave2 1119.484731 -snap {("dut" 2)}
wvZoom -win $_nWave2 1184.961014 1196.938383
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvResizeWindow -win $_nWave2 601 372 960 332
