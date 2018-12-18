演習問題1-1 下記テーブルから複数列の最大値を取得するにはどうすればよいでしょう。
●問1 x,yから最大値を取得
[問1.求める結果]
 key | greatest 
-----+----------
 A   |        2
 B   |        5
 C   |        7
 D   |        3

●問2 x,y,zから最大値を取得
[問2.求める結果]
 key | greatest 
-----+----------
 A   |        3
 B   |        5
 C   |        7
 D   |        8

greatestsテーブル
 key | x | y | z 
-----+---+---+---
 A   | 1 | 2 | 3
 B   | 5 | 5 | 2
 C   | 4 | 7 | 1
 D   | 3 | 3 | 8


[回答]
●問1
-- keyとxとyを比較した最大値を取得
SELECT 
  key,
CASE 
  -- xとyを比較した最大値の取得条件
  -- 条件1
  -- xがyより大きい場合,xのカラムを取得
  WHEN x > y THEN x
  -- 条件2
  -- yがxより大きい場合,yのカラムを取得
  WHEN x < y THEN y
-- 上記条件に該当しない場合
-- xのカラムを取得 
ELSE 
  x
-- xとyを比較した最大値の列名に greatest と命名
END AS greatest
-- greatestsテーブルから取得
FROM
  greatests
;


●問2
SELECT
  -- 取得列
  key, -- キー
  -- x,y,zの中の最大値
  CASE 
    -- 条件1
    -- x,y,zの中で最大値のカラムを取得
    WHEN x > y AND x > z THEN x
    WHEN y > x AND y > z THEN y
    WHEN z > x AND z > y THEN z
    -- 条件2
    -- x,y,zの中で二カラムの値が同じで かつ もう一カラムの値が低い場合
    -- 値が高いカラムのどちらかを取得
    WHEN x = y AND x > z THEN x
    WHEN x = z AND x > y THEN x
    WHEN y = z AND y > x THEN y
    -- 条件3
  -- 上記条件に該当しない場合
  -- 0を指定
  ELSE
    0
  -- x,y,zの中の最大値の列名に greatest と命名
  END AS greatest
-- greatestsテーブルから取得
FROM
  greatests
;


[出力結果]
●問1
export_sql=# SELECT 
export_sql-#   key,
export_sql-# CASE 
export_sql-#   WHEN x > y THEN x
export_sql-#   WHEN x < y THEN y
export_sql-# ELSE 
export_sql-#   x
export_sql-# END AS greatest
export_sql-# FROM
export_sql-#   greatests
export_sql-# ;
 key | greatest 
-----+----------
 A   |        2
 B   |        5
 C   |        7
 D   |        3
(4 rows)


●問2
export_sql=# SELECT
export_sql-#   -- 取得列
export_sql-#   key, -- キー
export_sql-#   -- x,y,zの中の最大値
export_sql-#   CASE 
export_sql-#     -- 条件1
export_sql-#     -- x,y,zの中で最大値のカラムを取得
export_sql-#     WHEN x > y AND x > z THEN x
export_sql-#     WHEN y > x AND y > z THEN y
export_sql-#     WHEN z > x AND z > y THEN z
export_sql-#     -- 条件2
export_sql-#     -- x,y,zの中で二カラムの値が同じで かつ もう一カラムの値が低い 場合
export_sql-#     -- 値が高いカラムのどちらかを取得
export_sql-#     WHEN x = y AND x > z THEN x
export_sql-#     WHEN x = z AND x > y THEN x
export_sql-#     WHEN y = z AND y > x THEN y
export_sql-#     -- 条件3
export_sql-#   -- 上記条件に該当しない場合
export_sql-#   -- 0を指定
export_sql-#   ELSE
export_sql-#     0
export_sql-#   -- x,y,zの中の最大値の列名に greatest と命名
export_sql-#   END AS greatest
export_sql-# -- greatestsテーブルから取得
export_sql-# FROM
export_sql-#   greatests
export_sql-# ;
 key | greatest 
-----+----------
 A   |        3
 B   |        5
 C   |        7
 D   |        8
(4 rows)