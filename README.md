ここではRIETIコラム「コロナ禍における人々の行動の変化のタイミング」で使われているデータとプログラムを公表している。プログラムはRを用いている。

## データについて
`data\`に本コラムで使用したデータの一部がある。

* `fies.csv`に総務省「家計調査」の日別支出のデータがある。このデータはe-Stat(https://www.e-stat.go.jp/) にある2000年以降の統計を元に作成した。

* Appleのモビリティデータはこのサイト(https://covid19.apple.com/mobility) よりダウンロードしたものを使った。`data\apple.csv`として保存するとプログラムのコードがそのまま使用可能になる。
* Googleのモビリティデータはコード内でこのurl(https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv) より直接ダウンロードされる

## コードについて
`code\`に本コラムで用いたコードがある。
* `preprocessing.R`
各データを推定のために加工するコード
* `estimation.R`推定を行うコード
* `figures.R`グラフを作るためのコード


## 推定モデルについて

推定に用いる統計モデルは以下の通りである。

<!-- \begin{align*}
&x_t = \mu (S_t)+ \sum_{i=1}^6 D_i (t) \phi_i + u_t\\
&\mu (1) = a, \mu(2) = b\\
&P(S_t=1|S_{t-1}=1) = \pi_{11}, P(S_t=2|S_{t-1}=1) = 1-\pi_{11}\\
&P(S_t=1|S_{t-1}=2) = 1-\pi_{22}, P(S_t=2|S_{t-1}=2) = \pi_{22}\\
&u_t ~ N(0, \sigma^2)
\end{align*} -->

![\begin{align*}
&x_t = \mu (S_t)+ \sum_{i=1}^6  \phi_i D_i (t) + u_t\\
&\mu (1) = a, \mu(2) = b\\
&P(S_t=1|S_{t-1}=1) = \pi_{11}, P(S_t=2|S_{t-1}=1) = 1-\pi_{11}\\
&P(S_t=1|S_{t-1}=2) = 1-\pi_{22}, P(S_t=2|S_{t-1}=2) = \pi_{22}\\
&u_t ~ N(0, \sigma^2)
\end{align*}](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%26x_t+%3D+%5Cmu+%28S_t%29%2B+%5Csum_%7Bi%3D1%7D%5E6++%5Cphi_i+D_i+%28t%29+%2B+u_t%5C%5C%0A%26%5Cmu+%281%29+%3D+a%2C+%5Cmu%282%29+%3D+b%5C%5C%0A%26P%28S_t%3D1%7CS_%7Bt-1%7D%3D1%29+%3D+%5Cpi_%7B11%7D%2C+P%28S_t%3D2%7CS_%7Bt-1%7D%3D1%29+%3D+1-%5Cpi_%7B11%7D%5C%5C%0A%26P%28S_t%3D1%7CS_%7Bt-1%7D%3D2%29+%3D+1-%5Cpi_%7B22%7D%2C+P%28S_t%3D2%7CS_%7Bt-1%7D%3D2%29+%3D+%5Cpi_%7B22%7D%5C%5C%0A%26u_t+%7E+N%280%2C+%5Csigma%5E2%29%0A%5Cend%7Balign%2A%7D)

ここで![x_t, S_t, D_i (t), u_t](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+x_t%2C+S_t%2C+%5Cphi+%28t%29%2C+u_t)がデータ、潜在的な状態、曜日のダミー変数、誤差項をそれぞれ表している。![a, b, \phi_i, \pi_{11}, \pi_{22}, \sigma](https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+a%2C+b%2C+%5Cphi_i%2C+%5Cpi_%7B11%7D%2C+%5Cpi_%7B22%7D%2C+%5Csigma)は最尤推定法によって推定を行う。
