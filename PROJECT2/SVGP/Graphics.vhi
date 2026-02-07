
-- VHDL Instantiation Created from source file Graphics.vhd -- 16:48:07 11/22/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Graphics
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		P1up : IN std_logic;
		P1dn : IN std_logic;
		P2up : IN std_logic;
		P2dn : IN std_logic;
		hpos : IN std_logic;
		vpos : IN std_logic;          
		graphics_on : OUT std_logic;
		hit : OUT std_logic;
		miss : OUT std_logic;
		rgb : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;

	Inst_Graphics: Graphics PORT MAP(
		clk => ,
		rst => ,
		P1up => ,
		P1dn => ,
		P2up => ,
		P2dn => ,
		hpos => ,
		vpos => ,
		graphics_on => ,
		hit => ,
		miss => ,
		rgb => 
	);


