# WiFi-D3fudd

Essa ferramenta procura redes Wi-Fi próximas e realiza tentativas de autenticação nas redes com base nas senhas padrão definidas pelo fabricante.

### :hammer_and_wrench: Requisitos

Para rodar é necessário utilizar um terminal linux e instalar os seguintes utilitários:

```
apt-get install network-manager
```
### 📋 Como usar
```
git clone https://github.com/caique-garbim/WiFi-D3fudd.git
```
```
cd WiFi-D3fudd/
```
```
sudo chmod a+x WiFi-D3fudd.sh
```
```
sudo ./WiFi-D3fudd.sh
```
![image](https://user-images.githubusercontent.com/76706456/172023673-17ce94ff-f17a-4aea-852e-dad14629f070.png)

![image](https://user-images.githubusercontent.com/76706456/172023683-e7983964-1848-4a10-93f8-b084bcdf834d.png)

#

### A insegurança em roteadores Wi-Fi
<br>

Muitos roteadores, principalmente fornecidos pelo provedor de internet contratado, são instalados em residências e empresas com suas configurações padrão. Às vezes pela “complexidade” da senha original faz o proprietário pensar que a senha é verdadeiramente aleatória, mas nem sempre é.

É de costume de alguns provedores definirem a senha do Wi-Fi respeitando um tipo de “padrão” que é facilmente perceptível (pode variar da região). Por isso, diversas redes Wi-Fi são vulneráveis por possuírem como senha uma concatenação de um segmento do BSSID (endereço MAC de um adaptador sem-fio) com o SSID (“nome” da rede Wi-Fi).

Uma vez que esses dados são públicos à qualquer um que busque por redes Wi-Fi, fica fácil para qualquer indivíduo testar algumas combinações e conseguir se autenticar na rede com poucas tentativas, principalmente se o SSID (padrão) indicar um provedor cujo o padrão já é conhecido.

**Exemplo 1:**
Geralmente os roteadores com o SSID iniciados com “NET_” possuem como senha o 3º ao 6º byte.

Suponhamos que temos um roteador NET com a seguinte configuração:
<br>
**SSID: NET_3C4D5E6F <br>
BSSID: 1A:2B:3C:4D:5E:6F**

É valido dizer que a senha pode ser: **3C4D5E6F**

**Exemplo 2:**
É notável que o SSID (padrão) possua uma semelhança com o BSSID, às vezes com uma diferença no último byte. Neste caso é valido tentar de ambas as formas:
<br>
**SSID: NET_3C4D5EFF <br>
BSSID: 1A:2B:3C:4D:5E:6F**

É valido dizer que a senha pode ser: **3C4D5E6F** ou  **3C4D5EFF**

**Exemplo 3:**
Suponhamos que temos um roteador VIVO. Mesmo sendo diferente dos primeiros exemplos, muitos modelos sofrem com o mesmo problema. Observe a seguinte configuração:
<br>
**SSID: VIVO-5E6F <br>
BSSID: 1A:2B:3C:4D:5E:6F**

É válido dizer que a senha pode ser: **2B3C4D5E6F**

**Exemplo 4:**
Caso o último byte não corresponder com os últimos 2 caracteres do SSID, é válido tentar de ambas as formas:
<br>
**SSID: VIVO-5E66 <br>
BSSID: 1A:2B:3C:4D:5E:6F**

É válido dizer que a senha pode ser: **2B3C4D5E6F** ou  **2B3C4D5E66**

O mesmo problema se repete em alguns roteadores CLARO e SKY.

Por fim, entendemos que por mais complexa que a senha possa parecer, não significa que está verdadeiramente imune de intrusos. Para mitigar esse risco é altamente recomendado que altere o SSID e a senha padrão do roteador que for identificado com este problema.

Esse tipo de vulnerabilidade permite que um intruso, uma vez autenticado, possa causar danos de diversas formas. Seja interceptando o tráfego ou movimentando-se lateralmente pela rede, explorando hosts, servidores, escalando seu privilégio.

#

### Referência:
<br>
https://olhardigital.com.br/2019/03/15/noticias/roteadores-da-vivo-apresentam-vulnerabilidade-que-pode-comprometer-a-rede/
