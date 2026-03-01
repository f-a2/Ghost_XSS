# 👻 Ghost_XSS: Advanced XSS Bypass Automator

<p align="center">
  <img src="https://d26e3f10zvrezp.cloudfront.net/Gallery/108895d8-66a9-44b1-97a8-028e019920cf-711x400.webp" alt="Ghost_XSS Interface" width="100%">
</p>

**Ghost_XSS** هو سكريبت أتمتة متقدم (Bash Script) مصمم لصيد ثغرات الـ **Cross-Site Scripting (XSS)**. يتميز السكريبت بقدرته على الجمع بين جلب الروابط المؤرشفة وتنقيتها، ثم فحصها باستخدام محرك `Dalfox` القوي مع تفعيل خيارات التخطي (Bypass) لتجاوز جدران حماية تطبيقات الويب (WAF).

---

## 🛠️ المتطلبات (Prerequisites)

لضمان عمل السكريبت بدون أخطاء على نظام **Kali Linux** أو أي توزيعة Linux، يجب تثبيت الأدوات التالية:

### 1. لغة البرمجة Go
```bash
sudo apt update && sudo apt install golang -y

go install [github.com/tomnomnom/waybackurls@latest](https://github.com/tomnomnom/waybackurls@latest)
sudo cp ~/go/bin/waybackurls /usr/local/bin/

go install [github.com/hahwul/dalfox/v2@latest](https://github.com/hahwul/dalfox/v2@latest)
sudo cp ~/go/bin/dalfox /usr/local/bin/


git clone [https://github.com/f-a2/Ghost_XSS.git](https://github.com/f-a2/Ghost_XSS.git)
cd Ghost_XSS

chmod +x Faisal_Ghost_XSS.sh

./Faisal_Ghost_XSS.sh
