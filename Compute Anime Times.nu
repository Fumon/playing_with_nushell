let animetimes = ls **/* |
where type == file and name =~ '\.(ogm|avi|AVI|mp4|MP4|mkv|MKV|mov|MOV)$' |
par-each -t 256 {|it| try {
        let dur = (
            ^ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $it.name
        ); { name: $it.name, duration_sec: $dur} 
    } catch { null } 
};
$animetimes | each {|it| $it.duration_sec | into float } | reduce {|it, acc| $it + $acc } | rink $"($in) seconds -> month;day;hour;minute;second;millisecond;microsecond"