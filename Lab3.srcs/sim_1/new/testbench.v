`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Compeng 331 Lab3
// Engineer: Rachel Brooks
// Create Date: 07/01/2020 11:03:44 PM

//Module Name: testbench
//////////////////////////////////////////////////////////////////////////////////

module testbench();

    reg clk;
    //pc and adder
    wire [31:0] pc;
    wire [31:0] pcout;
    
    //instruction mem
    wire [31:0] instr;
    wire [31:0] outif;
    //CU outputs
    wire wreg;
    wire m2reg;
    wire wmem; 
    wire [3:0] aluc;
    wire aluimm;
    //mux input
    wire regrt;
    //muxoutput
    wire [4:0] muxo;
    //regfile output
    wire [31:0] qa;
    wire [31:0] qb;
    //signextension output 
    wire [31:0] exout;
   // id exe output
    wire em2reg;
    wire ewreg;
    wire ewmem;
    wire [3:0] ealuc;
    wire ealuimm;
    //from muxout
    wire [4:0] emuxo;
    //from regfile
    wire [31:0] eqa;
    wire [31:0] eqb;
    //sign extension
    wire [31:0] eexout;
    //mux output
    wire [31:0] exemuxo;
    //alu output
    wire [31:0] aluout;
    //exemem output
    wire mwreg;
    wire mm2reg;
    wire mwmem;
    wire [4:0] mmux;
    wire [31:0] maluout;
    wire [31:0] mqb;
    //datamem output
    wire [31:0] do;
    //memwb output
    wire wwreg;
    wire wm2reg;
    wire [4:0] wmux;
    wire [31:0] waluout;
    wire [31:0] wdo;
    
    wire [31:0] wb_d;
    wire [1:0] fwda;
    wire [31:0]fwda_out;
    wire [1:0] fwdb;
    wire [31:0]fwdb_out;
   
    
    pc pc_tb(pc, pcout, clk,); //pc to next pc
    
    adder adder_tb(pcout, pc); //uses pc output and gets next pc
   
    IF_ID IF_ID_tb(clk, instr,outif);  //gets instruction and outputs it at clk edge (need clk)
    
    instMem instMem_tb(pcout, instr); //in address from adder and out instruction
    
    regFile regFile_tb(clk, outif[25:21], outif[20:16], wwreg, wmux, wb_d, qa, qb);
    
    signEx signEx_tb(outif, exout);
    
    controlUnit controlUnit_tb(outif[31:26], outif[5:0], outif[25:21], outif[20:16],mmux,emuxo, mm2reg,mwreg, em2reg, ewreg, wreg, m2reg, wmem, aluc, aluimm, regrt,fwda,fwdb);

    mux mux_tb(outif[15:11], outif[20:16], regrt, muxo);
    
    ID_EXE ID_EXE_tb(clk, wreg, m2reg,wmem, aluc, aluimm, muxo, fwda_out, fwdb_out, exout, ewreg, em2reg,ewmem, ealuc, ealuimm, emuxo, eqa, eqb, eexout);
    
    exe_mux exe_mux_tb(eqb,eexout,ealuimm,exemuxo);
    
    ALU ALU_tb(eqa,exemuxo,ealuc,aluout);
    
    EXE_MEM EXE_MEM_TB(clk, ewreg, em2reg, ewmem, emuxo, aluout, eqb, mwreg, mm2reg, mwmem, mmux, maluout, mqb);
     
    Datamem Datamem_tb(maluout, mqb, mwmem ,do);
    
    MEM_WB MEM_WB_tb(clk, mwreg,mm2reg,mmux, maluout,do,wwreg,wm2reg,wmux,waluout,wdo);
    
    wb_mux wb_mux_tb(waluout,wdo,wm2reg,wb_d);
   
    fwda_sel fwda_sel_tb(fwda, qa, aluout, maluout, do,fwda_out);
    
    fwdb_sel fwdb_sel_tb(fwdb, qb, aluout, maluout, do,fwdb_out);
   
    initial begin
        clk = 0;
    end

    always begin
        #5;
        clk = ~clk;
    end

endmodule
