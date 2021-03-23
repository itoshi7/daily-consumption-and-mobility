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

推定に用いる統計モデルは以下である。

<!-- $$
x_t = \mu (S_t) + u_t
$$ --> 

<div align="center"><img style="background: white;" src="https://render.githubusercontent.com/render/math?math=x_t%20%3D%20%5Cmu%20(S_t)%20%2B%20u_t%0D"></div>

<!-- $$
\mu (1) = a, \mu(2) = b,
$$ --> 

<div align="center"><img style="background: white;" src="https://render.githubusercontent.com/render/math?math=%5Cmu%20(1)%20%3D%20a%2C%20%5Cmu(2)%20%3D%20b%2C%0D"></div>

$$
P(S_t=1|S_t=1) = \pi_{11}, P(S_t=2|S_t=1) = 1-\pi_{11},$$ 

$$
P(S_t=1|S_t=2) = 1-\pi_{22}, P(S_t=2|S_t=2) = 1-\pi_{22}
$$

\begin{align*}
x_t = \mu (S_t) + u_t\\
\end{align*}

![\begin{align*}
x_t &= \mu (S_t) + u_t\\
\end{align*}](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0Ax_t+%26%3D+%5Cmu+%28S_t%29+%2B+u_t%5C%5C%0A%5Cend%7Balign%2A%7D)

aaa


