演習問題2-3
次のように、順位列が最初からテーブルに用意されているとします。

 district |  name  | price | ranking 
----------+--------+-------+---------
 東北     | みかん |   100 |        
 東北     | りんご |    50 |        
 東北     | ぶどう |    50 |        
 東北     | レモン |    30 |        
 関東     | レモン |   100 |        
 関東     | パイン |   100 |        
 関東     | りんご |   100 |        
 関東     | ぶどう |    70 |        
 関西     | レモン |    70 |        
 関西     | スイカ |    30 |        
 関西     | りんご |    20 |        

ただし、順位の初期値はオールNULLです。皆さんにやってほしいのは、この列に順位を入れることです。
この場合、自己結合を使うには何の問題もないのですが、OLAP関数を使おうとすると、ちょっとクリアすべき壁に突き当たります。

[回答(自己結合)]
UPDATE
  -- 自己結合で更新
  DistrictProducts2 AS DistrictProducts2_Main
-- 更新カラム
-- ランキング
SET ranking = 
  -- サブクエリ各地方ごとの金額の高い順のランキングを取得
  (SELECT
    -- Subテーブルの金額の数 +1
    -- 下記条件で絞り込んだランキング順の値が0から始まるので1加算する
    COUNT(DistrictProducts2_Sub.price) +1
  -- 自己結合のsubテーブルを定義
  FROM DistrictProducts2 AS DistrictProducts2_Sub
  -- 取得条件
  -- MainテーブルよりSubテーブルの金額が高いカラム
  -- 同内容の金額を比較し、Subテーブルの金額の大きいカラムのみ取得
  -- 上記SELECT句でSubテーブルの金額をカウントしてランキング順を決める
  WHERE DistrictProducts2_Sub.price > DistrictProducts2_Main.price
  -- 地方が同名のカラム
  -- 地方ごとでランキング付けしたいので地方のカラムが同名のカラムだけに絞る
  AND DistrictProducts2_Main.district = DistrictProducts2_Sub.district);

▪️出力結果
UPDATE 11
export_sql=# SELECT * FROM DistrictProducts2;
 district |  name  | price | ranking 
----------+--------+-------+---------
 東北     | みかん |   100 |       1
 東北     | りんご |    50 |       2
 東北     | ぶどう |    50 |       2
 東北     | レモン |    30 |       4
 関東     | レモン |   100 |       1
 関東     | パイン |   100 |       1
 関東     | りんご |   100 |       1
 関東     | ぶどう |    70 |       4
 関西     | レモン |    70 |       1
 関西     | スイカ |    30 |       2
 関西     | りんご |    20 |       3
(11 rows)


[回答(OLAP関数)]
-- RANK関数で更新
UPDATE 
-- DistrictProducts2のMainテーブルを定義
  DistrictProducts2 AS DistrictProducts2_Main
SET
-- 更新カラム
-- ランキング順位
  ranking = 
    (SELECT 
    -- サブクエリでFROM句内のサブクエリの結果のrankingカラムを取得
      DistrictProducts2_Sub.ranking
      -- サブクエリでDistrictProducts2テーブルから地域ごとの順位付けを行う
      FROM (SELECT 
              -- 取得列
              district, -- 地方
              name, -- 名前
              -- 地域別の金額が高い順のランキング
              -- PARTITION BYで地方ごとにわけ
              -- ORDER BY ~ DESC で金額ごとに順位付け
              RANK() OVER(PARTITION BY district ORDER BY price DESC) AS ranking
            FROM
              -- DistrictProducts2のSubテーブルを定義
              DistrictProducts2) AS DistrictProducts2_Sub
      -- 取得条件
      -- MainテーブルとSubテーブルの地方と金額がそれぞれ同じカラム
      WHERE 
        DistrictProducts2_Main.district = DistrictProducts2_Sub.district
      AND 
        DistrictProducts2_Main.name = DistrictProducts2_Sub.name);


▪️出力結果
UPDATE 11
 district |  name  | price | ranking 
----------+--------+-------+---------
 東北     | みかん |   100 |       1
 東北     | りんご |    50 |       2
 東北     | ぶどう |    50 |       2
 東北     | レモン |    30 |       4
 関東     | レモン |   100 |       1
 関東     | パイン |   100 |       1
 関東     | りんご |   100 |       1
 関東     | ぶどう |    70 |       4
 関西     | レモン |    70 |       1
 関西     | スイカ |    30 |       2
 関西     | りんご |    20 |       3
(11 rows)