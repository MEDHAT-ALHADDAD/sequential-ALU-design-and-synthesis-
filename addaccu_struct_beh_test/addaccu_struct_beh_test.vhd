library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Entity declaration for your testbench. Don't declare any ports here
ENTITY testbench_struct_beh IS
END ENTITY testbench_struct_beh;

ARCHITECTURE test_addaccu_struct_beh OF testbench_struct_beh IS

-- Component Declaration for the Device Under Test (DUT)
COMPONENT addaccu IS
-- Just copy and paste the input and output ports of your module as such. 
port ( a : in std_logic_vector (3 downto 0);
       b : in std_logic_vector (3 downto 0);
     sel : in std_logic;
      ck : in std_logic;
     vdd : in std_logic;
     vss : in std_logic;
     sum : inout std_logic_vector (3 downto 0);
   carry : out std_logic
     );
END COMPONENT addaccu;

FOR dut_beh: addaccu USE ENTITY WORK.addaccu (data_flow);
FOR dut_struct: addaccu USE ENTITY WORK.addaccu (struct);

-- Declare input signals and initialize them
SIGNAL sel : std_logic := '0';
SIGNAL clock : std_logic := '0'; 
SIGNAL vdd : std_logic := '1';
SIGNAL vss : std_logic := '0'; 
SIGNAL a : std_logic_vector (3 downto 0) := X"0";
SIGNAL b : std_logic_vector (3 downto 0) := X"0";

-- Declare two output signals and initialize them
SIGNAL s_beh : std_logic_vector (3 downto 0) := X"0";
SIGNAL s_struct : std_logic_vector (3 downto 0) := X"0";
SIGNAL c_beh : std_logic := '0';
SIGNAL c_struct : std_logic := '0';

-- Constants and Clock period definitions
constant clk_period : time := 20 ns;

BEGIN

-- Instantiate the Device Under Test (DUT)
dut_beh: addaccu PORT MAP (a, b, sel, clock, vdd, vss, s_beh, c_beh);
dut_struct: addaccu PORT MAP (a, b, sel, clock, vdd, vss, s_struct, c_struct);

-- Clock process definitions( clock with 50% duty cycle )
   clk_process :process
   begin
        clock <= '1';
        wait for clk_period/2;  
        clock <= '0';
        wait for clk_period/2;  
   end process;

-- Stimulus process, refer to clock signal
stim_proc: PROCESS IS
BEGIN

sel <= '0', '1' after 16*clk_period; 	-- Two cases

Report "---- case 1: Combinational path - a held at 2, Loop on all values of 'b' ";
a <= X"2";
for i In 0 to 15 loop
	if i=0 then
		b <= X"0";
	else
		b <= b + X"1";
	end if;
	wait for clk_period; -- Apply signals and Leave time for the output to stabilize
	-- Check that Both Structural and Behavioral match at the end of the clock period
	Assert s_beh = s_struct 
	Report "Structural and Behavioral outputs don't match"
	Severity Error;
end loop;

Report "---- End of case 1 -------------";

Report "---- case 2: Sequential path - a held at 0 (no effect since sel=1), Loop on all values of 'b' ";
a <= X"0";
for i In 0 to 15 loop
	if i=0 then
		b <= X"0";
	else
		b <= b + X"1";
	end if;
	wait for clk_period; -- Apply signals and Leave time for the output to stabilize
	-- Check that Both Structural and Behavioral match at the end of the clock period
	Assert s_beh = s_struct 
	Report "Structural and Behavioral outputs don't match"
	Severity Error;
end loop;
Report "---- End of case 2 -------------";

WAIT; -- don't repeat above test vectors

END PROCESS;
END ARCHITECTURE test_addaccu_struct_beh;
