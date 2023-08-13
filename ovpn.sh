#!/bin/bash
checkvpn () {
echo "Ну и че те надо"
echo "Жди.."
sleep 1
if tmux has-session -t ISP > /dev/null 2>&1
then
	echo "Обнаружено VPN соединение в ISP"
	chckvpn='ISP'
	namevpn='Иркутск'
	startscriptreconnect

elif tmux has-session -t German > /dev/null 2>&1
then
	echo "Обнаружено VPN соединение в German"
	chckvpn='German'
	namevpn='Германию'
	startscriptreconnect
else
	echo "Активных VPN соединений не найдено"
	selectnamevpn
	
fi }

startscriptreconnect () {
echo "Хочешь закрыть текущее соединение или открыть новое?"
echo "Close (C) or Open (O) or Reconnect (R)"
read instr
	if [[ $instr != [Cc] ]] && [[ $instr != [Oo] ]] && [[ $instr != [rR] ]]
	then echo "Ну пиши ты нормально, как человек.."
		startscriptreconnect
	else
			
			if [[ $instr = [Cc] ]]

			then echo "Закрываю VPN в $namevpn"
			     tmux kill-session -t $chckvpn

			elif [[ $instr = [Oo] ]]

			then echo "Закрываю vpn в $namevpn"
			     echo "Открываем VPN"
			     tmux kill-session -t $chckvpn
			     selectnamevpn

			elif [[ $instr = [rR] ]]
			then echo "Перезапускаем VPN соединение"
			     tmux kill-session -t $chckvpn
				if [[ $chckvpn = 'ISP' ]]
				then typevpn='I'
				     namevpn='Иркутск'
				elif [[ $chckvpn = 'German' ]]
				then typevpn='G'		
				     namevpn='Германию'
				fi
			newconnectvpn
			fi
	fi }

selectnamevpn () {
echo "German (G) or ISP (I)"
read typevpn
echo "$tnamevpn"
        if [[ $typevpn != [gG] ]] && [[ $typevpn != [iI] ]]
        then 	echo "Ну пожалуйста, ну пиши ты как человек."
		
		echo "G ИЛИ I, че сложного я не пойму"
                
		selectnamevpn
        else 
			if [[ $typevpn = [Gg] ]]
			then namevpn='Германию'
				
			elif [[ $typevpn = [iI] ]]	
			then namevpn='Иркутск'
			fi
		echo "Идем в $namevpn" 
newconnectvpn
                fi }

newconnectvpn () {
if [[ $typevpn = [gG] ]]
then
	tmux new-session -s German -n G -d 'sudo openvpn 1.ovpn' 
	echo "Поднял сессию в $namevpn!"


elif [[ $typevpn = [iI] ]]
then
 	tmux new-session -s ISP -n I -d 'sudo openvpn 2.ovpn'
	echo "Поднял сессию в $namevpn!"

fi }

checkvpn
