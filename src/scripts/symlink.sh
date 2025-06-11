#!/bin/zsh --no-rcs

dirname=$(dirname -- "$source_path")
basename=$(basename -- "$source_path")

if [[ sl_suffix_enable -eq 1 ]]; then
  [[ -n $sl_suffix_custom ]] && sl_suffix=$sl_suffix_custom || sl_suffix=$sl_suffix_default
fi
sl_suffix="${sl_suffix//\[space\]/ }"


# if file, get extension, accounting for filenames ending in "." or with no extension
if [[ -f $source_path && "$basename" == *"."* && "$basename" != *"." ]]; then
  name="${basename%.*}"
  extension="${basename##*.}"
elif [[ -f $source_path || -d $source_path ]]; then
  name="$basename"
  extension=""
fi

get_target_path() {
  num=$1
  if [[ $num -eq 0 ]]; then
    target_basename="${name}${extension:+.$extension}"
  elif [[ $num -eq 1 ]]; then
    target_basename="${name}${sl_suffix}${extension:+.$extension}"
  elif [[ $num -ge 2 ]]; then
    target_basename="${name}${sl_suffix}${num:+ $num}${extension:+.$extension}"
  fi
  target_path="${dirname}/${target_basename}"
  echo "$target_path"
}

# if file exists, append string and numerical iterator
i=0
while [[ -e $(get_target_path "$i") || -L $(get_target_path "$i") ]] ; do
  let i++
done

target_path=$(get_target_path $i)
error_msg=$(ln -s "$source_path" "$target_path" 2>&1)
printf "${target_path}${error_msg:+\n$error_msg}"
