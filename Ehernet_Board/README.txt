Luiz Renato RODRIGUES CARNEIRO
Martin Cheliz
Bojian Shang

Nous avons fait tout du projet demandé (la partie du transmetteur et du récepteur), si il y a des erreurs il seront en raison de ,mauvaise compréhension/interprétation de la documentation.
De cet manière tout a marché, nous avons faire la simulation du receiver avec deux trame de donnée en séquence et un bruit entre les deux trames pour voir si le receiver peut recevoir les trames en séquence comme dans le monde réel. La Figure “Receiver1” a la première trame correct et le bruit, la Figure “Receiver2” a le bruit et la trame avec un errer dans le MACADRESS du destinateur (receiver).
La simulation du Transmitter nous avons fait les deux cas en séquence aussi le premier dans la Figure “Transmitter1” est la transmission correct et la Figure “Transmitter2” il y a le TABORTP
Nous avons fait la simulation de la collision dans la Figure “Collision” on a commencé avec le receiver et après on a lancé le transmitter.

Tous ces simulations ont été fait deux fois, pour la simulation comportemental (les image dans le dossier “Behavioral Simulation”), et pour le Timing Simulation ( dans le dossier “Post-Implementation Timing Simulation”).
Toutes les simulation sont très pareille sauf les trames en séquence du receiver dans le cas de Timing Simulation, le RTADAO a bien marché mais il y a des flags qui changent des pulses différentes de la simulation précédente, comme le cas de RCLEANP, RSTARTP et RCVNGP. 

 
Nombre de Bascule: 45 FF
Nombre de portes: 99
Consommation: 0,072 W
Max Frequency= 1/Trequired=1/2,155ns= 464 MHz

Tous ces information sont aussi disponible dans le dossier de screenshot "synthèse"