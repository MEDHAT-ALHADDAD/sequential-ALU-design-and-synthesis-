library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- port declaration

entity addaccu is 
port ( a : in std_logic_vector (3 downto 0);
       b : in std_logic_vector (3 downto 0);
     sel : in std_logic;
      ck : in std_logic;
     vdd : in std_logic;
     vss : in std_logic;
     sum : inout std_logic_vector (3 downto 0);
   carry : out std_logic
     );
end addaccu;

-- architecture body

architecture data_flow of addaccu is

signal mux_out : std_logic_vector (3 downto 0) := X"0";
signal reg_out : std_logic_vector (3 downto 0) := X"0";
signal s_temp : std_logic_vector (4 downto 0) := "00000";

begin 

  mux_out <= a when sel='0' else reg_out;
  -- Adder with carry
  s_temp <= ('0' & b) + ('0' & mux_out);
  sum <= s_temp(3 downto 0);
  carry <= s_temp(4);

process ( ck )
begin
   if ( ck'event and ck ='1' ) then 
	reg_out <= sum;
   end if;
end process;

end data_flow;
   
