<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>
<link rel="stylesheet" href="css/style.css">
</head>
<%--
  Lớp thiết kế: gdDangnhap.jsp
  Thuộc tính giao diện:
    - txtUsername : Text      -> ô nhập tên đăng nhập
    - txtPassword : Password  -> ô nhập mật khẩu
    - btnLogin    : submit    -> nút Đăng nhập
--%>
<body>
<%
    String err = request.getParameter("err");
    if (err != null && err.equalsIgnoreCase("timeout")) {
%>  <h4>Hết phiên làm việc. Làm ơn đăng nhập lại!</h4>
<%  } else if (err != null && err.equalsIgnoreCase("fail")) { %>
    <h4 style="color:red;">Sai tên đăng nhập/mật khẩu!</h4>
<%  } else if (err != null && err.equalsIgnoreCase("role")) { %>
    <h4 style="color:red;">Chức năng của vị trí này chưa được cài đặt!</h4>
<%  } %>
    <h2>Đăng nhập</h2>
    <form name="dangnhap" action="doDangnhap.jsp" method="post">
        <table border="0">
            <tr>
                <td>Tên đăng nhập:</td>
                <!-- txtUsername : Text -->
                <td><input type="text" name="username" id="username" required /></td>
            </tr>
            <tr>
                <td>Mật khẩu:</td>
                <!-- txtPassword : Password -->
                <td><input type="password" name="password" id="password" required /></td>
            </tr>
            <tr>
                <td></td>
                <!-- btnLogin : submit -->
                <td><input type="submit" value="Đăng nhập" /></td>
            </tr>
        </table>
    </form>
    <br/>
    <a href="khachhang/gdHome.jsp">Về trang chủ khách hàng</a>
</body>
</html>
