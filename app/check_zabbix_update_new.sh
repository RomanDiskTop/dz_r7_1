#!/bin/bash

# Версии Zabbix агентов для разных ОС
VERSION_UBUNTU="7.4.0"
VERSION_DEBIAN="7.4.0"
VERSION_REDOS="7.0.12"
VERSION_CENTOS="7.4.0"

BOT_TOKEN="Тут токен"
CHAT_ID="Тут айдишник"
API_URL="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
INVENTORY="inventory.ini"

# Формируем сообщение с разделителями
REPORT="*Проверка версий Zabbix\-агентов*"
REPORT+="\n═══════════════════════════════"

# Парсим inventory.ini
AGENTS=$(awk '/\[zabbix_agents\]/ {flag=1; next} /^\[/ {flag=0} flag && NF' "$INVENTORY")

while read -r line; do
    HOST=$(echo "$line" | awk '{print $1}')
    IP=$(echo "$line" | grep -oP 'ansible_host=\K[0-9.]+')

    # Получаем версию агента и инфу об ОС
    VERSION=$(zabbix_get -s "$IP" -k "agent.version" 2>/dev/null)
    OS_INFO=$(zabbix_get -s "$IP" -k "system.sw.os[full]" 2>/dev/null)
    OS_NAME=$(zabbix_get -s "$IP" -k "system.sw.os[name]" 2>/dev/null)
    
    # Определяем тип ОС
    if [[ "$OS_INFO" =~ "red-soft.ru" ]] || [[ "$OS_NAME" == "RedOS" ]]; then
        OS_TYPE="RedOS"
        EXPECTED="$VERSION_REDOS"
        OS_VERSION=$(echo "$OS_INFO" | grep -oP 'Red Soft \K[0-9.]+' || echo "unknown")
    elif [[ "$OS_INFO" =~ "Ubuntu" ]] || [[ "$OS_NAME" == "Ubuntu" ]]; then
        OS_TYPE="Ubuntu"
        EXPECTED="$VERSION_UBUNTU"
        OS_VERSION=$(echo "$OS_INFO" | grep -oP 'Ubuntu \K[0-9.]+' || echo "unknown")
    elif [[ "$OS_INFO" =~ "Debian" ]] || [[ "$OS_NAME" == "Debian" ]]; then
        OS_TYPE="Debian"
        EXPECTED="$VERSION_DEBIAN"
        OS_VERSION=$(echo "$OS_INFO" | grep -oP 'Debian \K[0-9.]+' || echo "unknown")
    elif [[ "$OS_INFO" =~ "Red Hat" ]] || [[ "$OS_NAME" == "CentOS" ]]; then
        OS_TYPE="CentOS"
        EXPECTED="$VERSION_CENTOS"
        OS_VERSION=$(echo "$OS_INFO" | grep -oP 'Red Hat \K[0-9.]+' || echo "unknown")
    else
        OS_TYPE="Unknown"
        EXPECTED="Unknown"
        OS_VERSION="unknown"
    fi

    REPORT+="\n\n *Хост:* \`$HOST\`"
    REPORT+="\n   *IP:* \`$IP\`"
    REPORT+="\n   *ОС:* \`$OS_TYPE $OS_VERSION\`"

    if [[ -z "$VERSION" ]]; then
        REPORT+="\n   *Статус:* ❌ Не отвечает"
        continue
    fi

    REPORT+="\n   *Версия агента:* \`$VERSION | $EXPECTED\`"

    if [[ "$VERSION" == "$EXPECTED" ]]; then
        REPORT+="\n   *Статус:* ✅"
    else
        REPORT+="\n   *Статус:* ❌"
    fi

    REPORT+="\n─────────────────────"

done <<< "$AGENTS"

# Экранирование для нормального переноса текста в телеграм v100500
SAFE_REPORT=$(echo -e "$REPORT" | sed \
  -e 's/\./\\./g' -e 's/\-/\\-/g' -e 's/(/\\(/g' \
  -e 's/)/\\)/g' -e 's/!/\\!/g' -e 's/+/\\+/g' \
  -e 's/=/\\=/g' -e 's/>/\\>/g' -e 's/</\\</g' \
  -e 's/#/\\#/g' -e 's/-/\\-/g' -e 's/|/\\|/g')

# Вывод в консоль
echo -e "$REPORT"

# Отправка в Telegram
curl -s -X POST "$API_URL" \
    -d chat_id="$CHAT_ID" \
    -d parse_mode="MarkdownV2" \
    --data-urlencode "text=$SAFE_REPORT" > /dev/null