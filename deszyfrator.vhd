---------------------------------------------------------------------
--Projekt Szyfratora/Deszyfratora TEA i Kodera/Dekodera kodu Hamminga 
--v1.0 by Michal Ryszka & Wojciech Kowalski
---------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY deszyfrator is
	PORT (
		  en : in std_logic;
		  clkd, rstd : in std_logic;						           	--clk zegar , rst sygnal resetujacy licznik
		  v0_ind, v1_ind : in unsigned(31 downto 0);		     	   --dane wejsciowe dla szyfratora
		  key0, key1, key2, key3 : in unsigned(31 downto 0); 		--klucze
		  v0_outd, v1_outd : out unsigned(31 downto 0)		     	--dane wyjsciowe zaszyfrowane
			);
END deszyfrator;

ARCHITECTURE desz of deszyfrator is
	
	type states is (start, licz, zwroc, stop);	--Stany jakie przyjmuje automat, mozna sie zastanowic nad optymalniejszym automatem, stan stop dodalem tylko dlatego ze 	
	signal state, next_state : states;				--nie umiem w symulacje tzn. nie wiem jak ustawic zeby ruszala od 0 do np 5 ns
	signal counter : integer;							--Sygnal licznika
	signal su : unsigned(31 DOWNTO 0);				--Sygnal sumy do szyfratora
	signal v0, v1 : unsigned(31 downto 0);			--Sygnaly pomocnicze do szyfratora

BEGIN
	
	process (clkd, rstd)
		begin
		if rstd='1' then
			state <= start;
		elsif (rising_edge(clkd)) then
		
		if(en = '1') then
			state<= next_state;
		end if;	
		end if;
	end process;
	
	
	
	process(clkd, v0_ind, v1_ind,en)
			variable delta : unsigned(31 DOWNTO 0);
			variable suma : unsigned(31 DOWNTO 0);
			variable v0_v : unsigned(31 DOWNTO 0);
			variable v1_v : unsigned(31 DOWNTO 0);
			variable k0,k1,k2,k3 : unsigned(31 DOWNTO 0);
	
	begin
	
	if(rising_edge(clkd)) then
		case state is
			when start =>
																				--Zmienne
				delta  := "10011110001101110111100110111001";	
				su     <= "11000110111011110011011100100000"; 	--suma
				
				k0 := key0;
				k1 := key1;
				k2 := key2;
				k3 := key3;
				
				counter <= 0;
				v0 <= v0_ind;
				v1 <= v1_ind;
				--Watosci domyslne
				v0_outd <= "00000000000000000000000000000000";
				v1_outd <= "00000000000000000000000000000000";
		
				next_state <= licz;
				
				
			when licz =>	
				if counter < 32 then
					suma := su;
					v0_v := v0;
					v1_v := v1;
					
					
					v1_v := v1_v -  ( ((v0_v sll 4) + k2) XOR (v0_v + suma)  XOR ( (v0_v srl 5) + k3 ) );
					v0_v := v0_v -  ( ((v1_v sll 4) + k0) XOR (v1_v + suma)  XOR ( (v1_v srl 5) + k1 ) );
					
					suma := suma - delta;
					
					counter <= counter + 1;
					su <= suma;
					v0 <= v0_v;
					v1 <= v1_v;
				end if;
				if counter = 32 then
					next_state <= zwroc;
				end if;
				
				when zwroc =>
					v0_outd <= v0;
					v1_outd <= v1;
					next_state <= stop;
				when stop =>
					v0 <= v0;
					v1 <= v1;
					counter <= counter;
			end case;
		end if;
		
	end process;
	
	
	
END desz;

