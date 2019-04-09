library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.all;

-- Entity declaration for your testbench. Don't declare any ports here
ENTITY testbench_beh_comb IS
END ENTITY testbench_beh_comb;

ARCHITECTURE test_addaccu_beh OF testbench_beh_comb IS

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

FOR dut: addaccu USE ENTITY WORK.addaccu (data_flow);

-- Declare input signals and initialize them
SIGNAL sel : std_logic := '0';
SIGNAL clock : std_logic := '0'; 
SIGNAL vdd : std_logic := '1';
SIGNAL vss : std_logic := '0'; 
SIGNAL a : std_logic_vector (3 downto 0) := X"0";
SIGNAL b : std_logic_vector (3 downto 0) := X"0";

-- Declare output signals and initialize them
SIGNAL sum : std_logic_vector (3 downto 0) := X"0";
SIGNAL carry : std_logic := '0'; 

-- Constants 
constant delay_time : time := 50 ns;

BEGIN

-- Instantiate the Device Under Test (DUT)
dut: addaccu PORT MAP (a, b, sel, clock, vdd, vss, sum, carry);

stim_proc: PROCESS IS

VARIABLE b_int: natural;

PROCEDURE check_add(constant in1 : in natural;
		    constant in2 : in natural) is
BEGIN
-- Assign values to circuit inputs.
a <= std_logic_vector(to_unsigned(in1, a'length));
b <= std_logic_vector(to_unsigned(in2, b'length));
-- Wait for some time for the simulator to "propagate" their values.
wait for delay_time;
-- Check output against expected result.
Assert sum = a + b Report "S not equal to A+B" 
Severity Error;
end procedure check_add;

BEGIN

sel <= '0'; 	-- sel held at '0'
clock <= '0'; 	-- clock held at '0'

Report "---- case 1: 'a' held at 2, Loop on all values of 'b' ";
for i In 0 to 15 loop
	b_int := i;
	check_add(2,b_int);
end loop;
Report "---- End of case 1 -------------";

Report "---- case 2: Some Random testing of 'a' and 'b' ";
check_add(10,5);
check_add(12,2);
check_add(1,14);
check_add(15,10);
Report "---- End of case 2 -------------";

WAIT; -- stop process simulation run

END PROCESS;
END ARCHITECTURE test_addaccu_beh;
