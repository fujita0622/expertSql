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
SELECT 
  key,
CASE 
  -- 取得条件
  -- 条件1
  -- xがより大きい場合,xのカラムを取得
  WHEN x > y THEN x
  -- 条件2
  -- xがより大きい場合,xのカラムを取得
  WHEN x < y THEN y
-- 条件2
-- 上記条件に該当しない場合
-- xのカラムを取得 
ELSE 
  x
END AS greatest
FROM
  greatests
;

●問2
SELECT
  key,
CASE 
  WHEN x > y THEN CASE WHEN x > z THEN x ELSE x END
  WHEN y > x THEN CASE WHEN y > z THEN y ELSE x END
  WHEN z > x THEN CASE WHEN z > y THEN z ELSE x END
ELSE 
  x
END AS greatest
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
