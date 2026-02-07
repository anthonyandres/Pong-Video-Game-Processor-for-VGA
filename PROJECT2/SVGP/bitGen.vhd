----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:22 11/11/2023 
-- Design Name: 
-- Module Name:    bitGen - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- takes hcount, and bright signal, decides for each pixel what colour
-- the pixel should be on the screen

entity bitGen is
    Port ( bright : in  STD_LOGIC;
           hcount : in  integer;
           vcount : in  integer;
           RGB : out  STD_LOGIC_VECTOR (2 downto 0));
end bitGen;

architecture Behavioral of bitGen is
	signal HGCount: std_logic_vector(6 downto 0); --8x8 block counter
	signal VGCount: std_logic_vector(6 downto 0); -- it can be 5 downto 0, but i just did this for convenience
	signal hcountVec: STD_LOGIC_VECTOR(9 downto 0);
	signal vcountVec: std_logic_vector(9 downto 0);
	--the vertical and horizontal glyph counts will be assigned the 7 left most bits of the
	--vertical and horizontal count vector signals
	--this is done to obtain which glyph a pixel is on
	--ex. hcount = 465, hcountVec = 0111010001
	--		HGCount <= hcountVec(9 downto 3)
	--		HGCount = 0111010 (horizontal glyph #58)
	-- 	
	--		vcount = 67, vcountVec = 0001000011
	--		VGCount <= hcountVec(9 downto 3)
	--		VGCount = 0001000 (vertical glyph #8)
	
	-- we can verify this to be true since 465/8 ~= 58
	--													67/8 ~= 8
	
	--the screen is 80x60 glyphs, but since we start at 0
	-- HGCount goes from [0 to 79]
	-- VGCount goes from [0 to 59]
	
	-- if bright is '1', we are in the display area
	-- 
begin
	process(bright, hcount, vcount)
		begin
			if(bright = '0')then
				RGB<="000";
			else
				hcountVec<=std_logic_vector(to_unsigned(hcount, hcountVec'length));
				vcountVec<=std_logic_vector(to_unsigned(vcount, vcountVec'length));
				
				HGCount <= hcountVec(9 downto 3);
				VGCount <= vcountVec(9 downto 3);
				--using HGCount and VGCount, we address some ROM to determine colour
				
			end if;
	end process;

end Behavioral;

