----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:53 11/11/2023 
-- Design Name: 
-- Module Name:    VGAclk - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGAclk is
    Port ( clk : in  STD_LOGIC;
           clkVGA : out  STD_LOGIC);
end VGAclk;

architecture Behavioral of VGAclk is

signal counter : integer:=0;

begin
	process(clk)
		begin
			if(clk'Event and clk = '1') then	
				if(counter mod 2 = 1) then
					clkVGA <= '1';      -- essentially making a clk signal that is half
					counter <= counter + 1;-- as fast as the Spartan3E clock (50Mhz / 2 = 25Mhz)
				else							  -- on odd clock: '1'
					clkVGA <= '0';		  -- on even clocks: '0'
				end if;				
			end if;		
	end process;
end Behavioral;

