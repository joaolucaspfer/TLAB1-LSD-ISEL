library ieee;

use ieee.std_logic_1164.all;

entity maioria is
port(
-- Input ports
	A : in std_logic;
	B : in std_logic;
	C : in std_logic;
	D : in std_logic;
-- Output port	
	M : out std_logic
	);
	end maioria;
	
architecture structural of maioria is
signal term : std_logic_vector(3 downto 0);
begin
term(0) <= A and B and C;
term(1) <= A and B and D;
term(2) <= A and C and D;
term(3) <= B and C and D;

M <= term(0) or term(1) or term(2) or term(3);

end structural;
