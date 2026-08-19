/*
  Müzik Platformu Veritabanı
  Microsoft SQL Server için şema ve örnek veri betiği.

  Güvenlik notu:
  - Betik mevcut bir veritabanını veya tabloyu silmez.
  - Yalnızca MuzikPlatformuDB henüz yoksa çalıştırılmalıdır.
*/

USE master;
GO

IF DB_ID(N'MuzikPlatformuDB') IS NOT NULL
BEGIN
    THROW 50000, N'MuzikPlatformuDB zaten mevcut. Veri kaybını önlemek için işlem durduruldu.', 1;
END;
GO

CREATE DATABASE MuzikPlatformuDB;
GO

USE MuzikPlatformuDB;
GO

CREATE TABLE dbo.Turler (
    TurID INT IDENTITY(1,1) NOT NULL,
    Ad NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Turler PRIMARY KEY (TurID),
    CONSTRAINT UQ_Turler_Ad UNIQUE (Ad)
);

CREATE TABLE dbo.Sanatcilar (
    SanatciID INT IDENTITY(1,1) NOT NULL,
    AdSoyad NVARCHAR(150) NOT NULL,
    Ulke NVARCHAR(80) NOT NULL,
    DogumTarihi DATE NULL,
    CONSTRAINT PK_Sanatcilar PRIMARY KEY (SanatciID)
);

CREATE TABLE dbo.Kullanicilar (
    KullaniciID INT IDENTITY(1,1) NOT NULL,
    AdSoyad NVARCHAR(150) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    SifreHash VARBINARY(64) NOT NULL,
    KayitTarihi DATE NOT NULL CONSTRAINT DF_Kullanicilar_KayitTarihi DEFAULT (CONVERT(date, GETDATE())),
    PremiumMu BIT NOT NULL CONSTRAINT DF_Kullanicilar_PremiumMu DEFAULT (0),
    CONSTRAINT PK_Kullanicilar PRIMARY KEY (KullaniciID),
    CONSTRAINT UQ_Kullanicilar_Email UNIQUE (Email)
);

CREATE TABLE dbo.Albumler (
    AlbumID INT IDENTITY(1,1) NOT NULL,
    AlbumAdi NVARCHAR(200) NOT NULL,
    SanatciID INT NOT NULL,
    CONSTRAINT PK_Albumler PRIMARY KEY (AlbumID),
    CONSTRAINT FK_Albumler_Sanatcilar FOREIGN KEY (SanatciID)
        REFERENCES dbo.Sanatcilar (SanatciID)
);

CREATE TABLE dbo.Sarkilar (
    SarkiID INT IDENTITY(1,1) NOT NULL,
    SarkiAdi NVARCHAR(200) NOT NULL,
    SureSaniye INT NOT NULL,
    YayinTarihi DATE NOT NULL,
    TurID INT NOT NULL,
    AlbumID INT NOT NULL,
    CONSTRAINT PK_Sarkilar PRIMARY KEY (SarkiID),
    CONSTRAINT CK_Sarkilar_SureSaniye CHECK (SureSaniye > 0),
    CONSTRAINT FK_Sarkilar_Turler FOREIGN KEY (TurID)
        REFERENCES dbo.Turler (TurID),
    CONSTRAINT FK_Sarkilar_Albumler FOREIGN KEY (AlbumID)
        REFERENCES dbo.Albumler (AlbumID)
);

CREATE TABLE dbo.CalmaListeleri (
    ListeID INT IDENTITY(1,1) NOT NULL,
    ListeAdi NVARCHAR(200) NOT NULL,
    OlusturmaTarihi DATE NOT NULL CONSTRAINT DF_CalmaListeleri_OlusturmaTarihi DEFAULT (CONVERT(date, GETDATE())),
    KullaniciID INT NOT NULL,
    CONSTRAINT PK_CalmaListeleri PRIMARY KEY (ListeID),
    CONSTRAINT FK_CalmaListeleri_Kullanicilar FOREIGN KEY (KullaniciID)
        REFERENCES dbo.Kullanicilar (KullaniciID)
);

CREATE TABLE dbo.CalmaListesiSarkilari (
    ListeID INT NOT NULL,
    SarkiID INT NOT NULL,
    EklenmeTarihi DATE NOT NULL CONSTRAINT DF_CalmaListesiSarkilari_EklenmeTarihi DEFAULT (CONVERT(date, GETDATE())),
    SiraNo INT NOT NULL,
    CONSTRAINT PK_CalmaListesiSarkilari PRIMARY KEY (ListeID, SarkiID),
    CONSTRAINT CK_CalmaListesiSarkilari_SiraNo CHECK (SiraNo > 0),
    CONSTRAINT UQ_CalmaListesiSarkilari_Sira UNIQUE (ListeID, SiraNo),
    CONSTRAINT FK_CalmaListesiSarkilari_Listeler FOREIGN KEY (ListeID)
        REFERENCES dbo.CalmaListeleri (ListeID),
    CONSTRAINT FK_CalmaListesiSarkilari_Sarkilar FOREIGN KEY (SarkiID)
        REFERENCES dbo.Sarkilar (SarkiID)
);

CREATE TABLE dbo.SanatciSarkilari (
    SanatciID INT NOT NULL,
    SarkiID INT NOT NULL,
    Rol NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_SanatciSarkilari PRIMARY KEY (SanatciID, SarkiID),
    CONSTRAINT FK_SanatciSarkilari_Sanatcilar FOREIGN KEY (SanatciID)
        REFERENCES dbo.Sanatcilar (SanatciID),
    CONSTRAINT FK_SanatciSarkilari_Sarkilar FOREIGN KEY (SarkiID)
        REFERENCES dbo.Sarkilar (SarkiID)
);

CREATE TABLE dbo.Dinlemeler (
    KullaniciID INT NOT NULL,
    SarkiID INT NOT NULL,
    DinlemeTarihi DATE NOT NULL,
    DinlemeSayisi INT NOT NULL,
    CONSTRAINT PK_Dinlemeler PRIMARY KEY (KullaniciID, SarkiID, DinlemeTarihi),
    CONSTRAINT CK_Dinlemeler_DinlemeSayisi CHECK (DinlemeSayisi > 0),
    CONSTRAINT FK_Dinlemeler_Kullanicilar FOREIGN KEY (KullaniciID)
        REFERENCES dbo.Kullanicilar (KullaniciID),
    CONSTRAINT FK_Dinlemeler_Sarkilar FOREIGN KEY (SarkiID)
        REFERENCES dbo.Sarkilar (SarkiID)
);

CREATE TABLE dbo.Takipler (
    KullaniciID INT NOT NULL,
    SanatciID INT NOT NULL,
    TakipTarihi DATE NOT NULL CONSTRAINT DF_Takipler_TakipTarihi DEFAULT (CONVERT(date, GETDATE())),
    CONSTRAINT PK_Takipler PRIMARY KEY (KullaniciID, SanatciID),
    CONSTRAINT FK_Takipler_Kullanicilar FOREIGN KEY (KullaniciID)
        REFERENCES dbo.Kullanicilar (KullaniciID),
    CONSTRAINT FK_Takipler_Sanatcilar FOREIGN KEY (SanatciID)
        REFERENCES dbo.Sanatcilar (SanatciID)
);
GO

INSERT INTO dbo.Turler (Ad)
VALUES (N'Pop'), (N'Rock'), (N'Jazz');

INSERT INTO dbo.Sanatcilar (AdSoyad, Ulke, DogumTarihi)
VALUES
    (N'Tarkan', N'Türkiye', '1972-10-17'),
    (N'Sezen Aksu', N'Türkiye', '1954-07-13'),
    (N'Ed Sheeran', N'İngiltere', '1991-02-17');

INSERT INTO dbo.Kullanicilar (AdSoyad, Email, SifreHash, KayitTarihi, PremiumMu)
VALUES
    (N'İlayda Gökhan', N'ilayda@example.com', HASHBYTES('SHA2_256', N'ornek-parola-1'), '2024-01-10', 1),
    (N'Ali Yılmaz', N'ali@example.com', HASHBYTES('SHA2_256', N'ornek-parola-2'), '2024-02-05', 0);

INSERT INTO dbo.Albumler (AlbumAdi, SanatciID)
VALUES
    (N'Karma', 1),
    (N'Gülümse', 2),
    (N'Divide', 3);

INSERT INTO dbo.Sarkilar (SarkiAdi, SureSaniye, YayinTarihi, TurID, AlbumID)
VALUES
    (N'Şımarık', 230, '1997-07-01', 1, 1),
    (N'Gülümse', 245, '1991-05-01', 1, 2),
    (N'Shape of You', 233, '2017-01-06', 1, 3);

INSERT INTO dbo.CalmaListeleri (ListeAdi, OlusturmaTarihi, KullaniciID)
VALUES
    (N'Favorilerim', '2024-03-01', 1),
    (N'Ders Çalışırken', '2024-03-02', 1),
    (N'Hafta Sonu', '2024-03-05', 2);

INSERT INTO dbo.CalmaListesiSarkilari (ListeID, SarkiID, EklenmeTarihi, SiraNo)
VALUES
    (1, 1, '2024-03-01', 1),
    (1, 2, '2024-03-01', 2),
    (2, 3, '2024-03-02', 1),
    (3, 1, '2024-03-05', 1);

INSERT INTO dbo.SanatciSarkilari (SanatciID, SarkiID, Rol)
VALUES
    (1, 1, N'Ana sanatçı'),
    (2, 2, N'Ana sanatçı'),
    (3, 3, N'Ana sanatçı');

INSERT INTO dbo.Dinlemeler (KullaniciID, SarkiID, DinlemeTarihi, DinlemeSayisi)
VALUES
    (1, 1, '2024-03-10', 5),
    (1, 2, '2024-03-10', 3),
    (2, 3, '2024-03-11', 7);

INSERT INTO dbo.Takipler (KullaniciID, SanatciID, TakipTarihi)
VALUES
    (1, 1, '2024-02-01'),
    (1, 2, '2024-02-01'),
    (2, 3, '2024-02-10');
GO

-- İlişkileri ve örnek verileri kontrol etmek için örnek sorgu:
SELECT
    k.AdSoyad AS Kullanici,
    cl.ListeAdi,
    cls.SiraNo,
    s.SarkiAdi,
    a.AlbumAdi,
    sa.AdSoyad AS Sanatci,
    t.Ad AS Tur
FROM dbo.CalmaListeleri AS cl
INNER JOIN dbo.Kullanicilar AS k ON k.KullaniciID = cl.KullaniciID
INNER JOIN dbo.CalmaListesiSarkilari AS cls ON cls.ListeID = cl.ListeID
INNER JOIN dbo.Sarkilar AS s ON s.SarkiID = cls.SarkiID
INNER JOIN dbo.Albumler AS a ON a.AlbumID = s.AlbumID
INNER JOIN dbo.Sanatcilar AS sa ON sa.SanatciID = a.SanatciID
INNER JOIN dbo.Turler AS t ON t.TurID = s.TurID
ORDER BY k.AdSoyad, cl.ListeAdi, cls.SiraNo;
GO
