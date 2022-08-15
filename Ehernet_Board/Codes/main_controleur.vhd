----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2021 17:41:10
-- Design Name: 
-- Module Name: main_controleur - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL ;
use IEEE.NUMERIC_STD.ALL  ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_controleur is
    Port ( CLK10I : in STD_LOGIC;
           RESETN : in STD_LOGIC;
           NOADDRI : out STD_LOGIC_VECTOR (47 downto 0); -- Our MAC adress
           VCC : in STD_LOGIC;
           --receiver
           RBYTEP : out STD_LOGIC; --Available data in RDATAI
           RCLEANP : out STD_LOGIC;
           RCVNGP : out STD_LOGIC; -- Receiving because ze have detected the SFD (will be 1 till the detection of EFD )
           RDATAO : out STD_LOGIC_VECTOR (7 downto 0);
           RDATAI : in STD_LOGIC_VECTOR (7 downto 0);
           RDONEP : out STD_LOGIC;
           RENABP : in STD_LOGIC;
           RSMATIP : out STD_LOGIC;
           RSTARTP : out STD_LOGIC; -- Detected SFD (Start Frame Delimitator)
           --transmitter
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
           TSOCOLP : out STD_LOGIC);
           
           
end main_controleur;

architecture Behavioral of main_controleur is

    constant SFD: STD_LOGIC_VECTOR(7 downto 0) := "10101011" ;
    constant EFD: STD_LOGIC_VECTOR(7 downto 0) := "01010100" ;
    signal counter8 : STD_LOGIC_VECTOR(2 downto 0):= "000" ;
    signal counter8t : STD_LOGIC_VECTOR(2 downto 0):= "000" ;
    signal counter4 : integer range 0 to 4:=0 ;
    signal RCVNGP_AUX : STD_LOGIC:= '0' ;
    signal RCLEANP_AUX : STD_LOGIC:= '0' ;
    signal index : integer range 0 to  5:= 5 ;
    signal des_tindex : integer range 0 to  6:= 6 ;
    signal tindex : integer range 0 to  6:= 6 ;
    signal RSMATIP_AUX: STD_LOGIC ;
    signal TRNSMTP_AUX : STD_LOGIC ;
    signal TSOCOLP_AUX : STD_LOGIC ;
    signal NOADDRI_AUX: STD_LOGIC_VECTOR(47 downto 0) := X"123456789ABC";

begin
   
    RCVNGP <= RCVNGP_AUX ;
    RCLEANP <= RCLEANP_AUX ;
    RSMATIP <= RSMATIP_AUX ;
    TRNSMTP <= TRNSMTP_AUX ;
    NOADDRI <= NOADDRI_AUX ;
    TSOCOLP <= TSOCOLP_AUX ;
    
    
    --========================================Receiver======================================================
    receiver : process
    begin
    wait until CLK10I'event and CLK10I='1' ; 
        
        if RESETN='0'then 
            RBYTEP<='0' ;
            RCLEANP_AUX<='0' ;
            RCVNGP_AUX<='0' ;
            RDONEP<='0' ;
            RSMATIP_AUX<='0' ;
            RSTARTP<='0' ; 
            RDATAO<=(others=>'0') ;
            counter8 <= "000" ;
            index <= 5 ;
            
        elsif  RENABP = '1' and  RCLEANP_AUX = '0' then -- If ENABLE -> detect the SFD
            RBYTEP <= '0' ;
            RDONEP <= '0' ;
            if ( ( RDATAI = SFD ) and (RCVNGP_AUX='0') ) then 
                RBYTEP <= '1' ;
                RCVNGP_AUX <= '1' ;
                RSTARTP <= '1' ;
                          
            elsif RCVNGP_AUX = '1' then -- If the SFD has been detected , counting 8 bits.
                counter8 <= counter8 + 1 ;
                RBYTEP <= '0' ;
                RSTARTP <= '0' ;
                if counter8 = "111"  then --Received SFD
                    counter8 <= "000" ;
                    
                -- Lecture of the Destination Adress
                    if RDATAI = NOADDRI_AUX( ((index+1)*8-1) downto ((index)*8) ) and RSMATIP_AUX = '0' then -- AND NOT RSMATIP
                        index<= index-1 ;
                        RBYTEP <= '1' ;
                        if index = 0 then index<=5 ; RSMATIP_AUX <= '1' ; end if;
                       
                 -- Lecture of the Source Adress
                -- Send all the data (Source adress + Data ) to host 
                    elsif RSMATIP_AUX = '1' then 
                         RDATAO <= RDATAI ;
                         RBYTEP <= '1' ;
                    else 
                        -- If its not the macadress and we haven't detected it -> error
                        RCLEANP_AUX <= '1' ;
                    end if ;-- end data send /lecture of Destination Adress
                        
                end if ; -- end counter8 if
                
                
                if RDATAI = EFD then -- check EFD
                    RCVNGP_AUX <='0' ;
                    RDONEP <= '1' ;
                    RSMATIP_AUX <= '0' ;
                   
                end if ; -- end EFD if
                
            end if ; -- end SFD if
            
            
            
        elsif RCLEANP_AUX = '1' then -- Clean th system in case that the message is not for us(dest. @ != mac @) or invalid source @.
            RCVNGP_AUX <= '0' ;
            RCLEANP_AUX <= '0' ;                
        end if; -- end reset/enable/Cleanp if
             
            
    end process receiver ;
    
    
    --========================================Transmitter======================================================
    transmitter : process
    begin
    wait until CLK10I'event and CLK10I='1' ; 
        
        TDONEP <= '0' ;--pulse 
        
        if RESETN='0'then 
                TDONEP<='0' ; 
                TRNSMTP_AUX<='0' ;
                TSTARTP<='0' ;
                TSOCOLP_AUX<='0' ;
                TREADDP<='0' ;  
                TDATAO<=(others=>'0') ;
                counter8t <= "000" ;
                counter4 <= 0 ;
                des_tindex <= 6 ;
                tindex <= 6 ;
        
        elsif (TRNSMTP_AUX = '1' and RCVNGP_AUX='1') then -- collision (receiver and transmitter is working)
            TSOCOLP_AUX <= '1' ;
                 
        elsif  ((TAVAILP = '1' or TRNSMTP_AUX = '1') and (TABORTP = '0' and TSOCOLP_AUX = '0')) then -- If available frame and not errors
            counter8t <= counter8t + 1 ;
            -- Pulse configurations 
            TSTARTP <= '0' ;
            TREADDP <= '0' ;
            
            -- Octal syncronisation 
            if counter8t = "111"  then
                counter8t <= "000" ;
                -- Send SFD 
                if TRNSMTP_AUX = '0' and TLASTP = '0' and TFINISHP= '0' then  
                    TDATAO <=  SFD ;
                    -- Start pulse 
                    TSTARTP <= '1' ;
                    --transmit mode on
                    TRNSMTP_AUX <= '1';
                    
                elsif TRNSMTP_AUX = '1' then --if is transmitting
                    
                    if des_tindex /= 0 then --Read and Send Destination Address
                        TDATAO <= TDATAI ;
                        des_tindex <= des_tindex - 1 ;
                                    
                    elsif tindex /= 0 and des_tindex = 0 then --Send Source Address
                        TDATAO <= NOADDRI_AUX( ((tindex)*8-1) downto ((tindex-1)*8) ) ;
                        tindex <= tindex - 1 ;
                       
    
                    elsif tindex = 0  and des_tindex=0 then --No more address to send
                                  
                        if TLASTP = '1' then
                                                
                            TDATAO <= TDATAI ;
                        
                        elsif  TFINISHP ='1' then -- if last frame to send 
                            -- Pulses
                            TDONEP <= '1' ;
                            --restore indexs
                            tindex <= 6 ;
                            des_tindex <= 6 ;
                            -- Send EFD
                            TDATAO <=  EFD ; 
                            -- End transmitting
                            TRNSMTP_AUX <= '0' ;
                        else
                        -- Transmitting data 
                            TDATAO <= TDATAI ;   
                            -- Pulse
                            TREADDP <= '1' ;
                        
                        end if;
                        
                    end if ; -- if indexs 0 0
                
                end if ; -- end if transmission
                
            end if ; -- end compteur 8bits
        
        elsif TABORTP = '1' and TRNSMTP_AUX = '1' then -- Abort signal received (underflow condition)
            counter8t <= counter8t + 1 ;
            TREADDP <= '0' ;
            TSOCOLP_AUX <= '1' ;
            if counter8t = "111"  then
                counter8t <= "000" ;
                TDATAO<= "10101010";
                counter4 <= counter4 + 1;
                if counter4 = 4 then
                    TRNSMTP_AUX <= '0';
                    counter4 <= 0;
                    TDATAO<= "00000000";
                end if;
            end if; --end comteur 8bits
                     
        end if; -- end abort if
    
                   
    end process transmitter;


end Behavioral;
