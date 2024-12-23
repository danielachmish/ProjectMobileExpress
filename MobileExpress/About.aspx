<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MobileExpress.About" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <div class="main-container">
        <!-- אודות -->
        <section class="content-section">
            <h2 class="section-title">אודות MobileExpress</h2>
            <div class="section-content">
                <p>
                    MobileExpress הינה פלטפורמה מתקדמת המחברת בין טכנאים מקצועיים ללקוחות. 
                    המערכת שלנו מאפשרת ניהול יעיל של קריאות שירות, מעקב אחר ביצועים ותקשורת ישירה עם לקוחות.
                </p>
                <p>
                    אנו מאמינים במתן שירות איכותי, אמין ומקצועי, תוך שמירה על סטנדרטים גבוהים ושקיפות מלאה.
                </p>
            </div>
        </section>

        <!-- צור קשר -->
        <section class="content-section">
            <h2 class="section-title">צור קשר</h2>
            <div class="section-content">
                <p>יש לכם שאלה? נשמח לעמוד לרשותכם בכל פנייה:</p>
                <div class="contact-grid">
                    <div class="contact-card">
                        <div class="contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div>
                            <h3>טלפון</h3>
                            <p>054-7945077</p>
                        </div>
                    </div>
                    <div class="contact-card">
                        <div class="contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <h3>אימייל</h3>
                            <p>danielachmish@gmail.com</p>
                        </div>
                    </div>
                    <div class="contact-card">
                        <div class="contact-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div>
                            <h3>כתובת</h3>
                            <p>רחוב ערבי נחל 9, בני עיי"ש</p>
                        </div>
                    </div>

                </div>

                <div class="contact-grid">
                    <div class="contact-card">
                        <div class="contact-icon">
                            <i class="fas fa-phone"></i>
                        </div>
                        <div>
                            <h3>טלפון</h3>
                            <p>053-7167770</p>
                        </div>
                    </div>
                    <div class="contact-card">
                        <div class="contact-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <h3>אימייל</h3>
                            <p>shimi101295@gmail.com</p>
                        </div>
                    </div>
                    <div class="contact-card">
                        <div class="contact-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div>
                            <h3>כתובת</h3>
                            <p>רחוב מיכשוילי 26ב ד51  אשדוד</p>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- תקנון -->
        <section class="content-section">
            <h2 class="section-title">תקנון האתר</h2>
            <div class="section-content">
                <ul class="terms-list">
                    <li>השימוש באתר ובשירותים המוצעים בו כפוף לתנאי השימוש המפורטים להלן.</li>
                    <li>המערכת מיועדת לשימוש טכנאים מורשים בלבד אשר עברו את תהליך האימות שלנו.</li>
                    <li>כל המידע המוצג באתר הינו בבעלות MobileExpress ומוגן בזכויות יוצרים.</li>
                    <li>אנו מתחייבים לשמור על פרטיות המשתמשים בהתאם למדיניות הפרטיות שלנו.</li>
                    <li>המערכת מתעדכנת באופן שוטף ועשויה להשתנות מעת לעת.</li>
                </ul>
            </div>
        </section>

        <!-- מדיניות פרטיות -->
        <section class="content-section">
            <h2 class="section-title">מדיניות פרטיות</h2>
            <div class="section-content">
                <p>אנו ב-MobileExpress מכבדים את פרטיותך ומחויבים להגן על המידע האישי שלך:</p>
                <ul class="terms-list">
                    <li>כל המידע האישי נשמר במאגר מאובטח ומוצפן.</li>
                    <li>איננו מעבירים מידע אישי לצדדים שלישיים ללא הסכמתך.</li>
                    <li>אתה רשאי לבקש לעיין במידע שנאסף עליך ולבקש את תיקונו או מחיקתו.</li>
                    <li>אנו משתמשים בעוגיות (Cookies) לצורך שיפור חווית המשתמש באתר.</li>
                </ul>
            </div>
        </section>
    </div>
     <style>
        .content-section {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 16px;
    padding: 2rem;
    margin-bottom: 2rem;
    box-shadow: 0 10px 30px rgba(124, 58, 237, 0.2);
    direction: rtl;
    text-align: right;
    backdrop-filter: blur(10px);
    transition: all 0.3s ease;
}

.content-section:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(124, 58, 237, 0.3);
}

.section-title {
    color: #1f2937;
    font-size: 1.8rem;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid rgba(124, 58, 237, 0.1);
    font-weight: 600;
}

.section-content {
    color: #4b5563;
    line-height: 1.8;
    margin-bottom: 1.5rem;
    font-size: 1.1rem;
}

.contact-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 2rem;
    margin-top: 2rem;
}

.contact-card {
    padding: 1.5rem;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.95);
    display: flex;
    align-items: center;
    gap: 1.2rem;
    box-shadow: 0 4px 20px rgba(124, 58, 237, 0.1);
    transition: all 0.3s ease;
}

.contact-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 30px rgba(124, 58, 237, 0.2);
}

.contact-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    background: rgba(124, 58, 237, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #7c3aed;
    font-size: 1.3rem;
    transition: all 0.3s ease;
}

.contact-card:hover .contact-icon {
    background: #7c3aed;
    color: white;
}

.contact-card h3 {
    color: #1f2937;
    font-size: 1.2rem;
    margin-bottom: 0.3rem;
    font-weight: 600;
}

.contact-card p {
    color: #6b7280;
    font-size: 1rem;
}

.terms-list {
    list-style-type: none;
    padding: 0;
}

.terms-list li {
    margin-bottom: 1.2rem;
    padding-right: 1.8rem;
    position: relative;
    color: #4b5563;
    line-height: 1.7;
}

.terms-list li::before {
    content: "";
    width: 8px;
    height: 8px;
    background: #7c3aed;
    border-radius: 50%;
    position: absolute;
    right: 0;
    top: 0.7rem;
    transition: all 0.3s ease;
}

.terms-list li:hover::before {
    transform: scale(1.3);
    box-shadow: 0 0 10px rgba(124, 58, 237, 0.3);
}

.main-container {
    min-height: calc(100vh - 70px);
    padding: 3rem 1.5rem;
    max-width: 1200px;
    margin: 0 auto;
    position: relative;
    z-index: 1;
}

@media (max-width: 768px) {
    .content-section {
        padding: 1.5rem;
        margin-bottom: 1.5rem;
    }

    .section-title {
        font-size: 1.5rem;
    }

    .contact-grid {
        gap: 1rem;
    }

    .contact-card {
        padding: 1rem;
    }

    .contact-icon {
        width: 40px;
        height: 40px;
        font-size: 1.1rem;
    }
}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
