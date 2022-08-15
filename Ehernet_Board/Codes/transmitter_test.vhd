library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter_test is
--  Port ( );
end transmitter_test;

architecture Behavioral of transmitter_test is

COMPONENT main_controleur 
PORT(
       CLK10I : in STD_LOGIC;
       RESETN : in STD_LOGIC;
       NOADDRI : out STD_LOGIC_VECTOR (47 downto 0);
       VCC : in STD_LOGIC;
       RBYTEP : out STD_LOGIC;
       RCLEANP : out STD_LOGIC;
       RCVNGP : out STD_LOGIC;
       RDATAO : out STD_LOGIC_VECTOR (7 downto 0);
       RDATAI : in STD_LOGIC_VECTOR (7 downto 0);
       RDONEP : out STD_LOGIC;
       RENABP : in STD_LOGIC;
       RSMATIP : out STD_LOGIC;
       RSTARTP : out STD_LOGIC;
       TABORTP : in STD_LOGIC;
       TAVAILP : in STD_LOGIC;
       TDATAI : in STD_LOGIC_VECTOR (7 downto 0);
       TDATAO : out STD_LOGIC_VECTOR (7 downto 0);
       TDONEP : out STD_LOGIC;
       TFINISHP : in STD_LOGIC;
       TLASTP : in STD_LOGIC;
       TREADDP : out STD_LOGIC;
       TRNSMTP : out STD_LOGIC;
       TSTARTP : out STD_LOGIC;
       TSOCOLP : out STD_LOGIC
    );
END COMPONENT ;

--Inputs

signal CLK10I : std_logic := '0';
signal RESETN : std_logic := '1';
signal VCC : std_logic := '1';
signal RDATAI : std_logic_vector(7 downto 0) := (others => '1');
signal RENABP : std_logic := '1';
signal TABORTP : std_logic := '1';
signal TAVAILP : std_logic := '1';
signal TDATAI : std_logic_vector(7 downto 0) := (others => '1');
signal TFINISHP : std_logic := '1';
signal TLASTP : std_logic := '1';


--Outputs 


signal NOADDRI :  STD_LOGIC_VECTOR (47 downto 0);
signal RBYTEP :  STD_LOGIC;
signal RCLEANP :  STD_LOGIC;
signal RCVNGP :  STD_LOGIC;
signal RDATAO :  STD_LOGIC_VECTOR (7 downto 0);
signal RDONEP :  STD_LOGIC;
signal RSMATIP :  STD_LOGIC;
signal RSTARTP :  STD_LOGIC;
signal TDATAO :  STD_LOGIC_VECTOR (7 downto 0);
signal TDONEP :  STD_LOGIC;
signal TREADDP : std_logic ;
signal TRNSMTP :  STD_LOGIC;
signal TSTARTP :  STD_LOGIC;
signal TSOCOLP :  STD_LOGIC;

-- Clock period definitions 
constant Clock_period : time := 10 ns; 

begin
 -- Instantiate the Unit Under Test (UUT) 
 uut: main_controleur PORT MAP (
        CLK10I => CLK10I,
        RESETN => RESETN,
        NOADDRI => NOADDRI,
        VCC => VCC,
        RBYTEP => RBYTEP,
        RCLEANP => RCLEANP,
        RCVNGP => RCVNGP,
        RDATAO => RDATAO,
        RDATAI => RDATAI,
        RDONEP => RDONEP,
        RENABP => RENABP,
        RSMATIP => RSMATIP,
        RSTARTP => RSTARTP,
        TABORTP => TABORTP,
        TAVAILP => TAVAILP,
        TDATAI => TDATAI,
        TDATAO => TDATAO,
        TDONEP => TDONEP,
        TFINISHP => TFINISHP,
        TLASTP => TLASTP,
        TREADDP => TREADDP,
        TRNSMTP => TRNSMTP,
        TSTARTP => TSTARTP,
        TSOCOLP => TSOCOLP
     );

Clock_process :process 
begin 
   CLK10I <= not(CLK10I); 
   wait for Clock_period/2; 
end process; 


stim_proc: process 
begin         
    VCC <= '1';
    RESETN <= '1', '0' after 3*Clock_period ,'1' after 5*Clock_period ;
   
 --======================insert signal for transmitter=====================================================================
   TAVAILP<= '0', '1' after (1*8+2)*Clock_period, '0' after 3*8*Clock_period, '1' after 22*8*Clock_period , '0' after 24*8*Clock_period;
   TABORTP<= '1', '0' after (1*8+2)*Clock_period, '1' after 36*8*Clock_period ;
   TDATAI<= --All correct TRansmission
             -- SFD + Destination Address
             X"34", "10101011" after 2*8*Clock_period , X"13" after 3*8*Clock_period, X"24" after 4*8*Clock_period, X"35" after 5*8*Clock_period, X"46" after 6*8*Clock_period , X"57" after 7*8*Clock_period, X"68"  after 8*8*Clock_period ,
             -- Source Address
             X"AB" after 9*8*Clock_period, X"CD" after 10*8*Clock_period, X"11" after 11*8*Clock_period, X"22" after 12*8*Clock_period, X"33" after 13*8*Clock_period, X"44" after 14*8*Clock_period,
             -- Data + EFD
             X"31" after 15*8*Clock_period, X"45" after 16*8*Clock_period, X"CD" after 17*8*Clock_period, X"12" after 18*8*Clock_period, X"45" after 19*8*Clock_period, "01010100" after 20*8*Clock_period ,
             --All correct TRansmission
            -- SFD + Destination Address
            "10101011" after 22*8*Clock_period , X"14" after 23*8*Clock_period, X"25" after 24*8*Clock_period, X"36" after 25*8*Clock_period, X"47" after 26*8*Clock_period , X"58" after 27*8*Clock_period, X"69"  after 28*8*Clock_period ,
            -- Source Address
            X"AC" after 29*8*Clock_period, X"CE" after 30*8*Clock_period, X"11" after 31*8*Clock_period, X"22" after 32*8*Clock_period, X"33" after 33*8*Clock_period, X"44" after 34*8*Clock_period,
            -- Data + EFD
            X"31" after 35*8*Clock_period, X"45" after 36*8*Clock_period, X"CD" after 37*8*Clock_period, X"12" after 38*8*Clock_period, X"45" after 39*8*Clock_period, "01010100" after 40*8*Clock_period ;
  
   TLASTP<= '0', '1' after 19*8*Clock_period, '0' after (19*8+3)*Clock_period ;
   TFINISHP<= '0', '1' after 20*8*Clock_period, '0' after (20*8+3)*Clock_period ;
   
   
   wait; 
end process;



end Behavioral;