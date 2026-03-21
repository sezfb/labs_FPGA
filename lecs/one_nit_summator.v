module sum1(input a,b,c output s,h_c);

// проміжні дроти
wire xor1_out, and1_out, xor2_out, and2_out, or_out;

// 1 крок
xor xor1(xor1_out, a, b);
and and1(and1_out, a, b);

// 2 крок
xor xor2(xor2_out, xor1_out, c);
and and2(and2_out, xor1_out, c);

// 3 крок
or or1(or_out, and2, and1);
assign h_c = or_out;
assign s = xor2_out;

endmodule
/*

1 bit summator
------------------------------
| A | B | C_in | Sum | C_out | 
| 0 | 0 | 0    | 0   | 0     |
| 0 | 0 | 1    | 1   | 0     | 
| 0 | 1 | 0    | 1   | 0     | 
| 0 | 1 | 1    | 0   | 1     |
| 1 | 0 | 0    | 1   | 0     |
| 1 | 0 | 1    | 0   | 1     |
| 1 | 1 | 0    | 0   | 1     |
| 1 | 1 | 1    | 1   | 1     |
*/



