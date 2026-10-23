library ieee;
use ieee.std_logic_1164.all;

entity Identifica_Departamento is
    port (
        A : in  std_logic_vector(3 downto 0);
        D : out std_logic_vector(3 downto 0)
    );
end entity Identifica_Departamento;

architecture Behavioral of Identifica_Departamento is
begin

    D(0) <= (A(3) and not A(2) and A(1))                         
         or (not A(3) and A(2) and not A(1) and A(0))            
         or (not A(3) and not A(2) and not A(1) and not A(0))    
         or (not A(3) and A(2) and A(1) and not A(0))            
         or (A(3) and A(2) and not A(1) and not A(0));           

    D(1) <= (A(3) and A(2) and A(0))                             
         or (A(3) and A(2) and A(1))                             
         or (not A(3) and not A(2) and A(1) and not A(0))       
         or (not A(3) and A(2) and not A(1) and not A(0));       

    D(2) <= (A(2) and not A(1) and not A(0))                     
         or (A(3) and A(2) and not A(0))                         
         or (not A(3) and not A(1) and A(0))                     
         or (not A(3) and A(2) and A(0))                         
         or (A(3) and not A(2) and A(1) and A(0));               

   D(3) <= (A(3) and not A(2) and not A(1))                     
         or (not A(3) and not A(2) and A(1) and A(0))            
         or (A(3) and A(2) and A(1) and A(0));                   

end architecture Behavioral;
