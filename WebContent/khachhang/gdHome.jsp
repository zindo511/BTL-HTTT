<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ GaraMan</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdHome.jsp
  Thuộc tính:
    - timKiemDV : link   -> liên kết vào chức năng tìm thông tin dịch vụ/phụ tùng
  Khách hàng không cần đăng nhập nên trang không kiểm tra session.
--%>
<body>
    <h2>Trang chủ GaraMan</h2>
    <ul>
        <!-- timKiemDV : link -->
        <li><a id="timKiemDV" href="gdSearchService.jsp">Tìm thông tin dịch vụ/phụ tùng</a></li>
    </ul>
    <a href="../gdDangnhap.jsp">Đăng nhập dành cho nhân viên</a>
</body>
</html>
