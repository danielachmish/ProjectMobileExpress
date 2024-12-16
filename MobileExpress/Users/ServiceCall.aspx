<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="ServiceCall.aspx.cs" Inherits="MobileExpress.Users.ServiceCall" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBTDLC_uiYwIrAB6-7TCxAPg4AfO3-CbAY&libraries=places"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="ticket-form-container">
        <div class="form-header">
            <h2>פתיחת קריאת שירות חדשה</h2>
            <p class="sub-title">אנא מלא את הפרטים הבאים</p>
        </div>

        <%-- מכיוון שאנחנו בתוך Content, לא צריך form נוסף כי הוא כבר קיים במאסטר פייג' --%>
        <div class="form-grid">
            <div class="form-group">
                <asp:Label AssociatedControlID="txtFullName" runat="server">שם מלא</asp:Label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                    ControlToValidate="txtFullName"
                    ErrorMessage="שדה חובה"
                    Display="Dynamic"
                    CssClass="field-error">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtPhone" runat="server">טלפון</asp:Label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                    ControlToValidate="txtPhone"
                    ErrorMessage="שדה חובה"
                    Display="Dynamic"
                    CssClass="field-error">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtCusId" runat="server">מספר לקוח</asp:Label>
                <asp:TextBox ID="txtCusId" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCusId" runat="server"
                    ControlToValidate="txtCusId"
                    ErrorMessage="שדה חובה"
                    Display="Dynamic"
                    CssClass="field-error">
                </asp:RequiredFieldValidator>
            </div>

            <%-- <div class="form-group">
                <asp:Label AssociatedControlID="ddlmodelcode" runat="server">דגם המכשיר</asp:Label>
                <asp:DropDownList ID="ddlmodelcode" runat="server" CssClass="form-control">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvmodelcode" runat="server" 
                    ControlToValidate="ddlmodelcode" 
                    ErrorMessage="שדה חובה" 
                    Display="Dynamic" 
                    CssClass="field-error">
                </asp:RequiredFieldValidator>
            </div>--%>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtmodelcode" runat="server">דגם המכשיר</asp:Label>
                <div class="device-input-wrapper">
                    <asp:TextBox ID="txtmodelcode" runat="server" CssClass="form-control" placeholder="הקלד או לחץ לזיהוי אוטומטי"></asp:TextBox>
                    <asp:Button ID="btnDetectDevice" runat="server" Text="זהה מכשיר"
                        CssClass="detect-device-btn"
                        OnClick="btnDetectDevice_Click"
                        CausesValidation="false" />
                </div>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                    ControlToValidate="txtmodelcode"
                    ErrorMessage="שדה חובה"
                    Display="Dynamic"
                    CssClass="field-error">
                </asp:RequiredFieldValidator>
            </div>

            <div class="form-group full-width">
                <asp:Label AssociatedControlID="txtDesc" runat="server">תיאור התקלה</asp:Label>
                <asp:TextBox ID="txtDesc" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDesc" runat="server"
                    ControlToValidate="txtDesc"
                    ErrorMessage="שדה חובה"
                    Display="Dynamic"
                    CssClass="field-error">
                </asp:RequiredFieldValidator>
            </div>

            <%--<div class="form-group">
                <asp:Label AssociatedControlID="ddlUrgency" runat="server">דחיפות</asp:Label>
                <asp:DropDownList ID="ddlUrgency" runat="server" CssClass="form-control">
                    <asp:ListItem Text="רגילה" Value="רגילה" />
                    <asp:ListItem Text="דחופה" Value="דחופה" />
                    <asp:ListItem Text="קריטית" Value="קריטית" />
                </asp:DropDownList>
            </div>--%>
            <div class="form-group">
                <asp:Label AssociatedControlID="ddlUrgency" runat="server">דחיפות</asp:Label>
                <asp:DropDownList ID="ddlUrgency" runat="server" CssClass="form-control rtl-select">
                    <asp:ListItem Text="רגילה" Value="רגילה" />
                    <asp:ListItem Text="דחופה" Value="דחופה" />
                    <asp:ListItem Text="קריטית" Value="קריטית" />
                </asp:DropDownList>
            </div>

            <%-- <div class="form-group">
                <asp:Label AssociatedControlID="fuImage" runat="server">תמונה (אופציונלי)</asp:Label>
                <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control file-upload" />
            </div>--%>

            <div class="form-group full-width">
                <asp:Label AssociatedControlID="txtNotes" runat="server">הערות נוספות</asp:Label>
                <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
            </div>
        </div>
        <div class="form-group">
            <asp:CheckBox ID="chkShowLocation" runat="server" Text="זיהוי מיקום אוטומטי" CssClass="form-check" />
            <asp:CheckBox ID="chkManualLocation" runat="server" Text="בחירת מיקום ידנית" CssClass="form-check" AutoPostBack="true" OnCheckedChanged="chkManualLocation_CheckedChanged" />
        </div>

        <div id="mapDiv" runat="server" visible="false" class="form-group full-width">
            <div id="locationMap" style="height: 400px; width: 100%; margin: 10px 0;"></div>
            <asp:HiddenField ID="hdnSelectedLat" runat="server" />
            <asp:HiddenField ID="hdnSelectedLng" runat="server" />
        </div>


        <div class="form-actions">
            <asp:Button ID="btnSubmit" runat="server" Text="פתיחת קריאה"
                CssClass="submit-button" OnClick="btnSubmit_Click" />
        </div>

        <%-- הודעת שגיאה כללית --%>
        <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>
    </div>
    <style>
        .rtl-select {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f9fafb;
            direction: rtl;
            text-align: right;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%239333ea' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: left 1rem center;
            background-size: 1rem;
            padding-left: 3rem;
            cursor: pointer;
        }

        select.form-control {
            width: 100%;
            padding: 10px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            direction: rtl;
            text-align: right;
            background-color: white;
            color: #333333;
            height: 45px; /* הוספת גובה קבוע */
            line-height: 1.5; /* גובה שורה */
            box-sizing: border-box; /* מונע חריגה מהגובה */
        }

            select.form-control option {
                padding: 10px;
                direction: rtl;
                text-align: right;
                background-color: white;
                color: #333333;
                min-height: 30px; /* גובה מינימלי לכל אופציה */
            }

            select.form-control:focus {
                outline: none;
                border-color: #9333ea;
                box-shadow: 0 0 0 4px rgba(147, 51, 234, 0.1);
            }




        .ticket-form-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2.5rem;
            background: white;
            border-radius: 24px;
            box-shadow: 0 10px 25px rgba(147, 51, 234, 0.1);
        }

        .form-header {
            text-align: center;
            margin-bottom: 3rem;
        }

            .form-header h2 {
                color: #9333ea;
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 0.75rem;
            }

            .form-header .sub-title {
                color: #6b7280;
                font-size: 16px;
            }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px 32px; /* שורה גובה, עמודה רוחב */
        }

        .form-group {
            display: flex;
            flex-direction: column;
            text-align: right;
        }

            .form-group.full-width {
                grid-column: span 2;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #4b5563;
                font-weight: 500;
            }

        .form-control {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

            .form-control:focus {
                outline: none;
                border-color: #9333ea;
                box-shadow: 0 0 0 4px rgba(147, 51, 234, 0.1);
                background: white;
            }

        .device-input-wrapper {
            display: flex;
            gap: 12px;
            width: 100%;
        }

        /* סגנון לכפתור "בחר קובץ" */
        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }

            .file-upload input[type="file"] {
                position: absolute;
                left: 0;
                top: 0;
                opacity: 0;
                width: 100%;
                height: 100%;
                cursor: pointer;
            }

            .file-upload .form-control {
                padding: 14px 18px;
                background: linear-gradient(135deg, #9333ea 0%, #7928ca 100%);
                color: white;
                text-align: center;
                cursor: pointer;
                font-weight: 600;
                border: none;
            }

            .file-upload:hover .form-control {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(147, 51, 234, 0.2);
            }

        .detect-device-btn {
            background: linear-gradient(135deg, #9333ea 0%, #7928ca 100%);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 14px 24px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 51px; /* גובה זהה לשדה הטקסט */
            display: flex;
            align-items: center;
            white-space: nowrap;
        }

            .detect-device-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(147, 51, 234, 0.2);
            }

        .submit-button {
            width: 100%;
            max-width: 200px;
            padding: 14px;
            background: linear-gradient(135deg, #9333ea 0%, #7928ca 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

            .submit-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(147, 51, 234, 0.2);
            }

        .form-actions {
            margin-top: 32px;
            text-align: center;
        }

        .field-error {
            color: #ef4444;
            font-size: 13px;
            margin-top: 6px;
            font-weight: 500;
        }

        .error-message {
            display: block;
            text-align: center;
            color: #ef4444;
            margin-top: 8px;
            font-weight: 500;
        }

        @media (max-width: 640px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: span 1;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
    <script>


        let locationMap;
        let locationMarker;

        window.onload = function () {
            initMap();
        }

        function initMap() {
            const defaultLocation = { lat: 32.0853, lng: 34.7818 };
            locationMap = new google.maps.Map(document.getElementById('locationMap'), {
                zoom: 13,
                center: defaultLocation,
                language: 'he'
            });

            locationMap.addListener('click', (e) => {
                placeLocationMarker(e.latLng);
            });
        }
        function placeLocationMarker(Nots) {
            if (locationMarker) locationMarker.setMap(null);
            locationMarker = new google.maps.Marker({
                position: Nots,
                map: locationMap
            });

            document.getElementById('<%= hdnSelectedLat.ClientID %>').value = Nots.lat();
            document.getElementById('<%= hdnSelectedLng.ClientID %>').value = Nots.lng();
            document.getElementById('<%= txtNotes.ClientID %>').value =
                `נבחר מיקום: ${Nots.lat()}, ${Nots.lng()}`;
        }


        // קוד הגיאולוקציה הקיים...
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                $.ajax({
                    type: "POST",
                    url: "ServiceCall.aspx/SaveUserLocation",
                    data: JSON.stringify({ Nots: position.coords.latitude + "," + position.coords.longitude }),
                    contentType: "application/json",
                    dataType: "json"
                });
            });
        }
    </script>

</asp:Content>
