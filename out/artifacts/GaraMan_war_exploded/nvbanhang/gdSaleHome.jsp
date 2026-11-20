<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ nhân viên bán hàng</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdSaleHome.jsp
  Thuộc tính giao diện:
    - thanhToan : link       -> liên kết vào chức năng thanh toán
  Thuộc tính ẩn:
    - nv : SaleStaff         -> nhân viên đang đăng nhập (được lưu vào session lúc đăng nhập)
--%>
<%
    SaleStaff nv = (SaleStaff) session.getAttribute("nhanvien");
    if (nv == null) {
        response.sendRedirect("../gdDangnhap.jsp?err=timeout");
        return;
    }
    // vào trang chính thì xoá dữ liệu thanh toán cũ (nếu có)
    session.removeAttribute("repair");
    session.removeAttribute("listCustomer");
    session.removeAttribute("customerKeyword");
%>
<body>
    <h2>Trang chủ nhân viên bán hàng</h2>
    <p>Xin chào: <b><%=nv.getFullName()%></b></p>
    <ul>
        <!-- thanhToan : link -->
        <li><a id="thanhToan" href="gdSearchCustomer.jsp">Thanh toán</a></li>
    </ul>
    <a href="../dangxuat.jsp"><button type="button">Đăng xuất</button></a>
</body>
</html>
