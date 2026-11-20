<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,dao.*,model.*,model.Part"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm dịch vụ/phụ tùng vào hoá đơn</title>
<link rel="stylesheet" href="../css/style.css">
</head>
<%--
  Lớp thiết kế: gdAddItem.jsp
  Thuộc tính giao diện:
    - txtKeyword  : Text    -> ô nhập tên dịch vụ/phụ tùng
    - btnSearch   : submit  -> nút Tìm
    - tblItem     : Table   -> bảng danh sách kết quả
    - chonItem    : link    -> chọn một dịch vụ/phụ tùng (nút chọn trên từng dòng)
    - txtQuantity : Text    -> ô nhập số lượng
    - btnAdd      : submit  -> nút Thêm
  Thuộc tính ẩn:
    - listService : Service[] -> dịch vụ tìm được (session)
    - listPart    : Part[]    -> phụ tùng tìm được (session)
    - repair      : Repair    -> lượt sửa đang thanh toán, nơi thêm dòng mới vào (session)
--%>
<%
    request.setCharacterEncoding("UTF-8");
    SaleStaff nv = (SaleStaff) session.getAttribute("nhanvien");
    Repair repair = (Repair) session.getAttribute("repair");
    if (nv == null || repair == null) {
        response.sendRedirect("../gdDangnhap.jsp?err=timeout");
        return;
    }
    String action = request.getParameter("action");      // "search" | "add" | null (mới vào trang)
    String keyword = request.getParameter("txtKeyword");
    ArrayList<Service> listService = (ArrayList<Service>) session.getAttribute("addListService");
    ArrayList<Part> listPart = (ArrayList<Part>) session.getAttribute("addListPart");
    String error = null;

    // ===== Sự kiện 1: click btnSearch -> gọi ServiceDAO và PartDAO tìm theo tên =====
    if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
        keyword = keyword.trim();
        listService = (new ServiceDAO()).searchService(keyword);
        listPart = (new PartDAO()).searchPart(keyword);
        session.setAttribute("addKeyword", keyword);
        session.setAttribute("addListService", listService);
        session.setAttribute("addListPart", listPart);
    }

    // ===== Sự kiện 2: click btnAdd -> thêm dòng mới vào hoá đơn (chưa lưu CSDL) =====
    else if ("add".equals(action)) {
        keyword = (String) session.getAttribute("addKeyword");

        // Giá trị nút chọn có dạng "service_2" hoặc "part_0": loại + vị trí trong danh sách
        String chon = request.getParameter("chonItem");
        int quantity = 0;
        try {
            quantity = Integer.parseInt(request.getParameter("txtQuantity"));
        } catch (Exception e) {
            quantity = 0;
        }

        if (chon == null || listService == null || listPart == null) {
            error = "Bạn chưa chọn dịch vụ/phụ tùng!";
        } else if (quantity <= 0) {
            error = "Số lượng phải lớn hơn 0!";
        } else {
            String type = chon.split("_")[0];
            int index = Integer.parseInt(chon.split("_")[1]);

            if (type.equals("service")) {
                Service service = listService.get(index);
                UsedService us = new UsedService();      // id = 0: dòng mới, chưa có trong CSDL
                us.setService(service);
                us.setQuantity(quantity);
                us.setPrice(service.getPrice());         // lưu giá tại thời điểm sử dụng
                us.setAmount(quantity * service.getPrice());
                repair.getUsedServices().add(us);
            } else {
                Part part = listPart.get(index);
                // số lượng phụ tùng này đã bổ sung vào hoá đơn từ trước (chưa trừ kho)
                int added = 0;
                for (UsedPart old : repair.getUsedParts()) {
                    if (old.getId() == 0 && old.getPart().getId() == part.getId()) added += old.getQuantity();
                }
                if (added + quantity > part.getStockQuantity()) {
                    error = "Phụ tùng " + part.getName() + " chỉ còn " + (part.getStockQuantity() - added)
                          + " " + part.getUnit() + " trong kho!";
                } else {
                    UsedPart up = new UsedPart();        // id = 0: dòng mới, chưa có trong CSDL
                    up.setPart(part);
                    up.setQuantity(quantity);
                    up.setPrice(part.getPrice());        // lưu giá tại thời điểm sử dụng
                    up.setAmount(quantity * part.getPrice());
                    repair.getUsedParts().add(up);
                }
            }
        }

        // Thêm thành công: xoá kết quả tìm kiếm và gọi lại gdBill.jsp hiển thị hoá đơn mới
        if (error == null) {
            session.setAttribute("repair", repair);
            session.removeAttribute("addKeyword");
            session.removeAttribute("addListService");
            session.removeAttribute("addListPart");
            response.sendRedirect("gdBill.jsp");
            return;
        }
    }

    // ===== Mới vào trang từ gdBill.jsp: bắt đầu với ô tìm kiếm trống =====
    else if (action == null) {
        listService = null;
        listPart = null;
        session.removeAttribute("addKeyword");
        session.removeAttribute("addListService");
        session.removeAttribute("addListPart");
    }

    if (keyword == null) keyword = "";
%>
<body>
    <h2>Thêm dịch vụ/phụ tùng vào hoá đơn</h2>

    <form name="frmSearch" action="gdAddItem.jsp" method="get">
        <input type="hidden" name="action" value="search" />
        Tên dịch vụ/phụ tùng:
        <!-- txtKeyword : Text -->
        <input type="text" name="txtKeyword" value="<%=keyword%>" required />
        <!-- btnSearch : submit -->
        <input type="submit" name="btnSearch" value="Tìm" />
    </form>
    <br/>

<%  if (error != null) { %>
    <p style="color:red;"><%=error%></p>
<%  } %>

<%  if (listService != null && listPart != null) {
        if (listService.isEmpty() && listPart.isEmpty()) { %>
    <h4>Không tìm thấy dịch vụ/phụ tùng phù hợp</h4>
<%      } else { %>
    <form name="frmAdd" action="gdAddItem.jsp" method="post">
        <input type="hidden" name="action" value="add" />
        <h3>Danh sách kết quả</h3>
        <!-- tblItem : Table -->
        <table border="1" style="border-collapse: collapse;" cellpadding="5">
            <tr><th>Chọn</th><th>TT</th><th>Mã</th><th>Tên dịch vụ/phụ tùng</th><th>Loại</th><th>Đơn giá</th></tr>
<%          int tt = 1;
            for (int i = 0; i < listService.size(); i++) {
                Service s = listService.get(i); %>
            <tr>
                <!-- chonItem -->
                <td><input type="radio" name="chonItem" value="service_<%=i%>" /></td>
                <td><%=tt++%></td><td><%=String.format("DV%02d", s.getId())%></td><td><%=s.getName()%></td>
                <td>Dịch vụ</td><td><%=String.format("%,.0f", s.getPrice())%></td>
            </tr>
<%          }
            for (int i = 0; i < listPart.size(); i++) {
                Part p = listPart.get(i); %>
            <tr>
                <!-- chonItem -->
                <td><input type="radio" name="chonItem" value="part_<%=i%>" /></td>
                <td><%=tt++%></td><td><%=String.format("PT%02d", p.getId())%></td><td><%=p.getName()%></td>
                <td>Phụ tùng</td><td><%=String.format("%,.0f", p.getPrice())%></td>
            </tr>
<%          } %>
        </table>
        <br/>
        Số lượng:
        <!-- txtQuantity : Text -->
        <input type="number" name="txtQuantity" min="1" value="1" required />
        <!-- btnAdd : submit -->
        <input type="submit" name="btnAdd" value="Thêm" />
    </form>
<%      }
    } %>
    <br/>
    <a href="gdBill.jsp"><button type="button">Quay lại</button></a>
</body>
</html>
