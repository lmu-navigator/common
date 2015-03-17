# parameter: a png image file located in the same directory!
filename=$1

extension="${filename##*.}"
basename="${filename%.*}"

if [ $extension != "png" ]
then
	echo "Error: Needs png image file from the same directory as argument!"
	exit
fi

imagemagick='convert -limit map 0 -limit memory 0'
tilesize=256
samplesize=1000

tilesfolder=tiles
samplesfolder=samples

echo "create tile folders"
mkdir -p $tilesfolder/$basename
mkdir -p $tilesfolder/$basename/1000
mkdir -p $tilesfolder/$basename/500
mkdir -p $tilesfolder/$basename/250
mkdir -p $tilesfolder/$basename/125
mkdir -p $samplesfolder

echo "create temporary scaled images"
$imagemagick $filename -resize 50%  $basename-500.$extension
$imagemagick $filename -resize 25%  $basename-250.$extension
$imagemagick $filename -resize 12.5%  $basename-125.$extension

echo "create sample"
$imagemagick $filename -thumbnail ${samplesize}x${samplesize}  ./$samplesfolder/$filename

echo "create tiles"
$imagemagick $filename -crop ${tilesize}x${tilesize} -set filename:tile "%[fx:page.x/$tilesize]_%[fx:page.y/$tilesize]" +repage +adjoin "./$tilesfolder/$basename/1000/%[filename:tile].$extension"
$imagemagick $basename-500.$extension -crop ${tilesize}x${tilesize} -set filename:tile "%[fx:page.x/$tilesize]_%[fx:page.y/$tilesize]" +repage +adjoin "./$tilesfolder/$basename/500/%[filename:tile].$extension"
$imagemagick $basename-250.$extension -crop ${tilesize}x${tilesize} -set filename:tile "%[fx:page.x/$tilesize]_%[fx:page.y/$tilesize]" +repage +adjoin "./$tilesfolder/$basename/250/%[filename:tile].$extension"
$imagemagick $basename-125.$extension -crop ${tilesize}x${tilesize} -set filename:tile "%[fx:page.x/$tilesize]_%[fx:page.y/$tilesize]" +repage +adjoin "./$tilesfolder/$basename/125/%[filename:tile].$extension"

# create tiles directory structures
for i in $tilesfolder/$basename/1000/*.png; do
	base=`basename $i`
	IFS='_' read -ra arr <<< "$base"
	mkdir -p $tilesfolder/$basename/1000/${arr[0]}
	mv $tilesfolder/$basename/1000/$base $tilesfolder/$basename/1000/${arr[0]}/${arr[1]}
done

for i in $tilesfolder/$basename/500/*.png; do
	base=`basename $i`
	IFS='_' read -ra arr <<< "$base"
	mkdir -p $tilesfolder/$basename/500/${arr[0]}
	mv $tilesfolder/$basename/500/$base $tilesfolder/$basename/500/${arr[0]}/${arr[1]}
done

for i in $tilesfolder/$basename/250/*.png; do
	base=`basename $i`
	IFS='_' read -ra arr <<< "$base"
	mkdir -p $tilesfolder/$basename/250/${arr[0]}
	mv $tilesfolder/$basename/250/$base $tilesfolder/$basename/250/${arr[0]}/${arr[1]}
done

for i in $tilesfolder/$basename/125/*.png; do
	base=`basename $i`
	IFS='_' read -ra arr <<< "$base"
	mkdir -p $tilesfolder/$basename/125/${arr[0]}
	mv $tilesfolder/$basename/125/$base $tilesfolder/$basename/125/${arr[0]}/${arr[1]}
done

echo "cleanup"
rm $basename-500.$extension
rm $basename-250.$extension
rm $basename-125.$extension

echo "DONE"
