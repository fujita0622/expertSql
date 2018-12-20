演習問題1-3
演習問題1-1のGreatestsテーブルのkeyカラムを「B-A-D-C」の順番に並び替えるクエリを考えてください。
また、他の適当な順番でも試してみてください。

greatestsテーブル
 key | x | y | z 
-----+---+---+---
 A   | 1 | 2 | 3
 B   | 5 | 5 | 2
 C   | 4 | 7 | 1
 D   | 3 | 3 | 8
(4 rows)

[回答.1]
-- 取得カラム：全て
SELECT
  *
FROM
-- 取得対象テーブル:greatests
  greatests
ORDER BY
-- ソート順位:keyの値が「B-A-D-C」の順
  CASE key
    WHEN 'B' THEN 1
    WHEN 'A' THEN 2
    WHEN 'D' THEN 3
    WHEN 'C' THEN 4
    ELSE 5
  END, key;

▪️出力結果
 key | x | y | z 
-----+---+---+---
 B   | 5 | 5 | 2
 A   | 1 | 2 | 3
 D   | 3 | 3 | 8
 C   | 4 | 7 | 1
(4 rows)

[回答.2]
並び順：「D-B-C-A」
-- 取得カラム：全て
SELECT
  *
FROM
-- 取得対象テーブル:greatests
  greatests
ORDER BY
-- ソート順位:keyの値が「D-B-C-A」の順
  CASE key
    WHEN 'D' THEN 1
    WHEN 'B' THEN 2
    WHEN 'C' THEN 3
    WHEN 'A' THEN 4
    ELSE 5
  END, key;

▪️出力結果
 key | x | y | z 
-----+---+---+---
 D   | 3 | 3 | 8
 B   | 5 | 5 | 2
 C   | 4 | 7 | 1
 A   | 1 | 2 | 3
(4 rows)