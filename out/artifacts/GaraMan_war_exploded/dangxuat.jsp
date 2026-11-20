<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%--
  Lớp thiết kế: dangxuat.jsp  (trang xử lí)
  Huỷ phiên làm việc rồi quay về trang đăng nhập.
--%>
<%
    session.invalidate();
    response.sendRedirect("gdDangnhap.jsp");
%>
