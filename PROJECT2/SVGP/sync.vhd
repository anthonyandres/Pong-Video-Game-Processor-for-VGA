----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:02:41 11/19/2023 
-- Design Name: 
-- Module Name:    sync - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sync is
    Port ( clk : in  STD_LOGIC;
			  rst : in std_logic;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           RGB: out std_logic_vector(2 downto 0));
end sync;

architecture Behavioral of sync is

signal hpos: integer range 0 to 800:=0;
signal vpos: integer range 0 to 525:=0;

begin
	process(clk)
	begin
		if(clk'Event and clk='1')then
			if(hpos<800) then --increment hpos until reach end, then increment vpos
				hpos<=hpos+1;
			else
				hpos<=0;
				if(vpos<525) then
					vpos<=vpos+1;
				else
					vpos<=0;
				end if;
			end if;
			
			if(hpos>16 and hpos<48) then --hsync goes low between front porch and back porch
				hsync<='0';--active low means we want to draw to the screen
			else
				hsync<='1';
			end if;
			
			if(vpos>10 and vpos<33) then --vsync goes low between front porch and back porch
				vsync<='0';
			else
				vsync<='1';
			end if;
			
			if(hpos>0 and hpos<160)or(vpos>0 and vpos<45) then --when hpos is not within the active pixels, RGB is zero
				RGB<=(others=>'0');
			end if;
		end if;
	end process;
end Behavioral;

