library ieee;
use ieee.std_logic_1164.all;

entity maioria_tb is
end maioria_tb;

architecture tb_maioria of maioria_tb is
component maioria is
port(
-- Input ports
	A : in std_logic;
	B : in std_logic;
	C : in std_logic;
	D : in std_logic;
-- Output port	
	M : out std_logic
	);
end component;

	
	signal X, Y, Z, W, F :std_logic;
	
	begin
	
	UUT: maioria port map( A => X, B => Y, C => Z, D => W, M => F);
	
	process
	begin
		X <= '0';
		Y <= '0';
		Z <= '0';
		W <= '0';
		wait for 10 ns;
		
		X <= '0';
		Y <= '0';
		Z <= '0';
		W <= '1';
		wait for 10 ns;
		
		X <= '0';
		Y <= '0';
		Z <= '1';
		W  <= '1';
		wait for 10 ns;
		
		X <= '0';
		Y <= '1';
		Z <= '1';
		W  <= '1';
		wait for 10 ns;
		wait;
	end process;
	
	end tb_maioria;
