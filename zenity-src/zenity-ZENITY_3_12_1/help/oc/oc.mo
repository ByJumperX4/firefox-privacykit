��    c      4  �   L      p  n   q  t   �    U	  �  Z
     @     R     Z     g     s  
        �  
   �     �     �     �     �     �  
   �     �                    .     >     N     _     n  
   z  	   �     �     �  	   �     �     �     �     �     �  ;   �  @   �  5   :  =   p  ?   �  ;   �  9   *  C   d  A   �  7   �  9   "  9   \  C   �  7   �  W     T   j  T   �  \     Z   q  S   �  [      W   |  W   �  S   ,  V   �  (   �                          (     H     N     ]     d     �     �     �     �     �     �     �     �     �     �     �     �          %     7     @     I     M  .   d     �     �     �     �     �     �     �  W  �  t   C  ~   �    7  	  P     Z     q     y     �     �  
   �     �  
   �     �     �     �     �     �  
   
          !     -     9     M     ]     m     ~     �  
   �  	   �     �     �  	   �     �     �     �     �     �  <   �  @     6   Z  >   �  F   �  ;     7   S  D   �  B   �  8      :   L   :   �   K   �   9   !  W   H!  T   �!  T   �!  \   J"  Z   �"  S   #  [   V#  W   �#  W   
$  S   b$  V   �$  4   %     B%  
   P%     [%     b%  &   n%     �%     �%     �%  #   �%     �%     �%     �%     &     &     &     +&     8&     H&     O&     X&     a&      x&     �&     �&     �&     �&     �&  2   �&     '     '     ''     .'     ?'  2   T'     �'     J       +   B       A   V                             b      *   W                          '      
   6                 8   N          [   3   =   ]   D   @   0   \   c   ^   _   #   $   a   U   ?         Y      :   -           C       O           5                  G   T      (   M   F   %          `   /       9   "   !   L      ,   I      )   ;      <      R   &   7   X      P              S   4             .   	              K   2                  Z         H       E       Q             >               1    
          #!/bin/bash

          zenity --error \
          --text="Could not find /var/log/syslog."
         
          #!/bin/bash

          zenity --info \
          --text="Merge complete. Updated 3 of 10 files."
         
        #!/bin/sh


        if zenity --calendar \
        --title="Select a Date" \
        --text="Click on a date to select that date." \
        --day=10 --month=8 --year=2004
          then echo $?
          else echo "No date selected"
        fi
       
        #!/bin/sh

        FILE=`zenity --file-selection \
          --title="Select a File"`

        case $? in
                 0)
                        zenity --text-info \
                          --title=$FILE \
                          --filename=$FILE \
                          --editable 2&gt;/tmp/tmp.txt;;
                 1)
                        echo "No file selected.";;
                -1)
                        echo "No file selected.";;
        esac
       "_Choose a name". --about --auto-close --checklist --directory --editable --help --help-all --help-calendar --help-entry --help-error --help-file-selection --help-general --help-gtk --help-info --help-list --help-misc --help-notification --help-progress --help-question --help-text-info --help-warning --hide-text --multiple --pulsate --radiolist --save --version -1 0 1 2003 2004 <option>--column</option>=<replaceable>column</replaceable> <option>--date-format</option>=<replaceable>format</replaceable> <option>--day</option>=<replaceable>day</replaceable> <option>--entry-text</option>=<replaceable>text</replaceable> <option>--filename</option>=<replaceable>filename</replaceable> <option>--height</option>=<replaceable>height</replaceable> <option>--month</option>=<replaceable>month</replaceable> <option>--percentage</option>=<replaceable>percentage</replaceable> <option>--print-column</option>=<replaceable>column</replaceable> <option>--text</option>=<replaceable>text</replaceable> <option>--title</option>=<replaceable>title</replaceable> <option>--width</option>=<replaceable>width</replaceable> <option>--window-icon</option>=<replaceable>icon_path</replaceable> <option>--year</option>=<replaceable>year</replaceable> @@image: 'figures/zenity-calendar-screenshot.png'; md5=b739d32aad963be4415d34ec103baf26 @@image: 'figures/zenity-entry-screenshot.png'; md5=0fb790cbb6d13ec13a314b34f844ee80 @@image: 'figures/zenity-error-screenshot.png'; md5=c0fae27dcfc45eb335fd6bbc5e7f29b5 @@image: 'figures/zenity-fileselection-screenshot.png'; md5=2c903cba26fb40462deea0bb6b931ea7 @@image: 'figures/zenity-information-screenshot.png'; md5=5a9af4275678c8bfb9b48010860a45e5 @@image: 'figures/zenity-list-screenshot.png'; md5=9c5a2704eb27e21a8e8739c49f77b3fc @@image: 'figures/zenity-notification-screenshot.png'; md5=d7a119ced7cdf49b307013551d94e11e @@image: 'figures/zenity-progress-screenshot.png'; md5=706736240f396ada12044c23b708a6a6 @@image: 'figures/zenity-question-screenshot.png'; md5=df8414504f8c8ca946a3f1e63a460938 @@image: 'figures/zenity-text-screenshot.png'; md5=55d2e2a0254f43ef3c7e9b3d0c4cde04 @@image: 'figures/zenity-warning-screenshot.png'; md5=cde1378d51f800a025b8c37ecdb60a20 Allows the displayed items to be edited. August 2004 Calendar Curran Description Displays help for GTK+ options. Error File selection Foster GNOME Documentation Project GTK+ Options General Options Glynn Glynn Foster Help Options Information Introduction January 2003 List Message Nicholas Notification Icon Notification Icon Example Notification icon Progress Question Sun Sun Microsystems, Inc. This manual describes version 2.6.0 of Zenity. Usage Warning Zenity Zenity Manual Zenity Manual V1.0 translator-credits zenity command Project-Id-Version: oc
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2008-01-20 16:03+0100
Last-Translator: Yannig Marchegay (Kokoyaya) <yannig@marchegay.org>
Language-Team: Occitan <ubuntu-l10n-oci@lists.ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1); 
          #!/bin/bash

          zenity --error \
          --text="Impossible de trobar /var/log/syslog."
         
          #!/bin/bash

          zenity --info \
          --text="Fusion acabada. 3 fichièrs sur 10 meses a jorn."
         
        #!/bin/sh


        if zenity --calendar \
        --title="Seleccionatz una data" \
        --text="Clicatz sus una data per la seleccionar." \
        --day=10 --month=8 --year=2004
          then echo $?
          else echo "Pas de data seleccionada"
        fi
       
        #!/bin/sh

        FILE=`zenity --file-selection  \
          --title="Seleccionatz un fichièr"`

        case $? in
                 0)
                        zenity --text-info  \
                          --title=$FILE  
                          --filename=$FILE  \
                          --editable 2&gt;/tmp/tmp.txt;;
                 1)
                        echo "Pas de fichièr seleccionat.";;
                -1)
                        echo "Pas de fichièr seleccionat.";;
        esac
       "_Causissètz un nom". --about --auto-close --checklist --directory --editable --help --help-all --help-calendar --help-entry --help-error --help-file-selection --help-general --help-gtk --help-info --help-list --help-misc --help-notification --help-progress --help-question --help-text-info --help-warning --hide-text --multiple --pulsate --radiolist --save --version -1 0 1 2003 2004 <option>--column</option>=<replaceable>colomna</replaceable> <option>--date-format</option>=<replaceable>format</replaceable> <option>--day</option>=<replaceable>jorn</replaceable> <option>--entry-text</option>=<replaceable>tèxt</replaceable> <option>--filename</option>=<replaceable>nom_de_fichièr</replaceable> <option>--height</option>=<replaceable>nautor</replaceable> <option>--month</option>=<replaceable>mes</replaceable> <option>--percentage</option>=<replaceable>percentatge</replaceable> <option>--print-column</option>=<replaceable>colomna</replaceable> <option>--text</option>=<replaceable>tèxt</replaceable> <option>--title</option>=<replaceable>títol</replaceable> <option>--width</option>=<replaceable>largor</replaceable> <option>--window-icon</option>=<replaceable>camin_de_l'icòna</replaceable> <option>--year</option>=<replaceable>annada</replaceable> @@image: 'figures/zenity-calendar-screenshot.png'; md5=b739d32aad963be4415d34ec103baf26 @@image: 'figures/zenity-entry-screenshot.png'; md5=0fb790cbb6d13ec13a314b34f844ee80 @@image: 'figures/zenity-error-screenshot.png'; md5=c0fae27dcfc45eb335fd6bbc5e7f29b5 @@image: 'figures/zenity-fileselection-screenshot.png'; md5=2c903cba26fb40462deea0bb6b931ea7 @@image: 'figures/zenity-information-screenshot.png'; md5=5a9af4275678c8bfb9b48010860a45e5 @@image: 'figures/zenity-list-screenshot.png'; md5=9c5a2704eb27e21a8e8739c49f77b3fc @@image: 'figures/zenity-notification-screenshot.png'; md5=d7a119ced7cdf49b307013551d94e11e @@image: 'figures/zenity-progress-screenshot.png'; md5=706736240f396ada12044c23b708a6a6 @@image: 'figures/zenity-question-screenshot.png'; md5=df8414504f8c8ca946a3f1e63a460938 @@image: 'figures/zenity-text-screenshot.png'; md5=55d2e2a0254f43ef3c7e9b3d0c4cde04 @@image: 'figures/zenity-warning-screenshot.png'; md5=cde1378d51f800a025b8c37ecdb60a20 Autorizar la modificacion dels elements visualizats. Agost de 2004 Calendièr Curran Descripcion Visualiza l'ajuda per las opcion GTK+. Error Seleccion de fichièrs Foster Projècte de documentacion de GNOME Opcions GTK+ Opcions generalas Glynn Glynn Foster Opcions d'ajuda Entresenhas Introduccion Genièr de 2003 Tièra Messatge Nicholas Icòna de notificacion Exemple d'icòna de notificacion Icòna de notificacion Avançament Question Sun Sun Microsystems, Inc. Aqueste manual descriu la version 2.6.0 de Zenity. Utilizacion Alèrta Zenity Manual de Zenity Manual de Zenity 1.0 Yannig Marchegay (Kokoyaya) <yannig@marchegay.org> comanda de zenity 