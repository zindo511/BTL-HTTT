<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.text.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hoá đơn thanh toán</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdBill.jsp
  Thuộc tính giao diện:
    - tblCustomerInfo : Table   -> thông tin khách hàng, xe, ngày nhận xe
    - tblUsedService  : Table   -> bảng dịch vụ đã dùng
    - tblUsedPart     : Table   -> bảng phụ tùng đã dùng
    - lblTotalAmount  : Label   -> tổng tiền
    - btnAddItem      : submit  -> nút Thêm dịch vụ/phụ tùng
    - btnConfirm      : submit  -> nút Xác nhận
  Thuộc tính ẩn:
    - repair : Repair     -> lượt sửa chữa đang thanh toán (session)
    - nv : SaleStaff      -> nhân viên đang đăng nhập (session)
--%>
<%
    SaleStaff nv = (SaleStaff) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../gdDangnhap.jsp?err=timeout");
        return;
    }
    Repair repair = null;
    String idCustomer = request.getParameter("idCustomer");

    if (idCustomer != null) {
        // Đến từ gdSearchCustomer.jsp: gọi RepairDAO lấy lượt sửa chưa thanh toán
        repair = (new RepairDAO()).getUnpaidRepair(Integer.parseInt(idCustomer));
        session.setAttribute("repair", repair);
    } else {
        // Quay lại từ gdAddItem.jsp: dùng lượt sửa đang giữ trong session (đã cập nhật)
        repair = (Repair) session.getAttribute("repair");
    }

    if (repair == null) {
%>
<script type="text/javascript">
    alert("Khách hàng không có hoá đơn cần thanh toán!");
    window.location = "gdSearchCustomer.jsp?back=1";
</script>
<%
        return;
    }
    Customer c = repair.getCar().getCustomer();
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<body>
    <h2>Hoá đơn thanh toán</h2>

    <!-- tblCustomerInfo : Table -->
    <table cellpadding="4">
        <tr><td>Khách hàng:</td><td><%=c.getFullName()%></td>
            <td>SĐT:</td><td><%=c.getTel()%></td></tr>
        <tr><td>Biển số xe:</td><td><%=repair.getCar().getLicensePlate()%></td>
            <td>Ngày nhận xe:</td><td><%=df.format(repair.getReceiveDate())%></td></tr>
    </table>

    <h3>Dịch vụ đã dùng</h3>
    <!-- tblUsedService : Table -->
    <table border="1" style="border-collapse: collapse;" cellpadding="5">
        <tr><th>TT</th><th>Tên dịch vụ</th><th>NV kỹ thuật</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr>
<%  for (int i = 0; i < repair.getUsedServices().size(); i++) {
        UsedService us = repair.getUsedServices().get(i); %>
        <tr>
            <td><%=i + 1%></td>
            <td><%=us.getService().getName()%></td>
            <td><%=us.getTechnician() != null ? us.getTechnician().getFullName() : "(chưa phân công)"%></td>
            <td><%=String.format("%,.0f", us.getPrice())%></td>
            <td><%=us.getQuantity()%></td>
            <td><%=String.format("%,.0f", us.getQuantity() * us.getPrice())%></td>
        </tr>
<%  } %>
    </table>

    <h3>Phụ tùng đã dùng</h3>
    <!-- tblUsedPart : Table -->
    <table border="1" style="border-collapse: collapse;" cellpadding="5">
        <tr><th>TT</th><th>Tên phụ tùng</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr>
<%  for (int i = 0; i < repair.getUsedParts().size(); i++) {
        UsedPart up = repair.getUsedParts().get(i); %>
        <tr>
            <td><%=i + 1%></td>
            <td><%=up.getPart().getName()%></td>
            <td><%=String.format("%,.0f", up.getPrice())%></td>
            <td><%=up.getQuantity()%></td>
            <td><%=String.format("%,.0f", up.getQuantity() * up.getPrice())%></td>
        </tr>
<%  } %>
    </table>

    <!-- lblTotalAmount : Label -->
    <h3>Tổng tiền: <span id="lblTotalAmount"><%=String.format("%,.0f", repair.getTotalAmount())%></span> đ</h3>

    <a href="gdSearchCustomer.jsp?back=1"><button type="button">Quay lại</button></a>
    <!-- btnAddItem : submit -->
    <form action="gdAddItem.jsp" method="get" style="display:inline;">
        <input type="submit" name="btnAddItem" value="Thêm dịch vụ/phụ tùng" />
    </form>
    <!-- btnConfirm : submit -->
    <form action="doSaveBill.jsp" method="post" style="display:inline;">
        <input type="submit" name="btnConfirm" value="Xác nhận" />
    </form>
</body>
</html>
