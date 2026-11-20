<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*,model.Part"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tìm thông tin dịch vụ/phụ tùng</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdSearchService.jsp
  Thuộc tính giao diện:
    - txtKeyword : Text      -> ô nhập tên dịch vụ/phụ tùng
    - btnSearch  : submit    -> nút Tìm
    - tblItem    : Table     -> bảng danh sách kết quả
    - chonItem   : link      -> liên kết trên từng dòng để xem chi tiết
  Thuộc tính ẩn (lưu trong session để chuyển sang trang chi tiết):
    - listService : Service[]
    - listPart    : Part[]
--%>
<%
    request.setCharacterEncoding("UTF-8");
    ArrayList<Service> listService = null;
    ArrayList<Part> listPart = null;
    String keyword = request.getParameter("txtKeyword");

    // Xử lí sự kiện click btnSearch: gọi DAO tìm dịch vụ và phụ tùng
    if (keyword != null && !keyword.trim().isEmpty()) {
        keyword = keyword.trim();
        listService = (new ServiceDAO()).searchService(keyword);
        listPart = (new PartDAO()).searchPart(keyword);
        // lưu thuộc tính ẩn vào session
        session.setAttribute("keyword", keyword);
        session.setAttribute("listService", listService);
        session.setAttribute("listPart", listPart);
    } else if (request.getParameter("back") != null) {
        // Quay lại từ trang chi tiết: hiển thị lại danh sách cũ
        keyword = (String) session.getAttribute("keyword");
        listService = (ArrayList<Service>) session.getAttribute("listService");
        listPart = (ArrayList<Part>) session.getAttribute("listPart");
    }
    if (keyword == null) keyword = "";
%>
<body>
    <h2>Tìm thông tin dịch vụ/phụ tùng</h2>

    <form name="frmSearch" action="gdSearchService.jsp" method="get">
        Tên dịch vụ/phụ tùng:
        <!-- txtKeyword : Text -->
        <input type="text" name="txtKeyword" value="<%=keyword%>" required />
        <!-- btnSearch : submit -->
        <input type="submit" name="btnSearch" value="Tìm" />
    </form>
    <br/>

<%  if (listService != null && listPart != null) {
        if (listService.isEmpty() && listPart.isEmpty()) { %>
    <h4>Không tìm thấy dịch vụ/phụ tùng phù hợp</h4>
<%      } else { %>
    <h3>Danh sách kết quả</h3>
    <!-- tblItem : Table -->
    <table border="1" style="border-collapse: collapse;" cellpadding="5">
        <tr>
            <th>TT</th><th>Mã</th><th>Tên dịch vụ/phụ tùng</th><th>Loại</th><th>Đơn giá</th><th>Xem chi tiết</th>
        </tr>
<%          int tt = 1;
            for (int i = 0; i < listService.size(); i++) {
                Service s = listService.get(i); %>
        <tr>
            <td><%=tt++%></td>
            <td><%=String.format("DV%02d", s.getId())%></td>
            <td><%=s.getName()%></td>
            <td>Dịch vụ</td>
            <td><%=String.format("%,.0f", s.getPrice())%></td>
            <!-- chonItem : link -->
            <td><a href="gdItemDetail.jsp?type=service&index=<%=i%>">Xem</a></td>
        </tr>
<%          }
            for (int i = 0; i < listPart.size(); i++) {
                Part p = listPart.get(i); %>
        <tr>
            <td><%=tt++%></td>
            <td><%=String.format("PT%02d", p.getId())%></td>
            <td><%=p.getName()%></td>
            <td>Phụ tùng</td>
            <td><%=String.format("%,.0f", p.getPrice())%></td>
            <!-- chonItem : link -->
            <td><a href="gdItemDetail.jsp?type=part&index=<%=i%>">Xem</a></td>
        </tr>
<%          } %>
    </table>
<%      }
    } %>
    <br/>
    <a href="gdHome.jsp"><button type="button">Về trang chủ</button></a>
</body>
</html>
