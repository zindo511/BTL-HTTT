<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*"%>
<%--
  Lớp thiết kế: doDangnhap.jsp  (trang xử lí, không hiển thị giao diện)
  Luồng xử lí:
    1. Lấy username, password từ gdDangnhap.jsp, set vào đối tượng nhân viên.
    2. Gọi MemberDAO.checkLogin() kiểm tra đăng nhập.
    3. Đúng thì lưu nhân viên vào session và chuyển tới trang chính theo vị trí,
       sai thì quay lại gdDangnhap.jsp?err=fail.
--%>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    SaleStaff nv = new SaleStaff();
    nv.setUsername(username);
    nv.setPassword(password);

    MemberDAO dao = new MemberDAO();
    boolean kq = dao.checkLogin(nv);

    if (kq && "sale".equalsIgnoreCase(nv.getPosition())) {
        session.setAttribute("nhanvien", nv);
        response.sendRedirect("nvbanhang/gdSaleHome.jsp");
    } else if (kq) {
        // NV quản lí, NV kho: không thuộc 2 module đã cài đặt
        response.sendRedirect("gdDangnhap.jsp?err=role");
    } else {
        response.sendRedirect("gdDangnhap.jsp?err=fail");
    }
%>
