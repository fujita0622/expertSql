演習問題2-1 
Productsテーブルを使って、2列の重複組合せを求めてください。

Productsテーブル
  name  | price 
--------+-------
 りんご |   100
 みかん |    50
 バナナ |    80
(3 rows)

結果が次のようになります。
 name_1 | name_2
--------+--------
 バナナ | みかん
 バナナ | りんご
 バナナ | バナナ
 りんご | みかん
 りんご | りんご
 みかん | みかん

(バナナ,みかん)と(みかん,バナナ)のような順序を入れ替えただけのペアは同じとみなしますが、
重複を許すので(みかん,みかん)のようなペアも現れます。


[回答]
▪SQL
-- Productsテーブル1のname
-- Productsテーブル2のname
SELECT
  P1.name AS name_1,P2.name AS name_2
-- Productsテーブルを自己結合
-- Productsテーブル1とProductsテーブル2を結合
FROM
  Products AS P1,Products AS P2
-- カラム取得条件
-- ソート順でname1が早い場合 または
-- nameの値が同じ
WHERE
  P1.name > P2.name
OR
  P1.name = P2.name
-- 文字列のソート
-- Productsテーブル1 降順 順序：カタカナ,ひらがな,ローマ字 五十音順:後ろから
-- Productsテーブル1 昇順 順序：ローマ字 ひらがな,カタカナ 五十音順:前から
ORDER BY
  P1.name DESC, P2.name ASC;


▪️実行結果
 name_1 | name_2 
--------+--------
 バナナ | みかん
 バナナ | りんご
 バナナ | バナナ
 りんご | みかん
 りんご | りんご
 みかん | みかん
(6 rows)