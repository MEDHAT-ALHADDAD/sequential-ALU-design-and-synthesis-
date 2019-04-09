-- Register 4 bits

LIBRARY sxlib_ModelSim;

ENTITY accu IS
  PORT (
		i 	: in bit_vector(3 downto 0);
		ck 	: in bit;
		o	: out bit_vector(3 downto 0);
                vdd     : in bit;
                vss     : in bit
    );
END accu;

-- Architecture Declaration

ARCHITECTURE behaviour_data_flow OF accu IS

BEGIN

-- register

  PROCESS ( ck )
  BEGIN
    IF  ((ck = '1') AND ck'EVENT)
    THEN o <= i;
    END IF;
  END PROCESS;

END;

-- Architecture Declaration

ARCHITECTURE structural_view OF accu IS

  COMPONENT sff1_x4
    PORT (
	  ck	 : in  BIT;
	  i	 : in  BIT;
	  q	 : out BIT;
	  vdd	 : in  BIT;
	  vss	 : in  BIT
	  );
  END COMPONENT;

-- Assemblage des instances

BEGIN

-- generation des sorties 

  reg_0 : sff1_x4 port map(ck, i(0), o(0), vdd, vss);
  reg_1 : sff1_x4 port map(ck, i(1), o(1), vdd, vss);
  reg_2 : sff1_x4 port map(ck, i(2), o(2), vdd, vss);
  reg_3 : sff1_x4 port map(ck, i(3), o(3), vdd, vss);

end structural_view;

