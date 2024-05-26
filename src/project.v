/*
 * Copyright (c) 2024 xenia dragon
 * SPDX-License-Identifier: Apache-2.0
 *
 * [usagi holding floppy disk.png] i'll just warn you right now, i don't know how to use a computer
 *
 * this is quite literally the first time i've written verilog. i have some VHDL experience but if
 * this code is spaghetti, i'm sorry ;____;
 */

`default_nettype none

module tt_um_xeniarose_sha256 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  // assign uio_out = 0;
  // assign uio_oe  = 0;

  wire [ 5 : 0 ] io_addr = ui_in[5 : 0];
  wire io_we = ui_in[6];
  wire io_clk = ui_in[7];

  reg io_ready;
  assign uo_out[0] = io_ready;

  assign uo_out[1] = io_we;
  assign uo_out[7 : 2] = 6'h0;
  assign uio_oe[0] = io_we;
  assign uio_oe[1] = io_we;
  assign uio_oe[2] = io_we;
  assign uio_oe[3] = io_we;
  assign uio_oe[4] = io_we;
  assign uio_oe[5] = io_we;
  assign uio_oe[6] = io_we;
  assign uio_oe[7] = io_we;

  reg [7 : 0] io_out;
  assign uio_out = io_out;

  reg [ 31 : 0 ] A_reg;
  reg [ 31 : 0 ] B_reg;
  reg [ 31 : 0 ] C_reg;
  reg [ 31 : 0 ] D_reg;
  reg [ 31 : 0 ] E_reg;
  reg [ 31 : 0 ] F_reg;
  reg [ 31 : 0 ] G_reg;
  reg [ 31 : 0 ] H_reg;

  reg [ 31 : 0 ] W_reg;
  reg [ 31 : 0 ] K_reg;

  wire [ 31 : 0 ] s1 =
    {E_reg[5:0],E_reg[31:6]} ^ {E_reg[10:0],E_reg[31:11]} ^ {E_reg[24:0],E_reg[31:25]};
  wire [ 31 : 0 ] ch = (E_reg & F_reg) ^ ((~E_reg) & G_reg);
  wire [ 31 : 0 ] temp1 = H_reg + s1 + ch + K_reg + W_reg;
  wire [ 31 : 0 ] s0 =
    {A_reg[1:0],A_reg[31:2]} ^ {A_reg[12:0],A_reg[31:13]} ^ {A_reg[21:0],A_reg[31:22]};
  wire [ 31 : 0 ] maj = (A_reg & B_reg) ^ (A_reg & C_reg) ^ (B_reg & C_reg);
  wire [ 31 : 0 ] temp2 = s0 + maj;

  always @(posedge clk or negedge rst_n) begin : io_proc
    if (!rst_n) begin
      A_reg <= 32'h0;
      B_reg <= 32'h0;
      C_reg <= 32'h0;
      D_reg <= 32'h0;
      E_reg <= 32'h0;
      F_reg <= 32'h0;
      G_reg <= 32'h0;
      H_reg <= 32'h0;
      W_reg <= 32'h0;
      K_reg <= 32'h0;

      io_out <= 8'h0;
      io_ready <= 0;
    end else begin
      io_ready <= 1;

      if (io_clk) begin
        if (!io_we) begin
          case (io_addr)
             0: begin
              A_reg <= temp1 + temp2;
              B_reg <= A_reg;
              C_reg <= B_reg;
              D_reg <= C_reg;
              E_reg <= D_reg + temp1;
              F_reg <= E_reg;
              G_reg <= F_reg;
              H_reg <= G_reg;
            end

             4: begin W_reg[ 7 :  0] <= uio_in; end
             5: begin W_reg[15 :  8] <= uio_in; end
             6: begin W_reg[23 : 16] <= uio_in; end
             7: begin W_reg[31 : 24] <= uio_in; end

             8: begin K_reg[ 7 :  0] <= uio_in; end
             9: begin K_reg[15 :  8] <= uio_in; end
            10: begin K_reg[23 : 16] <= uio_in; end
            11: begin K_reg[31 : 24] <= uio_in; end

            32: begin A_reg[ 7 :  0] <= uio_in; end
            33: begin A_reg[15 :  8] <= uio_in; end
            34: begin A_reg[23 : 16] <= uio_in; end
            35: begin A_reg[31 : 24] <= uio_in; end

            36: begin B_reg[ 7 :  0] <= uio_in; end
            37: begin B_reg[15 :  8] <= uio_in; end
            38: begin B_reg[23 : 16] <= uio_in; end
            39: begin B_reg[31 : 24] <= uio_in; end

            40: begin C_reg[ 7 :  0] <= uio_in; end
            41: begin C_reg[15 :  8] <= uio_in; end
            42: begin C_reg[23 : 16] <= uio_in; end
            43: begin C_reg[31 : 24] <= uio_in; end

            44: begin D_reg[ 7 :  0] <= uio_in; end
            45: begin D_reg[15 :  8] <= uio_in; end
            46: begin D_reg[23 : 16] <= uio_in; end
            47: begin D_reg[31 : 24] <= uio_in; end

            48: begin E_reg[ 7 :  0] <= uio_in; end
            49: begin E_reg[15 :  8] <= uio_in; end
            50: begin E_reg[23 : 16] <= uio_in; end
            51: begin E_reg[31 : 24] <= uio_in; end

            52: begin F_reg[ 7 :  0] <= uio_in; end
            53: begin F_reg[15 :  8] <= uio_in; end
            54: begin F_reg[23 : 16] <= uio_in; end
            55: begin F_reg[31 : 24] <= uio_in; end

            56: begin G_reg[ 7 :  0] <= uio_in; end
            57: begin G_reg[15 :  8] <= uio_in; end
            58: begin G_reg[23 : 16] <= uio_in; end
            59: begin G_reg[31 : 24] <= uio_in; end

            60: begin H_reg[ 7 :  0] <= uio_in; end
            61: begin H_reg[15 :  8] <= uio_in; end
            62: begin H_reg[23 : 16] <= uio_in; end
            63: begin H_reg[31 : 24] <= uio_in; end
          endcase
        end else begin
          case (io_addr)
             0: begin io_out[7 : 0] <= 8'h0; end

             4: begin io_out <= W_reg[ 7 :  0]; end
             5: begin io_out <= W_reg[15 :  8]; end
             6: begin io_out <= W_reg[23 : 16]; end
             7: begin io_out <= W_reg[31 : 24]; end

             8: begin io_out <= K_reg[ 7 :  0]; end
             9: begin io_out <= K_reg[15 :  8]; end
            10: begin io_out <= K_reg[23 : 16]; end
            11: begin io_out <= K_reg[31 : 24]; end

            32: begin io_out <= A_reg[ 7 :  0]; end
            33: begin io_out <= A_reg[15 :  8]; end
            34: begin io_out <= A_reg[23 : 16]; end
            35: begin io_out <= A_reg[31 : 24]; end

            36: begin io_out <= B_reg[ 7 :  0]; end
            37: begin io_out <= B_reg[15 :  8]; end
            38: begin io_out <= B_reg[23 : 16]; end
            39: begin io_out <= B_reg[31 : 24]; end

            40: begin io_out <= C_reg[ 7 :  0]; end
            41: begin io_out <= C_reg[15 :  8]; end
            42: begin io_out <= C_reg[23 : 16]; end
            43: begin io_out <= C_reg[31 : 24]; end

            44: begin io_out <= D_reg[ 7 :  0]; end
            45: begin io_out <= D_reg[15 :  8]; end
            46: begin io_out <= D_reg[23 : 16]; end
            47: begin io_out <= D_reg[31 : 24]; end

            48: begin io_out <= E_reg[ 7 :  0]; end
            49: begin io_out <= E_reg[15 :  8]; end
            50: begin io_out <= E_reg[23 : 16]; end
            51: begin io_out <= E_reg[31 : 24]; end

            52: begin io_out <= F_reg[ 7 :  0]; end
            53: begin io_out <= F_reg[15 :  8]; end
            54: begin io_out <= F_reg[23 : 16]; end
            55: begin io_out <= F_reg[31 : 24]; end

            56: begin io_out <= G_reg[ 7 :  0]; end
            57: begin io_out <= G_reg[15 :  8]; end
            58: begin io_out <= G_reg[23 : 16]; end
            59: begin io_out <= G_reg[31 : 24]; end

            60: begin io_out <= H_reg[ 7 :  0]; end
            61: begin io_out <= H_reg[15 :  8]; end
            62: begin io_out <= H_reg[23 : 16]; end
            63: begin io_out <= H_reg[31 : 24]; end
          endcase
        end
      end

    end
  end // rst_proc

endmodule
