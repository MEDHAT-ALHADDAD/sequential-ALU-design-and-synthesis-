library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.all;

-- Entity declaration for your testbench. Don't declare any ports here
ENTITY testbench_beh IS
END ENTITY testbench_beh;

ARCHITECTURE test_addaccu_beh OF testbench_beh IS

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
-- FOR dut: addaccu USE ENTITY WORK.addaccu (struct);

-- Declare input signals and initialize them
SIGNAL sel : std_logic := '0';
SIGNAL clock : std_logic := '0'; 
SIGNAL vdd : std_logic := '1';
SIGNAL vss : std_logic := '0'; 
SIGNAL a : std_logic_vector (3 downto 0) := X"0";
SIGNAL b : std_logic_vector (3 downto 0) := X"0";
SIGNAL b_test : std_logic_vector (3 downto 0) := X"0";

-- Declare output signals and initialize them
SIGNAL sum : std_logic_vector (3 downto 0) := X"0";
SIGNAL carry : std_logic := '0'; 
SIGNAL s_last : std_logic_vector (3 downto 0) := X"0";

-- Constants and Clock period definitions
constant clk_period : time := 50 ns;

BEGIN

-- Instantiate the Device Under Test (DUT)
dut: addaccu PORT MAP (a, b, sel, clock, vdd, vss, sum, carry);

-- Clock process definitions( clock with 50% duty cycle )
   clk_process :process
   begin
        clock <= '1';
	s_last <= sum;	-- Save the current value of 'sum'
        wait for clk_period/2;  
        clock <= '0';
        wait for clk_period/2;  
   end process;

-- Stimulus process, refer to clock signal
stim_proc: PROCESS IS

VARIABLE b_int: natural;

PROCEDURE check_add(constant in1 : in natural;
		    constant in2 : in natural) is
BEGIN
-- Assign values to circuit inputs.
a <= std_logic_vector(to_unsigned(in1, a'length));
b <= std_logic_vector(to_unsigned(in2, b'length));
-- Wait for some time for the simulator to "propagate" their values.
wait for clk_period;
-- Check output against expected result.
Assert sum = a + b Report "Sum not equal to A+B" 
Severity Error;
end procedure check_add;

BEGIN

sel <= '0', '1' after 17*clk_period; 

Report "---- case 1: Combinational path - 'a' held at 2, Loop on all values of 'b' ";
for i In 0 to 15 loop
	b_int := i;
	check_add(2,b_int);
end loop;
Report "---- End of case 1 -------------";

Report "---- case 2: Sequential path - 'a' held at 0 (no effect since sel=1), Loop on all values of 'b' ";
check_add(0,0);		-- Set sum to zero
-- Assign values to circuit inputs.
a <= X"0";
for i In 0 to 15 loop
	if i=0 then
		b <= X"0";
	else
		b <= b + X"1";
	end if;
	b_test <= b;	-- Test when the value of 'b' is assigned.
			-- New value is only assigned after the 'WAIT' statement
	wait for clk_period; -- Apply signals and Leave time for the output to stabilize
	if i > 0 then	-- Check output against expected result.
		Assert sum = b + s_last Report "Sum not equal to B+Sum'before"
		Severity Error;
	end if;
end loop;
Report "---- End of case 2 -------------";

WAIT; -- don't repeat above test vectors

END PROCESS;
END ARCHITECTURE test_addaccu_beh;
