<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/MainMaster.Master" AutoEventWireup="true" CodeBehind="CusList.aspx.cs" Inherits="MobileExpress.Manage.CusList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- תוכן ראשי, אם יש צורך -->

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="breadcrumb">
                    <h1>Contact List</h1>
                    <ul>
                        <li><a href="">UI Kits</a></li>
                        <li>Contact List</li>
                    </ul>
                </div>
                <div class="separator-breadcrumb border-top"></div>
                <!-- content goes here-->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header gradient-purple-indigo 0-hidden pb-80">
                                <div class="pt-4">
                                    <div class="row">
                                        <h4 class="col-md-4 text-white">Contacts</h4>
                                        <input class="form-control form-control-rounded col-md-4 ml-3 mr-3" id="exampleFormControlInput1" type="text" placeholder="Search Contacts..." />
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                
                                        <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered" role="document">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title" id="exampleModalLabel">New Contact</h5>
                                                        <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <form>
                                                            <div class="form-group">
                                                                <input class="form-control" type="text" placeholder="Name...." />
                                                            </div>
                                                            <div class="form-group">
                                                                <input class="form-control" id="exampleInputEmail1" type="email" aria-describedby="emailHelp" placeholder="Enter email...." />
                                                            </div>
                                                            <div class="form-group">
                                                                <input class="form-control" id="exampleInputPassword1" type="text" placeholder="phone...." />
                                                            </div>
                                                            <div class="form-group">
                                                                <textarea class="form-control" id="exampleFormControlTextarea1" rows="3" placeholder="notes...."></textarea>
                                                            </div>
                                                        </form>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button class="btn btn-secondary" type="button" data-dismiss="modal">Close</button>
                                                        <button class="btn btn-primary" type="button">
                                                            Save
                                                            changes
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ul-contact-content">
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="float-left"><i class="nav-icon i-Align-Justify-All text-25 ul-contact-mobile-icon"></i></div>
                                                    <div class="tab-content ul-contact-list-table--label" id="nav-tabContent">
                                                        <!-- all-contact-->
                                                        <div class="tab-pane fade show active" id="list-home" role="tabpanel" aria-labelledby="list-home-list">
                                                            <div class="text-left">
                                                                <div class="table-responsive">
                                                                    <table class="display table table-borderless ul-contact-list-table" id="contact_list_table" style="width:100%">
                                                                        <thead>
                                                                            <tr class="border-bottom">
                                                                                <th>Name</th>
                                                                                <th>Email</th>
                                                                                <th>Phone</th>
                                                                                <th>Action</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn border-0" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td> Carl Clarkson</td>
                                                                                <td>carl_657@gmail.com</td>
                                                                                <td>+88 0172-323-233</td>
                                                                                <td>
                                                                                    <button class="btn bg-transparent _r_btn" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span><span class="_dot _r_block-dot bg-dark"></span></button>
                                                                                    <div class="dropdown-menu" x-placement="bottom-start"><a class="dropdown-item" href="#"><i class="nav-icon i-Pen-2 text-success font-weight-bold mr-2"></i>Edit Contact</a><a class="dropdown-item" href="#"><i class="nav-icon i-Close-Window text-danger font-weight-bold mr-2"></i>Delete Contact</a></div>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <!--
                              <div class="tab-pane fade" id="list-profile" role="tabpanel"
                              aria-labelledby="list-profile-list">...</div>
                              <div class="tab-pane fade" id="list-messages" role="tabpanel"
                              aria-labelledby="list-messages-list">...</div>
                              <div class="tab-pane fade" id="list-settings" role="tabpanel"
                              aria-labelledby="list-settings-list">...</div>
                              
                              -->
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server"></asp:content>

<asp:Content ID="Content4" ContentPlaceHolderID="UnderFooter" runat="server">
        <script src="/assets/js/plugins/datatables.min.js"></script>
    <script src="/assets/js/scripts/contact-list-table.min.js"></script>
    <script src="/assets/js/scripts/datatables.script.min.js"></script>
</asp:content>