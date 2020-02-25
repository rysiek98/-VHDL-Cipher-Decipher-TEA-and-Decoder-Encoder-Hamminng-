---------------------------------------------------------------------
--Projekt Szyfratora/Deszyfratora TEA i Kodera/Dekodera kodu Hamminga 
--v1.0 by Michal Ryszka & Wojciech Kowalski
---------------------------------------------------------------------

-- Hamming Encoder

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Hamming_encoder is
	port(
	wiadomosc		:in unsigned (31 downto 0);	 
	kod				:out unsigned(37 downto 0);
	test 				: in std_logic
	
	);
end Hamming_encoder;

architecture encoder of Hamming_encoder is	 		

BEGIN


process(wiadomosc)

		variable it : integer;
		variable a1, a2, a4, a8, a16, a32  :std_logic;
		
		begin
		-- obliczamy bity kontrolne, dlwiadomosc 4 bit wektorwiadomosc mwiadomoscmy 7 bit wektro wyjsciowy 
		-- wzorek ze strony http://www.niko.interkwiadomosc.pl/sl/sl.php?p[]=pl&p[]=edu&p[]=hwiadomoscmming&p[]=exwiadomoscmple 
		
		it :=31;
		
		a1 := wiadomosc(31) XOR wiadomosc(30) XOR wiadomosc(28) XOR wiadomosc(27) XOR wiadomosc(25) XOR wiadomosc(23) XOR wiadomosc(21) XOR wiadomosc(20) XOR wiadomosc(18) XOR wiadomosc(16) XOR wiadomosc(14) XOR wiadomosc(12) XOR wiadomosc(10) XOR wiadomosc(8) XOR wiadomosc(6) XOR wiadomosc(5) XOR wiadomosc(3) XOR wiadomosc(1);
		a2 := wiadomosc(31) XOR wiadomosc(29) XOR wiadomosc(28) XOR wiadomosc(26) XOR wiadomosc(25) XOR wiadomosc(22) XOR wiadomosc(21) XOR wiadomosc(19) XOR wiadomosc(18) XOR wiadomosc(15) XOR wiadomosc(14) XOR wiadomosc(11) XOR wiadomosc(10) XOR wiadomosc(7) XOR wiadomosc(6) XOR wiadomosc(4) XOR wiadomosc(3) XOR wiadomosc(0);
		a4 := wiadomosc(30) XOR wiadomosc(29) XOR wiadomosc(28) XOR wiadomosc(24) XOR wiadomosc(23) XOR wiadomosc(22) XOR wiadomosc(21) XOR wiadomosc(17) XOR wiadomosc(16) XOR wiadomosc(15) XOR wiadomosc(14) XOR wiadomosc(9) XOR wiadomosc(8) XOR wiadomosc(7) XOR wiadomosc(6) XOR wiadomosc(2) XOR wiadomosc(1) XOR wiadomosc(0);
		a8 := wiadomosc(27) XOR wiadomosc(26) XOR wiadomosc(25) XOR wiadomosc(24) XOR wiadomosc(23) XOR wiadomosc(22) XOR wiadomosc(21) XOR wiadomosc(13) XOR wiadomosc(12) XOR wiadomosc(11) XOR wiadomosc(10) XOR wiadomosc(9) XOR wiadomosc(8) XOR wiadomosc(7) XOR wiadomosc(6);
		a16 := wiadomosc(20) XOR wiadomosc(19) XOR wiadomosc(18) XOR wiadomosc(17) XOR wiadomosc(16) XOR wiadomosc(15) XOR wiadomosc(14) XOR wiadomosc(13) XOR wiadomosc(12) XOR wiadomosc(11) XOR wiadomosc(10) XOR wiadomosc(9) XOR wiadomosc(8) XOR wiadomosc(7) XOR wiadomosc(6);
		a32 := wiadomosc(5) XOR wiadomosc(4) XOR wiadomosc(3) XOR wiadomosc(2) XOR wiadomosc(1) XOR wiadomosc(0);
		
		--Uzupełniwiadomoscmy wektor wyjsciowy
		if(test = '1') then		-- TYLKO DO TESTOW, pozwala sprawdzic czy dekoder poprawnie napraiwi przeklamany bit
			kod(37) <= NOT a1;
		else 
			kod(37) <= a1;
		end if;
		
		kod(36) <= a2;
		kod(34) <= a4;
		kod(30) <= a8;
		kod(22) <= a16;
		kod(6) <= a32;
		
		for i in 35 downto 0 loop
		
			--Uzupełniamy wektor wyjsciowy 
			
			if(i = 34 or i = 30 or i = 22 or i = 6) then
				next;
			else
				kod(i) <= wiadomosc(it);
				it := it-1;
			end if;
			
		end loop;
end process;

end encoder;
	
	
	