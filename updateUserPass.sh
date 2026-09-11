#!/bin/bash
set -e

# ============== 配置区（改这两行就行） ==============
EMAIL="$1"
NEW_PASSWORD="$2"
# ====================================================

echo "=========================================="
echo "  KPI 系统用户密码修改工具"
echo "=========================================="
echo "目标邮箱: $EMAIL"
echo "新密码:   $NEW_PASSWORD"
echo ""

# 检查容器是否运行
if ! docker ps --format '{{.Names}}' | grep -q '^kpi-backend$'; then
    echo "[错误] 容器 kpi-backend 未运行，请先执行 docker compose up -d"
    exit 1
fi

echo "[1/3] 更换国内源并安装依赖..."
docker exec -i kpi-backend bash <<'CONTAINER_SCRIPT'
set -e
# 更换阿里云源
[ -f /etc/apt/sources.list.d/debian.sources ] && sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources
[ -f /etc/apt/sources.list ] && sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list
apt-get update -qq
apt-get install -y -qq python3 python3-bcrypt >/dev/null
echo "依赖安装完成"
CONTAINER_SCRIPT

echo ""
echo "[2/3] 生成 bcrypt 哈希并更新数据库..."
docker exec -i -e EMAIL="$EMAIL" -e NEW_PASSWORD="$NEW_PASSWORD" kpi-backend python3 <<'PYEOF'
import os
import bcrypt
import sqlite3

email = os.environ['EMAIL']
password = os.environ['NEW_PASSWORD']

# 生成 bcrypt 哈希
hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

# 连接数据库
conn = sqlite3.connect('/app/db/kpi.db')
cursor = conn.cursor()

# 检查用户是否存在
cursor.execute("SELECT id, name, email, role FROM employees WHERE email=?", (email,))
row = cursor.fetchone()
if not row:
    print(f"[错误] 未找到邮箱为 {email} 的用户")
    conn.close()
    exit(1)

# 更新密码
cursor.execute("UPDATE employees SET password=? WHERE id=?", (hashed, row[0]))
conn.commit()
conn.close()

print(f"用户ID: {row[0]}")
print(f"姓名:   {row[1]}")
print(f"邮箱:   {row[2]}")
print(f"角色:   {row[3]}")
print("密码更新成功")
PYEOF

echo ""
echo "[3/3] 完成！"
echo "=========================================="
echo "  请使用以下信息登录："
echo "  邮箱: $EMAIL"
echo "  密码: $NEW_PASSWORD"
echo "=========================================="
echo ""
echo "提示: 修改立即生效，无需重启容器"
