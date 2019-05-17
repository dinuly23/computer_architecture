// ********************
// *модуль data_memory*
// ********************
// = Входы =
// [шина] addr [16]: адрес, по которому производится запись и с которого производится чтение данных
// [шина] id   [16]: данные, которые требуется записать в память по адресу addr
// [бит ] clk      : тактовый сигнал
// [бит ] w        : требуется ли запись данных (по переднему фронту clk)
//
// = Выходы =
// [шина] od [16]: данные, считываемые из памяти по адресу addr
//
// = Функционирование =
// Память содержит 2^16 ячейки памяти ширины 16, большинство которых фиктивно (не работает).
// Ячейки адресуются по словам ширины 16 (а не по байтам, как это обычно делается в "реальных" процессорах).
// В выходную шину непрерывно присваивается значение ячейки памяти с адресом addr.
// Если "w == 1", то по переднему фронту clk в ячейку памяти с адресом addr записывается значение id.
// Значение ячейки до записи не определено (xx...x).
//
// = Особенности реализации =
// Программное моделирование 2^16 ячеек памяти - вычислительно тяжёлая задача, поэтому большинство ячеек памяти в реализации объявлены "мёртвыми":
//   независимо от того, записывалось ли в них что бы то ни было, из этих ячеек всегда считывается 0.
// Остальные ячейки - "живые" и работают как полагается.
// Живыми объявлены ячейки со следующими диапазонами адресов и только они (четыре первых и четыре последних):
// * 00..000000 - 00..000011,
// * 11..111100 - 11..111111.
module data_memory(addr, id, clk, w, od);
  input [15:0] addr;
  input [15:0] id;
  input clk, w;
  output [15:0] od;
  
  // сигналы загрузки регистров и шины данных на выходах регистров
  wire l_low[0:3], l_high[0:3];
  wire [15:0] o_low[0:3];
  wire [15:0] o_high[0:3];
  
  // живые ячейки памяти
  genvar k;
  for(k = 0; k < 4; k = k + 1) begin : gen_block
    // диапазон 00..0
    register_sload #(.W(16)) _rl(.i(id), .l(l_low[k]), .clk(clk), .o(o_low[k]));
    // диапазон 11..1
    register_sload #(.W(16)) _rh(.i(id), .l(l_high[k]), .clk(clk), .o(o_high[k]));
  end
  
  // сигналы, по которым можно восстановить, к какому диапазону ячеек (low, high, мертвые) обращается addr, и для low/high - к какой ячейке диапазона
  wire addr_is_low = !(|addr[15:2]);
  wire addr_is_high = &addr[15:2];
  wire [1:0] truncated_addr = addr[1:0];
  
  // доведение сигнала записи до ячеек, т.е. установка l_low, l_high
  demux #(.DW(1), .CW(2)) _load_signal_low(
    .i(addr_is_low && w),
    .s(truncated_addr),
    .o({l_low[0], l_low[1], l_low[2], l_low[3]})
  );
  demux #(.DW(1), .CW(2)) _load_signal_high(
    .i(addr_is_high && w),
    .s(truncated_addr),
    .o({l_high[0], l_high[1], l_high[2], l_high[3]})
  );
  
  // выбор значения ячейки диапазаона low
  wire [15:0] od_low;
  mux #(.DW(16), .CW(2)) _get_read_low(
    .i({o_low[0], o_low[1], o_low[2], o_low[3]}),
    .s(truncated_addr),
    .o(od_low)
  );
  
  // выбор значения ячейки диапазаона high
  wire [15:0] od_high;
  mux #(.DW(16), .CW(2)) _get_read_high(
    .i({o_high[0], o_high[1], o_high[2], o_high[3]}),
    .s(truncated_addr),
    .o(od_high)
  );
  
  // выбор значения, выдаваемого на выход: мёртвое, od_low, od_high
  assign od =
    addr_is_low
    ? od_low
    : addr_is_high
      ? od_high
      : 0;
endmodule
