<div dir="rtl" align="right">

# پچ سازگاری Xilinx ISE با Windows 11 - سیسوگ

[English](README_EN.md) | **فارسی**

این یک اسکریپت Batch کوچک است که فایل‌های `libPortability.dll` لازم برای اجرای **Xilinx ISE Design Suite 14.7** روی **ویندوز ۱۱** را به‌صورت خودکار اعمال می‌کند، بدون این‌که نیاز باشد فایل‌ها را دستی کپی کنید. همچنین مشکل **گیر کردن ISim روی Elaborating** را حل می‌کند.

## آموزش فارسی

آموزش نصب و استفاده از این روش به زبان فارسی در سایت سیسوگ موجود است:</br>
[نصب Xilinx ISE روی ویندوز ۱۱ به روش سیسوگ](https://sisoog.com/xilinx-ise-installation-on-windows-11-using-sisoog-method/)

## این اسکریپت چه کاری انجام می‌دهد

نرم‌افزار Xilinx ISE 14.7 قبل از عرضه‌ی ویندوز ۱۱ ساخته شده است و نصب کردن آن روی این نسخه از ویندوز مشکلاتی به همراه دارد. برای نصب آن روی ویندوز ۱۱ باید ابتدا طبق آموزش بالا نرم‌افزار نصب کرده و سپس DLL های لازم در چند پوشه‌ی مختلف داخل مسیر نصب ISE کپی شود. این اسکریپت این مرحله‌ی کپی را خودکار می‌کند و از هر فایلی که رونویسی می‌کند، یک نسخه‌ی پشتیبان می‌گیرد.

**فایل ۶۴ بیتی (`nt64`) در مسیرهای زیر کپی می‌شود:**

<div dir="ltr" align="left">

```
ISE_DS\ISE\sysgen\bin\nt64
ISE_DS\ISE\bin\nt64
ISE_DS\EDK\lib\nt64\sdk
ISE_DS\EDK\lib\nt64
ISE_DS\ISE\lib\nt64
ISE_DS\common\lib\nt64
ISE_DS\.xinstall\bin\nt64
```

</div>

**فایل ۳۲ بیتی (`nt`) در مسیرهای زیر کپی می‌شود:**

<div dir="ltr" align="left">

```
ISE_DS\.xinstall\bin\nt
ISE_DS\common\lib\nt
ISE_DS\EDK\lib\nt
ISE_DS\ISE\lib\nt
ISE_DS\ISE\sysgen\bin\nt
```

</div>

پیش از رونویسی هر فایل، اسکریپت یک نسخه‌ی پشتیبان از فایل اصلی با نام `libPortability.dll.bak` در همان پوشه ذخیره می‌کند (فقط در اولین اجرا، تا با اجرای دوباره‌ی اسکریپت، پشتیبان سالم قبلی از بین نرود). ویژگی‌های read-only، hidden و system فایل‌ها پیش از کپی برداشته می‌شود، تا فایل‌هایی مثل فایل‌های داخل `.xinstall` خطای «Access is denied» ندهند.

### رفع مشکل ISim (`libPortabilityNOSH.dll`)

وقتی **Simulate Behavioral Model** را می‌زنید، ابزار `fuse` در ISim فایل `libPortabilityNOSH.dll` را از مسیر نصب ISE برمی‌دارد و با نام `libPortability.dll` داخل پوشه‌ی `isim\<name>.exe.sim\` پروژه کپی می‌کند. اگر این فایل پچ نشده باشد، ISim روی Elaborating گیر می‌کند. برای رفع این مشکل، اسکریپت دو فایل زیر را هم (با گرفتن نسخه‌ی پشتیبان `.bak`) جایگزین می‌کند:

<div dir="ltr" align="left">

```
ISE_DS\ISE\lib\nt64\libPortabilityNOSH.dll
ISE_DS\ISE\lib\nt\libPortabilityNOSH.dll
```

</div>

از این به بعد، پروژه‌های جدید به‌صورت خودکار DLL پچ‌شده را می‌گیرند. اگر پروژه‌ای را **قبل از** اعمال پچ شبیه‌سازی کرده‌اید، پوشه‌ی `isim` آن را یک‌بار پاک کنید تا دوباره ساخته شود.

## ساختار پوشه‌ها

اسکریپت را در هر پوشه‌ای زیر مسیر `C:\Xilinx` قرار دهید، کنار فایل‌های DLL پچ‌شده:

<div dir="ltr" align="left">

```
C:\Xilinx\
    ├── 14.7
    └── Sisoog ISE Win11 Fix\
        ├── Sisoog ISE Win11 Fix.bat
        ├── nt\
        │   └── libPortability.dll
        └── nt64\
            └── libPortability.dll
```

</div>

اسکریپت به‌صورت خودکار یک پوشه از مسیر خودش بالا می‌رود و پوشه‌ی نصب `ISE_DS` را زیر آن جست‌وجو می‌کند.

## نحوه‌ی استفاده

۱. این ریپازیتوری را دانلود کنید.</br>
۲. پوشه را در مسیر `C:\Xilinx\` (یا هر زیرپوشه‌ای از آن) کپی کنید.</br>
۳. ISE و ISim را ببندید (و اگر `isimgui.exe` در Task Manager باقی مانده، آن را هم ببندید).</br>
۴. روی `Sisoog ISE Win11 Fix.bat` راست‌کلیک کرده و گزینه‌ی **Run as administrator** را انتخاب کنید.</br>
۵. در صفحه‌ی شروع، یک کلید را فشار دهید.</br>
۶. منتظر بمانید تا پیام **SUCCESS** (سبز) یا **FAILED** (قرمز) نمایش داده شود.</br>

## بازگرداندن فایل‌های اصلی

در هر پوشه‌ی پچ‌شده، یک نسخه‌ی `libPortability.dll.bak` از فایل اصلی نگه‌داری می‌شود (و برای رفع مشکل ISim، فایل `libPortabilityNOSH.dll.bak`). برای لغو پچ، در هرکدام از پوشه‌های ذکرشده، هر فایل `.bak` را به نام اصلی خودش تغییر نام دهید.

## سلب مسئولیت

این یک راه‌حل غیررسمی و مبتنی بر تلاش جامعه‌ی کاربران است و توسط AMD/Xilinx ارائه یا تأیید نشده است. استفاده از آن بر عهده‌ی خودتان است.

## توسعه‌دهنده

**عباس قلاوندی**

## مجوز

MIT

</div>
