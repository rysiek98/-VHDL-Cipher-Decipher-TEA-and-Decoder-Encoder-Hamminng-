---------------------------------------------------------------------
--Projekt Szyfratora/Deszyfratora TEA i Kodera/Dekodera kodu Hamminga 
--v1.0 by Michal Ryszka & Wojciech Kowalski
---------------------------------------------------------------------
-- Hamming Decoder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Hamming_decoder is
	Port (
			kod_dec : in unsigned(37 DOWNTO 0);
			wiadomosc_dec : out unsigned(31 DOWNTO 0);
			suma_test :	out unsigned(5 DOWNTO 0)
			);
end Hamming_decoder;

Architecture decoder of Hamming_decoder is


BEGIN	
	
	-- Proces sprawdza czy kod jest okej, ewentualnie znajdzie bit na którym doszlo do przeklamania i zamienia go na przeciwny
	
	process(kod_dec)
	
		variable tmp : unsigned(5 DOWNTO 0);
		variable tmp2 : integer;
		variable tmp3: unsigned(37 DOWNTO 0);
		variable it: integer;


		begin

		tmp := "000000";
		tmp2 := 0;
		tmp3 := "00000000000000000000000000000000000000";
		it := 31;
		
		for i in 37 downto 0 loop
		
			if(kod_dec(i) = '1') then
				
			  tmp := tmp XOR (to_unsigned(38-i, 6));
					  
			end if;
			
		end loop;

		
		tmp3 := kod_dec;
		
		if(tmp /=  "000000") then 
			tmp2 := to_integer(tmp);
			tmp3(38-tmp2) := NOT kod_dec(38-tmp2);
		end if;
		
		for i in 37 downto 0 loop
		
			if(i = 37 or i = 36 or i = 34 or i = 30 or i = 22 or i  = 6 ) then
				next;
			else 
				wiadomosc_dec(it) <= tmp3(i);
				it := it-1;
			end if;
		
		end loop;
		suma_test <= tmp;
		
	end process;
	
end decoder;