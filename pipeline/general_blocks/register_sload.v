// ***********************
// *модуль register_sload*
// ***********************
// = Входы =
// [шина] i   [W]: входные данные
// [бит ] l      : синхронный сигнал загрузки (сохранения входных данных по переднему фронту clk)
// [бит ] clk    : тактовый сигнал
//
// = Выходы =
// [шина] o [W]: выходные данные: непрерывно выводится последнее сохранённое значение
//
// = Параметры =
// W [16]: ширина шин входных и выходных данных
//
// = Функционирование =
// В выходную шину непрерывно выводится последнее сохранённое значение.
// Значение i сохраняется по переднему фронту clk, если в этот момент "l == 1".
// До первого переднего фронта clk сохранённое значение не определено (x).
module register_sload(i, l, clk, o);
  parameter W = 16;
  input [W-1:0] i;
  input l, clk;
  output reg [W-1:0] o;
  
  always @(posedge clk)
    if(l) o <= i; //l всегда 1
endmodule