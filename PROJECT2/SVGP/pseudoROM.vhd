----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:40:08 11/11/2023 
-- Design Name: 
-- Module Name:    pseudoROM - Behavioral 
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

entity pseudoROM is
    Port ( charCode : in  STD_LOGIC_VECTOR (2 downto 0);
           rowAddr : in  STD_LOGIC_VECTOR (5 downto 0);
           chunkRow : out  STD_LOGIC_VECTOR (7 downto 0));
end pseudoROM;

architecture Behavioral of pseudoROM is
-- char code legend:
-- RGB
-- 000 > black
-- 001 > blue
-- 010 > green
-- 011 > cyan
-- 100 > red
-- 101 > pink
-- 110 > yellow
-- 111 > white


begin
	process(charCode, rowAddr)
		begin
			case rowAddr is
				when "000" =>
					case charCode is
						when "111" => chunkRow <= "11111111";
					end case;
					
				when "001" =>
				case charCode is
						when "111" => chunkRow <= "11111111";
					end case;
					
				when "010" =>
				case charCode is
						when "111" => chunkRow <= "11111111";
					end case;
				when "011" =>
				when "100" =>
				when "101" =>
				when "110" =>
				when "111" =>				
				
			end case;
	end process;

end Behavioral;

