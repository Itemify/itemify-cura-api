#!/bin/bash
STL="/models/Model.stl"
CURA_PATH="/usr/share/cura"

TO_BE_DOWNLOADED="https://itemify-models.fra1.cdn.digitaloceanspaces.com/$FILE_INPUT"

if [ -z "$FILE_INPUT" ]; then
    TO_BE_DOWNLOADED="https://itemify-models.fra1.cdn.digitaloceanspaces.com/364/tuxkey.stl"
fi

curl $TO_BE_DOWNLOADED -o $STL > /dev/null 2>&1

#CuraEngine slice -h
#ls "$CURA_PATH/resources/definitions/"
#cat "$CURA_PATH/resources/definitions/fdmextruder.def.json"
#cat $CURA_PATH/resources/definitions/creality_base.def.json
#cat $CURA_PATH/resources/definitions/creality_ender3.def.json

FILAMENT_USED=$((CuraEngine slice -v  \
    -j "$CURA_PATH/resources/definitions/creality_ender3.def.json" \
    -j "$CURA_PATH/resources/definitions/fdmextruder.def.json" \
    -o "/models/test.gcode" \
    -e1 -s infill_line_distance=0 -e0 \
    -s "machine_extruder_cooling_fan_number=1" \
    -l "$STL" 2>&1) | grep "Filament used" | sed "s/;Filament used: //g" | sed "s/m, 0m//g")

echo $FILAMENT_USED

#cat /models/test.gcode

psql -c "UPDATE item_files SET filament_used = $FILAMENT_USED WHERE file_path = '$FILE_INPUT'"
