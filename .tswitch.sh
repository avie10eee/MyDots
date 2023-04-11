#!/bin/bash

PS3="Select your ColorScheme: "

select colorsh in wasteland quartz ocean party gruvbox monokai Nord dracula Quit
do
   case $colorsh in
      "wasteland")
         sed -i 'colors: \*//colors: *wasteland' ${HOME}/.config/alacritty/alacritty.yml;;
      "quartz")
         sed -i 'colors: \*//colors: *quartz' ${HOME}/.config/alacritty/alacritty.yml;;
      "ocean")
         sed -i 'colors: \*//colors: *ocean' ${HOME}/.config/alacritty/alacritty.yml;;
      "party")
         sed -i 'colors: \*//colors: *party' ${HOME}/.config/alacritty/alacritty.yml;;
      "gruvbox")
         sed -i 'colors: \*//colors: *gruvbox' ${HOME}/.config/alacritty/alacritty.yml;;
      "monokai")
         sed -i 'colors: \*//colors: *monokai' ${HOME}/.config/alacritty/alacritty.yml;;
      "nord")
         sed -i 'colors: \*//colors: *nord' ${HOME}/.config/alacritty/alacritty.yml;;
      "dracula")
         sed -i 'colors: \*//colors: *dracula' ${HOME}/.config/alacritty/alacritty.yml;;
      "Quit")
         echo "We're done"
         break;;
        *)
         echo "Please try again";;
   esac
done


######################################################################
## SET THEME: Choose ONE color scheme from those in the above list. ##
## ###################################################################
# Available themes are:
# *wasteland
# *quartz
# *ocean
# *party
# *gruvbox
# *monokai
# *Nord
# *dracula