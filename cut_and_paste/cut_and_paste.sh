#!/bin/bash

# ファイル存在チェック関数
file_exist_check(){
    file=${1}
    messege=${2}
    # 引数のファイルが存在しなければ終了
    if [ ! -e ${file} ]; then
        echo "${messege}"
        exit 1
    fi
}

# 編集対象ファイル
target_file=${1}
# 編集後ファイル名
output_file=${2}
# 変数work_folderに作業フォルダを設定する
work_folder=${3}
# 切り出し開始時間[秒],切り出し終了時間[秒]の形式のファイル
time_lst="time.lst"
# カウント
count=0
# 結合するファイルのリストを記述した一時ファイル
tmp_file_lst="tmp_file.txt"

cd ${work_folder}

for line in `cat ${time_lst} | grep -v ^#`
do
    count=$(( count + 1 ))
    # 開始時間と終了時間を取得
    start_time=`echo ${line} | cut -d , -f 1`
    end_time=`echo ${line} | cut -d , -f 2`
    # 切り出し処理
    ffmpeg -ss ${start_time} -i ${target_file} -t ${end_time} ${count}_output_${target_file}
    file_exist_check ${count}_output_${target_file} "切り出し処理に失敗しました"
    # ファイルのパスを追記
    echo "file '${count}_output_${target_file}'" >> ${tmp_file_lst}
done
# 切り出したものを結合する
ffmpeg -f concat -safe 0 -i ${tmp_file_lst} ${output_file}
file_exist_check ${output_file} "結合に失敗しました"
# 一時作業ファイルを削除
\rm ${tmp_file_lst}
\rm *_output_*
