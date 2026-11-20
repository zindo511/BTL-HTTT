package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Part;

/**
 * Lớp truy xuất dữ liệu bảng tblPart.
 */
public class PartDAO extends DAO {

    public PartDAO() {
        super();
    }

    /**
     * Tìm các phụ tùng có tên chứa từ khoá.
     * @param key từ khoá cần tìm
     * @return danh sách phụ tùng tìm được (rỗng nếu không có)
     */
    public ArrayList<Part> searchPart(String key) {
        ArrayList<Part> result = new ArrayList<Part>();
        String sql = "SELECT * FROM tblPart WHERE name LIKE ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "%" + key + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // đóng gói thông tin vào đối tượng thực thể Part
                Part p = new Part();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getFloat("price"));
                p.setUnit(rs.getString("unit"));
                p.setStockQuantity(rs.getInt("stockQuantity"));
                p.setDescription(rs.getString("description"));
                result.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
