<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thanh toán - Tìm khách hàng</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdSearchCustomer.jsp
  Thuộc tính giao diện:
    - txtCustomerName : Text    -> ô nhập tên khách hàng
    - btnSearch       : submit  -> nút Tìm
    - tblCustomer     : Table   -> bảng danh sách khách hàng
    - chonCustomer    : link    -> liên kết chọn khách hàng trên từng dòng
  Thuộc tính ẩn:
    - listCustomer : Customer[] -> danh sách khách hàng tìm được (session)
    - nv : SaleStaff            -> nhân viên đang đăng nhập (session)
--%>
<%
    request.setCharacterEncoding("UTF-8");
    SaleStaff nv = (SaleStaff) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../gdDangnhap.jsp?err=timeout");
        return;
    }
    ArrayList<Customer> listCustomer = null;
    String name = request.getParameter("txtCustomerName");

    // Xử lí sự kiện click btnSearch: gọi CustomerDAO tìm khách hàng
    if (name != null && !name.trim().isEmpty()) {
        name = name.trim();
        listCustomer = (new CustomerDAO()).searchCustomer(name);
        session.setAttribute("customerKeyword", name);
        session.setAttribute("listCustomer", listCustomer);
    } else if (request.getParameter("back") != null) {
        // Quay lại từ gdBill.jsp: giữ nguyên từ khoá và danh sách khách hàng cũ
        name = (String) session.getAttribute("customerKeyword");
        listCustomer = (ArrayList<Customer>) session.getAttribute("listCustomer");
    }
    if (name == null) name = "";
%>
<body>
    <h2>Thanh toán - Tìm khách hàng</h2>

    <form name="frmSearchCustomer" action="gdSearchCustomer.jsp" method="get">
        Tên khách hàng:
        <!-- txtCustomerName : Text -->
        <input type="text" name="txtCustomerName" value="<%=name%>" required />
        <!-- btnSearch : submit -->
        <input type="submit" name="btnSearch" value="Tìm" />
    </form>
    <br/>

<%  if (listCustomer != null) {
        if (listCustomer.isEmpty()) { %>
    <h4>Không tìm thấy khách hàng</h4>
<%      } else { %>
    <h3>Danh sách khách hàng</h3>
    <!-- tblCustomer : Table -->
    <table border="1" style="border-collapse: collapse;" cellpadding="5">
        <tr><th>TT</th><th>Mã</th><th>Họ tên</th><th>SĐT</th><th>Địa chỉ</th><th>Chọn</th></tr>
<%          for (int i = 0; i < listCustomer.size(); i++) {
                Customer c = listCustomer.get(i); %>
        <tr>
            <td><%=i + 1%></td>
            <td><%=String.format("KH%02d", c.getId())%></td>
            <td><%=c.getFullName()%></td>
            <td><%=c.getTel()%></td>
            <td><%=c.getAddress() != null ? c.getAddress() : ""%></td>
            <!-- chonCustomer : link -->
            <td><a href="gdBill.jsp?idCustomer=<%=c.getId()%>">Chọn</a></td>
        </tr>
<%          } %>
    </table>
<%      }
    } %>
    <br/>
    <a href="gdSaleHome.jsp"><button type="button">Về trang chủ</button></a>
</body>
</html>
