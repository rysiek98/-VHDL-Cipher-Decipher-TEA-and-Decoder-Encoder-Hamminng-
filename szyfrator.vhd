
---------------------------------------------------------------------
--Projekt Szyfratora/Deszyfratora TEA i Kodera/Dekodera kodu Hamminga 
--v1.0 by Michal Ryszka & Wojciech Kowalski
---------------------------------------------------------------------

-- TEA SZYFRATOR

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY szyfrator is
	PORT (
		  clks, rsts : in std_logic;						           --clk zegar , rst sygnal resetujacy licznik
		  v0_ins, v1_ins : in unsigned(31 downto 0);		        --dane wejsciowe dla szyfratora
		  key0, key1, key2, key3 : in unsigned(31 downto 0); 	  --klucze
		  v0_outs, v1_outs : out unsigned(31 downto 0);		     --dane wyjsciowe zaszyfrowane
		  en_out : out std_logic;
		  load : in std_logic
		 

			);
END szyfrator;

ARCHITECTURE szyf of szyfrator is
	
	type states is (start, licz, zwroc, stop);	--Stany jakie przyjmuje automat, mozna sie zastanowic nad optymalniejszym automatem, stan stop dodalem tylko dlatego ze 	
	signal state, next_state : states;				--nie umiem w symulacje tzn. nie wiem jak ustawic zeby ruszala od 0 do np 5 ns
	signal counter : integer;							--Sygnal licznika
	signal su : unsigned(31 downto 0);				--Sygnal sumy do szyfratora
	signal v0, v1 : unsigned(31 downto 0);			--Sygnaly pomocnicze do szyfratora

BEGIN
	
	process (clks, rsts)
			begin
			if rsts='1' then
				state <= start;
			elsif (rising_edge(clks)) then
				if(load = '1') then
					state<= next_state;
				end if;
			end if;
	end process;
	
	
	
	process(clks,state,v0_ins,v1_ins)
			variable delta : unsigned(31 DOWNTO 0);
			variable suma : unsigned(31 DOWNTO 0);
			variable v0_v : unsigned(31 DOWNTO 0);
			variable v1_v : unsigned(31 DOWNTO 0);
			variable k0,k1,k2,k3 : unsigned(31 DOWNTO 0);
	
	begin
		if(rising_edge(clks)) then
				
			case state is
				when start =>
					en_out <= '0';												--Zmienne
					delta  := "10011110001101110111100110111001";	
					su     <= "00000000000000000000000000000000";
					
					k0 := key0;
					k1 := key1;
					k2 := key2;
					k3 := key3;
					
					counter <= 0;
					v0 <= v0_ins;
					v1 <= v1_ins;
					--Watosci domyslne
					v0_outs <= "00000000000000000000000000000000";
					v1_outs <= "00000000000000000000000000000000";
				
					next_state <= licz;
					
				when licz =>	
					if counter < 32 then
						suma := su;
						v0_v := v0;
						v1_v := v1;
						
						suma := suma + delta;
						
						v0_v := v0_v +  ( ((v1_v sll 4) + k0) XOR (v1_v + suma)  XOR ( (v1_v srl 5) + k1 ) );
						v1_v := v1_v +  ( ((v0_v sll 4) + k2) XOR (v0_v + suma)  XOR ( (v0_v srl 5) + k3 ) );
						
						counter <= counter + 1;
						su <= suma;
						v0 <= v0_v;
						v1 <= v1_v;
					end if;
					if counter = 32 then
						next_state <= zwroc;
					end if;
					
					when zwroc =>
						v0_outs <= v0;
						v1_outs <= v1;
						next_state <= stop;
					when stop =>
						en_out <= '1';
						v0 <= v0;
						v1 <= v1;
						counter <= counter;
				end case;
			end if;
	end process;
	
	
	
END szyf;

