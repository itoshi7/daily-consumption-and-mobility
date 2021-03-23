ここでは「RIETIコラムに寄贈された「」で使われているデータとプログラムを公表している。プログラムはRを使った。
以下に各

## データについて
`data\`に本コラムで使用したデータの一部がある。

* `fies.csv`に総務省「家計調査」の日別支出のデータがある。このデータはe-Stat(https://www.e-stat.go.jp/)にある2000年以降の統計を元に作成した。

* Appleのモビリティデータはこのサイト(https://covid19.apple.com/mobility)よりダウンロードしたものを使った。`data\apple.csv`として保存するとプログラムのコードがそのまま使用可能になる。
* Googleのモビリティデータはコード内でこのurl(https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv)より直接ダウンロードされる

## コードについて
`code\`に本コラムで用いたコードがある。
* `preprocessing.R`
各データを推定のために加工するコード
* `estimation.R`推定を行うコード
* `figures.R`グラフを作るためのコード


## 推定モデルについて
$ x_t $ 推定に用いる統計モデルは以下である。
