演習問題2-2
「地方」列をつけ加えたテーブルを用意して、地域ごとにランキングを求めてみましょう。
値段が高い順にランキングにして、同順位が続いたら順位を飛び石にします。
結果は次のようになります。

 district |  name  | price | rank_1 
----------+--------+-------+--------
 東北     | みかん |   100 |      1
 東北     | りんご |    50 |      2
 東北     | ぶどう |    50 |      2
 東北     | レモン |    30 |      4
 関東     | レモン |   100 |      1
 関東     | パイン |   100 |      1
 関東     | りんご |   100 |      1
 関東     | ぶどう |    70 |      4
 関西     | レモン |    70 |      1
 関西     | スイカ |    30 |      2
 関西     | りんご |    20 |      3

解き方はOLAP関数と自己結合の二通りがあります(スカラ・サブクエリと結合を別回答と考えれば3通り)。
それぞれ考えてみてください。


DistrictProductsテーブル
 district |  name  | price 
----------+--------+-------
 東北     | みかん |   100
 東北     | りんご |    50
 東北     | ぶどう |    50
 東北     | レモン |    30
 関東     | レモン |   100
 関東     | パイン |   100
 関東     | りんご |   100
 関東     | ぶどう |    70
 関西     | レモン |    70
 関西     | スイカ |    30
 関西     | りんご |    20
(11 rows)


[回答.1(OLAP関数)]
SELECT
-- 取得列
  district, -- 地方
  name,     -- 名称
  price,    -- 金額
  -- 値段が高い順でランキング
  -- RANK関数なので同順位が続いた場合は順位は飛び石になる
  -- PARTITION BYで地方ごとにランク付け
  RANK() OVER(PARTITION BY district ORDER BY price DESC) AS rank_1
FROM
  DistrictProducts
;

▪️出力結果
 district |  name  | price | rank_1 
----------+--------+-------+--------
 東北     | みかん |   100 |      1
 東北     | りんご |    50 |      2
 東北     | ぶどう |    50 |      2
 東北     | レモン |    30 |      4
 関東     | レモン |   100 |      1
 関東     | パイン |   100 |      1
 関東     | りんご |   100 |      1
 関東     | ぶどう |    70 |      4
 関西     | レモン |    70 |      1
 関西     | スイカ |    30 |      2
 関西     | りんご |    20 |      3
(11 rows)


[回答.2(自己結合)]
SELECT
  -- 取得列
  Products_Main.district, -- 地方
  Products_Main.name, -- 名称
  Products_Main.price, -- 金額
  -- 地域別に値段が高い順のランキングを取得するサブクエリ
  (SELECT
    COUNT(Products_Sub.price) -- Products_Subテーブルの金額数の合計値
  FROM
    DistrictProducts AS Products_Sub
  -- 取得条件
  WHERE
    -- MainテーブルよりSubテーブルの金額が高いカラム でかつ
    Products_Main.price < Products_Sub.price
  AND
    -- MainテーブルとSubテーブルの地域が同じカラム
    Products_Main.district = Products_Sub.district)
  -- 各地方の金額の最上位が0から始まるので ランキングが1位始まるようにカラムに1加算する
  +1 AS rank_1
FROM
  DistrictProducts AS Products_Main
;

▪️出力結果
 district |  name  | price | rank_1 
----------+--------+-------+--------
 東北     | みかん |   100 |      1
 東北     | りんご |    50 |      2
 東北     | ぶどう |    50 |      2
 東北     | レモン |    30 |      4
 関東     | レモン |   100 |      1
 関東     | パイン |   100 |      1
 関東     | りんご |   100 |      1
 関東     | ぶどう |    70 |      4
 関西     | レモン |    70 |      1
 関西     | スイカ |    30 |      2
 関西     | りんご |    20 |      3
(11 rows)


[回答.3(外部結合)]
SELECT
  -- 取得列
  Products_Main.district, -- 地方
  Products_Main.name, -- 名称
  Products_Main.price, -- 金額
  COUNT(Products_Sub.price) +1 AS rank_1 -- 地方ごとに金額が大きい順のランキング
FROM
-- DistrictProductsを自己結合
-- MainテーブルにSubテーブルを結合する
  DistrictProducts AS Products_Main
LEFT JOIN
  DistrictProducts AS Products_Sub
-- 結合条件
ON
-- MainテーブルよりSubテーブルの金額が高いカラム
  Products_Main.price < Products_Sub.price
AND
-- MainテーブルとSubテーブルの地方が同じカラム
  Products_Main.district = Products_Sub.district
-- グループ化
GROUP BY
  Products_Main.district, -- Mainテーブルの地方
  Products_Main.name -- Mainテーブルの名称
-- ソート条件
ORDER BY
  -- Mainテーブルの地方を昇順 漢字の音読み順ではなく文字コード順に昇順
  -- ※問題の回答結果に並び順を合わせるため条件指定
  Products_Main.district ASC
  -- Mainテーブルの金額が高い順
  Products_Main.price DESC
;

▪️出力結果
 district |  name  | price | rank_1 
----------+--------+-------+--------
 東北     | みかん |   100 |      1
 東北     | ぶどう |    50 |      2
 東北     | りんご |    50 |      2
 東北     | レモン |    30 |      4
 関東     | りんご |   100 |      1
 関東     | レモン |   100 |      1
 関東     | パイン |   100 |      1
 関東     | ぶどう |    70 |      4
 関西     | レモン |    70 |      1
 関西     | スイカ |    30 |      2
 関西     | りんご |    20 |      3
(11 rows)