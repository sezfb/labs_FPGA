module my_module(port_a, port_b, x, y, z); 

input port_a; // =wire 1 bit input
output[7:0] port_b; // =wire 8 bit ouput
input x, y, z; // =wire 1 bit input x, y, z
...
endmodule

[=]

module my_module(
    input port_a,
    output[7:0] port_b, 
    input x, y, z);
...
endmodule

[=]

module my_module(input port_a, output[7:0] port_b, input x, y, z);
...
endmodule
-----------------------------------------------------------------------
Виклик модуля:
-----------------------------------------------------------------------
// опис модуля, *схоже до опису функції

module my_module( // [my_module] - тип модуля
    input port_a,
    output[7:0] port_b, 
    input x, y, z);
endmodule

wire a,b,c,d,e; // фактичні

---
*
// позиційний виклик
my_module mod1( port_a -> a, // mod1 назва модуля типу [my_module]
                port_b -> b, // + передача фактичних параметрів
                x -> c, 
                y -> d, 
                z -> e); 

[=] --- OR

// явний виклик *краще
my_module mod1( .x(a), .z(b), .y(c), .e(port_a), .d(port_b) )
*
---

! - Пиши спочатку всі inputs, потім усі outputs :

module my_module( 
    input port_a, 
    input x, y, z,

    output[7:0] port_b,
    );
endmodule