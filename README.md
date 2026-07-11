# Windows Activation Manager 🔑

**برنامج إدارة تفعيل Windows - Automatic KMS Activation Tool**

## المميزات ✨

- ✅ تفعيل تلقائي كامل لـ Windows
- ✅ دعم Windows 11, 10, Server 2025, 2022, 2019, 2016
- ✅ واجهة بسيطة وسهلة الاستخدام
- ✅ بلا خطوات إضافية معقدة
- ✅ عرض حالة التفعيل الحالية

## المتطلبات 📋

- Windows 10/11 أو Windows Server 2016 وما بعده
- PowerShell 5.0 أو أعلى
- **تشغيل البرنامج بصلاحيات Administrator**
- KMS Host متاح على الشبكة المحلية

## طريقة الاستخدام 🚀

### الطريقة الأولى (الأسهل):

1. اضغط على ملف `Activate-Windows.ps1` بزر الفأرة الأيمن
2. اختر **"Run with PowerShell"**
3. اختر إصدار Windows الخاص بك
4. ادخل عنوان KMS Host
5. الانتظار حتى ينتهي البرنامج

### الطريقة الثانية:

```powershell
# اضغط Win + X واختر PowerShell (Admin)
cd C:\path\to\script
.\Activate-Windows.ps1
```

### الطريقة الثالثة:

انقر على `RunAsAdmin.bat` مباشرة بزر الفأرة الأيمن واختر "Run as administrator"

## الإصدارات المدعومة 📦

### Windows 11 و 10:
- Windows 11/10 Pro
- Windows 11/10 Pro N
- Windows 11/10 Enterprise
- Windows 11/10 Enterprise N

### Windows Server:
- Windows Server 2025 Standard / Datacenter
- Windows Server 2022 Standard / Datacenter
- Windows Server 2019 Standard / Datacenter
- Windows Server 2016 Standard / Datacenter

## ماذا يفعل البرنامج؟ 🔧

1. **عرض القائمة**: يعرض جميع إصدارات Windows المدعومة
2. **اختيار الإصدار**: تختار الإصدار الخاص بك
3. **إدخال KMS Host**: تدخل عنوان KMS Host
4. **تعيين KMS Host**: يعين KMS Host تلقائياً
5. **تثبيت المفتاح**: يثبت مفتاح KMS المناسب
6. **تفعيل Windows**: يقوم بتفعيل Windows تلقائياً
7. **عرض الحالة**: يعرض حالة التفعيل النهائية

## المفاتيح المستخدمة 🔐

جميع المفاتيح هي **Generic Volume License Keys (GVLKs)** من Microsoft:

```
Windows 11 Pro:           W269N-WFGWX-YVC9B-4J6C9-T83GX
Windows 11 Enterprise:    NPPR9-FWDCX-D2C8J-H872K-2YT43
Windows Server 2022:      WX4NM-KYWYW-QJJR4-XV3QB-6VM33
...
```

**ملاحظة:** هذه المفاتيح مخصصة فقط **للترخيص الحجمي Volume Licensing** ولا تعمل مع نسخ البيع بالتجزئة.

## معلومات KMS Host 🌐

```
عنوان KMS Host مثالي:
- kms.example.com
- 192.168.1.100
- kms-server.domain.local

المنفذ الافتراضي: 1688
```

إذا لم يكن لديك KMS Host، يمكنك:
- التواصل مع مسؤول الشبكة
- أو استخدام خدمة KMS عامة (إن أمكن)

## استكشاف الأخطاء 🐛

### المشكلة: "Permission Denied"
**الحل:** تأكد من تشغيل البرنامج بصلاحيات Administrator

### المشكلة: "KMS Host not found"
**الحل:** تحقق من أن عنوان KMS Host صحيح والجهاز متصل بالشبكة

### المشكلة: "Activation failed"
**الحل:** 
- تأكد من أن KMS Host يعمل بشكل صحيح
- تحقق من الاتصال بالشبكة
- جرب إعادة التشغيل

## أوامر مفيدة إضافية ⚙️

```powershell
# عرض حالة التفعيل الحالية
cscript "$env:SystemRoot\System32\slmgr.vbs" /dli

# تعيين KMS Host يدويًا
cscript "$env:SystemRoot\System32\slmgr.vbs" /skms kms.example.com:1688

# تثبيت مفتاح يدويًا
cscript "$env:SystemRoot\System32\slmgr.vbs" /ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX

# تفعيل يدويًا
cscript "$env:SystemRoot\System32\slmgr.vbs" /ato

# إعادة تعيين معلومات التفعيل
cscript "$env:SystemRoot\System32\slmgr.vbs" /rearm
```

## المتطلبات القانونية ⚖️

- هذا البرنامج مخصص **فقط** للأنظمة المرخصة بـ Volume Licensing
- **يجب أن يكون لديك ترخيص صحيح** لاستخدام هذا البرنامج
- لا تستخدمه مع نسخ البيع بالتجزئة أو المقرصنة

## الدعم والمساهمة 🤝

إذا واجهت مشكلة:
1. تحقق من قسم "استكشاف الأخطاء"
2. توصل مع مسؤول الشبكة
3. راجع توثيق Microsoft الرسمي

## الملفات المتضمنة 📁

```
├── Activate-Windows.ps1    # البرنامج الرئيسي
├── RunAsAdmin.bat          # ملف تشغيل سهل
├── README.md               # هذا الملف
└── LICENSE                 # رخصة الاستخدام
```

## الإصدار 📌

**Windows Activation Manager v1.0**
- تم الإنشاء: 2026
- آخر تحديث: 2026-07-11

---

**تم التطوير بواسطة:** do1a

**ملاحظة:** هذا البرنامج مجاني وبدون ضمانات. استخدمه على مسؤوليتك الخاصة.
