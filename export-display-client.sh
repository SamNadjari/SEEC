
name=$1
export DISPLAY=:0

#screenshot the display
import -window root SEEC/results/images/$name.png
#crop the image to remove the time which will make comparing two images quality inaccurate
#+10+80 represents the X and Y from the top left where you  want to start cropping
convert SEEC/results/images/$name.png  -crop 1024x600+10+80 SEEC/results/images/$name-cropped.png
