LIBRARY sxlib_ModelSim;

ENTITY structure_test IS
END structure_test;

ARCHITECTURE struct OF structure_test IS

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT alu
		PORT(
			a    : in  bit_vector(3 downto 0);
			b    : in  bit_vector(3 downto 0);
			s    : out bit_vector(3 downto 0);
			cin  : in  bit  := '0';
			cout : out bit ;
			vdd  : in  bit ;
			vss  : in  bit 
		);
	END COMPONENT;
	for uuts : alu use entity work.alu(imp);
	for uut : alu use entity work.alu(behaviour_data_flow);
	--Inputs
	signal A   : bit_vector(3 downto 0) := (others => '0');
	signal B   : bit_vector(3 downto 0) := (others => '0');
	signal Cin : bit                     := '0';
	signal Vdd : bit                     := '1';
	signal Vss : bit                     := '0';

	--Outputs
	signal S    : bit_vector(3 downto 0);
	signal Cout : bit ;
	signal Ss    : bit_vector(3 downto 0);
	signal Couts : bit ;

BEGIN

	uut : alu
	port map(
		a    => a,
		b    => b,
		s    => s,
		cin  => cin,
		cout => cout,
		vdd  => vdd,
		vss  => vss
	);

	uuts : alu
	port map(
		a    => a,
		b    => b,
		s    => Ss,
		cin  => cin,
		cout => Couts,
		vdd  => vdd,
		vss  => vss
	);


	stim_proc : process
	begin
		A <= "0110";
		B <= "1100";
		wait for 50 ns;
		Assert (S = Ss and Cout = Couts) Report "Sum not equal to expected"
		Severity Error;

		A <= "1111";
		B <= "1100";
		wait for 50 ns;
		Assert (S = Ss and Cout = Couts) Report "Sum not equal to expected"
		Severity Error;

		A <= "0110";
		B <= "0111";
		wait for 50 ns;
		Assert (S = Ss and Cout = Couts) Report "Sum not equal to expected"
		Severity Error;

		A <= "0110";
		B <= "1110";
		wait for 50 ns;
		Assert (S = Ss and Cout = Couts) Report "Sum not equal to expected"
		Severity Error;

		A <= "1111";
		B <= "1111";
		wait for 50 ns;
		Assert (S = Ss and Cout = Couts) Report "Sum not equal to expected"
		Severity Error;
		
		wait;

	end process;

END;
