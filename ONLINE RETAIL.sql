
SELECT @@SERVERNAME;
SELECT DB_NAME();


--1.ADIM VERÝYÝ ÝNCELEME
SELECT * FROM [dbo].[online_retail_II]
SELECT COUNT(*) FROM Vw_Clean_Data;


SELECT* FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'online_retail_II'
--2.ADIM VERÝYÝ DÜZENLEME
ALTER TABLE  [dbo].[online_retail_II]
ALTER COLUMN Quantity INT
ALTER TABLE  [dbo].[online_retail_II]
ALTER COLUMN InvoiceDate DATETIME
ALTER TABLE  [dbo].[online_retail_II]
ALTER COLUMN Price DECIMAL(10,2)
ALTER TABLE  [dbo].[online_retail_II]
ALTER COLUMN Customer ID DECIMAL(10,2)

-- Ýadeleri ve Hatalý Kayýtlarý Temizleyerek 
CREATE VIEW Vw_Clean_Data AS
SELECT *,(Quantity*Price) as TotalPrice FROM online_retail_II
WHERE Invoice NOT LIKE 'C%' 
AND Price > 0
AND Quantity > 0
AND Description IS NOT NULL
AND ([Customer ID] IS NOT NULL AND 
[Customer ID] != '')

SELECT * FROM Vw_Clean_Data


--VERIYI ANLAMA
SELECT StockCode, MAX(Description) AS urun_adi ,SUM(TotalPrice) AS Toplam_Ciro, SUM(Quantity) as urun_sayisi
FROM Vw_Clean_Data
GROUP BY StockCode
ORDER BY Toplam_Ciro DESC

--ÜLKELERE GÖRE ANALÝZ
SELECT Country,SUM(TotalPrice) AS Toplam_Ciro
FROM Vw_Clean_Data
GROUP BY Country
ORDER BY Toplam_Ciro DESC

SELECT Country,COUNT(COUNTRY) AS SAYI
FROM Vw_Clean_Data
GROUP BY Country
ORDER BY SAYI DESC 


--PARETO ANALIZI
ALTER VIEW Vw_ParetoAnalysis AS 
WITH urun_ozet AS (
    SELECT StockCode, MAX(Description) as urun_adi,SUM(TotalPrice) as ToplamCiro
    FROM Vw_Clean_Data
    GROUP BY StockCode 
)
SELECT urun_adi,ToplamCiro, 
SUM(ToplamCiro) OVER (ORDER BY ToplamCiro DESC) as Kumulatif_Ciro,
SUM(ToplamCiro) OVER (ORDER BY ToplamCiro DESC) / SUM(ToplamCiro) OVER () AS KumulatifYüzde,
ToplamCiro/SUM(ToplamCiro) OVER () AS UrunTekilPay
FROM urun_ozet;

SELECT * FROM Vw_ParetoAnalysis

-- RFM Metriklerini Hesaplama (BUGÜNÜ 2012-01-01 olarak kabul edelim)

CREATE VIEW Vw_RFM_Analysis AS 
WITH RFM_Metrics AS (
    SELECT [Customer ID],DATEDIFF(day,MAX(InvoiceDate),'2012-01-01') AS RECENCY,
            COUNT(DISTINCT(Invoice)) AS FREQUENCY,
            SUM (TotalPrice) AS MONETARY
    FROM Vw_Clean_Data
    GROUP BY [Customer ID]),

RFM_Scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY RECENCY DESC) AS RECENCY_SCORE,
        NTILE(5) OVER (ORDER BY FREQUENCY ASC) AS FREQUENCY_SCORE,
        NTILE(5) OVER (ORDER BY MONETARY ASC) AS MONETARY_SCORE
    FROM RFM_Metrics)

    SELECT 
    *,
        (CAST(RECENCY_SCORE AS varchar) + CAST(FREQUENCY_SCORE AS varchar)) AS RF_SCORE,
        CASE
            WHEN RECENCY_SCORE = 5 AND FREQUENCY_SCORE BETWEEN 4 AND 5 THEN 'CHAMPIONS'
            WHEN RECENCY_SCORE BETWEEN 3 AND 4 AND FREQUENCY_SCORE BETWEEN 4 AND 5 THEN 'LOYAL CUSTOMERS'
            WHEN RECENCY_SCORE BETWEEN 4 AND 5 AND FREQUENCY_SCORE BETWEEN 2 AND 3 THEN 'POTENTIAL LOYALISTS'
            WHEN RECENCY_SCORE = 5 AND FREQUENCY_SCORE = 1 THEN 'NEW CUSTOMERS'
            WHEN RECENCY_SCORE = 4 AND FREQUENCY_SCORE = 1 THEN 'PROMISING'
            WHEN RECENCY_SCORE = 3 AND FREQUENCY_SCORE = 3 THEN 'NEED ATTENTION'
            WHEN RECENCY_SCORE = 3 AND FREQUENCY_SCORE BETWEEN 1 AND 2 THEN 'ABOUT TO SLEEP'
            WHEN RECENCY_SCORE BETWEEN 1 AND 2 AND FREQUENCY_SCORE BETWEEN 3 AND 4 THEN 'AT RISK'
            WHEN RECENCY_SCORE BETWEEN 1 AND 2 AND FREQUENCY_SCORE = 5 THEN 'CANT LOOSE'
            WHEN RECENCY_SCORE BETWEEN 1 AND 2 AND FREQUENCY_SCORE BETWEEN 1 AND 2 THEN 'HIBERNATING'
            ELSE 'Others'
        END AS SEGMENTS
    FROM RFM_Scores;

    --SEGMENTLERÝ GRUPLAMA
    SELECT SEGMENTS,AVG(MONETARY) AS ORT_HARCAMA FROM Vw_RFM_Analysis
    GROUP BY SEGMENTS
    ORDER BY ORT_HARCAMA DESC;

    --IADE ANALIZI--
    SELECT * FROM online_retail_II

    CREATE VIEW VW_iade_analizi AS (
    SELECT * FROM online_retail_II
    WHERE Invoice LIKE 'C%' 
    AND [Customer ID] IS NOT NULL)

    --En çok iade edilen ürünler--
    SELECT TOP 10  StockCode,MAX(Description),SUM(Quantity) AS UrunAdet,SUM(Quantity*Price) AS TotalPrice 
    FROM VW_iade_analizi
    GROUP BY StockCode
    ORDER BY UrunAdet DESC;
    -- ZAMAN SERÝSÝ ANALÝZÝ
    CREATE VIEW Vw_zaman_analizi2 AS
    SELECT
        DATEPART(YEAR,InvoiceDate) AS Yýl,
        DATEPART(HOUR,InvoiceDate) AS Saat,
        DATEPART(WEEKDAY, InvoiceDate) AS Gun_No,
        DATENAME(WEEKDAY,InvoiceDate) AS Gun,
        DATENAME(MONTH,InvoiceDate) AS Ay,
        MONTH(InvoiceDate) AS Ay_No,
        COUNT(DISTINCT(Invoice)) AS Siparis_Sayisi,
        SUM(TotalPrice) AS ToplamCiro
    FROM Vw_Clean_Data
    GROUP BY 
    DATEPART(YEAR,InvoiceDate),
    DATEPART(HOUR,InvoiceDate),
    DATENAME(WEEKDAY,InvoiceDate),
    DATEPART(WEEKDAY, InvoiceDate),
    DATENAME(MONTH,InvoiceDate),
    MONTH(InvoiceDate) 

    SELECT * FROM Vw_zaman_analizi2
    ORDER BY ToplamCiro DESC

    SELECT *FROM dbo.Fact_ProductReco



