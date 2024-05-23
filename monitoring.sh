#!/bin/bash
architecture=$(uname -a) // imprime les infos du systeme -a = all
physicap_p=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) // cherche dans cpuinfo |
trie par ordre alphabétiquement | supprime les doubles | compte le nombre de lignes
virtual_p=$(grep "^processor" /proc/cpuinfo | wc -l) // cherche dans cpuinfo | prend les
resultats commencant avec processor
free_ram=$(free -m | awk '$1 == "Mem:" {print $2}') // affiche la RAM | awk éditeur de texte
2eme colonne
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
percent_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}') // 3eme colonne / 2eme
colonne * 100
total_disk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}') // imprime
les files systems sur le système en taille G (gigabytes) | prends les lignes commencant par
/dev | exclut /boott$ | ft += → additionne toutes les infos de la 2eme colonne
used_disk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}') //
imprime les files systèmes en taille M (Megabytes)
percent_disk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END
{printf("%d"), ut/ft*100}') // pourcentage entre ut et ft
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}') //usage
du CPU | filtre en le 9eme et le dernier char | xargs = concatene en une seule ligne |
pourcentage
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}') // date et jour quand le systeme a ete
boot
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi) // variable
assigne a yes si le systeme a des LVM, sinon no. | lsblk → liste des appareils sur le systeme
| eq 0 → si le resultat de la commande est egal a 0, alors echo no
ctcp=$(ss -neopt state established | wc -l) // montre les nombres des connections TCP deja
etablis
ulog=$(users | wc -w) // users | word count
ip=$(hostname -I) // montre le nom du host name -I → les adresses IP
mac=$(ip link show | grep "ether" | awk '{print $2}') // liste les interfaces network
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l) // liste toutes les commandes
sudo du systemes
wall " #Architecture: $architecture
#CPU physical: $physical_p#vCPU: $virtual_p
#Memory Usage: $used_ram/${free_ram}MB ($percent_ram%)
#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
#CPU load: $cpul
#Last boot: $lb
#LVM use: $lvmu
#Connections TCP: $ctcp ESTABLISHED
#User log: $ulog
#Network: IP $ip ($mac)
#Sudo: $cmds cmd"
