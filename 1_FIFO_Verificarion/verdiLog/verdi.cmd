verdiSetPrefEnv -bUndockNewCreatedWindow "on"
simSetSimulator "-vcssv" -exec \
           "/home/stone/System_Verilog_Study/2_Verfication_Projects/1_FIFO_Verificarion/simv" \
           -args "+ntb_random_seed=1"
debImport "-dbdir" \
          "/home/stone/System_Verilog_Study/2_Verfication_Projects/1_FIFO_Verificarion/simv.daidir"
debLoadSimResult \
           /home/stone/System_Verilog_Study/2_Verfication_Projects/1_FIFO_Verificarion/novas.fsdb
wvCreateWindow
wvResizeWindow -win $_nWave2 62 229 960 332
srcHBDrag -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {dut}
wvAddSignal -win $_nWave2 "/tb/dut/clock" "/tb/dut/rst" "/tb/dut/rd" "/tb/dut/wr" \
           "/tb/dut/data_in\[7:0\]" "/tb/dut/data_out\[7:0\]" "/tb/dut/full" \
           "/tb/dut/empty"
wvSetPosition -win $_nWave2 {("dut" 0)}
wvSetPosition -win $_nWave2 {("dut" 8)}
wvSetPosition -win $_nWave2 {("dut" 8)}
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("dut" 0)}
wvSetPosition -win $_nWave2 {("dut" 1)}
wvSetPosition -win $_nWave2 {("dut" 2)}
wvSetPosition -win $_nWave2 {("dut" 3)}
wvSetPosition -win $_nWave2 {("dut" 4)}
wvSetPosition -win $_nWave2 {("dut" 5)}
wvSetPosition -win $_nWave2 {("dut" 6)}
wvSetPosition -win $_nWave2 {("dut" 6)}
wvSetPosition -win $_nWave2 {("dut/tb" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {tb}
wvSetPosition -win $_nWave2 {("dut" 6)}
wvSetPosition -win $_nWave2 {("dut" 6)}
wvSetPosition -win $_nWave2 {("dut/fif(fifo_if)" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {fif(fifo_if)}
wvAddSignal -win $_nWave2 "/tb/fif/clock" "/tb/fif/rst" "/tb/fif/rd" "/tb/fif/wr" \
           "/tb/fif/data_in\[7:0\]" "/tb/fif/data_out\[7:0\]" "/tb/fif/full" \
           "/tb/fif/empty"
wvSetPosition -win $_nWave2 {("dut/fif(fifo_if)" 0)}
wvSetPosition -win $_nWave2 {("dut/fif(fifo_if)" 8)}
wvSetPosition -win $_nWave2 {("dut" 6)}
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
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 127.924577 -snap {("fif(fifo_if)" 2)}
wvResizeWindow -win $_nWave2 877 357 993 592
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
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
wvGoToGroup -win $_nWave2 "G2"
wvTpfCloseForm -win $_nWave2
wvGetSignalClose -win $_nWave2
wvCloseWindow -win $_nWave2
debExit
