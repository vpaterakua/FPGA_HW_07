`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module tb_moving_max;

    localparam N = 64;
    localparam W = 8;
    
    reg     ap_clk;
    reg     ap_rst;
    reg     ap_start;
    wire    ap_done, ap_idle, ap_ready;
    
    wire[5:0]   in_data_address0;
    wire        in_data_ce0;
    reg[31:0]   in_data_q0;
    
    wire[5:0]   out_data_address0;
    wire        out_data_ce0;
    wire        out_data_we0;
    wire[31:0]  out_data_d0;
    
    integer in_mem  [0:N-1];
    integer out_mem [0:N-1];
    
    moving_max dut(
        .ap_clk(ap_clk), .ap_rst(ap_rst), .ap_start(ap_start),
        .ap_done(ap_done), .ap_idle(ap_idle), .ap_ready(ap_ready),
        .in_data_address0(in_data_address0), .in_data_ce0(in_data_ce0),
        .in_data_q0(in_data_q0), .out_data_address0(out_data_address0),
        .out_data_ce0(out_data_ce0), .out_data_we0(out_data_we0), .out_data_d0(out_data_d0)
        );
        
    integer n, k, start, ref_max, errors, t0;     
    
    
    //clock    
    always
        begin
            #5 ap_clk = ~ap_clk;
        end 
    
    //input data       
    always @(posedge ap_clk)
        begin
            if (in_data_ce0)
                in_data_q0 <= in_mem[in_data_address0];
        end
    
    //output data    
    always @(posedge ap_clk)
        begin
            if(out_data_ce0 && out_data_we0)
                out_mem[out_data_address0] <= out_data_d0;
        end
        
    initial
        begin
            ap_clk = 0;
            ap_rst = 1;
            ap_start = 0;
            
            //test data
            for (n = 0; n < N; n = n + 1)
                in_mem[n] = $urandom_range(0, 2000) - 1000;
            
            repeat (5) @(posedge ap_clk);
            ap_rst <= 0;
            repeat (5) @(posedge ap_clk);
            
            t0 = $time;
            ap_start <= 1;
            @(posedge ap_clk);
            while (!ap_ready) @(posedge ap_clk);
            ap_start <= 0;
            while (!ap_done) @(posedge ap_clk);
            @(posedge ap_clk);
            $display("Done after %0d cycles", ($time - t0) / 10);
            
            errors = 0;
            for (n = 0; n < N; n = n + 1) begin
                start = (n - (W - 1) < 0) ? 0 : n - (W - 1);
                ref_max = in_mem[start];
                for (k = start + 1; k <= n; k = k + 1)
                    if (in_mem[k] > ref_max) ref_max = in_mem[k];
                if (out_mem[n] !== ref_max) begin
                    $display("ERR n=%0d: got %0d, expected %0d", n, out_mem[n], ref_max);
                    errors = errors + 1;
                end    
        end
        
        if (errors == 0) $display("PASS");
        else             $display("FAIL (%0d errors)", errors);
        $finish;
        
    end
    
endmodule
