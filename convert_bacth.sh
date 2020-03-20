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

# 結合対象フォルダ
target_folda=${1}
# 変数work_folderに作業フォルダを設定する
work_folder=${2}
cd ${work_folder}
# 結合後ファイル
output_file=${3}
# ファイル一覧
file_lst="files.txt"
# ファイルリスト作成
find ${target_folda} -type f | sort | perl -pe 's/^/file '\''/g' | perl -pe 's/mp4$/mp4'\''/g' > ${file_lst}
# フォルダ内のファイルを全て結合
ffmpeg -f concat -safe 0 -i ${file_lst} ${output_file}
file_exist_check ${output_file} "結合に失敗しました"

