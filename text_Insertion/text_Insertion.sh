#!/bin/bash
# 編集対象ファイル
target_file=${1}
# 文字入れ開始時間[秒],文字入れ終了時間[秒],挿入文字列の形式のファイル
time_lst="time.lst"
# カウント
count=0
# 変数work_folderに作業フォルダを設定する
work_folder=${2}
cd ${work_folder}

for line in `cat ${time_lst} | grep -v ^#`
do
    count=$(( count + 1 ))
    # 開始時間と終了時間と表示文字を取得
    start_time=`echo ${line} | cut -d , -f 1`
    end_time=`echo ${line} | cut -d , -f 2`
    messege=`echo ${line} | cut -d , -f 3`
    # 文字入れ処理
    ffmpeg -i ${target_file} -filter_complex "drawtext=fontfile=/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc:text=${messege}:x=(w-text_w)/2:y=(h-text_h)-10:fontsize=50:fontcolor=red:enable='between(t,${start_time},${end_time})'" ${count}_output_${target_file}
    # 編集後ファイルが存在していれば、編集前ファイルを削除
    if [ -e ${count}_output_${target_file} ]; then
        \rm -f ${tmp_file_lst}
    else
        # 失敗していたら、終了
        echo "文字入れに失敗しました"
        exit 1
    fi
    # 編集対象ファイルを更新
    target_file="${count}_output_${target_file}"
done
