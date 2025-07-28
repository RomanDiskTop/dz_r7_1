#!/bin/bash

VERSION_V1="7.4.0" # Установить актуальную версию агента с сайта https://www.zabbix.com/ru/download
VERSION_V2="7.4.0" # Установить актуальную версию агента с сайта https://www.zabbix.com/ru/download
BOT_TOKEN="8387838156:AAH8tX-iKbrQO3sFWyDAqsPwry8BCW8bDvo"
CHAT_ID="977567841"
API_URL="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
INVENTORY="inventory.ini"

# Формируем сообщение с разделителями
REPORT="*Проверка версий Zabbix\-агентов*"
REPORT+="\n═════════════════" # Для красоты
# Парсим inventory.ini
AGENTS=$(awk '/\[zabbix_agents\]/ {flag=1; next} /^\[/ {flag=0} flag && NF' "$INVENTORY")

while read -r line; do
    HOST=$(echo "$line" | awk '{print $1}')
    IP=$(echo "$line" | grep -oP 'ansible_host=\K[0-9.]+')

    VERSION=$(zabbix_get -s "$IP" -k "agent.version" 2>/dev/null)  # Метод через zabbix-get

    REPORT+="\n\n*Хост:* \`$HOST\`"
    REPORT+="\n*IP:* \`$IP\`"

    if [[ -z "$VERSION" ]]; then
        REPORT+="\n*Статус:* ❌ Не отвечает"
        continue
    fi

    [[ "$VERSION" =~ ^7\. ]] && AGENT=2 || AGENT=1
    [[ $AGENT -eq 1 ]] && EXPECTED="$VERSION_V1" || EXPECTED="$VERSION_V2"

    REPORT+="\n*Версия:* \`$VERSION\`"
    REPORT+="\n*Тип агента:* \`$AGENT\`"

    if [[ "$VERSION" == "$EXPECTED" ]]; then
        REPORT+="\n*Статус:* ✅ Соответствует (\`$EXPECTED\`)"
    else
        REPORT+="\n*Статус:* ❌ Не соответствует (ожидается \`$EXPECTED\`)"
    fi

    REPORT+="\n─────────────────────" # Для красоты
done <<< "$AGENTS"

# Экранирование для нормального переноса текста в телеге версия17
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
    --data-urlencode "text=$SAFE_REPORT" > /dev/null # Сливает вывод телеграмма
