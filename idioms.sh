# Проверка количества аргументов
if [ $# -lt 1 ]
then
  echo "Нечего бэкапить"
  exit $E_NOTDIR
fi

# Проверка дискового пространства
DISK_USAGE=$(df / | grep $BACKUP_DEST | awk '{ print $5 }' | sed 's/%//g')
if [ ${DISK_USAGE} -gt ${DISK_USAGE_THRESHOLD} ]; then
    exit $E_NOTFREESPACE
fi

# Удаление файлов старше $BACKUP_RETENTION_DAYS дней
BACKUP_RETENTION_DAYS=3 
CURRENT_DATE=$(date +"%Y-%m-%d")
PURGE_DATE=$(date -d "-${BACKUP_RETENTION_DAYS} days" +"%Y-%m-%d")
find "${BACKUP_DEST}" -type d -name "${ARCHIVE_NAME}-${PURGE_DATE}" -exec rm -rf {} \;