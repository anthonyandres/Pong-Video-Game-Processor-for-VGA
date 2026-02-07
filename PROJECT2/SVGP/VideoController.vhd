----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:49:38 11/11/2023 
-- Design Name: 
-- Module Name:    VideoController - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


-- VideoController generates hSync, vSync, bright, hCount, and vCount signals
-- module should take 50MHz clock from pin C9
-- VGA timing based on 60Hz refresh rate on 640x480 VGA timing 

-- hCount and vCount are used to know where you are on the screen
-- starting from 0, hCount will count pixels 0 to 639 (horizontal)
-- starting from 0, vCount will count pixels from 0 to 479 (vertical)
-- vCount and hCount are 10 bits, they can represent up to 1024 pixels

-- hsync and vsync are asserted low
-- bright signal can be used to tell bit Gen circuit that the pixel is on or off


-- for this project i will be using Character graphics:
-- i will break the screen up into chunks of 8x8 blocks
-- 80x60 blocks


-- there will be 6 different blocks to represent:
-- 1) 8x8 blue block
-- 2) 8x8 yellow block
-- 3) 8x8 green block
-- 4) 8x8 white block
-- 5) 8x8 pink block
-- 6) 8x8 red block

-- 6 possible 8x8 chunks, means 2^3, or 3 bits to represent them all (total 8, spare 2)
-- each block is 64 bits, 8 bytes
-- total volume of ROM is 8 bytes x 6 chunks = 48 bytes

-- the VideoController module will generate timing signals vsync hsync vcount and hcount and bright


-- horizontal parameters (clocks)
--Front porch: 16
--back porch: 48
--sync pulse: 96
--complete line: 800 (640+16+48+96) = 800

-- vertical parameters (lines)
--complete Frame: 525 (480+10+33+2) = 525
--Front porch: 10
--back porch: 33
--sync pulse: 2

-- with horizontal offset of 160, the middle of the screen occurs at hpos = 160+640/2 = 480
-- with vertical offset of 45, the middle of the screen occurs at vpos = 45+480/2 = 285
entity VideoController is
    Port ( clk 		: in   STD_LOGIC;
			  --clk		: in   STD_LOGIC;
           rst 		: in   STD_LOGIC;
			  --rgb			: out std_logic_vector(2 downto 0);
			  video_on		: out  STD_LOGIC;
			  clk_25		: out STD_LOGIC;
           vsync 		: out  STD_LOGIC;
           hsync 		: out  STD_LOGIC;
			  vposition: out std_logic_vector(9 downto 0);
			  hposition: out std_logic_vector(9 downto 0)
           --vcount 	: out  STD_LOGIC_VECTOR (9 downto 0); --2^9 = 1024, which is enough for 525
           --hcount 	: out  STD_LOGIC_VECTOR (9 downto 0) --2^10 = 1024, which is enough for 800
			 );--should h/vcount be integer??
end VideoController;

architecture Behavioral of VideoController is

	signal clk25 	: STD_LOGIC:= '0';
	
	--declaring horizontal and vertical parameters
--	|    HD    |HFP|HS|HBP|
	constant HD : integer := 639; --639 and not 400 bc we will start at 0
	constant HFP : integer := 16;
	constant HBP : integer := 48;
	constant HS : integer := 96;
	
	constant VD : integer := 479; -- 479 and not 480 bc we will start at 0
	constant VFP : integer := 10;
	constant VBP : integer := 33;
	constant VS : integer := 2;

--------------//Signals & Components//---------------

--	COMPONENT VGAclk
--		PORT(
--			clk 	 : IN STD_LOGIC;
--			clkVGA : OUT STD_LOGIC
--		);
--	END COMPONENT;
	
	
-----------------------------------------------------
--	component sync
--		Port( 
--			clk : in  STD_LOGIC;
--         hsync : out  STD_LOGIC;
--         vsync : out  STD_LOGIC;
--         RGB: out std_logic_vector(2 downto 0));
--	end component;	
	
	signal RGB : std_logic_vector(2 downto 0);
	signal hpos: integer :=0;
	signal vpos: integer :=0;
	signal bright: std_logic:='0'; --tells if video is on or not (on if in display area, off elsewhere)
-----------------------------------------------------




-----------------------------------------------------
BEGIN
-------------//Port Maps//-------------------------

----VGAclk (clk generator) port map
--systemVGAclk : VGAclk
--	port map(clk, clk25);
--
----sync port map
--systemSync : sync
--	port map(clk25, hsync, vsync, RGB);



---------------------------------------------------
clk_25<=clk25;--clk_25 = 0;

clk_vga:process(clk) --clk25 starts at 0, when 50MHz clk is rising to 1, invert clk25
	begin					--clk25 is effectively 25MHz
		if(clk'Event and clk = '1') then --every rising edge...
			clk25<= not clk25;
		end if;
end process;

clk_25<=clk25; --update clk_25

hpos_counter:process(clk25, rst) --increment horizontal position
	begin
		if(rst = '1')then
			hpos<=0;
		else if(clk25'Event and clk25 ='1')then
			if(hpos = (HD + HFP + HS + HBP))then --if horizontal position reaches the end, retrace
				hpos<=0;
			else
			hpos<=hpos+1; -- otherwise increment horizontal position
			end if;
		end if;
		end if;
end process;

vpos_counter:process(clk25, rst, hpos) --increment vertical position
	begin
		if(rst = '1')then
			vpos<=0;
		else if(clk25'Event and clk25 ='1')then
			if(hpos = (HD + HFP + HS + HBP))then --if horizontal position reaches the end..
				if(vpos = (VD + VFP + VS + VBP))then -- and vertical position reaches the end
					vpos<=0; --retrace
				else
					vpos<=vpos+1;
				end if;
			end if;
		end if;
		end if;
end process;

horizontal_sync:process(clk25, rst, hpos)
	begin
		if(rst = '1')then
			hsync<='0';
		else if(clk25'Event and clk25 ='1')then
			if(hpos>=(HD+HFP) and hpos<(HD+HFP+HS))then --hsync goes low between pixels [655 and 751), note pixel 0 is the first pixel
				hsync<='0';--active low means we want to retrace
			else
				hsync<='1';
			end if;
		end if;
		end if;
end process;

vertical_syn:process(clk25, rst, vpos)
	begin
		if(rst = '1')then
			vsync<='0';
		else if(clk25'Event and clk25 ='1')then
			if(vpos>=(VD+VFP) and vpos<(VD+VFP+VS))then --hsync goes low between pixels [479 and 491), note pixel 0 is the first pixel
				vsync<='0';--active low means we want to retrace
			else
				vsync<='1';
			end if;
		end if;
		end if;
end process;

vid_on:process(clk25, rst, hpos, vpos)
	begin
		if(rst='1')then
			bright<='0';
		else if(clk25'Event and clk25 = '1')then
			if(hpos<=HD and vpos<=VD)then -- if we are within the display area..
				bright<='1'; --video is on
			else
				bright<='0';
			end if;
		end if;	
		end if;

end process;

video_on<= bright;
--draw_TODELETE:process(clk25, rst, hpos, vpos, bright) --test process to draw a square
--	begin
--		if(rst='1')then
--			RGB<="000";
--		else if(clk25'Event and clk25='1')then
--			if(bright = '1')then
--				if((hpos>=10 and hpos<=60) and (vpos>=10 and vpos<=60))then
--					RGB<="101";
--				else
--					RGB<="011";
--				end if;
--			end if;
--		end if;
--		end if;
--end process;
hposition<=std_logic_vector(to_unsigned(hpos, hposition'length));
vposition<=std_logic_vector(to_unsigned(vpos, vposition'length));
end Behavioral;

