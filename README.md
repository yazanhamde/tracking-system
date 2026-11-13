# 📍 Fleet, Employee & Inventory Tracking System

**English** | [العربية](#-نظام-تتبع-الموظفين-والأسطول-والمستودع)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Yazan%20Hamdi-blue?logo=linkedin)](https://www.linkedin.com/in/yazan-hamdi/)

A PHP/MySQL web app (installable PWA, Arabic RTL) for managing employees, drivers, vehicles and a parts warehouse in one place: live location tracking, attendance, trips, leave and overtime, fleet maintenance, inventory and reports — with role-based access for admins, employees and drivers.

---

## ✨ Features

- **Attendance & live location:** check-in/out with location, live map data, geofence/location alerts, manual force check-out (admin only).
- **Trips:** driver trips with live location updates (`trips_live.php`, `api/trip_live.php`).
- **Fleet:** vehicles, maintenance, fuel log, tracking and Google Maps view (`fleet.php`, `vehicles.php`, `cron_fleet.php`).
- **HR:** employees, shifts, leave types/balances/requests, overtime requests, holidays, performance reviews.
- **Warehouse:** parts inventory, sales, inventory log, suppliers and inventory reports (`inventory.php`, `suppliers.php`, `warehouse_dashboard.php`).
- **Communication:** notifications, internal messages, employee notes to the manager.
- **Reports & export:** attendance and employee reports, attendance export, role-based filters.
- **Roles:** admin (full access), employee and driver (search and sell in the warehouse; no add/edit/delete).
- **PWA:** manifest and service worker, installable on phones.

## 🛠️ Tech stack

PHP 8.x · MySQL/MariaDB (PDO) · Vanilla JS · Google Maps JavaScript API · PWA · cron jobs

## 📁 Structure

```
├── api/         # JSON endpoints (attendance, trips, fleet, inventory, notifications...)
├── database/    # schema.sql
├── includes/    # config, auth, theme, HR helpers, upload helper
├── *.php        # Pages: admin, employee, driver, fleet, inventory, reports...
├── cron.php     # Per-minute job (attendance and alerts logic)
├── cron_fleet.php
├── manifest.json, sw.js   # PWA
└── .env.example
```

## ⚙️ Setup

1. Copy the files to your server (e.g. `public_html/tracking/`).
2. `cp .env.example .env` and fill in the database credentials, `SITE_URL` and `GMAPS_API_KEY`. Never commit `.env`.
3. Create an empty MySQL database and import `database/schema.sql` (30 tables, plus default leave types and warehouse shelf sections).
4. Create the first admin user in the `employees` table (password hashed with PHP `password_hash()` / bcrypt).
5. Create a writable `uploads/` folder. It must block script execution.
6. Add cron jobs (replace the path):
   ```
   * * * * * php /home/YOUR_USER/public_html/tracking/cron.php
   ```
   and schedule `cron_fleet.php` as needed.

## ⚠️ Notes

- The included `.htaccess` blocks web access to `.env`, logs and SQL dumps, and `includes/.htaccess` denies direct access to includes. Make sure your server honors `.htaccess` (Apache).
- Location data is personal data. Inform your employees and drivers about tracking and comply with local regulations.

## 📄 License
MIT

---
---

<div dir="rtl">

# 📍 نظام تتبع الموظفين والأسطول والمستودع

تطبيق ويب بـ PHP وMySQL (قابل للتثبيت كـ PWA وبواجهة عربية RTL) لإدارة الموظفين والسائقين والمركبات ومستودع قطع الغيار بمكان واحد: تتبع الموقع المباشر، الحضور، الرحلات، الإجازات والعمل الإضافي، صيانة الأسطول، المخزون والتقارير، مع صلاحيات حسب الدور (مدير، موظف، سائق).

## ✨ المزايا

- **الحضور والموقع المباشر:** تسجيل دخول وخروج مع الموقع، بيانات خريطة مباشرة، تنبيهات الموقع، وإنهاء دوام يدوي (للمدير فقط).
- **الرحلات:** رحلات السائقين مع تحديث الموقع مباشرة.
- **الأسطول:** المركبات والصيانة وسجل الوقود وعرض خرائط Google.
- **الموارد البشرية:** الموظفون، الورديات، أنواع الإجازات والأرصدة والطلبات، العمل الإضافي، العطل، تقييم الأداء.
- **المستودع:** قطع الغيار، المبيعات، سجل المخزون، الموردون وتقارير المخزون.
- **التواصل:** إشعارات، رسائل داخلية، وملاحظات الموظف للمدير.
- **التقارير والتصدير:** تقارير الحضور والموظفين وتصدير الحضور.
- **الصلاحيات:** المدير صلاحيات كاملة، والموظف والسائق بحث وبيع فقط بالمستودع.

## ⚙️ التثبيت

1. انسخ الملفات للسيرفر (مثلاً `public_html/tracking/`).
2. `cp .env.example .env` وعبّي بيانات القاعدة و`SITE_URL` و`GMAPS_API_KEY`. لا ترفع `.env` أبداً.
3. أنشئ قاعدة MySQL فاضية واستورد `database/schema.sql` (30 جدول مع أنواع الإجازات الافتراضية ورفوف المستودع).
4. أنشئ أول مستخدم مدير بجدول `employees` (كلمة السر مشفّرة بـ `password_hash()`).
5. أنشئ مجلد `uploads/` قابل للكتابة ويمنع تنفيذ السكربتات.
6. أضف cron: `* * * * * php /home/YOUR_USER/public_html/tracking/cron.php`

## ⚠️ ملاحظات

- ملفا `.htaccess` المرفقان يمنعان الوصول المباشر لـ `.env` والسجلات وملفات SQL ومجلد `includes/`.
- بيانات الموقع بيانات شخصية: أبلغ الموظفين والسائقين بالتتبع والتزم بالأنظمة المحلية.

## 📄 الترخيص
MIT

</div>
