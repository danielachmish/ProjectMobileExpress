<%@ Page Title="" Language="C#" MasterPageFile="~/Users/MainMaster.Master" AutoEventWireup="true" CodeBehind="Reads.aspx.cs" Inherits="MobileExpress.Users.Reads" %>

<%@ Import Namespace="BLL" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent1" runat="server">
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/responsive/2.2.9/css/responsive.bootstrap5.min.css">

    <!-- JavaScript -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <div class="container" dir="rtl">
        <h2 class="mt-4 mb-4">קריאות שירות</h2>

        <div class="card">
            <div class="card-header bg-white">
                <!-- חיפוש וסינון -->
                <div class="row g-3 align-items-center p-2">
                    <div class="col-md-4">
                        <div class="input-group">
                            <input type="text" id="txtSearch" runat="server" class="form-control" placeholder="חיפוש חופשי..." />
                            <div class="input-group-append">
                                <asp:Button ID="btnSearch" runat="server" CssClass="btn btn-primary" Text="חפש" OnClick="btnSearch_Click" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                            <asp:ListItem Text="כל הסטטוסים" Value="" />
                            <asp:ListItem Text="חדשה" Value="0" />
                            <asp:ListItem Text="בטיפול" Value="1" />
                            <asp:ListItem Text="סגורה" Value="2" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group">
                            <asp:TextBox ID="txtDateFrom" runat="server" CssClass="form-control" TextMode="Date" />
                            <span class="input-group-text">עד</span>
                            <asp:TextBox ID="txtDateTo" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-body p-0">
                <asp:GridView ID="gvReads" runat="server" CssClass="table table-hover"
                    AutoGenerateColumns="False" DataKeyNames="ReadId">
                    <Columns>
                        <asp:BoundField DataField="ReadId" HeaderText="מספר קריאה" />
                        <asp:BoundField DataField="FullName" HeaderText="שם לקוח" />
                        <asp:BoundField DataField="DateRead" HeaderText="תאריך" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="ModelCode" HeaderText="דגם" />
                        <asp:BoundField DataField="Desc" HeaderText="תיאור" />
                        <asp:TemplateField HeaderText="סטטוס">
                            <ItemTemplate>
                                <span class='badge <%# GetStatusClass(Convert.ToBoolean(Eval("Status"))) %>'>
                                    <%# GetStatusText(Convert.ToBoolean(Eval("Status"))) %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%-- <asp:TemplateField HeaderText="דחיפות">
            <ItemTemplate>
                <span class='badge <%# GetUrgencyClass(Eval("Urgency")?.ToString()) %>'>
                    <%# HttpUtility.HtmlEncode(Eval("Urgency")?.ToString() ?? "") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="פעולות">
                            <ItemTemplate>
                                <div class="btn-group">
                                    <button type="button" class="btn btn-info btn-sm"
                                        onclick='viewRead(<%# Eval("ReadId") %>)'>
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <a href='<%# ResolveUrl("~/Users/Bids.aspx?ReadId=" + Eval("ReadId")) %>' 
   class="btn btn-primary btn-sm" target="_blank">
    <i class="fas fa-file-invoice-dollar"></i> Quotes
</a>

                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <style>
        :root {
            /* צבעי בסיס */
            --purple-50: rgba(124, 58, 237, 0.05);
            --purple-100: rgba(124, 58, 237, 0.1);
            --purple-200: rgba(124, 58, 237, 0.2);
            --purple-300: rgba(124, 58, 237, 0.3);
            --purple-400: rgba(124, 58, 237, 0.4);
            --purple-500: #7c3aed;
            --purple-600: #6d28d9;
            --purple-700: #5b21b6;
            /* צבעים נלווים */
            --border-light: #e5e7eb;
            --text-dark: #1f2937;
            --text-light: #6b7280;
            --bg-light: #f9fafb;
            /* אנימציות */
            --transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
            --transition-normal: 300ms cubic-bezier(0.4, 0, 0.2, 1);
            --transition-slow: 500ms cubic-bezier(0.4, 0, 0.2, 1);
            /* צללים */
            --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --shadow-focus: 0 0 0 3px var(--purple-100);
        }

        /* אפקטים גלובליים */
        .btn, .badge, .form-control, .table tr {
            will-change: transform;
            backface-visibility: hidden;
        }

        /* טבלה */
        .table {
            margin-bottom: 0;
            border-spacing: 0;
            border-collapse: separate;
            border-radius: 12px;
            overflow: hidden;
        }

            .table th {
                background-color: var(--bg-light);
                border-bottom: 2px solid var(--border-light);
                color: var(--text-dark);
                font-weight: 600;
                padding: 16px;
                transition: background-color var(--transition-fast);
                position: relative;
            }

                .table th:hover {
                    background-color: var(--purple-50);
                }

            .table td {
                vertical-align: middle;
                padding: 16px;
                border-bottom: 1px solid var(--border-light);
                transition: all var(--transition-fast);
            }

            .table tbody tr {
                transition: all var(--transition-normal);
            }

                .table tbody tr:hover {
                    background-color: var(--purple-50);
                    transform: translateY(-1px);
                    box-shadow: var(--shadow-sm);
                }

                .table tbody tr:active {
                    transform: translateY(0);
                    background-color: var(--purple-100);
                }

        /* תגיות */
        .badge {
            padding: 8px 16px;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all var(--transition-fast);
            transform-origin: center;
        }

            .badge:hover {
                transform: scale(1.05);
                filter: brightness(1.1);
            }

        /* כפתורים */
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all var(--transition-normal);
            position: relative;
            overflow: hidden;
        }

            .btn::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width var(--transition-normal), height var(--transition-normal);
            }

            .btn:active::after {
                width: 200%;
                height: 200%;
            }

        .btn-group .btn {
            padding: 8px 16px;
            margin: 0 4px;
        }

        .btn-info {
            background-color: var(--purple-50);
            color: var(--purple-500);
            border: none;
            box-shadow: var(--shadow-sm);
        }

            .btn-info:hover {
                background-color: var(--purple-100);
                color: var(--purple-600);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .btn-info:active {
                transform: translateY(0);
                box-shadow: var(--shadow-sm);
            }

        /* שדות קלט */
        .form-control, .form-select {
            border: 2px solid var(--border-light);
            padding: 12px 16px;
            border-radius: 8px;
            transition: all var(--transition-normal);
            background-color: white;
        }

            .form-control:hover, .form-select:hover {
                border-color: var(--purple-200);
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--purple-500);
                box-shadow: var(--shadow-focus);
                outline: none;
            }

        .input-group {
            position: relative;
        }

        .input-group-text {
            background-color: var(--bg-light);
            border: 2px solid var(--border-light);
            padding: 12px 16px;
            transition: all var(--transition-normal);
        }

        /* אנימציית טעינה */
        @keyframes shimmer {
            0% {
                background-position: -1000px 0;
            }

            100% {
                background-position: 1000px 0;
            }
        }

        .loading {
            animation: shimmer 2s infinite linear;
            background: linear-gradient(to right, var(--purple-50) 4%, var(--purple-100) 25%, var(--purple-50) 36%);
            background-size: 1000px 100%;
        }

        /* רספונסיביות */
        @media (max-width: 768px) {
            .table td, .table th {
                padding: 12px;
            }

            .btn-group {
                display: flex;
                gap: 8px;
            }

            .form-control, .form-select, .btn {
                font-size: 14px;
            }
        }

        /* נגישות */
        @media (prefers-reduced-motion: reduce) {
            *, ::before, ::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
                scroll-behavior: auto !important;
            }
        }
        /* אנימציות לשורות */
        .hover-effect {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
            transition: all var(--transition-fast);
        }

        /* עיצוב DataTables */
        .dataTables_wrapper {
            padding: 1rem;
            background: white;
            border-radius: 12px;
        }

        .dataTables_filter input {
            margin-left: 0.5rem;
            border: 2px solid var(--border-light);
            border-radius: 8px;
            padding: 0.5rem 1rem;
            transition: all var(--transition-normal);
        }

            .dataTables_filter input:focus {
                border-color: var(--purple-500);
                box-shadow: var(--shadow-focus);
                outline: none;
            }

        .dataTables_length select {
            border: 2px solid var(--border-light);
            border-radius: 8px;
            padding: 0.5rem 2rem 0.5rem 1rem;
            transition: all var(--transition-normal);
        }

        .dataTables_paginate .paginate_button {
            padding: 0.5rem 1rem;
            margin: 0 0.25rem;
            border-radius: 8px;
            border: none;
            background: var(--purple-50);
            color: var(--purple-500) !important;
            transition: all var(--transition-normal);
        }

            .dataTables_paginate .paginate_button:hover {
                background: var(--purple-100) !important;
                border: none;
            }

            .dataTables_paginate .paginate_button.current {
                background: var(--purple-500) !important;
                color: white !important;
                border: none;
            }
            .btn-primary {
    background-color: var(--purple-500);
    color: white;
    border: none;
}

.btn-primary:hover {
    background-color: var(--purple-600);
}

.btn-primary {
    background-color: var(--purple-500);
    color: white;
    border: none;
}

.btn-primary:hover {
    background-color: var(--purple-600);
}
    </style>
    <%--<style>
     .btn-primary {
    background: var(--purple-500);
    color: white;
    border: none;
    padding: 8px 16px;
    font-size: 0.875rem;
    border-radius: 8px;
}

.btn-primary:hover {
    background: var(--purple-600);
}.table tbody tr {
    transition: background-color 0.2s ease;
}

.table tbody tr:hover {
    background-color: var(--purple-50);
}/* הוספת משתנים חדשים */
:root {
    --purple-50: rgba(124, 58, 237, 0.05);
    --purple-100: rgba(124, 58, 237, 0.1);
    --purple-500: #7c3aed;
    --purple-600: #6d28d9;
    --purple-700: #5b21b6;
    --border-light: #f3f4f6;
    --text-dark: #1f2937;
}

/* עיצוב כללי */
.card {
    background: white;
    border: 1px solid var(--border-light);
    border-radius: 12px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

/* סגנון חדש לטבלה */
.table {
    width: 100%;
    background: white;
}

.table th {
    background: #f9fafb;
    color: var(--text-dark);
    font-weight: 500;
    padding: 12px 16px;
    font-size: 0.9rem;
}

.table td {
    padding: 12px 16px;
    border-bottom: 1px solid var(--border-light);
    color: var(--text-dark);
}

/* עיצוב תגיות סטטוס */
.badge {
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.875rem;
    font-weight: 500;
}

.badge.pending {
    background-color: #fee2e2;
    color: #dc2626;
}

.badge.approved {
    background-color: #dcfce7;
    color: #16a34a;
}

/* כפתורי פעולות */
.btn-icon {
    width: 32px;
    height: 32px;
    padding: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    background: var(--purple-50);
    color: var(--purple-600);
    border: none;
}

/* אזור חיפוש */
.search-section {
    margin-bottom: 1.5rem;
}

.form-control, .form-select {
    border: 1px solid var(--border-light);
    border-radius: 8px;
    padding: 8px 12px;
    font-size: 0.875rem;
}

.form-control:focus, .form-select:focus {
    border-color: var(--purple-500);
    box-shadow: 0 0 0 2px var(--purple-50);
}

/* רספונסיביות */
@media (max-width: 768px) {
    .date-range {
        flex-direction: column;
        width: 100%;
    }
    
    .search-section .form-control,
    .search-section .form-select,
    .search-section .btn {
        width: 100%;
    }
}
    </style>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder3" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder4" runat="server">
    <script type="text/javascript" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.9/js/dataTables.responsive.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/responsive/2.2.9/js/responsive.bootstrap5.min.js"></script>

    <script>



        $(document).ready(function () {
            var table = $('#gvReads').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.11.5/i18n/he.json'
                },
                responsive: true,
                ordering: true,
                paging: true,
                pageLength: 10,
                dom: '<"top"lf>rt<"bottom"ip>',
                lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "הכל"]],
                columnDefs: [
                    {
                        targets: -1, // עמודה אחרונה
                        orderable: false
                    }
                ],
                initComplete: function () {
                    $('.dataTables_wrapper').addClass('bg-white p-3 rounded-lg shadow-sm');
                    $('.dataTables_filter input').addClass('form-control');
                    $('.dataTables_length select').addClass('form-select');
                }
            });

            // אנימציות לשורות
            $('#gvReads tbody').on('mouseenter', 'tr', function () {
                $(this).addClass('hover-effect');
            }).on('mouseleave', 'tr', function () {
                $(this).removeClass('hover-effect');
            });
        });
    </script>

</asp:Content>
