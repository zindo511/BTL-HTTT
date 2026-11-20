package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Customer;

/**
 * Lớp truy xuất dữ liệu bảng tblCustomer.
 */
public class CustomerDAO extends DAO {

    public CustomerDAO() {
        super();
    }

    /**
     * Tìm các khách hàng có tên chứa từ khoá.
     * (Khách không có lượt sửa chưa thanh toán vẫn được trả về; gdBill.jsp sẽ báo
     *  "Khách hàng không có hoá đơn cần thanh toán" - ngoại lệ 6 của kịch bản.)
     * @param name tên (hoặc một phần tên) khách hàng
     * @return danh sách khách hàng tìm được (rỗng nếu không có)
     */
    public ArrayList<Customer> searchCustomer(String name) {
        ArrayList<Customer> result = new ArrayList<Customer>();
        String sql = "SELECT * FROM tblCustomer WHERE fullName LIKE ? ORDER BY fullName";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // đóng gói thông tin vào đối tượng thực thể Customer
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setFullName(rs.getString("fullName"));
                c.setTel(rs.getString("tel"));
                c.setAddress(rs.getString("address"));
                c.setEmail(rs.getString("email"));                result.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
