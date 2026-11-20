<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.text.*,dao.*,model.*"%>
<%--
  Lớp thiết kế: doSaveBill.jsp  (trang xử lí)
  Thuộc tính ẩn:
    - bill : Bill   -> hoá đơn được tạo và set thông tin trước khi lưu
  Luồng xử lí:
    1. Tạo đối tượng Bill và set các thuộc tính (repair, saleStaff, paymentDate, totalAmount).
    2. Gọi BillDAO.saveBill(bill) để lưu xuống CSDL.
    3. Thành công: hiện hoá đơn, thông báo lưu hoá đơn thành công kèm tổng tiền
       cần thu, click OK thì in hoá đơn, quay về gdSaleHome.jsp. (NV nhận tiền của khách ngoài hệ thống.)
       Lỗi: thông báo và quay lại gdBill.jsp.
--%>
<%
    SaleStaff nv = (SaleStaff) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../gdDangnhap.jsp?err=timeout");
        return;
    }
    Repair repair = (Repair) session.getAttribute("repair");
    if (repair == null) {
        // hoá đơn đã lưu rồi (ví dụ người dùng tải lại trang): về trang chính
        response.sendRedirect("gdSaleHome.jsp");
        return;
    }

    // 1. Gọi lớp Bill: set các thuộc tính của hoá đơn
    Bill bill = new Bill();
    bill.setRepair(repair);
    bill.setSaleStaff(nv);
    bill.setPaymentDate(new Date());
    bill.setTotalAmount(repair.getTotalAmount());

    // 2. Gọi BillDAO lưu hoá đơn
    boolean ok = (new BillDAO()).saveBill(bill);

    if (!ok) {
%>
<script type="text/javascript">
    alert("Lỗi lưu hoá đơn, vui lòng thử lại!");
    history.back();
</script>
<%
        return;
    }
    session.removeAttribute("repair");
    Customer c = repair.getCar().getCustomer();
    SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hoá đơn <%=String.format("HD%02d", bill.getId())%></title>
<link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <h2>GARA Ô TÔ GARAMAN - HOÁ ĐƠN THANH TOÁN</h2>
    <table cellpadding="4">
        <tr><td>Số hoá đơn:</td><td><%=String.format("HD%02d", bill.getId())%></td>
            <td>Ngày thanh toán:</td><td><%=df.format(bill.getPaymentDate())%></td></tr>
        <tr><td>Khách hàng:</td><td><%=c.getFullName()%></td>
            <td>SĐT:</td><td><%=c.getTel()%></td></tr>
        <tr><td>Biển số xe:</td><td><%=repair.getCar().getLicensePlate()%></td>
            <td>Ngày nhận xe:</td><td><%=df.format(repair.getReceiveDate())%></td></tr>
        <tr><td>NV lập hoá đơn:</td><td colspan="3"><%=nv.getFullName()%></td></tr>
    </table>

    <h3>Dịch vụ đã dùng</h3>
    <table border="1" style="border-collapse: collapse;" cellpadding="5">
        <tr><th>TT</th><th>Tên dịch vụ</th><th>NV kỹ thuật</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th></tr>
<%  for (int i = 0; i < repair.getUsedServices().size(); i++) {
        UsedService us = repair.getUsedServices().get(i); %>
        <tr>
            <td><%=i + 1%></td>
            <td><%=us.getService().getName()%></td>
            <td><%=us.getTechnician() != null ? us.getTechnician().getFullName() : ""%></td>
            <td><%=String.format("%,.0f", us.getPrice())%></td>
            <td><%=us.getQuantity()%></td>
            <td><%=String.format("%,.0f", us.getQuantity() * us.getPrice())%></td>
        </tr>
<%  } %>
    </table>

    <h3>Phụ tùng đã dùng</h3>
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

    <h3>Tổng tiền: <%=String.format("%,.0f", bill.getTotalAmount())%> đ</h3>

<script type="text/javascript">
    window.onload = function () {
        alert("Lưu hoá đơn thành công! Tổng tiền cần thu: <%=String.format("%,.0f", bill.getTotalAmount())%> đ");
        window.print();   // click OK -> in hoá đơn
        window.location = "gdSaleHome.jsp";   // in xong -> quay về trang chính
    };
</script>
</body>
</html>
