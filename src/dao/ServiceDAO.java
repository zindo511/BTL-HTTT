package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Service;

/**
 * Lớp truy xuất dữ liệu bảng tblService.
 */
public class ServiceDAO extends DAO {

    public ServiceDAO() {
        super();
    }

    /**
     * Tìm các dịch vụ có tên chứa từ khoá.
     * @param key từ khoá khách hàng / nhân viên nhập vào
     * @return danh sách dịch vụ tìm được (rỗng nếu không có)
     */
    public ArrayList<Service> searchService(String key) {
        ArrayList<Service> result = new ArrayList<Service>();
        String sql = "SELECT * FROM tblService WHERE name LIKE ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + key + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // đóng gói thông tin vào đối tượng thực thể Service
                Service s = new Service();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPrice(rs.getFloat("price"));
                s.setDescription(rs.getString("description"));
                result.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
