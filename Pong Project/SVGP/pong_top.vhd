----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:33:53 11/20/2023 
-- Design Name: 
-- Module Name:    pong_top - Behavioral 
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

entity pong_top is
	port(
		clk:in std_logic;
		rst:in std_logic;
		P1up : IN std_logic;
		P1dn : IN std_logic;
		P2up : IN std_logic;
		P2dn : IN std_logic;
		Rout: out std_logic_vector(7 downto 0);
		Gout: out std_logic_vector(7 downto 0);
		Bout: out std_logic_vector(7 downto 0);
		DAC_CLK: out std_logic;
		hsync, vsync: out std_logic;
		rgb: out std_logic_vector(2 downto 0)
	);
end pong_top;

architecture Behavioral of pong_top is
--signal hpos, vpos: integer;
signal hit, miss: std_logic;
signal graphics_rgb: std_logic_vector(2 downto 0);
signal rgb_reg, rgb_next: std_logic_vector(2 downto 0);
signal ball_reg, ball_next: unsigned(1 downto 0);

--components
	COMPONENT VideoController
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		video_on : OUT std_logic;
		clk_25 : OUT std_logic;
		vsync : OUT std_logic;
		hsync : OUT std_logic;
		vposition: out std_logic_vector(9 downto 0);
		hposition: out std_logic_vector(9 downto 0)
		);
	END COMPONENT;
	signal clk25: std_logic;
	signal bright: std_logic;
	signal hpos: std_logic_vector(9 downto 0);
	signal vpos: std_logic_vector(9 downto 0);
	
	
	COMPONENT Graphics
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		P1up : IN std_logic;
		P1dn : IN std_logic;
		P2up : IN std_logic;
		P2dn : IN std_logic;
		hpos : IN std_logic_vector(9 downto 0);
		vpos : IN std_logic_vector(9 downto 0);          
		graphics_on : OUT std_logic;
		hit : OUT std_logic;
		miss : OUT std_logic;
		rgb : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	signal graphic_on: std_logic;


begin
--port maps	
	Inst_VideoController: VideoController PORT MAP(
		clk => clk,
		rst => rst,
		video_on => bright,
		clk_25 => clk25,
		vsync => vsync,
		hsync => hsync,
		hposition => hpos,
		vposition => vpos
	);
	
	--Inst_Graphics: Graphics PORT MAP(clk25, rst, P1up, P1dn, P2up, P2dn, hpos, vpos, graphic_on, hit, miss, graphics_rgb);
		Inst_Graphics: Graphics PORT MAP(
		clk => clk25,
		rst => rst,
		P1up => P1up,
		P1dn => P2dn,
		P2up => P2up,
		P2dn => P2dn,
		hpos => hpos,
		vpos => vpos,
		graphics_on => graphic_on,
		hit => hit,
		miss => miss,
		rgb => graphics_rgb
	);
--initialize registers
process(clk25, rst)
	begin
		if(rst = '1')then
			ball_reg<=(others=>'0');
			rgb_reg<=(others=>'0');
		elsif(clk'event and clk='1')then
			ball_reg<=ball_next;
			if(clk25 = '1')then
				rgb_reg<=rgb_next;
			end if;
		end if;
end process;

--rgb multiplexing
process(bright, graphic_on, graphics_rgb)
	begin
		if(bright = '0')then
			rgb_next<="000"; --blank when retract
		else
			if(graphic_on = '1')then
				rgb_next<= graphics_rgb;
			else
				rgb_next<="010";--green bg
			end if;
		end if;
end process;
rgb<=rgb_reg;--this is implemented get a computer and pray you can implement the design!!
DAC_CLK<=clk25;
Rout<=(others=>'1');
Gout<=(others=>'1');
Bout<=(others=>'1');
--process(rgb_reg)
--	begin
--		if(rgb_reg(0) = '1')then
--			Bout<=(others=>'1');
--		elsif(rgb_reg(0) = '1')then
--			Gout<=(others=>'1');
--		elsif(rgb_reg(0) = '1')then
--			Rout<=(others=>'1');
--		end if;
--end process;


--Rout<=(others=>'0');

--
--Gout(0)<=(others=>'0');
--Gout(0)<=rgb_reg(1);
--
--Bout(0)<=(others=>'0');
--Bout(0)<=rgb_reg(0);
end Behavioral;

