GEOMETRY=`xdotool getwindowgeometry $(xdotool getactivewindow)`
DIMENSIONS=$(echo "$GEOMETRY" | grep -Po "[0-9]+x[0-9]+")
X=$(echo $DIMENSIONS | sed 's/x[0-9]\+//g')
Y=$(echo $DIMENSIONS | sed 's/[0-9]\+x//g')
xdotool mousemove -window $(xdotool getactivewindow) $(( $X / 2)) $(( $Y /2))
