# Online Retail CRM Analytics & Sales Forecasting

Bu proje, Online Retail II veri seti kullanılarak uçtan uca veri analitiği, müşteri segmentasyonu ve satış tahminlemesi süreçlerini kapsar. Projede veritabanı yönetimi ve manipülasyonu için **SQL**, ileri seviye makine öğrenmesi ve istatistiksel modellemeler için **Python** kullanılmıştır.

## Proje İçeriği

Bu repo iki ana bölümden oluşmaktadır:

### 1. SQL ile Veri Analizi ve Manipülasyon (`ONLINE RETAIL.sql`)
Veri tabanı seviyesinde gerçekleştirilen işlemler:
* **Veri Temizleme:** İadelerin (Invoice 'C' ile başlayanlar) ve eksik müşteri ID'lerinin temizlenmesi.
* **View Oluşturma:** Analizler için temizlenmiş veri tablolarının (Views) oluşturulması.
* **RFM Analizi:** Recency, Frequency ve Monetary metriklerine göre müşterilerin segmentlere ayrılması (Champions, Loyal, Hibernating vb.).
* **Pareto Analizi:** Ürünlerin kümülatif ciro katkısının hesaplanması (80/20 kuralı).
* **İade Analizi:** En çok iade edilen ürünlerin tespiti.

### 2. Python ile İleri Seviye Analitik (`ONLINE RETAIL PYTHON.ipynb`)
SQL Server'dan çekilen veri üzerinde yapılan modellemeler:
* **Birliktelik Kuralı Madenciliği (Association Rules):** Apriori ve FP-Growth algoritmaları ile ürün öneri sistemi ("Bunu alan bunu da aldı").
* **CLTV Tahmini:** BG/NBD ve Gamma-Gamma modelleri ile Müşteri Yaşam Boyu Değeri (Customer Lifetime Value) tahmini ve 6 aylık projeksiyon.
* **Churn Tahmini:** Random Forest Classifier kullanılarak müşterilerin terk etme olasılıklarının hesaplanması.
* **Zaman Serisi Analizi:** Facebook Prophet kütüphanesi ile haftalık satış tahminlemesi.

## Kullanılan Teknolojiler ve Kütüphaneler

* **Veritabanı:** MS SQL Server
* **Diller:** MSSQL, Python
* **Python Kütüphaneleri:**
    * `pandas`, `numpy` (Veri İşleme)
    * `sqlalchemy`, `pyodbc` (Veritabanı Bağlantısı)
    * `mlxtend` (Apriori & Birliktelik Kuralları)
    * `lifetimes` (CLTV - BG/NBD & Gamma-Gamma)
    * `sklearn` (Random Forest - Churn Prediction)
    * `prophet` (Zaman Serisi Tahminlemesi)

## Öne Çıkan Sonuçlar

* Müşteriler, satın alma alışkanlıklarına göre başarıyla segmentlere ayrıldı ve SQL veritabanına `Dim_Customer_CLTV` olarak kaydedildi.
* Satış verileri Prophet modeli ile analiz edilerek gelecek 26 haftanın satış tahminleri oluşturuldu (`Tbl_Py_Satis_Tahmin_Haftalik`).
* Churn riski taşıyan müşteriler %90 eşik değeri ile belirlendi.

*Bu proje, veri bilimi ve CRM analitiği yetkinliklerini sergilemek amacıyla hazırlanmıştır.*
