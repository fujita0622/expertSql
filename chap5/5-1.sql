演習問題5-1
下記SQL文では、集約してDATAビューとMASTERビューの対応を一対一にしてから結合を行いました。
これはわかりやすい方法ですが、パフォーマンスを考慮するならば中間ビューを二つ作るのは無駄が多い方法です。
この中間ビューを減らすようにコードを改良してください。

SQL文
SELECT
  MASTER.age_class AS age_class,
  MASTER.sex_cd AS sex_cd,
  DATA.pop_tohoku AS pop_tohoku,
  DATA.pop_kanto AS pop_kanto
FROM
  (SELECT age_class, sex_cd FROM TblAge CROSS JOIN TblSex) AS MASTER
LEFT OUTER JOIN
  (SELECT age_class, sex_cd,
    SUM(CASE WHEN pref_name IN ('秋田','青森') THEN population ELSE NULL END) AS pop_tohoku,
    SUM(CASE WHEN pref_name IN ('東京','千葉') THEN population ELSE NULL END) AS pop_kanto
   FROM
    TblPop
   GROUP BY
    age_class, sex_cd) AS DATA
ON
  MASTER.age_class = DATA.age_class
AND
  MASTER.sex_cd = DATA.sex_cd
;

出力結果
 age_class | sex_cd | pop_tohoku | pop_kanto 
-----------+--------+------------+-----------
 1         | m      |       1100 |      1800
 1         | f      |       1300 |      2500
 2         | m      |            |          
 2         | f      |            |          
 3         | m      |       1000 |          
 3         | f      |       1800 |      2100

TblAgeテーブル
 age_class | age_range 
-----------+-----------
 1         | 21～30歳
 2         | 31～40歳
 3         | 41～50歳

TblSexテーブル
 sex_cd | sex 
--------+-----
 m      | 男
 f      | 女

TblPop
 pref_name | age_class | sex_cd | population 
-----------+-----------+--------+------------
 秋田      | 1         | m      |        400
 秋田      | 3         | m      |       1000
 秋田      | 1         | f      |        800
 秋田      | 3         | f      |       1000
 青森      | 1         | m      |        700
 青森      | 1         | f      |        500
 青森      | 3         | f      |        800
 東京      | 1         | m      |        900
 東京      | 1         | f      |       1500
 東京      | 3         | f      |       1200
 千葉      | 1         | m      |        900
 千葉      | 1         | f      |       1000
 千葉      | 3         | f      |        900


[回答]
-- MASTERテーブル = TblAgeテーブルとTblSexテーブルをクロス結合したテーブル(年代と性別のマスターデータ)
-- DATAテーブル   = TblPopテーブル
SELECT
  MASTER.age_class AS age_class, -- MASTERテーブルの年代ID
  MASTER.sex_cd AS sex_cd, -- MASTERテーブルの性別ID
  SUM(CASE WHEN DATA.pref_name IN ('秋田','青森') THEN DATA.population ELSE NULL END) AS pop_tohoku, -- DATAテーブルの東北地方の総人口
  SUM(CASE WHEN DATA.pref_name IN ('東京','千葉') THEN DATA.population ELSE NULL END) AS pop_kanto -- DATAテーブルの関東地方の総人口
FROM
  -- MASTERテーブルの生成
  (SELECT
    age_class, -- 年代ID
    sex_cd  -- 性別ID
   -- 年代テーブルと性別テーブルをクロス結合
   FROM
    TblAge
   CROSS JOIN
    TblSex) AS MASTER
-- MASTERテーブルにDATAテーブルを外部結合
LEFT JOIN
  TblPop AS DATA
-- 結合条件
-- MASTERとDATAの年代IDが一致したカラム
ON
  MASTER.age_class = DATA.age_class
-- MASTERとDATAの性別IDが一致したカラム
AND
  MASTER.sex_cd = DATA.sex_cd
-- グループ化
GROUP BY
  MASTER.age_class, -- MASTERテーブルの年代ID
  MASTER.sex_cd -- MASTERテーブルの性別ID
;

[出力結果]
 age_class | sex_cd | pop_tohoku | pop_kanto 
-----------+--------+------------+-----------
 1         | f      |       1300 |      2500
 1         | m      |       1100 |      1800
 2         | f      |            |          
 2         | m      |            |          
 3         | f      |       1800 |      2100
 3         | m      |       1000 |          
(6 rows)