
img1=$1 #refernce image name without the extension (e.g., .png)
img2=$2
app=$3
rtt=$4
loss=$5

res_dir=/home/harlem1/SEEC/Windows-scripts/results

#chop the bottom of the image that have the time
convert  $img1.png -gravity South  -chop  0x40  $img1-chop.png
convert  $img2.png -gravity South  -chop  0x40  $img2-chop.png

#compute the metric
#PSNR
magick compare  -metric psnr $img1-chop.png $img2-chop.png difference.png 2> xx #2> is used because by default compare send the output to the stdr error so using redicrtion ">" without 2 will not capture th eoutput
psnr=`cat xx`
echo $rtt $loss $psnr > $res_dir/$app-image-quality-PSNR.txt

#MSE
magick compare  -metric mse $img1-chop.png $img2-chop.png difference.png 2> xx
mse=`cat xx`
echo $rtt $loss $mse > $res_dir/$app-image-quality-MSE.txt

#SSIM
magick compare  -metric ssim $img1-chop.png $img2-chop.png difference.png 2> xx
ssim=`cat xx`
echo $rtt $loss $ssim > $res_dir/$app-image-quality-SSIM.txt

rm xx
