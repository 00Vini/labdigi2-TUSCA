/*
  FPGA manda 0 por 18us
  FPGA manda 1 por 20us
  DHT manda 0 por 80us
  DHT manda 1 por 80us
  Para cada bit
    DHT manda 0 por ~50us (aqui só consideramos um timeout de 100us)
    Se o bit é 1:
      DHT manda 1 por 26us
    Se o bit é 0:
      DHT manda 0 por 70us
    (Aqui consideraremos: se for maior que 50us, é 1, caso contrário é 0)
  Fim bits 

*/

module dht11 (
  inout dht_bus,
  input start,
  input clock,
  input reset,
  output reg [15:0] temperatura,
  output reg [15:0] umidade,
  output reg pronto,
  output reg error,
  output [3:0] db_estado
);

  localparam TIME_80us = 5000, // 100us
             TIME_18ms = 900000, //18ms
             TIME_20us = 1000, // 20us
             TIME_50us = 2500, // 50us
             TIME_TIMEOUT = 10000; // 20us
  localparam READ = 0, WRITE = 1;
  
  localparam IDLE = 0,
             SEND_SYNC_L = 1,
             SEND_SYNC_H = 2,
             RECEIVE_SYNC_L = 3,
             RECEIVE_SYNC_H = 4,
             RECEIVE_LOW = 5,
             RECEIVE_HIGH = 6,
             RECEIVE_BIT = 13,
             INSPECT_BIT = 7,
             CHECK_END = 8,
             END_RECEIVE = 9,
             ERRO = 10,
             CHECKSUM = 11,
             END_MEASURE = 12;

  wire                 dht_in;
  reg [3:0]            state;
  reg [39:0]           dht_data;
  reg [$clog2(39)-1:0]   bit_counter;
  reg [$clog2(900000)-1:0] time_counter, low_counter, high_counter;
  reg                  dir, dht_out;

  assign db_estado = state;

  assign dht_bus = dir ? dht_out : 1'bz; // dir = 1, write
  assign dht_in  = dir ? 1'bz : dht_bus; // dir = 0, read

  // Lógica de saída combinatória
  always @* begin
    if (state == SEND_SYNC_H || state == SEND_SYNC_L) begin
      dir = WRITE;
    end
    else begin
      dir = READ;
    end

    if (state == SEND_SYNC_H) begin
      dht_out = 1;
    end
    else begin
      dht_out = 0;
    end
  end

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      time_counter <= 0;
      low_counter <= 0;
      high_counter <= 0;
      bit_counter <= 39;
      temperatura <= 0;
      umidade <= 0;
      dht_data <= 0;
      state <= IDLE;
      error <= 0;
      pronto <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          if (start) begin
            state <= SEND_SYNC_L;
            time_counter <= 0;
            low_counter <= 0;
            high_counter <= 0;
            bit_counter <= 39;
            dht_data <= 0;
            error <= 0;
            pronto <= 0;
          end
          else begin
            state <= IDLE;
          end
        end
        SEND_SYNC_L: begin
          if (time_counter < TIME_18ms - 1) begin
            time_counter <= time_counter + 1'b1;
            state <= SEND_SYNC_L;
          end
          else begin
            time_counter <= 0;
            state <= SEND_SYNC_H;
          end
        end
        SEND_SYNC_H: begin
          if (time_counter < TIME_20us - 1) begin
            state <= SEND_SYNC_H;
            time_counter <= time_counter + 1'b1;
          end
          else begin
            time_counter <= 0;
            state <= RECEIVE_SYNC_L;
          end
        end
        RECEIVE_SYNC_L: begin
          if (dht_in == 0 && time_counter < TIME_80us - 1) begin
            state <= RECEIVE_SYNC_L;
            time_counter <= time_counter + 1'b1;
          end
          else begin
            time_counter <= 0;
            if (dht_in == 1) begin
              state <= RECEIVE_SYNC_H;
            end
            else begin
              state <= ERRO;
            end
          end
        end
        RECEIVE_SYNC_H: begin
          if (dht_in == 1 && time_counter < TIME_80us - 1) begin
            state <= RECEIVE_SYNC_H;
            time_counter <= time_counter + 1'b1;
          end
          else begin
            time_counter <= 0;
             if (dht_in == 0) begin
              state <= RECEIVE_LOW;
            end
            else begin
              state <= ERRO;
            end
          end
        end
        RECEIVE_LOW: begin
          if (dht_in == 0 && time_counter < TIME_TIMEOUT - 1) begin // Timeout
            state <= RECEIVE_LOW;
            low_counter <= low_counter + 1'b1;
          end
          else begin
            time_counter <= 0;
            if (dht_in == 1) begin
              state <= RECEIVE_HIGH;
            end
            else begin
              state <= ERRO;
            end
          end
        end
        RECEIVE_HIGH: begin
          if (dht_in == 1 && time_counter < TIME_TIMEOUT - 1) begin // Timeout
            state <= RECEIVE_HIGH;
            high_counter <= high_counter + 1'b1;
          end
          else begin
            time_counter <= 0;
            if (dht_in == 0) begin
              state <= RECEIVE_BIT;
            end
            else begin
              state <= ERRO;
            end
          end
        end
        RECEIVE_BIT: begin
          if (low_counter > high_counter) begin
            // Received 0
            dht_data[bit_counter] <= 1'b0;
            state <= INSPECT_BIT;
          end
          else begin
            // Received 1
            dht_data[bit_counter] <= 1'b1;
            state <= INSPECT_BIT;
          end
        end
        INSPECT_BIT: begin
          high_counter <= 0;
          low_counter <= 0;
          bit_counter <= bit_counter - 1'b1;
          state <= CHECK_END;
        end
        CHECK_END: begin
          time_counter <= 0;
          if (bit_counter == 0) begin
            state <= END_RECEIVE;
          end
          else begin
            state <= RECEIVE_LOW;
          end
        end
        ERRO: begin
          state <= IDLE;
          error <= 1;
        end
        END_RECEIVE: begin
          state <= IDLE;
          pronto <= 1;
          umidade <= dht_data[39:24];
          temperatura <= dht_data[23:8];
        end
        default: state <= IDLE;
      endcase
    end
  end


endmodule