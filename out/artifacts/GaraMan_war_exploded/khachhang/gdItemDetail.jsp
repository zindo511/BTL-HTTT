<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="java.util.*,dao.*,model.*,model.Part"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chi tiết dịch vụ/phụ tùng</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdItemDetail.jsp
  Thuộc tính giao diện:
    - tblDetail : Table   -> bảng thông tin chi tiết
    - btnBack   : submit  -> nút Quay lại
  Thuộc tính ẩn:
    - service : Service   -> dịch vụ được chọn (nếu khách chọn dịch vụ)
    - part    : Part      -> phụ tùng được chọn (nếu khách chọn phụ tùng)
  Không gọi DAO: đối tượng được lấy từ danh sách kết quả đã lưu trong session.
--%>
<%
    String type = request.getParameter("type");
    int index;
    try {
        index = Integer.parseInt(request.getParameter("index"));
    } catch (Exception e) {
        response.sendRedirect("gdSearchService.jsp");
        return;
    }
    Service service = null;
    Part part = null;
    if ("service".equals(type)) {
        ArrayList<Service> listService = (ArrayList<Service>) session.getAttribute("listService");
        if (listService != null && index >= 0 && index < listService.size()) service = listService.get(index);
    } else if ("part".equals(type)) {
        ArrayList<Part> listPart = (ArrayList<Part>) session.getAttribute("listPart");
        if (listPart != null && index >= 0 && index < listPart.size()) part = listPart.get(index);
    }
    if (service == null && part == null) {
        response.sendRedirect("gdSearchService.jsp");
        return;
    }
%>
<body>
    <h2>Chi tiết dịch vụ/phụ tùng</h2>
    <!-- tblDetail : Table -->
    <table cellpadding="5">
<%  if (service != null) { %>
        <tr><td>Mã:</td><td><%=String.format("DV%02d", service.getId())%></td></tr>
        <tr><td>Tên:</td><td><%=service.getName()%></td></tr>
        <tr><td>Loại:</td><td>Dịch vụ</td></tr>
        <tr><td>Đơn giá:</td><td><%=String.format("%,.0f", service.getPrice())%> đ</td></tr>
        <tr><td>Mô tả:</td><td><%=service.getDescription()%></td></tr>
<%  } else { %>
        <tr><td>Mã:</td><td><%=String.format("PT%02d", part.getId())%></td></tr>
        <tr><td>Tên:</td><td><%=part.getName()%></td></tr>
        <tr><td>Loại:</td><td>Phụ tùng</td></tr>
        <tr><td>Đơn giá:</td><td><%=String.format("%,.0f", part.getPrice())%> đ / <%=part.getUnit()%></td></tr>
        <tr><td>Mô tả:</td><td><%=part.getDescription()%></td></tr>
<%  } %>
    </table>
    <br/>
    <!-- btnBack : submit -> quay về danh sách kết quả cũ -->
    <form action="gdSearchService.jsp" method="get">
        <input type="hidden" name="back" value="1" />
        <input type="submit" name="btnBack" value="Quay lại" />
    </form>
</body>
</html>
