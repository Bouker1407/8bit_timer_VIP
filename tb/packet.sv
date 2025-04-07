class packet;
typedef enum {READ, WRITE} transfer_enum;
bit [7:0] paddr;
bit [7:0] pdata;
transfer_enum transfer;

function new();
endfunction

endclass


