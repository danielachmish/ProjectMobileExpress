מערכת Backend חכמה מבוססת FastAPI המאפשרת ניתוח, שיפור וביצוע בדיקות ביצועים לשאילתות SQL באמצעות בינה מלאכותית (AI).

✅ פיצ'רים עיקריים

* אימות משתמשים עם OAuth2 (Google / GitHub)
* יצירת Access + Refresh Tokens עם JWT
* חיבור לריפוזיטוריז (GitHub API) וסריקת קוד
* שליפת שאילתות SQL מתוך קבצים
* הפעלת מנוע AI לשיפור השאילתות
* בדיקות EXPLAIN ANALYZE
* שמירת נתונים בבסיס PostgreSQL
### API מלא לתקשורת עם ממשק React
* ניהול אישורים, תשלומים, והודעות
* שליפת מבנה סכימה מתוך מסד הנתונים (טבלאות, עמודות, אינדקסים, foreign keys)
* שמירת סכימה בטבלת db_schema_metadata לצורך ניתוח ואופטימיזציה עתידית
* GET /payment/details – שליפת פרטי תשלום של המשתמש הנוכחי
* POST /payment/details – יצירת פרטי תשלום


### 🔁 POST /payment/details
{
  "provider": "stripe",
  "payment_identifier": "cus_ABC123"
}

// ✅ תשובת שרת:
{
  "message": "Payment details saved",
  "data": {
    "provider": "stripe",
    "identifier": "cus_ABC123"
  }
}

🔐 התחברות עם חשבון Google
המערכת תומכת באימות OAuth דרך Google.
כאשר משתמש נכנס עם חשבון Google בפעם הראשונה – נוצר עבורו משתמש חדש אוטומטית במסד הנתונים.

Authorization: Bearer <access_token>


**🔗 API – נקודות קצה**
👤 אימות והרשאות

POST /metadata/sync
GET /repos – שליפת ריפוזיטוריז של המשתמש מתוך GitHub לפי github_token


GET /auth/google
מתחיל תהליך התחברות OAuth עם Google.

POST /auth/refresh
מקבל טוקן רענון (refresh_token) ומחזיר טוקן חדש.

{
  "refresh_token": "xxx.yyy.zzz"
}
👥 משתמשים
GET /users/me
מחזיר את פרטי המשתמש המחובר (דורש טוקן גישה).


Authorization: Bearer <access_token>
🗃️ פרויקטים
GET /projects
מחזיר את רשימת הפרויקטים של המשתמש המחובר.

POST /projects
יוצר פרויקט חדש.

{
  "name": "בדיקת שאילתות",
  "description": "פרויקט ראשון"
}

🧠 סריקה ואופטימיזציה
POST /repos/scan
סורק ריפו מרוחק לשליפת שאילתות SQL.

{
  "repo_url": "https://github.com/user/repo",
  "branch": "main"
}
POST /metadata/sync
סורק את מבנה הסכימה של מסד הנתונים (טבלאות, עמודות, קשרים וכו') ושומר לטבלה db_schema_metadata.

💡 אופטימיזציה של שאילתות
POST /query/optimize
שולח שאילתת SQL לשיפור בעזרת AI.

{
  "query": "SELECT * FROM orders WHERE status = 'paid'"
}
POST /query/explain
מבצע EXPLAIN ANALYZE לשאילתה במבנה הנתונים הנוכחי.

{
  "query": "SELECT * FROM orders WHERE status = 'paid'"
}
💳 תשלומים
GET /payment/details
מחזיר את פרטי התשלום של המשתמש.

POST /payment/details
יוצר או מעדכן פרטי תשלום.


{
  "provider": "stripe",
  "payment_identifier": "cus_ABC123"
}

**🧪 דוגמה לזרימה:**

1. המשתמש לוחץ על קישור התחברות עם Google.
2. מתבצע ניתוב ל־Google לצורך אישור.
3. לאחר קבלת קוד, השרת שולח בקשת טוקן.
4. נשלפת כתובת המייל והפרופיל מה־Google API.
5. אם המשתמש לא קיים – נרשם אוטומטית עם:

   * `google_id`
   * `email`
   * `full_name`
   * `picture`

📁 שליפת ריפוזיטוריז מ־GitHub

המערכת שולפת את רשימת הריפוזיטוריז של המשתמש באמצעות GitHub API, לפי ה־github_token שלו.

- במקרה של טוקן שגוי (401), מחזירה שגיאה עם פירוט.
- בעתיד – תתבצע גם שמירה למסד בטבלת `repositories`.

**🗃️ שדות בטבלה `users`:**

| שדה          | סוג            | הערות                      |
| ------------ | -------------- | -------------------------- |
| `id`         | int            | מפתח ראשי                  |
| `google_id`  | str            | מזהה ייחודי מגוגל (unique) |
| `email`      | str            | כתובת מייל                 |
| `full_name`  | str (nullable) | שם מלא מהפרופיל            |
| `picture`    | str (nullable) | URL של תמונת פרופיל        |
| `created_at` | datetime       | תאריך יצירה אוטומטי        |
| `organization_id` | int (nullable) | מזהה הארגון של המשתמש (foreign key) |
| `role`       | enum(`admin`, `member`, `viewer`) | תפקיד המשתמש, ברירת מחדל: `member` |
| `github_token` | str (nullable) | טוקן GitHub לצורך שליפת ריפוזיטוריז |


# 🔁 דוגמה מתוך הקוד:
class RoleEnum(str, enum.Enum):
    admin = "admin"
    member = "member"
    viewer = "viewer"

role = Column(Enum(RoleEnum), nullable=False, server_default="member")

# מתוך auth_service.py
github_token = Column(String, nullable=True)


**🗃️ שדות בטבלה `db_schema_metadata`:**

| שדה              | סוג        | הערות                                |
|------------------|------------|---------------------------------------|
| `id`             | int        | מפתח ראשי אוטומטי                    |
| `table_name`     | str        | שם הטבלה                             |
| `column_name`    | str        | שם העמודה                            |
| `column_type`    | str        | סוג העמודה (INTEGER, VARCHAR וכו')  |
| `is_indexed`     | bool       | האם יש אינדקס על העמודה             |
| `is_foreign_key` | bool       | האם העמודה היא מפתח זר              |
| `referred_table` | str?       | אם מפתח זר – שם הטבלה המקושרת       |
| `referred_column`| str?       | אם מפתח זר – שם העמודה המקושרת      |


**🗃️ טבלה: `organizations`**

| שדה         | סוג     | הערות                 |
|-------------|---------|------------------------|
| `id`        | int     | מפתח ראשי              |
| `name`      | str     | שם הארגון (ייחודי)     |
| `created_at`| datetime| תאריך יצירה אוטומטי    |

**🗃️ שדות בטבלה `user_payment_details`:**

| שדה                 | סוג        | הערות                                      |
|---------------------|------------|---------------------------------------------|
| `id`                | int        | מפתח ראשי                                   |
| `user_id`           | int        | מזהה משתמש (FK → users.id)                 |
| `provider`          | str        | ספק התשלום (למשל stripe, paypal)           |
| `payment_identifier`| str        | מזהה אצל הספק (ID של כרטיס/חשבון)          |
| `created_at`        | datetime   | נוצר אוטומטית                              |

**🗃️ שדות בטבלה `payment_history`:**

| שדה         | סוג        | הערות                                    |
|-------------|------------|-------------------------------------------|
| `id`        | int        | מפתח ראשי                                 |
| `user_id`   | int        | מזהה משתמש (FK)                          |
| `amount`    | float      | סכום ששולם                                |
| `currency`  | str        | מטבע (ברירת מחדל: USD)                   |
| `status`    | str        | סטטוס תשלום (`paid`, `failed`, `pending`) |
| `paid_at`   | datetime   | זמן ביצוע התשלום                          |


🧰 טכנולוגיות בשימוש

* Python 3.10+
* FastAPI
* SQLAlchemy + Alembic
* PostgreSQL
* OAuth2 (Google, GitHub)
* JWT Tokens
* Docker + docker-compose
* GitHub API
* OpenAI API / LLM

⚙️ הרצה מקומית

```bash
git clone https://github.com/dbooster-ai/dbooster-backend.git
cd dbooster-backend
cp .env.example .env
docker-compose up --build
```
# יצירת מיגרציה חדשה:
alembic revision --autogenerate -m "הודעת שינוי"

# הפעלת כל המיגרציות:
alembic upgrade head

# בדיקת סטטוס מיגרציות:
alembic current

לאחר ההרצה:

* 📦 Backend רץ על [http://localhost:8000](http://localhost:8000)
* 📚 תיעוד אוטומטי: [http://localhost:8000/docs](http://localhost:8000/docs)
* 🗂️ pgAdmin: [http://localhost:5050](http://localhost:5050) ([admin@dbooster.com](mailto:admin@dbooster.com) / dbooster123)

🧾 תבנית .env.example

```env
DATABASE_URL=postgresql://postgres:password@db:5432/dbooster
JWT_SECRET=super_secret_key_here
GITHUB_CLIENT_ID=your_client_id
GITHUB_CLIENT_SECRET=your_client_secret
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
FRONTEND_URL=http://localhost:5173
```

❗ הקובץ .env לא אמור להיות מגובה ב-Git – השתמש ב-.gitignore

📂 מבנה תיקיות

```
dbooster-backend/
├── main.py              # נקודת כניסה לאפליקציה
├── db.py                # חיבור למסד נתונים
├── config.py            # משתני סביבה
├── models/              # ORM Models
├── schemas/             # סכמות Pydantic
├── routers/             # API Routers
├── services/            # לוגיקה עסקית
│   └── github_service.py   # חיבור ל־GitHub API, כולל fetch_user_repos(token)
├── utils/               # פונקציות עזר
├── alembic/             # מיגרציות DB
└── tests/               # בדיקות
```

🧪 בדיקות

```bash
pytest
```

📌 Roadmap (MVP → מוצר מתקדם)

* תשתיות FastAPI + Docker
* OAuth + JWT + הרשאות
☑️ חיבור לחשבון GitHub ושליפת ריפוזיטוריז דרך API
* חיבור לריפוזיטוריז + שליפת קוד
* סריקת שאילתות ושמירה למסד
* שיפור שאילתות עם AI (LLM)
* בדיקות ביצועים
* ממשק ניהול והרשאות (Frontend)
* מערכת תשלומים + מנויים
* CI/CD + אבטחה
* תמיכה ב־ORM נוספים (SQLModel, Prisma)
* סנכרון מבנה מסד נתונים (טבלאות, אינדקסים, קשרים)


🔗 פרויקטים קשורים

* 🖥️ Frontend: dbooster-frontend
* 🌐 API Docs: [http://localhost:8001/docs](http://localhost:8001/docs)
