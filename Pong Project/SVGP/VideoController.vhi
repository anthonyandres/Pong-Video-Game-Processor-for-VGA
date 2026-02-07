
-- VHDL Instantiation Created from source file VideoController.vhd -- 16:51:26 11/22/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT VideoController
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		video_on : OUT std_logic;
		clk_25 : OUT std_logic;
		vsync : OUT std_logic;
		hsync : OUT std_logic
		);
	END COMPONENT;

	Inst_VideoController: VideoController PORT MAP(
		clk => ,
		rst => ,
		video_on => ,
		clk_25 => ,
		vsync => ,
		hsync => 
	);


