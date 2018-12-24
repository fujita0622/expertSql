演習問題4-3
Itemsテーブルの品物を全て揃えていなかった店舗について「どのくらいの品物が不足していたのか」を一覧表示したい。
my_item_cntが店舗の現在の在庫数、diff_cntは、足りなかった商品の数を表します。

問題の回答結果
shop | my_item_cnt | diff_cnt 
------+-------------+----------
 東京 |           3 |        0
 大阪 |           2 |        1
 仙台 |           3 |        0

Itemsテーブル
   item   
----------
 ビール
 紙オムツ
 自転車

ShopItemsテーブル
 shop |   item   
------+----------
 仙台 | ビール
 仙台 | 紙オムツ
 仙台 | 自転車
 仙台 | カーテン
 東京 | ビール
 東京 | 紙オムツ
 東京 | 自転車
 大阪 | テレビ
 大阪 | 紙オムツ
 大阪 | 自転車


[回答]
SELECT
  -- 取得列
  ShopItems.shop, -- 店舗(都道府県)
  COUNT(Items.item) AS my_item_cnt, -- 店舗の商品数の合計(商品マスターと一致する商品のみ)
  -- サブクエリで商品マスターの商品数を取得して店舗の商品数の合計を減算し足りない商品数を算出
  ((SELECT COUNT(item) FROM Items) - COUNT(Items.item)) AS diff_cnt -- 足りない商品数
FROM
-- 店舗商品テーブルに商品マスターを外部結合
  ShopItems
LEFT JOIN
  Items
ON
-- 結合条件
-- 商品マスターと店舗の商品が一致する商品
  ShopItems.item = Items.item
-- 店舗(都道府県)をグループ化
GROUP BY
  ShopItems.shop
;

[️実行結果]
 shop | my_item_cnt | diff_cnt 
------+-------------+----------
 東京 |           3 |        0
 仙台 |           3 |        0
 大阪 |           2 |        1
(3 rows)