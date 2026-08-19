# Müzik Veritabanı Projesi

Müzik verilerinin görselleştirilmesi ve temel bir müzik platformu arayüzünün oluşturulması amacıyla geliştirilmiş bir veritabanı ve web arayüzü projesidir.

Proje kapsamında veritabanı yapısı diyagram ile modellenmiş; sanatçı, albüm ve müzik içeriklerini temsil eden örnek HTML/CSS arayüzleri hazırlanmıştır.

## Özellikler

- Veritabanı yapısının diyagram ile modellenmesi
- Sanatçı ve albüm bilgilerinin arayüz üzerinde gösterilmesi
- Müzik ana sayfası tasarımı
- Albüm detay sayfası
- HTML ve CSS ile kullanıcı arayüzü geliştirme

## Kullanılan Teknolojiler

- HTML5
- CSS3
- JavaScript
- Draw.io

## Proje Dosyaları

- `index.html` — Müzik platformunun ana sayfası
- `album-detail.html` — Albüm detay sayfası
- `music-database.html` — Müzik veritabanı arayüzü
- `database-diagram.html` — Veritabanı diyagramı


## Projenin Amacı

Bu proje, Veritabanı Sistemleri dersi kapsamında veritabanı modelleme yaklaşımını web arayüzü tasarımıyla birleştirmek amacıyla hazırlanmıştır.

## Canlı Demo

Projenin GitHub Pages üzerinden yayınlanan sürümüne aşağıdaki bağlantıdan ulaşabilirsiniz:

[Canlı Projeyi Görüntüle](https://ilyda-gkhn.github.io/muzik-veritabani-projesi/)

## SQL Server veritabanı

Projenin ilişkisel veritabanı yapısı [`music-platform-database.sql`](music-platform-database.sql) dosyasında yer almaktadır.

SQL betiği aşağıdaki yapıları içerir:

- Türler, sanatçılar, kullanıcılar, albümler ve şarkılar
- Kullanıcı çalma listeleri ve liste-şarkı ilişkileri
- Sanatçı-şarkı, kullanıcı-dinleme ve kullanıcı-takip ilişkileri
- 10 tablo ve tablolar arasındaki yabancı anahtar bağlantıları
- Birincil anahtar, benzersizlik ve veri doğrulama kısıtları
- Örnek veriler ve ilişkileri gösteren örnek sorgu

### Çalıştırma

1. Microsoft SQL Server Management Studio'yu açın.
2. `music-platform-database.sql` dosyasını çalıştırın.
3. Betik `MuzikPlatformuDB` veritabanını, tabloları ve örnek verileri oluşturacaktır.

> Güvenlik: Betik mevcut bir veritabanını silmez. `MuzikPlatformuDB` zaten varsa veri kaybını önlemek için işlemi durdurur.
