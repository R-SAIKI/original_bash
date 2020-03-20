#!/bin/bash

# ファイル存在チェック関数
file_check(){
    input_file=${1}
    output_file=${2}
    messege=${3}
    # 編集後ファイルが存在していれば、編集前ファイルを削除
    if [ -e ${output_file} ]; then
        \rm ${input_file}
    else
        # 失敗していたら、終了
        echo ${messege}
        exit 1
    fi
}

# 対象のフォルダパス
folda_path=${1}
# 対象のフォルダに移動
cd ${folda_path}
# ファイル名から空白とアポストロフィを削除
find . -name "*" | rename 's/ /_/g'
find . -name "*" | rename "s/'//g"
# フォルダ内の全てのmp4ファイルを処理する
for file in `\find . -name '*.mp4'`; do
    output_file="${file}_output.mp4"
    # ボリューム設定（倍率）
    ffmpeg -i ${file} -vcodec copy -af "volume=4.0" ${output_file}
    file_check ${file} ${output_file} "音量上げに失敗しました"
    \rm -f ${file}
    input_file=${output_file}
    output_file="${output_file}_output.mp4"
    # ノーマライズ処理
    ffmpeg -i ${input_file} -af dynaudnorm ${output_file}
    file_check ${input_file} ${output_file} "ノーマライズに失敗しました"
    \rm -f ${input_file}
done

