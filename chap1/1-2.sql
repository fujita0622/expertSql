演習問題1-2
次のようなクロス表を作ってください。

 性別 | 全国 | 徳島 | 香川 | 愛媛 | 高知 | 四国（再掲） 
------+------+------+------+------+------+--------------
 男   |  855 |   60 |  100 |  100 |  100 |          360
 女   |  845 |   40 |  100 |   50 |  100 |          290

「全国」は、テーブルに存在するデータ全ての合計人口。
「四国（再掲）」は、四国4県の合計値です。

PopTbl2テーブル
 pref_name | sex | population
-----------+-----+------------
 徳島      | 1   |         60
 徳島      | 2   |         40
 香川      | 1   |        100
 香川      | 2   |        100
 愛媛      | 1   |        100
 愛媛      | 2   |         50
 高知      | 1   |        100
 高知      | 2   |        100
 福岡      | 1   |        100
 福岡      | 2   |        200
 佐賀      | 1   |         20
 佐賀      | 2   |         80
 長崎      | 1   |        125
 長崎      | 2   |        125
 東京      | 1   |        250
 東京      | 2   |        150
(16 rows)


[回答]
SELECT 
  -- 性別の値が「1」の場合は「男」、「2」の場合は「女」、それ以外は「不明」に置換
  CASE sex
    WHEN '1' THEN '男'
    WHEN '2' THEN '女'
    ELSE '不明'
  END AS 性別,
  SUM(population) AS 全国, -- 全国の総人口
  SUM(CASE pref_name WHEN '徳島' THEN population ELSE 0 END) AS 徳島, -- 福島の人口
  SUM(CASE pref_name WHEN '香川' THEN population ELSE 0 END) AS 香川, -- 香川の人口
  SUM(CASE pref_name WHEN '愛媛' THEN population ELSE 0 END) AS 愛媛, -- 愛媛の人口
  SUM(CASE pref_name WHEN '高知' THEN population ELSE 0 END) AS 高知, -- 高知の人口
  -- 四国四県(徳島,香川,愛媛,高知)の人口(合計値)
  SUM(
    CASE pref_name 
      WHEN '徳島' THEN population
      WHEN '香川' THEN population
      WHEN '愛媛' THEN population
      WHEN '高知' THEN population
      ELSE 0
    END
  ) AS 四国（再掲）
FROM
  PopTbl2
-- 性別でグループ化
GROUP BY
  sex
-- 結果で「男」を行の上に表示させるため,性別を昇順で表示
ORDER BY
  sex ASC;

▪️出力結果
 性別 | 全国 | 徳島 | 香川 | 愛媛 | 高知 | 四国（再掲） 
------+------+------+------+------+------+--------------
 男   |  855 |   60 |  100 |  100 |  100 |          360
 女   |  845 |   40 |  100 |   50 |  100 |          290
(2 rows)
