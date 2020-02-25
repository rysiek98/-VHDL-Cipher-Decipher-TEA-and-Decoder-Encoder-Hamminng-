---------------------------------------------------------------------
--Projekt Szyfratora/Deszyfratora TEA i Kodera/Dekodera kodu Hamminga 
--v1.0 by Michal Ryszka & Wojciech Kowalski
---------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity Projekt_UCYF is
Port ( 
		clk, rst, test_in, load_in : in std_logic;			  --clk - zegar, rst - sygnal resetujacy licznik, load_in -- sygnal startujacy szyfrator
		v0_in, v1_in 	: in unsigned(31 downto 0);	        --wiadomość wchodząca
		k0, k1, k2, k3 : in unsigned(31 downto 0);        	  --klucz
		v0_out, v1_out : out unsigned(31 downto 0)		     --wiadomość wychodząca	  
			  );
			 
End Projekt_UCYF;

Architecture ARCH of Projekt_UCYF is
--Sygnaly laczace komponenty itp.
Signal Wiadomosc1,Wiadomosc11   	:  unsigned(31 DOWNTO 0);
Signal Wiadomosc2,Wiadomosc22  	:  unsigned(31 DOWNTO 0); 
Signal Kod 								: unsigned(37 DOWNTO 0);
Signal Kod2 							: unsigned(37 DOWNTO 0);
signal v0_t, v1_t,v0_tmp,v1_tmp  : unsigned(31 downto 0);
signal v0_t2, v1_t2 					: unsigned(31 downto 0);
signal ent 								: std_logic;
signal suma 							: unsigned(5 downto 0);
signal suma2 							: unsigned(5 downto 0);

Component Hamming_encoder
	Port (wiadomosc : in unsigned(31 DOWNTO 0);
			kod 		 : out unsigned(37 DOWNTO 0); 
			test 		 : in std_logic);
End Component;

Component Hamming_decoder
	Port( kod_dec 		  : in unsigned(37 DOWNTO 0);
			wiadomosc_dec : out unsigned(31 DOWNTO 0);
			suma_test 	  : out unsigned(5 DOWNTO 0)					  --Pokazuje na ktorej pozycji nastapilo przeklamanie, gdy == 0 brak przeklamanaego bitu
			);
End Component;

COMPONENT szyfrator
	PORT (
		  clks, rsts 		: in std_logic;						     --clk zegar , rst sygnal resetujacy licznik
		  v0_ins, v1_ins  : in unsigned(31 downto 0);		     --dane wejsciowe dla szyfratora
		  key0, key1, key2, key3 : in unsigned(31 downto 0);	  --klucze
		  v0_outs, v1_outs : out unsigned(31 downto 0);		     --dane wyjsciowe zaszyfrowane
		  en_out 			: out std_logic;
		  load 				: in std_logic
			);
END COMPONENT;

COMPONENT deszyfrator
	PORT (
		  clkd, rstd 	  : in std_logic;						       	--clk zegar , rst sygnal resetujacy licznik
		  v0_ind, v1_ind : in unsigned(31 downto 0);		     		--dane wejsciowe dla szyfratora
		  key0, key1, key2, key3 : in unsigned(31 downto 0); 		--klucze
		  v0_outd, v1_outd : out unsigned(31 downto 0);		  		--dane wyjsciowe zaszyfrowane
		  en 				  : in std_logic
			);
END COMPONENT;

Begin
	
	
	szyf : szyfrator PORT MAP(
									  load => load_in,	
									  clks => clk,
									  rsts => rst,
									  v0_ins => v0_in,
									  v1_ins => v1_in,
									  key0 => k0,
									  key1 => k1,
									  key2 => k2,
									  key3 => k3,
									  v0_outs => v0_t,
									  v1_outs => v1_t,
									  en_out => ent
									  );
									  

	Wiadomosc1 <= v0_t;
	--Sygnal test pozwala za symulowac przeklamanie jednego bitu
	H_encoder: Hamming_encoder PORT MAP(test => test_in, wiadomosc => Wiadomosc1, kod => Kod);
	H_decoder: Hamming_decoder PORT MAP(suma_test => suma, kod_dec => Kod, wiadomosc_dec => Wiadomosc2);
	
	v0_tmp <= Wiadomosc2;
	
	
	Wiadomosc11 <= v1_t;
	
	H_encoder2: Hamming_encoder PORT MAP(test => test_in, wiadomosc => Wiadomosc11, kod => Kod2);
	H_decoder2: Hamming_decoder PORT MAP(suma_test => suma2, kod_dec => Kod2, wiadomosc_dec => Wiadomosc22);
	
	v1_tmp <= Wiadomosc22;
	
	
		desz : deszyfrator PORT MAP(
										 en => ent,	
										 clkd => clk,
										 rstd => rst,
										 v0_ind => v0_tmp,
										 v1_ind => v1_tmp,
										 key0 => k0,
										 key1 => k1,
										 key2 => k2,
										 key3 => k3,
										 v0_outd => v0_t2,
										 v1_outd => v1_t2
										 );
	
	v0_out <= v0_t2;
	v1_out <= v1_t2;
	
End ARCH;

