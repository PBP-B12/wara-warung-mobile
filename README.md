# 🫕WaraWarung Mobile😋

## 👨‍👩‍👦‍👦 Anggota Kelompok B-12
| Nama | NPM | Akun GitHub | 
| -- | -- | -- |
| Dhania Tiaraputri Herdiani | 2306165881 | [dhaniatiara](https://github.com/dhaniatiara) |
| Rania Berliana | 2306165875 | [bberliana](https://github.com/bberliana) |
| Jeremia Rangga Setyawan | 2306245775| [jeremiaranggasetyawan](https://github.com/jeremiaranggasetyawan) |
| Luthfi Febriyan | 2306245913| [lutpiieee](https://github.com/lutpiieee) |
| Najwa Zarifa | 2306207796 | [ondaonde](https://github.com/ondaonde) |

  

## 📛 Nama Aplikasi

**WaraWarung** adalah sebuah aplikasi berbasis website untuk mencari makanan pada warung di daerah Bali.


## 📝 Cerita Aplikasi

Banyak wisatawan yang baru pertama kali datang ke Bali menghadapi kesulitan saat ingin menemukan tempat yang benar-benar menyajikan makanan otentik khas Bali. Ketidakjelasan informasi mengenai lokasi, jenis hidangan, dan keaslian rasa membuat mereka seringkali terjebak di restoran yang menawarkan versi modern atau modifikasi (bukan otentik) dari masakan tradisional. Hal ini tentu saja mengurangi kesempatan bagi mereka untuk merasakan pengalaman kuliner Bali yang sesungguhnya. Ditambah lagi, hambatan seperti keterbatasan bahasa dan minimnya pengetahuan budaya setempat membuat para wisatawan sering merasa kurang percaya diri dalam mengeksplorasi kuliner lokal tanpa panduan yang jelas dan informatif.

Untuk itulah WaraWarung hadir, memberikan solusi bagi wisatawan yang ingin merasakan cita rasa asli Bali. Dengan menggunakan WaraWarung, para pengguna dapat dengan mudah menemukan makanan otentik pada warung melalui fitur pencarian berbasis kata kunci. Wisatawan juga dapat menyimpan menu favorit, memberikan ulasan, melihat rating dari sesama pengguna untuk menentukan pilihan terbaik, dan juga fitur menu planning. Menu planning merupakan fitur bagi pengguna dimana mereka bisa mengatur budget di warung pilihan mereka, kemudian dapat melihat menu apa saja pada warung tersebut yang sesuai dengan budget yang dimiliki. Dengan kemudahan ini, WaraWarung menjadi teman ideal bagi para wisatawan maupun pendatang untuk menikmati perjalanan kuliner yang otentik, sederhana, dan nikmat di Bali.


## ⚙️ Daftar Modul

| Daftar Modul | Penjelasan | Nama Pengembang |
|  :----  |  :----  |  :----  |
| Authentication (Login & Logout) | Sebelum dapat mengakses fitur Menu Favorit, Menu Planning, Menu Rate & Review dan User Dashboard, pengguna wajib untuk login terlebih dahulu pada page login. Pengguna juga dapat logout maupun register jika belum memiliki akun. | Luthfi Febriyan |
| Menu Favorit | Pengguna dapat menambahkan menu ke list favorit menggunakan tombol add to favourite yang ada di cards Menu. List dari favourite menu dapat diberikan nama berdasarkan keinginan pengguna. | Luthfi Febriyan |
| User Dashboard (Edit profile & Halaman profile) | Pengguna yang sudah login dapat mengedit maupun mengatur ulang informasi pribadinya pada form yang disediakan pada aplikasi. | Rania Berliana |
| Homepage (Landing page) | Page utama yang berisikan tombol maupun card yang menavigasi ke fitur lainnya seperti searching dan fitur lainnya. | Dhania Tiaraputri H |
| Menu planning | Fitur yang memungkinkan pengguna untuk mengatur budget pada warung pilihan mereka. Pengguna kemudian dapat memilih menu dan kuantitasnya dari warung pilihan, kemudian menyimpan pilihan tersebut selama sesuai budget. | Dhania Tiaraputri H |
| Searching Berdasarkan Kata Kunci | Pengguna dapat mencari makanan berdasarkan kata kunci. Selain itu pengguna juga dapat melakukan filtering makanan berdasarkan budget yang ditampilkan dalam bentuk dropdown. Saat pengguna menekan tombol search, maka akan muncul makanan yang sesuai dengan kata kunci dan budget yang dipilih. | Jeremia Rangga |
| Menu Rate & Review | Pengguna yang sudah login dapat membuat rating dan review pada suatu menu yang sudah mereka cicipi. Pengguna yang belum login hanya dapat melihat rating. | Najwa Zarifa | 
| Filter Menu Planning | Setelah pengguna membuat menu planning, list dari semua menu plan pengguna tersebut dapat di-filter kembali untuk ditampilkan berdasarkan budget atau warung. | Rania Berliana |

  

## 📖 Sumber initial dataset kategori utama produk

**Data Warung di Denpasar (Ada menunya) :** [https://ppid.denpasarkota.go.id/files/resource/data%20kuliner%20di%20Kota%20Denpasar.pdf](https://ppid.denpasarkota.go.id/files/resource/data%20kuliner%20di%20Kota%20Denpasar.pdf)

**Data yang sudah di proses :** [https://docs.google.com/spreadsheets/d/1tYzChmxiDQ-cLoarDDSe6ivMk4kg6eXhjOx0c_xG-gU/edit?usp=sharing](https://docs.google.com/spreadsheets/d/1tYzChmxiDQ-cLoarDDSe6ivMk4kg6eXhjOx0c_xG-gU/edit?usp=sharing)


## 🧑‍💻 Role atau peran pengguna beserta deskripsinya

####  🔓 User yang Sudah Terautentikasi :

*  Melakukan pencarian dan *filter* berdasarkan kata kunci (kategori makanan, lokasi, preferensi)

*  Membuka halaman *profile* yang berisi data-data user terkait

*  Memberikan *review* dan *rating* ke menu pada warung yang sudah dikunjungi

*  Menambah dan menghapus daftar warung maupun menu pada fitur favorites

*  Melakukan planning menu berdasarkan budget yang diatur oleh pengguna pada warung tertentu

####  🔒 User yang Belum Terautentikasi :

*  Melakukan pencarian dan *filter* berdasarkan kata kunci (kategori makanan, lokasi, preferensi)

*  Melihat daftar warung pada halaman utama

*  Melihat *review* dan *rating* menu pada warung yang sudah dikunjungi


## Alur Pengintegrasian dengan Web Service

![pbp kelompok bagan](https://github.com/user-attachments/assets/5ece6dcc-3004-478d-8bf1-f7560c83c8fe)

### Langkah-Langkah Integrasi Flutter dengan Django

**1. Menambahkan Dependensi HTTP**

- Jalankan perintah berikut pada terminal proyek Flutter flutter pub add http

- Dependensi ini digunakan untuk mengirim dan menerima HTTP Request dari aplikasi Flutter ke Django Web Service.

**2. Membuat Model untuk Respons JSON Django**

- Kami menggunakan website seperti QuickType untuk membuat model berdasarkan struktur JSON yang dikembalikan Django.

- Model ini akan mempermudah proses pemetaan data JSON ke struktur data Flutter. Pastikan model sesuai dengan data yang dikirim oleh Serializers di Django.

**3. Memodifikasi Views pada Django (Backend)**

- Sesuaikan kode di views.py Django agar data yang dikirimkan ke Flutter sesuai kebutuhan aplikasi.

**4. Mengirim Request dari Flutter**

- Kami menggunakan dependensi http di Flutter untuk mengirim HTTP Request ke endpoint Django.

**5. Mengolah Respons Data di Flutter**

- Data yang diterima dari Django dipetakan ke dalam struktur data seperti List atau Map.

- Kami menggunakan model yang telah dibuat (pada langkah 2) untuk mempermudah konversi data JSON ke objek Flutter.

**6. Menampilkan Data Menggunakan FutureBuilder**

- Gunakan widget `FutureBuilder` untuk menampilkan data yang didapatkan dari Django.

**7. Endpoint Django untuk Data JSON/XML**

- Pastikan Django memiliki endpoint API yang siap diakses dari Flutter.

**8. Testing dan Debugging**

- Pastikan data yang dikirim dan diterima antara Django dan Flutter sudah sesuai.

- Gunakan alat seperti Postman atau cURL untuk mengetes API Django sebelum menghubungkannya dengan Flutter.

## 🔗 Tautan Deployment Aplikasi
[![Build status](https://build.appcenter.ms/v0.1/apps/dff9639d-3233-42f4-abc1-c51119273735/branches/main/badge)](https://appcenter.ms)

URL : Akan di sampaikan saat aplikasi sudah rilis.
