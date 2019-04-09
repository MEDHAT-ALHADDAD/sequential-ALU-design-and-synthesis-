-- Adder 

LIBRARY sxlib_ModelSim;

ENTITY alu IS
	PORT(
		a    : in  bit_vector(3 downto 0);
		b    : in  bit_vector(3 downto 0);
		s    : out bit_vector(3 downto 0);
		cin  : in  bit := '0';
		cout : out bit;
		vdd  : in  bit;
		vss  : in  bit
	);
END  alu;

-- Architecture Declaration

ARCHITECTURE behaviour_data_flow OF alu IS

	-- carry

	SIGNAL carry : bit_vector(3 downto 0);

BEGIN

	-- carry definition

	carry(0)          <= cin;           -- carry in
	carry(3 downto 1) <= ((b(2 downto 0) and a(2 downto 0)) or (a(2 downto 0) and carry(2 downto 0)) or (carry(2 downto 0) and b(2 downto 0)));

	-- sum definition

	s    <= b xor a xor carry;
	cout <= (a(3) and b(3)) or ((b(3) and carry(3)) or (a(3) and carry(3)));
END;

-- Architecture Declaration

ARCHITECTURE structural_view OF alu IS

	COMPONENT a2_x2
		port(
			i0  : in  bit;              -- i0
			i1  : in  bit;              -- i1
			q   : out bit;              -- t
			vdd : in  bit;              -- vdd
			vss : in  bit               -- vss
		);
	END COMPONENT;

	COMPONENT o3_x2
		port(
			i0  : in  bit;              -- i0
			i1  : in  bit;              -- i1
			i2  : in  bit;              -- i2
			q   : out bit;              -- f
			vdd : in  bit;              -- vdd
			vss : in  bit               -- vss
		);
	END COMPONENT;

	COMPONENT xr2_x1
		PORT(
			i0  : in  bit;
			i1  : in  bit;
			q   : out bit;
			vdd : in  bit;
			vss : in  bit
		);
	END COMPONENT;

	-- carry signals	

	SIGNAL carry   : bit_vector(2 downto 0);
	signal carry_0 : bit_vector(2 downto 1);
	signal carry_1 : bit_vector(2 downto 1);
	signal carry_2 : bit_vector(2 downto 1);
	signal sum     : bit_vector(3 downto 1);

BEGIN

	-- instances

	carry_0_0 : a2_x2 port map(b(0), a(0), carry(0), vdd, vss);
	carry_0_1 : a2_x2 port map(b(1), a(1), carry_0(1), vdd, vss);
	carry_0_2 : a2_x2 port map(b(2), a(2), carry_0(2), vdd, vss);

	carry_1_1 : a2_x2 port map(b(1), carry(0), carry_1(1), vdd, vss);
	carry_1_2 : a2_x2 port map(b(2), carry(1), carry_1(2), vdd, vss);
	carry_2_1 : a2_x2 port map(a(1), carry(0), carry_2(1), vdd, vss);
	carry_2_2 : a2_x2 port map(a(2), carry(1), carry_2(2), vdd, vss);

	carry_out_1 : o3_x2 port map(carry_0(1), carry_1(1), carry_2(1), carry(1), vdd, vss);
	carry_out_2 : o3_x2 port map(carry_0(2), carry_1(2), carry_2(2), carry(2), vdd, vss);

	sum_0_0 : xr2_x1 port map(a(0), b(0), s(0), vdd, vss);
	sum_0_1 : xr2_x1 port map(a(1), b(1), sum(1), vdd, vss);
	sum_0_2 : xr2_x1 port map(a(2), b(2), sum(2), vdd, vss);
	sum_0_3 : xr2_x1 port map(a(3), b(3), sum(3), vdd, vss);

	sum_1_1 : xr2_x1 port map(sum(1), carry(0), s(1), vdd, vss);
	sum_1_2 : xr2_x1 port map(sum(2), carry(1), s(2), vdd, vss);
	sum_1_3 : xr2_x1 port map(sum(3), carry(2), s(3), vdd, vss);

end structural_view;

ARCHITECTURE imp OF alu IS
	COMPONENT Adder1
		PORT(
			a, b, cin : in  bit;
			s, cout   : out bit;
			vdd, vss  : in  bit);
	END COMPONENT;

	SIGNAL carry_sig : bit_vector(3 DOWNTO 0);
BEGIN
	A1 : Adder1
		port map(
			a    => a(0),
			b    => b(0),
			cin  => cin,
			s    => s(0),
			cout => carry_sig(0),
			vdd  => vdd,
			vss  => vss
		);
	A2 : Adder1
		port map(
			a    => a(1),
			b    => b(1),
			cin  => carry_sig(0),
			s    => s(1),
			cout => carry_sig(1),
			vdd  => vdd,
			vss  => vss
		);
	A3 : Adder1
		port map(
			a    => a(2),
			b    => b(2),
			cin  => carry_sig(1),
			s    => s(2),
			cout => carry_sig(2),
			vdd  => vdd,
			vss  => vss
		);
	A4 : Adder1
		port map(
			a    => a(3),
			b    => b(3),
			cin  => carry_sig(2),
			s    => s(3),
			cout => cout,
			vdd  => vdd,
			vss  => vss
		);

END imp;

entity Adder1 is
	port(
		a, b, cin : in  bit;
		s, cout   : out bit;
		vdd, vss  : in  bit);
end Adder1;

architecture fa_str of Adder1 is
	COMPONENT a2_x2
		port(
			i0  : in  bit;              -- i0
			i1  : in  bit;              -- i1
			q   : out bit;              -- t
			vdd : in  bit;              -- vdd
			vss : in  bit               -- vss
		);
	END COMPONENT;

	COMPONENT o2_x2
		port(
			i0  : in  bit;              -- i0
			i1  : in  bit;              -- i1
			q   : out bit;              -- f
			vdd : in  bit;              -- vdd
			vss : in  bit               -- vss
		);
	END COMPONENT;

	COMPONENT xr2_x1
		PORT(
			i0  : in  bit;
			i1  : in  bit;
			q   : out bit;
			vdd : in  bit;
			vss : in  bit
		);
	END COMPONENT;

	signal s1, s2, s3, s4, s5 : bit;
begin
	x1 : xr2_x1
		port map(
			i0  => a,
			i1  => b,
			q   => s1,
			vdd => vdd,
			vss => vss
		);
	x2 : xr2_x1
		port map(
			i0  => s1,
			i1  => cin,
			q   => s,
			vdd => vdd,
			vss => vss
		);
	r1 : a2_x2
		port map(
			i0  => a,
			i1  => b,
			q   => s2,
			vdd => vdd,
			vss => vss
		);
	r2 : a2_x2
		port map(
			i0  => b,
			i1  => cin,
			q   => s3,
			vdd => vdd,
			vss => vss
		);
	r3 : a2_x2
		port map(
			i0  => a,
			i1  => cin,
			q   => s4,
			vdd => vdd,
			vss => vss
		);
	o1 : o2_x2
		port map(
			i0  => s2,
			i1  => s3,
			q   => s5,
			vdd => vdd,
			vss => vss
		);
	o2 : o2_x2
		port map(
			i0  => s4,
			i1  => s5,
			q   => cout,
			vdd => vdd,
			vss => vss
		);
end fa_str;



